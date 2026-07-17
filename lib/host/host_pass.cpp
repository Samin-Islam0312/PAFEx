/*
PaFEx HostPass — host-side companion to the DevicePass.

Responsibilities, per translation unit:
  1. In the TU that registers device globals (__cuda_register_globals for
     CUDA, __hip_register_globals for HIP):
       - declare host shadow variables for fp_counters, fp_site_counters,
         and fp_result_counters,
       - register each shadow against its device symbol
         (__cudaRegisterVar / __hipRegisterVar),
       - emit the extern "C" readback/reset accessors the runtime driver
         links against (fp_read_counters, fp_read_site_counters,
         fp_read_result_counters, fp_reset_counters). The accessor names
         and signatures are identical for CUDA and HIP; only the memcpy
         entry points they call differ.
  2. In the TU that has main(): inject the PAPI SDE lifecycle calls
     (fp_instrument_init at entry, fp_instrument_finalize before each ret).

All array sizes and symbol names come from fp_abi.h, shared with the
DevicePass and the runtime driver.

KNOWN LIMITATIONS (unchanged from previous version, documented here):
  - fp_reset_counters zeroes only the aggregate array, not the per-site or
    result-class arrays. Single-run measurement is unaffected.
  - finalize is injected before `ret` in main only; programs that terminate
    via exit()/abort() skip publication.
*/
#include "fp_abi.h"

#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/Passes/PassBuilder.h"
#include "pass_plugin_compat.h"
#include "llvm/TargetParser/Triple.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

using namespace pafex;

// Which GPU runtime this host TU is built against, detected from the
// clang-emitted registration function. The two runtimes' registration and
// memcpy-by-symbol C ABIs have identical shapes (and identical memcpy-kind
// enum values: HostToDevice=1, DeviceToHost=2), so everything below differs
// only in the names of the functions called.
enum class GPURuntime { None, CUDA, HIP };

struct RuntimeNames {
    const char *RegisterGlobals;
    const char *ModuleCtor;        // NEW
    const char *RegisterVar;
    const char *RegisterFunction;
    const char *MemcpyFromSymbol;
    const char *MemcpyToSymbol;
    const char *Tag;
};
static const RuntimeNames CUDANames = {
    "__cuda_register_globals", "__cuda_module_ctor",
    "__cudaRegisterVar", "__cudaRegisterFunction",
    "cudaMemcpyFromSymbol", "cudaMemcpyToSymbol", "CUDA"
};
static const RuntimeNames HIPNames = {
    "__hip_register_globals", "__hip_module_ctor",
    "__hipRegisterVar", "__hipRegisterFunction",
    "hipMemcpyFromSymbol", "hipMemcpyToSymbol", "HIP"
};
// Returns the register-callback function to anchor on, and writes the fatbin
// handle Value into HandleOut. CUDA: __cuda_register_globals(handle) — handle
// is arg 0. HIP (ROCm 7.x): no __hip_register_globals; registration is inlined
// into __hip_module_ctor(), handle is the first operand of the first
// __hipRegisterFunction/Var call (the merged phi), valid only from that call on.
static Function *findRegSite(Module &M, const RuntimeNames *RT,
                             Value *&HandleOut, Instruction *&InsertAfter) {
    HandleOut = nullptr; InsertAfter = nullptr;

    // CUDA: dedicated register-globals fn, handle = arg 0 (unchanged behavior).
    if (Function *F = M.getFunction(RT->RegisterGlobals);
        F && !F->isDeclaration()) {
        HandleOut = F->getArg(0);
        InsertAfter = &*F->getEntryBlock().getFirstInsertionPt();
        return F;
    }

    // HIP ROCm 7.x: anchor on __hip_module_ctor, but only if it actually
    // contains a RegisterFunction call (distinguishes it from __hip_module_dtor).
    if (Function *F = M.getFunction(RT->ModuleCtor);
        F && !F->isDeclaration()) {
        for (BasicBlock &BB : *F)
            for (Instruction &I : BB)
                if (auto *CI = dyn_cast<CallInst>(&I))
                    if (Function *Callee = CI->getCalledFunction()) {
                        StringRef N = Callee->getName();
                        if (N == RT->RegisterFunction || N == RT->RegisterVar) {
                            Instruction *After = CI->getNextNode();
                            if (!After) continue;              // register call is block terminator-adjacent; skip
                            HandleOut = CI->getArgOperand(0);  // = %6, the phi
                            InsertAfter = CI->getNextNode();   // in block %5, handle dominates
                            return F;
                        }
                    }
    }
    return nullptr;
}
class HostPass : public PassInfoMixin<HostPass> {
public:
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
        // Skip GPU DEVICE modules outright — this pass touches host IR only.
        Triple T(M.getTargetTriple());
        if (T.getArch() == Triple::nvptx || T.getArch() == Triple::nvptx64 ||
            T.getArch() == Triple::amdgcn)
            return PreservedAnalyses::all();

        errs() << "[HostPass] Running on Host Module: " << M.getName() << "\n";

        Function *MainFn = M.getFunction("main");
        bool HasMain = MainFn && !MainFn->isDeclaration();

        // Detect which runtime's registration function this TU carries.
        // Function *RegGlobals = nullptr;
        // if (Function *F = M.getFunction(CUDANames.RegisterGlobals);
        //     F && !F->isDeclaration()) {
        //     RegGlobals = F;
        //     RT = &CUDANames;
        // } else if (Function *F = M.getFunction(HIPNames.RegisterGlobals);
        //            F && !F->isDeclaration()) {
        //     RegGlobals = F;
        //     RT = &HIPNames;
        // }
        // Detect the registration site (CUDA arg-0, or HIP inlined-ctor phi).
        Value *FatbinHandle = nullptr;
        Instruction *RegInsertPt = nullptr;
        Function *RegGlobals = nullptr;
        if (Function *F = findRegSite(M, &CUDANames, FatbinHandle, RegInsertPt)) {
            RegGlobals = F; RT = &CUDANames;
        } else if (Function *F = findRegSite(M, &HIPNames, FatbinHandle, RegInsertPt)) {
            RegGlobals = F; RT = &HIPNames;
        }

        if (!HasMain && !RegGlobals) {
            errs() << "[HostPass] Skipping TU (no main, no "
                   << CUDANames.RegisterGlobals << " / "
                   << HIPNames.RegisterGlobals << "): " << M.getName() << "\n";
            return PreservedAnalyses::all();
        }

        LLVMContext &Ctx = M.getContext();
        bool Changed = false;

        Type *I64 = Type::getInt64Ty(Ctx);
        Type *I32 = Type::getInt32Ty(Ctx);
        PointerType *PtrTy = PointerType::getUnqual(Ctx);
        ArrayType *ArrTy = ArrayType::get(I64, kNumCounters);

        // ===== Counter-side work: shadows + register calls + accessors =====
        // Done in the TU that has the register-globals function (the one with
        // kernel definitions).
        if (RegGlobals) {
            errs() << "[HostPass] TU has " << RegGlobals->getName()
                << " (" << RT->Tag << "); emitting shadows, register calls, and accessors.\n";

            // Stage A: aggregate shadow
            GlobalVariable *Shadow = M.getGlobalVariable(kAggSymbol);
            if (!Shadow) {
                Shadow = new GlobalVariable(
                    M, ArrTy, /*isConstant=*/false,
                    GlobalValue::InternalLinkage,
                    ConstantAggregateZero::get(ArrTy),
                    kAggSymbol);
                Shadow->setAlignment(Align(8));
                errs() << "[HostPass] Created host shadow: " << kAggSymbol
                       << "[" << kNumCounters << "]\n";
            }

            // Stage B: register call.
            // __cudaRegisterVar / __hipRegisterVar share the shape:
            //   (void **handle, char *hostVar, char *deviceAddress,
            //    const char *deviceName, int ext, size_t size,
            //    int constant, int global)
            FunctionType *RegVarTy = FunctionType::get(
                Type::getVoidTy(Ctx),
                {PtrTy, PtrTy, PtrTy, PtrTy, I32, I64, I32, I32},
                false);
            FunctionCallee RegVarFn = M.getOrInsertFunction(RT->RegisterVar, RegVarTy);

            // // Insert after clang's own register calls so our registrations
            // // happen on the same, already-live fatbin/module handle.
            // BasicBlock &EntryBB = RegGlobals->getEntryBlock();
            // Instruction *InsertPt = &*EntryBB.getFirstInsertionPt();
            // while (CallInst *CI = dyn_cast<CallInst>(InsertPt)) {
            //     if (Function *Callee = CI->getCalledFunction()) {
            //         StringRef N = Callee->getName();
            //         if (N == RT->RegisterFunction || N == RT->RegisterVar ||
            //             N == "__cudaRegisterManagedVar" ||
            //             N == "__hipRegisterManagedVar" ||
            //             N == "__cudaRegisterSurface" ||
            //             N == "__cudaRegisterTexture") {
            //             InsertPt = InsertPt->getNextNode();
            //             if (!InsertPt) break;
            //             continue;
            //         }
            //     }
            //     break;
            // }

            // IRBuilder<> RegBuilder(InsertPt ? InsertPt : EntryBB.getTerminator());
            // Value *FatbinHandle = RegGlobals->getArg(0);

            // Insertion point and fatbin handle were already resolved by
            // findRegSite: CUDA -> entry of __cuda_register_globals, handle = arg 0;
            // HIP -> right after the first __hipRegister* call in __hip_module_ctor,
            // handle = that call's operand 0 (the merged phi). Both dominate here.
            IRBuilder<> RegBuilder(RegInsertPt);   // [hip-ctor-fix]

            auto registerShadow = [&](GlobalVariable *GV, const char *SymName,
                                      uint64_t SizeBytes) {
                Constant *NameStr = RegBuilder.CreateGlobalString(
                    SymName, std::string("__gpu_var_name_") + SymName);
                RegBuilder.CreateCall(RegVarFn, {
                    FatbinHandle, GV, NameStr, NameStr,
                    ConstantInt::get(I32, 0),         // ext = 0
                    ConstantInt::get(I64, SizeBytes), // size
                    ConstantInt::get(I32, 0),         // constant = 0
                    ConstantInt::get(I32, 1),         // global = 1
                });
                errs() << "[HostPass] Registered shadow: " << SymName
                       << " (" << SizeBytes << " bytes)\n";
            };

            registerShadow(Shadow, kAggSymbol, (uint64_t)kNumCounters * 8);

            // Stage C: aggregate accessors
            emitReadFunction(M, Shadow);
            emitResetFunction(M, Shadow);

            // ===== Per-site sibling: shadow + register + read accessor =====
            ArrayType *SiteArrTy = ArrayType::get(I64, kNumSiteSlots);
            GlobalVariable *SiteShadow = M.getGlobalVariable(kSiteSymbol);
            if (!SiteShadow) {
                SiteShadow = new GlobalVariable(
                    M, SiteArrTy, /*isConstant=*/false,
                    GlobalValue::InternalLinkage,
                    ConstantAggregateZero::get(SiteArrTy),
                    kSiteSymbol);
                SiteShadow->setAlignment(Align(8));
                errs() << "[HostPass] Created host shadow: " << kSiteSymbol
                       << "[" << kNumSiteSlots << "]\n";
            }
            registerShadow(SiteShadow, kSiteSymbol, (uint64_t)kNumSiteSlots * 8);
            emitBulkReadFunction(M, SiteShadow, kReadSiteFn,
                                 (uint64_t)kNumSiteSlots * 8);

            // ===== Result-class sibling: shadow + register + read accessor =====
            ArrayType *ResArrTy = ArrayType::get(I64, kNumResultSlots);
            GlobalVariable *ResShadow = M.getGlobalVariable(kResultSymbol);
            if (!ResShadow) {
                ResShadow = new GlobalVariable(
                    M, ResArrTy, /*isConstant=*/false,
                    GlobalValue::InternalLinkage,
                    ConstantAggregateZero::get(ResArrTy),
                    kResultSymbol);
                ResShadow->setAlignment(Align(8));
                errs() << "[HostPass] Created host shadow: " << kResultSymbol
                       << "[" << kNumResultSlots << "]\n";
            }
            registerShadow(ResShadow, kResultSymbol, (uint64_t)kNumResultSlots * 8);
            emitBulkReadFunction(M, ResShadow, kReadResultFn,
                                 (uint64_t)kNumResultSlots * 8);

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
    const RuntimeNames *RT = &CUDANames;

    FunctionCallee getMemcpyFromSymbol(Module &M) {
        LLVMContext &Ctx = M.getContext();
        PointerType *PtrTy = PointerType::getUnqual(Ctx);
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        // (void* dst, const void* sym, size_t count, size_t offset, MemcpyKind)
        FunctionType *Ty = FunctionType::get(I32, {PtrTy, PtrTy, I64, I64, I32}, false);
        return M.getOrInsertFunction(RT->MemcpyFromSymbol, Ty);
    }

    FunctionCallee getMemcpyToSymbol(Module &M) {
        LLVMContext &Ctx = M.getContext();
        PointerType *PtrTy = PointerType::getUnqual(Ctx);
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        // (const void* sym, const void* src, size_t count, size_t offset, MemcpyKind)
        FunctionType *Ty = FunctionType::get(I32, {PtrTy, PtrTy, I64, I64, I32}, false);
        return M.getOrInsertFunction(RT->MemcpyToSymbol, Ty);
    }

    // Emit: extern "C" int fp_read_counters(u64*, u64*, u64*, u64*, u64*, u64*)
    // One coalesced D2H copy of the aggregate array, scattered into the six
    // output pointers (one per ExceptionID, in index order).
    void emitReadFunction(Module &M, GlobalVariable *Shadow) {
        LLVMContext &Ctx = M.getContext();
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        PointerType *PtrTy = PointerType::getUnqual(Ctx);
        ArrayType *ArrTy = ArrayType::get(I64, kNumCounters);

        FunctionCallee MemcpyFromSym = getMemcpyFromSymbol(M);

        FunctionType *ReadTy = FunctionType::get(
            I32, {PtrTy, PtrTy, PtrTy, PtrTy, PtrTy, PtrTy}, false);
        Function *ReadFn = Function::Create(
            ReadTy, GlobalValue::ExternalLinkage, kReadFn, &M);

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
        Value *Kind   = ConstantInt::get(I32, 2);  // cudaMemcpyDeviceToHost == hipMemcpyDeviceToHost == 2

        CallInst *Err = B.CreateCall(MemcpyFromSym, {Buf, Shadow, Size, Offset, Kind});
        Value *IsOK = B.CreateICmpEQ(Err, ConstantInt::get(I32, 0));
        B.CreateCondBr(IsOK, Ok, Bad);

        // Error path: propagate the runtime error code
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
        B.CreateRet(ConstantInt::get(I32, 0));  // success
    }

    // Emit: extern "C" int <FnName>(unsigned long long *dst)
    // One bulk D2H copy of the entire shadow array into dst (caller provides
    // a buffer of the matching slot count). Used for both fp_site_counters
    // and fp_result_counters — the two previous near-identical emitters
    // collapsed into one.
    void emitBulkReadFunction(Module &M, GlobalVariable *ArrShadow,
                              const char *FnName, uint64_t SizeBytes) {
        LLVMContext &Ctx = M.getContext();
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        PointerType *PtrTy = PointerType::getUnqual(Ctx);

        FunctionCallee MemcpyFromSym = getMemcpyFromSymbol(M);

        FunctionType *ReadTy = FunctionType::get(I32, {PtrTy}, false);
        Function *ReadFn = Function::Create(
            ReadTy, GlobalValue::ExternalLinkage, FnName, &M);
        ReadFn->getArg(0)->setName("dst");

        BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", ReadFn);
        IRBuilder<> B(Entry);

        Value *Dst    = ReadFn->getArg(0);
        Value *Size   = ConstantInt::get(I64, SizeBytes);
        Value *Offset = ConstantInt::get(I64, 0);
        Value *Kind   = ConstantInt::get(I32, 2);  // DeviceToHost

        CallInst *Err = B.CreateCall(MemcpyFromSym, {Dst, ArrShadow, Size, Offset, Kind});
        B.CreateRet(Err);
    }

    // Emit: extern "C" int fp_reset_counters(void) — zeroes the aggregate
    // array on device (one coalesced H2D copy of zeros).
    void emitResetFunction(Module &M, GlobalVariable *Shadow) {
        LLVMContext &Ctx = M.getContext();
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        ArrayType *ArrTy = ArrayType::get(I64, kNumCounters);

        FunctionCallee MemcpyToSym = getMemcpyToSymbol(M);

        FunctionType *ResetTy = FunctionType::get(I32, {}, false);
        Function *ResetFn = Function::Create(
            ResetTy, GlobalValue::ExternalLinkage, kResetFn, &M);

        BasicBlock *Entry = BasicBlock::Create(Ctx, "entry", ResetFn);
        IRBuilder<> B(Entry);

        // Stack [6 x i64] initialized to zero
        AllocaInst *Zeros = B.CreateAlloca(ArrTy, nullptr, "zeros");
        Zeros->setAlignment(Align(8));
        B.CreateAlignedStore(ConstantAggregateZero::get(ArrTy), Zeros, Align(8));

        // One coalesced 48-byte H2D copy
        Value *Size   = ConstantInt::get(I64, kNumCounters * 8);
        Value *Offset = ConstantInt::get(I64, 0);
        Value *Kind   = ConstantInt::get(I32, 1);  // HostToDevice == 1 (both runtimes)

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
        "v0.3",
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