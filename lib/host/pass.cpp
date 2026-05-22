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
    // PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
    //     Triple T(M.getTargetTriple());
    //     if (T.getArch() == Triple::nvptx || T.getArch() == Triple::nvptx64)
    //         return PreservedAnalyses::all();

    //     errs() << "[HostPass] Running on Host Module: " << M.getName() << "\n";
    //     Function *MainFn = M.getFunction("main");
    //     bool IsMainTU = MainFn && !MainFn->isDeclaration();
        
    //     if (!IsMainTU) {
    //         errs() << "[HostPass] Skipping non-main TU: " << M.getName() << "\n";
    //         return PreservedAnalyses::all();
    //     }

    //     LLVMContext &Ctx = M.getContext();
    //     bool Changed = false;

    //     // -------------------------------------------------------------------
    //     // Stage A: Create host shadow globals for the device counters.
    //     // These are the "host-side handles" CUDA uses to identify device
    //     // symbols. cudaMemcpyFromSymbol(&host_shadow, ...) looks up the
    //     // shadow in the registration table to find the device pointer.
    //     // -------------------------------------------------------------------
    //     Type *I64 = Type::getInt64Ty(Ctx);
    //     ArrayType *ArrTy = ArrayType::get(I64, kNumCounters);  // [6 x i64]
    //     const char *kArrayName = "fp_counters";

    //     GlobalVariable *Shadow = M.getGlobalVariable(kArrayName);
    //     if (!Shadow) {
    //         Shadow = new GlobalVariable(
    //             M, ArrTy, /*isConstant=*/false,
    //             GlobalValue::ExternalLinkage,
    //             ConstantAggregateZero::get(ArrTy),
    //             kArrayName);
    //         Shadow->setAlignment(Align(8));
    //         errs() << "[HostPass] Created host shadow: " << kArrayName << "[6]\n";
    //     }

    //     // -------------------------------------------------------------------
    //     // Stage B: Inject __cudaRegisterVar calls into __cuda_register_globals.
    //     // This binds each host shadow to the device symbol in the fatbin
    //     // (which the LLVM device pass already defined).
    //     // -------------------------------------------------------------------
    //     Function *RegGlobals = M.getFunction("__cuda_register_globals");
    //     if (!RegGlobals || RegGlobals->isDeclaration()) {
    //         errs() << "[HostPass] WARNING: __cuda_register_globals not found. "
    //                << "Counters will not be registered. Did the fatbin get "
    //                << "embedded with -fcuda-include-gpubinary?\n";
    //     } else {
    //         // __cudaRegisterVar signature:
    //         //   void(i8** handle, i8* hostVar, i8* deviceAddr, i8* deviceName,
    //         //        i32 ext, i64 size, i32 constant, i32 global)
    //         PointerType *PtrTy = PointerType::getUnqual(Ctx);
    //         Type *I32 = Type::getInt32Ty(Ctx);
    //         FunctionType *RegVarTy = FunctionType::get(
    //             Type::getVoidTy(Ctx),
    //             {PtrTy, PtrTy, PtrTy, PtrTy, I32, I64, I32, I32},
    //             false);
    //         FunctionCallee RegVarFn = M.getOrInsertFunction(
    //             "__cudaRegisterVar", RegVarTy);

    //         // Insert at the beginning of __cuda_register_globals, just after
    //         // any existing __cudaRegisterFunction calls. Putting them at the
    //         // entry is fine — order between Function/Var registrations doesn't
    //         // matter to the runtime.
    //         BasicBlock &EntryBB = RegGlobals->getEntryBlock();
    //         Instruction *InsertPt = &*EntryBB.getFirstInsertionPt();
    //         // Skip past existing register calls to keep ordering clean
    //         while (CallInst *CI = dyn_cast<CallInst>(InsertPt)) {
    //             if (Function *Callee = CI->getCalledFunction()) {
    //                 StringRef N = Callee->getName();
    //                 if (N == "__cudaRegisterFunction" || N == "__cudaRegisterVar") {
    //                     InsertPt = InsertPt->getNextNode();
    //                     if (!InsertPt) break;
    //                     continue;
    //                 }
    //             }
    //             break;
    //         }

    //         IRBuilder<> RegBuilder(InsertPt ? InsertPt : EntryBB.getTerminator());
    //         Value *FatbinHandle = RegGlobals->getArg(0);

    //         Constant *NameStr = RegBuilder.CreateGlobalString(
    //             kArrayName,
    //             std::string("__cuda_var_name_") + kArrayName);

    //         RegBuilder.CreateCall(RegVarFn, {
    //             FatbinHandle,                              // handle
    //             Shadow,                                    // hostVar = [6 x i64]
    //             NameStr,                                   // deviceAddress (the name)
    //             NameStr,                                   // deviceName
    //             ConstantInt::get(I32, 0),                  // ext = 0
    //             ConstantInt::get(I64, kNumCounters * 8),   // size = 48 bytes
    //             ConstantInt::get(I32, 0),                  // constant = 0
    //             ConstantInt::get(I32, 0),                  // global = 0
    //         });
    //         errs() << "[HostPass] Registered shadow: " << kArrayName
    //             << "[" << kNumCounters << "] (" << (kNumCounters * 8) << " bytes)\n";
    //         Changed = true;
    //     }

    //     // -------------------------------------------------------------------
    //     // Stage C: Create fp_read_counters and fp_reset_counters functions
    //     // in this module so the driver can call them.
    //     // -------------------------------------------------------------------
    //     emitReadFunction(M, Shadow);
    //     emitResetFunction(M, Shadow);
    //     Changed = true;

    //     // -------------------------------------------------------------------
    //     // Stage D: existing lifecycle injection (init/finalize, region wrap)
    //     // -------------------------------------------------------------------
    //     FunctionType *VoidTy = FunctionType::get(Type::getVoidTy(Ctx), false);
    //     FunctionType *InitTy = FunctionType::get(
    //         Type::getVoidTy(Ctx), {PointerType::getUnqual(Ctx)}, false);
    //     FunctionCallee InitHook     = M.getOrInsertFunction("fp_instrument_init", InitTy);
    //     FunctionCallee FinalizeHook = M.getOrInsertFunction("fp_instrument_finalize", VoidTy);
    //     //FunctionCallee StartHook    = M.getOrInsertFunction("fp_instrument_region_start", VoidTy);
    //     //FunctionCallee StopHook     = M.getOrInsertFunction("fp_instrument_region_stop", VoidTy);

        
    //     errs() << "[HostPass] Found main(), injecting PAPI lifecycle.\n";
    //     Instruction *FirstInst = &*MainFn->getEntryBlock().getFirstInsertionPt();
    //     IRBuilder<> BuilderInit(FirstInst);
    //     Value *AppName = BuilderInit.CreateGlobalString(M.getName().str());
    //     BuilderInit.CreateCall(InitHook, {AppName});

    //     for (BasicBlock &BB : *MainFn) {
    //         if (ReturnInst *RI = dyn_cast<ReturnInst>(BB.getTerminator())) {
    //             IRBuilder<> BuilderFinalize(RI);
    //             BuilderFinalize.CreateCall(FinalizeHook);
    //         }
    //     }
    //     Changed = true;

    //     return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
    // }
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
    Triple T(M.getTargetTriple());
    if (T.getArch() == Triple::nvptx || T.getArch() == Triple::nvptx64)
        return PreservedAnalyses::all();

    errs() << "[HostPass] Running on Host Module: " << M.getName() << "\n";

    Function *MainFn = M.getFunction("main");
    bool HasMain = MainFn && !MainFn->isDeclaration();

    Function *RegGlobals = M.getFunction("__cuda_register_globals");
    bool HasRegGlobals = RegGlobals && !RegGlobals->isDeclaration();

    if (!HasMain && !HasRegGlobals) {
        errs() << "[HostPass] Skipping TU (no main, no __cuda_register_globals): "
               << M.getName() << "\n";
        return PreservedAnalyses::all();
    }

    LLVMContext &Ctx = M.getContext();
    bool Changed = false;

    Type *I64 = Type::getInt64Ty(Ctx);
    Type *I32 = Type::getInt32Ty(Ctx);
    PointerType *PtrTy = PointerType::getUnqual(Ctx);
    ArrayType *ArrTy = ArrayType::get(I64, kNumCounters);
    const char *kArrayName = "fp_counters";

    // ===== Counter-side work: shadow + register call + accessors =====
    // Done in the TU that has __cuda_register_globals (the one with kernel defs).
    if (HasRegGlobals) {
        errs() << "[HostPass] TU has __cuda_register_globals; emitting shadow, "
               << "register call, and accessors.\n";

        // Stage A: shadow
        GlobalVariable *Shadow = M.getGlobalVariable(kArrayName);
        if (!Shadow) {
            Shadow = new GlobalVariable(
                M, ArrTy, /*isConstant=*/false,
                GlobalValue::ExternalLinkage,
                ConstantAggregateZero::get(ArrTy),
                kArrayName);
            Shadow->setAlignment(Align(8));
            errs() << "[HostPass] Created host shadow: " << kArrayName << "[6]\n";
        }

        // Stage B: __cudaRegisterVar call
        FunctionType *RegVarTy = FunctionType::get(
            Type::getVoidTy(Ctx),
            {PtrTy, PtrTy, PtrTy, PtrTy, I32, I64, I32, I32},
            false);
        FunctionCallee RegVarFn = M.getOrInsertFunction("__cudaRegisterVar", RegVarTy);

        BasicBlock &EntryBB = RegGlobals->getEntryBlock();
        Instruction *InsertPt = &*EntryBB.getFirstInsertionPt();
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
        Constant *NameStr = RegBuilder.CreateGlobalString(
            kArrayName,
            std::string("__cuda_var_name_") + kArrayName);

        RegBuilder.CreateCall(RegVarFn, {
            FatbinHandle, Shadow, NameStr, NameStr,
            ConstantInt::get(I32, 0),
            ConstantInt::get(I64, kNumCounters * 8),
            ConstantInt::get(I32, 0),
            ConstantInt::get(I32, 0),
        });
        errs() << "[HostPass] Registered shadow: " << kArrayName
               << "[" << kNumCounters << "] (" << (kNumCounters * 8) << " bytes)\n";

        // Stage C: accessors
        emitReadFunction(M, Shadow);
        emitResetFunction(M, Shadow);
        Changed = true;
    }

    // ===== Lifecycle injection =====
    // Done in the TU that has main.
    if (HasMain) {
        errs() << "[HostPass] TU has main; injecting PAPI lifecycle.\n";

        FunctionType *VoidTy = FunctionType::get(Type::getVoidTy(Ctx), false);
        FunctionType *InitTy = FunctionType::get(
            Type::getVoidTy(Ctx), {PtrTy}, false);
        FunctionCallee InitHook = M.getOrInsertFunction("fp_instrument_init", InitTy);
        FunctionCallee FinalizeHook = M.getOrInsertFunction("fp_instrument_finalize", VoidTy);

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

    return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
}

private:
    // Emit: extern "C" cudaError_t fp_read_counters(u64*, u64*, u64*, u64*, u64*, u64*)
    // that calls cudaMemcpyFromSymbol on each shadow.
        void emitReadFunction(Module &M, GlobalVariable *Shadow) {
        LLVMContext &Ctx = M.getContext();
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        PointerType *PtrTy = PointerType::getUnqual(Ctx);
        ArrayType *ArrTy = ArrayType::get(I64, kNumCounters);

        // cudaError_t cudaMemcpyFromSymbol(void* dst, const void* sym,
        //                                  size_t count, size_t offset, cudaMemcpyKind)
        FunctionType *MemcpySymTy = FunctionType::get(
            I32, {PtrTy, PtrTy, I64, I64, I32}, false);
        FunctionCallee MemcpyFromSym =
            M.getOrInsertFunction("cudaMemcpyFromSymbol", MemcpySymTy);

        // Same external API: extern "C" cudaError_t
        //   fp_read_counters(u64* invalid, u64* divzero, u64* overflow,
        //                    u64* underflow, u64* total, u64* subnormal);
        FunctionType *ReadTy = FunctionType::get(
            I32, {PtrTy, PtrTy, PtrTy, PtrTy, PtrTy, PtrTy}, false);
        Function *ReadFn = Function::Create(
            ReadTy, GlobalValue::ExternalLinkage, "fp_read_counters", &M);

        const char *ArgNames[kNumCounters] = {
            "invalid", "divzero", "overflow", "underflow", "total", "subnormal"
        };
        unsigned ai = 0;
        for (Argument &A : ReadFn->args()) A.setName(ArgNames[ai++]);

        BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", ReadFn);
        BasicBlock *Bad   = BasicBlock::Create(Ctx, "bad",   ReadFn);
        BasicBlock *Ok    = BasicBlock::Create(Ctx, "ok",    ReadFn);

        IRBuilder<> B(Entry);

        // Stack buffer [6 x i64] to receive the device snapshot
        AllocaInst *Buf = B.CreateAlloca(ArrTy, nullptr, "buf");
        Buf->setAlignment(Align(8));

        // One coalesced 48-byte D2H copy
        Value *Size   = ConstantInt::get(I64, kNumCounters * 8);
        Value *Offset = ConstantInt::get(I64, 0);
        Value *Kind   = ConstantInt::get(I32, 2);  // cudaMemcpyDeviceToHost

        CallInst *Err = B.CreateCall(MemcpyFromSym, {Buf, Shadow, Size, Offset, Kind});
        Value *IsOK = B.CreateICmpEQ(Err, ConstantInt::get(I32, 0));
        B.CreateCondBr(IsOK, Ok, Bad);

        // Error path: propagate the CUDA error
        IRBuilder<> BadB(Bad);
        BadB.CreateRet(Err);

        // Success path: scatter buf[i] into output pointers
        B.SetInsertPoint(Ok);
        ai = 0;
        for (Argument &OutArg : ReadFn->args()) {
            Value *Idx[] = {
                ConstantInt::get(I32, 0),
                ConstantInt::get(I32, ai)
            };
            Value *ElemPtr = B.CreateInBoundsGEP(ArrTy, Buf, Idx);
            Value *Loaded = B.CreateAlignedLoad(I64, ElemPtr, Align(8));
            B.CreateAlignedStore(Loaded, &OutArg, Align(8));
            ++ai;
        }
        B.CreateRet(ConstantInt::get(I32, 0));  // cudaSuccess
    }

        void emitResetFunction(Module &M, GlobalVariable *Shadow) {
        LLVMContext &Ctx = M.getContext();
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        PointerType *PtrTy = PointerType::getUnqual(Ctx);
        ArrayType *ArrTy = ArrayType::get(I64, kNumCounters);

        FunctionType *MemcpySymTy = FunctionType::get(
            I32, {PtrTy, PtrTy, I64, I64, I32}, false);
        FunctionCallee MemcpyToSym =
            M.getOrInsertFunction("cudaMemcpyToSymbol", MemcpySymTy);

        FunctionType *ResetTy = FunctionType::get(I32, {}, false);
        Function *ResetFn = Function::Create(
            ResetTy, GlobalValue::ExternalLinkage, "fp_reset_counters", &M);

        BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", ResetFn);
        IRBuilder<> B(Entry);

        // Stack [6 x i64] initialized to zero
        AllocaInst *Zeros = B.CreateAlloca(ArrTy, nullptr, "zeros");
        Zeros->setAlignment(Align(8));
        B.CreateAlignedStore(ConstantAggregateZero::get(ArrTy), Zeros, Align(8));

        // One coalesced 48-byte H2D copy
        Value *Size   = ConstantInt::get(I64, kNumCounters * 8);
        Value *Offset = ConstantInt::get(I64, 0);
        Value *Kind   = ConstantInt::get(I32, 1);  // cudaMemcpyHostToDevice

        CallInst *Err = B.CreateCall(MemcpyToSym, {Shadow, Zeros, Size, Offset, Kind});
        B.CreateRet(Err);  // returns 0 on success, error code otherwise
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
