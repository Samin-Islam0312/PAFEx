#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/TargetParser/Triple.h"
#include "llvm/Support/raw_ostream.h"

#if __has_include("llvm/Plugins/PassPlugin.h")
  #include "llvm/Plugins/PassPlugin.h"   // LLVM 22+
#else
  #include "llvm/Passes/PassPlugin.h"
#endif

using namespace llvm;

namespace {

static const char *kCounterNames[] = {
    "fp_invalid_counter",
    "fp_divbyzero_counter",
    "fp_overflow_counter",
    "fp_underflow_counter",
    "fp_total_counter",
    "fp_subnormal_counter",
};
static constexpr unsigned kNumCounters =
    sizeof(kCounterNames) / sizeof(kCounterNames[0]);

class HostPass : public PassInfoMixin<HostPass> {
public:
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
        Triple T(M.getTargetTriple());
        if (T.getArch() == Triple::nvptx || T.getArch() == Triple::nvptx64)
            return PreservedAnalyses::all();

        errs() << "[HostPass] Running on Host Module: " << M.getName() << "\n";

        LLVMContext &Ctx = M.getContext();
        bool Changed = false;

        // -------------------------------------------------------------------
        // Stage A: Create host shadow globals for the device counters.
        // These are the "host-side handles" CUDA uses to identify device
        // symbols. cudaMemcpyFromSymbol(&host_shadow, ...) looks up the
        // shadow in the registration table to find the device pointer.
        // -------------------------------------------------------------------
        Type *I64 = Type::getInt64Ty(Ctx);
        GlobalVariable *Shadows[kNumCounters];

        for (unsigned i = 0; i < kNumCounters; ++i) {
            // Reuse if it already exists (e.g. previous pass run on same module)
            if ((Shadows[i] = M.getGlobalVariable(kCounterNames[i]))) continue;

            Shadows[i] = new GlobalVariable(
                M, I64, /*isConstant=*/false,
                GlobalValue::ExternalLinkage,
                ConstantInt::get(I64, 0),
                kCounterNames[i]);
            Shadows[i]->setAlignment(Align(8));
            errs() << "[HostPass] Created host shadow: " << kCounterNames[i] << "\n";
        }

        // -------------------------------------------------------------------
        // Stage B: Inject __cudaRegisterVar calls into __cuda_register_globals.
        // This binds each host shadow to the device symbol in the fatbin
        // (which the LLVM device pass already defined).
        // -------------------------------------------------------------------
        Function *RegGlobals = M.getFunction("__cuda_register_globals");
        if (!RegGlobals || RegGlobals->isDeclaration()) {
            errs() << "[HostPass] WARNING: __cuda_register_globals not found. "
                   << "Counters will not be registered. Did the fatbin get "
                   << "embedded with -fcuda-include-gpubinary?\n";
        } else {
            // __cudaRegisterVar signature:
            //   void(i8** handle, i8* hostVar, i8* deviceAddr, i8* deviceName,
            //        i32 ext, i64 size, i32 constant, i32 global)
            PointerType *PtrTy = PointerType::getUnqual(Ctx);
            Type *I32 = Type::getInt32Ty(Ctx);
            FunctionType *RegVarTy = FunctionType::get(
                Type::getVoidTy(Ctx),
                {PtrTy, PtrTy, PtrTy, PtrTy, I32, I64, I32, I32},
                false);
            FunctionCallee RegVarFn = M.getOrInsertFunction(
                "__cudaRegisterVar", RegVarTy);

            // Insert at the beginning of __cuda_register_globals, just after
            // any existing __cudaRegisterFunction calls. Putting them at the
            // entry is fine — order between Function/Var registrations doesn't
            // matter to the runtime.
            BasicBlock &EntryBB = RegGlobals->getEntryBlock();
            Instruction *InsertPt = &*EntryBB.getFirstInsertionPt();
            // Skip past existing register calls to keep ordering clean
            while (CallInst *CI = dyn_cast<CallInst>(InsertPt)) {
                if (Function *Callee = CI->getCalledFunction()) {
                    StringRef N = Callee->getName();
                    if (N == "__cudaRegisterFunction" || N == "__cudaRegisterVar") {
                        InsertPt = InsertPt->getNextNode();
                        if (!InsertPt) break;
                        continue;
                    }
                }
                break;
            }

            IRBuilder<> RegBuilder(InsertPt ? InsertPt : EntryBB.getTerminator());
            Value *FatbinHandle = RegGlobals->getArg(0);

            for (unsigned i = 0; i < kNumCounters; ++i) {
                // Create the name string constant
                Constant *NameStr = RegBuilder.CreateGlobalString(
                    kCounterNames[i],
                    std::string("__cuda_var_name_") + kCounterNames[i]);

                RegBuilder.CreateCall(RegVarFn, {
                    FatbinHandle,                       // handle
                    Shadows[i],                          // hostVar
                    NameStr,                             // deviceAddress (name)
                    NameStr,                             // deviceName
                    ConstantInt::get(I32, 0),            // ext = 0
                    ConstantInt::get(I64, 8),            // size = 8 bytes
                    ConstantInt::get(I32, 0),            // constant = 0
                    ConstantInt::get(I32, 0),            // global = 0
                });
                errs() << "[HostPass] Registered shadow: " << kCounterNames[i] << "\n";
            }
            Changed = true;
        }

        // -------------------------------------------------------------------
        // Stage C: Create fp_read_counters and fp_reset_counters functions
        // in this module so the driver can call them.
        // -------------------------------------------------------------------
        emitReadFunction(M, Shadows);
        emitResetFunction(M, Shadows);
        Changed = true;

        // -------------------------------------------------------------------
        // Stage D: existing lifecycle injection (init/finalize, region wrap)
        // -------------------------------------------------------------------
        FunctionType *VoidTy = FunctionType::get(Type::getVoidTy(Ctx), false);
        FunctionType *InitTy = FunctionType::get(
            Type::getVoidTy(Ctx), {PointerType::getUnqual(Ctx)}, false);
        FunctionCallee InitHook     = M.getOrInsertFunction("fp_instrument_init", InitTy);
        FunctionCallee FinalizeHook = M.getOrInsertFunction("fp_instrument_finalize", VoidTy);
        FunctionCallee StartHook    = M.getOrInsertFunction("fp_instrument_region_start", VoidTy);
        FunctionCallee StopHook     = M.getOrInsertFunction("fp_instrument_region_stop", VoidTy);

        Function *MainFn = M.getFunction("main");
        if (MainFn && !MainFn->isDeclaration()) {
            errs() << "[HostPass] Found main(), injecting PAPI lifecycle.\n";
            Instruction *FirstInst = &*MainFn->getEntryBlock().getFirstInsertionPt();
            IRBuilder<> BuilderInit(FirstInst);
            Value *AppName = BuilderInit.CreateGlobalString(M.getName().str());
            BuilderInit.CreateCall(InitHook, {AppName});

            for (BasicBlock &BB : *MainFn) {
                if (ReturnInst *RI = dyn_cast<ReturnInst>(BB.getTerminator())) {
                    IRBuilder<> BuilderFinalize(RI);
                    BuilderFinalize.CreateCall(FinalizeHook);
                }
            }
            Changed = true;
        }

        int kernelsInstrumented = 0;
        for (Function &F : M) {
            if (F.isDeclaration()) continue;
            for (BasicBlock &BB : F) {
                for (Instruction &I : BB) {
                    auto *CI = dyn_cast<CallInst>(&I);
                    if (!CI) continue;
                    Function *Callee = CI->getCalledFunction();
                    if (!Callee) continue;
                    StringRef N = Callee->getName();
                    if (N == "cudaLaunchKernel" || N == "cudaLaunchKernelExC") {
                        IRBuilder<> B(CI);
                        B.CreateCall(StartHook);
                        if (Instruction *Next = CI->getNextNode()) {
                            IRBuilder<> A(Next);
                            A.CreateCall(StopHook);
                        }
                        kernelsInstrumented++;
                        Changed = true;
                    }
                }
            }
        }
        errs() << "[HostPass] Instrumented " << kernelsInstrumented << " kernel launches.\n";

        return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
    }

private:
    // Emit: extern "C" cudaError_t fp_read_counters(u64*, u64*, u64*, u64*, u64*, u64*)
    // that calls cudaMemcpyFromSymbol on each shadow.
    void emitReadFunction(Module &M, GlobalVariable *Shadows[]) {
        LLVMContext &Ctx = M.getContext();
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        PointerType *PtrTy = PointerType::getUnqual(Ctx);

        // cudaError_t cudaMemcpyFromSymbol(void* dst, const void* sym,
        //                                  size_t count, size_t offset=0,
        //                                  cudaMemcpyKind kind=DeviceToHost=2)
        FunctionType *MemcpySymTy = FunctionType::get(
            I32, {PtrTy, PtrTy, I64, I64, I32}, false);
        FunctionCallee MemcpyFromSym =
            M.getOrInsertFunction("cudaMemcpyFromSymbol", MemcpySymTy);

        FunctionType *ReadTy = FunctionType::get(
            I32, {PtrTy, PtrTy, PtrTy, PtrTy, PtrTy, PtrTy}, false);
        Function *ReadFn = Function::Create(
            ReadTy, GlobalValue::ExternalLinkage, "fp_read_counters", &M);

        // Arg names just for IR readability
        const char *ArgNames[kNumCounters] = {
            "invalid", "divzero", "overflow", "underflow", "total", "subnormal"
        };
        unsigned ai = 0;
        for (Argument &A : ReadFn->args()) A.setName(ArgNames[ai++]);

        BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", ReadFn);
        IRBuilder<> B(Entry);

        // 4 = cudaMemcpyDefault is safest; explicit DeviceToHost=2 also OK.
        Value *Count = ConstantInt::get(I64, 8);     // sizeof(u64)
        Value *Offset = ConstantInt::get(I64, 0);
        Value *Kind = ConstantInt::get(I32, 2);      // cudaMemcpyDeviceToHost

        ai = 0;
        for (Argument &OutArg : ReadFn->args()) {
            CallInst *Err = B.CreateCall(MemcpyFromSym, {
                &OutArg,        // dst (caller-provided u64*)
                Shadows[ai],    // sym (host shadow address)
                Count, Offset, Kind
            });
            // Early-return on first error
            BasicBlock *Cont = BasicBlock::Create(Ctx, "cont", ReadFn);
            BasicBlock *Bad  = BasicBlock::Create(Ctx, "bad", ReadFn);
            Value *IsOK = B.CreateICmpEQ(Err, ConstantInt::get(I32, 0));
            B.CreateCondBr(IsOK, Cont, Bad);

            IRBuilder<> BadB(Bad);
            BadB.CreateRet(Err);

            B.SetInsertPoint(Cont);
            ++ai;
        }
        B.CreateRet(ConstantInt::get(I32, 0));   // cudaSuccess
    }

    void emitResetFunction(Module &M, GlobalVariable *Shadows[]) {
        LLVMContext &Ctx = M.getContext();
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        PointerType *PtrTy = PointerType::getUnqual(Ctx);

        FunctionType *MemcpySymTy = FunctionType::get(
            I32, {PtrTy, PtrTy, I64, I64, I32}, false);
        FunctionCallee MemcpyToSym =
            M.getOrInsertFunction("cudaMemcpyToSymbol", MemcpySymTy);

        FunctionType *ResetTy = FunctionType::get(I32, {}, false);
        Function *ResetFn = Function::Create(
            ResetTy, GlobalValue::ExternalLinkage, "fp_reset_counters", &M);

        BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", ResetFn);
        IRBuilder<> B(Entry);

        // Stack-allocated zero
        AllocaInst *Zero = B.CreateAlloca(I64);
        Zero->setAlignment(Align(8));
        B.CreateStore(ConstantInt::get(I64, 0), Zero);

        Value *Count = ConstantInt::get(I64, 8);
        Value *Offset = ConstantInt::get(I64, 0);
        Value *Kind = ConstantInt::get(I32, 1);   // cudaMemcpyHostToDevice

        for (unsigned i = 0; i < kNumCounters; ++i) {
            CallInst *Err = B.CreateCall(MemcpyToSym, {
                Shadows[i], Zero, Count, Offset, Kind
            });
            BasicBlock *Cont = BasicBlock::Create(Ctx, "cont", ResetFn);
            BasicBlock *Bad  = BasicBlock::Create(Ctx, "bad", ResetFn);
            Value *IsOK = B.CreateICmpEQ(Err, ConstantInt::get(I32, 0));
            B.CreateCondBr(IsOK, Cont, Bad);

            IRBuilder<> BadB(Bad);
            BadB.CreateRet(Err);

            B.SetInsertPoint(Cont);
        }
        B.CreateRet(ConstantInt::get(I32, 0));
    }
};

} // end anonymous namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION,
        "HostPass",
        "v0.2",
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "fp-host-instrument") {
                        MPM.addPass(HostPass());
                        return true;
                    }
                    return false;
                });
        }
    };
}
