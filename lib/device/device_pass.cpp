/*
PaFEx DevicePass — IR-level IEEE 754 exception instrumentation for GPU device
modules (NVIDIA NVPTX and AMD AMDGCN).

ARCHITECTURE:
   - Module pass. Declares __device__ global counter arrays in addrspace(1)
     (the GLOBAL address space on BOTH nvptx64 and amdgcn).
   - Worklist: collect instructions first, instrument after, to avoid
     iterator invalidation / undefined behavior while mutating.
   - Runs only on GPU device modules (nvptx64 or amdgcn triple).
   - Counters are read back by the HostPass / runtime driver:
       fp_counters[6]                          aggregate, indexed by ExceptionID
       fp_site_counters[kMaxSites*kSiteStride] per-site, dense site index
       fp_result_counters[kMaxSites*kResultStride] GPU-FPX-style (gated)

EXCEPTION COVERAGE (per IEEE 754-2019):
   EX_DIVZERO   §7.3  — fdiv(finite_nonzero, ±0), rcp(±0), logB(0)
   EX_INVALID   §7.2  — 0/0, ∞/∞, 0×∞, ∞-∞, sqrt(neg), sNaN operands
   EX_OVERFLOW  §7.4  — result exceeds MAX_FINITE (rounding-mode aware)
   EX_UNDERFLOW §7.5  — result is subnormal OR flushed-to-zero (mul/div)
   EX_SUBNORMAL       — result is subnormal, inputs were not (origination)

All checks are pure bit-pattern tests on the IEEE 754 binary32/binary64
encodings, so they are target-agnostic; only module gating, kernel
detection, intrinsic name matching, and the function filter are
target-specific.

CLI FLAGS (pass via -mllvm when driven from clang, or directly to opt):
   -result-class           also tally GPU-FPX-style result-bit classes
   -count-total[=false]    count every FP op into EX_FP_TOTAL (default true)
   -fp-sites-csv=<path>    where to write the static site table
                           (default fp_sites.csv; set per-target names for
                           dual NVIDIA/AMD builds so they don't clobber)
   -fp-verbose             per-instruction COLLECT/INSTRUMENT logging
   -fp-at-optimizer-last   auto-register at the OptimizerLast extension
                           point when loaded with -fpass-plugin (fires at
                           O0..O3); default off — the explicit
                           -passes=fp-exception pipeline spelling is
                           unaffected either way
*/
#include "fp_abi.h"

#include <map>
#include <string>
#include <vector>
#include <system_error>
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Demangle/Demangle.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Operator.h"
#include "llvm/Passes/PassBuilder.h"
#include "pass_plugin_compat.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/Triple.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

using namespace llvm;
namespace {

    // addrspace(1) is the GLOBAL memory space on both NVPTX and AMDGPU.
    constexpr unsigned GPU_GLOBAL_AS = 1;

    static llvm::cl::opt<bool> ResultClass(
        "result-class",
        llvm::cl::desc("Also classify by result-register bits, GPU-FPX-style "
                       "(NAN/INF/SUB/DIV0 per site, separate array). For comparison runs."),
        llvm::cl::init(false));

    static llvm::cl::opt<bool> CountTotal(
        "count-total",
        llvm::cl::desc("Count every FP op into EX_FP_TOTAL (denominator for exception "
                       "density). One atomic per FP op; pass =false for faster runs that "
                       "only need exception counts."),
        llvm::cl::init(true));

    static llvm::cl::opt<std::string> SitesCSVPath(
        "fp-sites-csv",
        llvm::cl::desc("Output path for the static site table written at compile time"),
        llvm::cl::init("fp_sites.csv"));

    static llvm::cl::opt<bool> Verbose(
        "fp-verbose",
        llvm::cl::desc("Per-instruction COLLECT/INSTRUMENT/inject logging "
                       "(very noisy at -O0)"),
        llvm::cl::init(false));

    static llvm::cl::opt<bool> AtOptimizerLast(
        "fp-at-optimizer-last",
        llvm::cl::desc("Auto-register the pass at the OptimizerLast extension point "
                       "(runs at O0..O3 when loaded via -fpass-plugin). Leave off if "
                       "you invoke the pass explicitly with -passes=fp-exception, or "
                       "it will run twice."),
        llvm::cl::init(false));
    static llvm::cl::opt<bool> FaithfulFMA(
        "faithful-fma",
        llvm::cl::desc("Fold contract-flagged fmul+fadd/fsub pairs into one FMA and "
                    "gate on the true inputs (a,b,c), matching backend fusion. "
                    "Fixes phantom intermediate overflow under -ffp-contract=fast. "
                    "Default off: preserves per-IR-op counts."),
        llvm::cl::init(false));
    static llvm::cl::opt<bool> InstrumentLibInternals(
        "instrument-libinternals",
        llvm::cl::desc("Instrument inside vendor math libraries (OCML/libdevice) and "
                    "inline math-header shims instead of counting at the call "
                    "boundary. Default off: library-internal FP ops are filtered "
                    "for cross-vendor comparability. Disables BOTH filter "
                    "mechanisms: the callee-name filter (catches library bodies "
                    "that still exist as functions) and the !pafex.libinternal "
                    "metadata filter (catches bodies already inlined into user "
                    "kernels; requires -fpass-plugin=TagPass.so at the clang step, "
                    "without which no tags exist and this flag only affects the "
                    "name filter)."),
        llvm::cl::init(false));
    // FP32 masks
    constexpr uint32_t F32_SIGN_MASK = 0x80000000;
    constexpr uint32_t F32_EXP_MASK  = 0x7F800000;
    constexpr uint32_t F32_MANT_MASK = 0x007FFFFF;
    constexpr uint32_t F32_ABS_MASK  = 0x7FFFFFFF;
    constexpr uint32_t F32_QNAN_BIT  = 0x00400000;
    constexpr uint32_t F32_MAX_FIN   = 0x7F7FFFFF;
    constexpr uint32_t F32_MIN_NORM  = 0x00800000;

    // FP64 masks
    constexpr uint64_t F64_SIGN_MASK = 0x8000000000000000ULL;
    constexpr uint64_t F64_EXP_MASK  = 0x7FF0000000000000ULL;
    constexpr uint64_t F64_MANT_MASK = 0x000FFFFFFFFFFFFFULL;
    constexpr uint64_t F64_ABS_MASK  = 0x7FFFFFFFFFFFFFFFULL;
    constexpr uint64_t F64_QNAN_BIT  = 0x0008000000000000ULL;
    constexpr uint64_t F64_MAX_FIN   = 0x7FEFFFFFFFFFFFFFULL;
    constexpr uint64_t F64_MIN_NORM  = 0x0010000000000000ULL;

    // ExceptionID and ResultClassID come from fp_abi.h (shared with the
    // HostPass and the runtime driver), as do the array layout constants.
    using namespace pafex;

    enum OperationID {
        OP_ADD  = 0,
        OP_SUB  = 1,
        OP_MUL  = 2,
        OP_DIV  = 3,
        OP_REM  = 4,
        OP_SQRT = 5,
        OP_FMA  = 6,
        OP_CVT  = 7,
        OP_CMP  = 8,
        OP_LOGB = 9,
        OP_RCP  = 10   // reciprocal intrinsic (AMD llvm.amdgcn.rcp.*); appended
                       // so existing IDs keep their values
    };

    enum RoundingModeID {
        RM_DEFAULT = 0,
        RM_ZERO    = 1,
        RM_MINF    = 2,
        RM_PINF    = 3
    };


    struct WorklistEntry {
        Instruction  *Instr;
        OperationID   OpID;
        std::string   FuncName;
        int           LineNumber;
        std::string   FileName;
        bool          IsF64;
        unsigned      SiteIndex = 0;   // dense per-(file:func:line) index, assigned post-collection
        std::string   OpTag; 
    };

    enum class GPUTarget { None, NVPTX, AMDGCN };

    static GPUTarget classifyModule(const Module &M) {
        Triple T(M.getTargetTriple());
        if (T.getArch() == Triple::nvptx64) return GPUTarget::NVPTX;
        if (T.getArch() == Triple::amdgcn)  return GPUTarget::AMDGCN;
        return GPUTarget::None;
    }

    // Matches the inlined/decomposed libdevice logb: bitcast(fabs(x)) compared
    // unsigned against the min-normal bit pattern. NVPTX libdevice uses
    // llvm.nvvm.fabs; the generic/AMD form uses llvm.fabs. The full
    // bitcast -> fabs -> icmp-against-MIN_NORM shape is specific enough that
    // accepting both fabs spellings does not over-match in practice.
    static bool matchDecomposedLogB(Instruction *I, Value *&OutArg) {
        auto *BC = dyn_cast<BitCastInst>(I);
        if (!BC) return false;

        auto *Fabs = dyn_cast<CallInst>(BC->getOperand(0));
        if (!Fabs || !Fabs->getCalledFunction()) return false;
        StringRef FabsName = Fabs->getCalledFunction()->getName();
        if (!FabsName.contains("llvm.nvvm.fabs") &&
            !FabsName.starts_with("llvm.fabs"))
            return false;

        Value *Arg = Fabs->getArgOperand(0);
        Type  *Ty  = Arg->getType();

        // min-normal threshold the libdevice logb decomposition compares against
        uint64_t Threshold;
        if (Ty->isFloatTy())       Threshold = 0x00800000ULL;          // 8388608
        else if (Ty->isDoubleTy()) Threshold = 0x0010000000000000ULL;  // 4503599627370496
        else return false;

        for (User *U : BC->users()) {
            auto *Cmp = dyn_cast<ICmpInst>(U);
            if (!Cmp) continue;
            // accept "bits < T" (ULT, const on RHS) or "T > bits" (UGT, const on LHS)
            ConstantInt *C = nullptr;
            if (Cmp->getPredicate() == CmpInst::ICMP_ULT)
                C = dyn_cast<ConstantInt>(Cmp->getOperand(1));
            else if (Cmp->getPredicate() == CmpInst::ICMP_UGT)
                C = dyn_cast<ConstantInt>(Cmp->getOperand(0));
            if (C && C->getZExtValue() == Threshold) {
                OutArg = Arg;
                return true;
            }
        }
        return false;
    }
    static bool matchContractFMA(Instruction *I, Value *&A, Value *&B, Value *&C,
                                Instruction **MulOut = nullptr) {
        unsigned Op = I->getOpcode();
        if (Op != Instruction::FAdd && Op != Instruction::FSub) return false;
        if (!cast<FPMathOperator>(I)->hasAllowContract()) return false;   // add is contract-flagged
        for (unsigned k = 0; k < 2; ++k) {                                // mul on either side
            auto *M = dyn_cast<Instruction>(I->getOperand(k));
            if (!M || M->getOpcode() != Instruction::FMul) continue;
            if (!cast<FPMathOperator>(M)->hasAllowContract() || !M->hasOneUse()) continue;
            A = M->getOperand(0); B = M->getOperand(1); C = I->getOperand(1 - k);
            if (MulOut) *MulOut = M;
            return true;
        }
        return false;
    }

    class DevicePass : public PassInfoMixin<DevicePass> {
    public:
        PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
        bool detectLogB(Instruction *I, Module &M, const WorklistEntry &Entry);
    private:
        GPUTarget Target = GPUTarget::None;

        void declareDeviceCounters(Module &M);
        void collectInstructions(Function &F, std::vector<WorklistEntry> &WL);
        bool instrumentInstruction(WorklistEntry &Entry, Module &M);
        bool isLibraryInternal(StringRef FuncName) const;
        Value* toInt(IRBuilder<> &B, Value *V);
        Value* isInf(IRBuilder<> &B, Value *V, Type *Ty);
        Value* isNaN(IRBuilder<> &B, Value *V, Type *Ty);
        Value* isSNaN(IRBuilder<> &B, Value *V, Type *Ty);
        Value* isZero(IRBuilder<> &B, Value *V, Type *Ty);
        Value* isNeg(IRBuilder<> &B, Value *V, Type *Ty);
        Value* isFinite(IRBuilder<> &B, Value *V, Type *Ty);
        Value* isSubnormal(IRBuilder<> &B, Value *V, Type *Ty);
        Value* isMaxFinite(IRBuilder<> &B, Value *V, Type *Ty);
        RoundingModeID getRoundingMode(Instruction *I);
        void injectExceptionCheck(Value *Condition, Instruction *InsertBefore,
                                ExceptionID ExID, OperationID OpID,
                                RoundingModeID RMode, bool IsF64,
                                const WorklistEntry &Entry, Module &M,
                                int ExtraSiteCol = -1);

        void injectTotalIncrement(Instruction *InsertBefore, Module &M);
        // GPU-FPX-style result-bit classification (gated behind -result-class).
        bool detectResultClass(Instruction *I, Instruction *NextI,
                               OperationID OpID, const WorklistEntry &Entry, Module &M);
        void injectResultCheck(Value *Condition, Instruction *InsertBefore,
                               unsigned ResultCol, const WorklistEntry &Entry, Module &M);

        // NOTE (bug fix): detectDivByZero and detectInvalidOp previously took a
        // shared IRBuilder created once in instrumentInstruction. The first
        // injectExceptionCheck splits the block at I, which moves I into a new
        // tail block and leaves the shared builder holding a stale
        // (block, iterator) pair — subsequent inserts through it corrupt the
        // instruction list (assertion failure on +Asserts builds, silent IR
        // corruption otherwise). Every detector now builds its own IRBuilder
        // at its own, current insertion point.
        bool detectDivByZero(Instruction *I, Module &M,
                            OperationID OpID, const WorklistEntry &Entry);
        bool detectInvalidOp(Instruction *I, Module &M,
                        OperationID OpID, const WorklistEntry &Entry);
        bool detectOverflow(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry);
        bool detectSubnormal(Instruction *I, Instruction *NextI, Module &M,
                     OperationID OpID, const WorklistEntry &Entry);
        bool detectUnderflow(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry);
        bool isKernelFunction(const Function &F);

        // ---- source-location site interning ----
        // Array layout (kMaxSites, kSiteStride, kColDivInvalid, kResultStride)
        // and the per-site column semantics are defined in fp_abi.h, shared
        // with the HostPass and the runtime driver.
        std::map<std::string, unsigned> SiteMap;     // "file:func:line" -> dense index
        std::vector<std::string> SiteList;           // index -> CSV row tail (tab-separated)
        unsigned UnknownLocSites = 0;                // sites with no debug location
        unsigned SpilledSites = 0;                   // distinct keys folded into the spill bucket

        // The last slot of the per-site array is RESERVED as the spill bucket and
        // is never interned to a real source location. Interning a real site there
        // (the previous behavior: clamp at kMaxSites, hand back kMaxSites-1) meant
        // every overflowing site atomically incremented the same columns as the
        // legitimate site that had already claimed that index — a silent, plausible
        // wrong answer, and it also kept the driver's SPILL branch permanently dead
        // because the slot had a real CSV row.
        static constexpr unsigned kSpillSite = kMaxSites - 1;

unsigned getSiteIndex(const std::string &File,
                              const std::string &Func, int Line,
                              bool IsKernel, const std::string &Op) {
            std::string Key = File + ":" + Func + ":" + std::to_string(Line);
            auto It = SiteMap.find(Key);
            if (It != SiteMap.end()) return It->second;
            unsigned Idx = (unsigned)SiteList.size();
            if (Idx >= kSpillSite) {
                // Deliberately do NOT push a SiteList row for the spill slot.
                // The driver's report keys the SPILL diagnostic on the ABSENCE
                // of a site-table entry at kMaxSites-1:
                //     if (g_sites && g_sites[s].valid)      -> print location
                //     else if (s == kMaxSites - 1)          -> print SPILL
                // Emitting a synthetic "<spill>" row into fp_sites.csv would set
                // valid=1 for that index and keep the SPILL branch dead — the
                // same dead branch as before this fix, for a new reason. No row
                // means load_site_table leaves the slot invalid and the driver
                // reports the overflow itself, which is where that message
                // belongs (it is the component that knows the counts).
                if (SpilledSites == 0) {
                    errs() << "[FPPass] WARNING: site table full (" << kSpillSite
                           << " addressable slots). Further sites fold into the "
                           << "reserved spill bucket at index " << kSpillSite
                           << "; their counts are NOT attributable to a source "
                           << "location. Raise kMaxSites in fp_abi.h and rebuild "
                           << "BOTH passes and the driver.\n";
                }
                // Intern the key to the spill slot so a repeated site is counted
                // once here, and so subsequent lookups short-circuit above.
                SiteMap[Key] = kSpillSite;
                ++SpilledSites;
                return kSpillSite;
            }
            SiteMap[Key] = Idx;
            if (Line < 0) ++UnknownLocSites;
            // Columns 1-3 (file, func, line) keep the original layout so
            // existing offline-join scripts that read the first four columns
            // are unaffected; func_pretty and is_kernel are appended.
            std::string Pretty = demangle(Func);
            const std::string &FileOut = File.empty() ? std::string("<unknown>") : File;
SiteList.push_back(FileOut + "\t" + Func + "\t" + std::to_string(Line) +
                               "\t" + Pretty + "\t" + (IsKernel ? "1" : "0") +
                               "\t" + Op);
            return Idx;
        }
    };

// Functions belonging to vendor device libraries / template runtimes whose
// internals we never instrument. User code that merely CALLS into these is
// still covered at the call site (sqrt/fma/logb collection below); what we
// skip is instrumenting the library bodies themselves.
bool DevicePass::isLibraryInternal(StringRef FuncName) const {
    // Common
    if (FuncName.contains("__internal_")) return true;

    if (Target == GPUTarget::NVPTX) {
        // Thrust's device backend mangles mostly as cuda::std / cuda_cub /
        // __cuda, none of which contain the literal substrings "thrust" or
        // "cub". Match the mangled namespace fragments that actually appear
        // in the bitcode.
        return FuncName.contains("thrust")     || FuncName.contains("cub")      ||
               FuncName.contains("cuda_cub")   ||
               FuncName.contains("4cuda3std")  || FuncName.contains("cuda3std") || // cuda::std backend
               FuncName.contains("__nv_")      ||  // libdevice math
               FuncName.contains("__cudart")   ||
               FuncName.contains("__syncwarp") ||  // warp barrier
               FuncName.contains("_sync")      ||  // __shfl_sync, __ballot_sync, ...
               FuncName.contains("atomicAdd")  ||
               FuncName.contains("__nanosleep");
    }

    if (Target == GPUTarget::AMDGCN) {
        // ROCm device libraries (linked in as bitcode pre-codegen) and HIP
        // runtime internals.
        //
        // This name filter only sees library code that still EXISTS as a
        // function. Once the inliner pastes an OCML body into a user kernel and
        // deletes the callee, there is no name left to match and the library's
        // internals get counted as user code — at -O1+ on myocyte that was ~7k
        // spurious ops, enough to reverse the sign of the optimization-level
        // trend. Nor is file:line separable: prebuilt ocml.bc ships without
        // debug info, so inlined instructions inherit the CALL SITE's
        // DILocation. The !pafex.libinternal metadata stamped by TagPass at
        // PipelineStartEP (before any inliner runs) is what covers that regime;
        // this filter covers the not-yet-inlined one. See collectInstructions.
        return FuncName.contains("__ocml")  ||  // math library
               FuncName.contains("__ockl")  ||  // kernel library
               FuncName.contains("__oclc_")  ||  // control constants
               FuncName.contains("__hip_")   ||
               FuncName.contains("rocprim")  ||  // ROCm's CUB analogue
               FuncName.contains("hipcub");
    }

    return false;
}

PreservedAnalyses DevicePass::run(Module &M, ModuleAnalysisManager &MAM) {
    Target = classifyModule(M);
    if (Target == GPUTarget::None) {
        errs() << "[FPPass] Skipping non-device module: "
            << Triple(M.getTargetTriple()).str() << "\n";
        return PreservedAnalyses::all();
    }
    errs() << "[FPPass] Running on device module ("
        << (Target == GPUTarget::NVPTX ? "nvptx64" : "amdgcn") << "): "
        << Triple(M.getTargetTriple()).str() << "\n";

    declareDeviceCounters(M);

    bool Changed = false;
    int totalFunctions = 0;
    int totalInstructions = 0;

    for (Function &F : M) {
        if (F.isDeclaration()) continue;
        if (F.getName().starts_with("__fppass_")) continue;
        // line 385, was: if (isLibraryInternal(F.getName())) continue;
        if (!InstrumentLibInternals && isLibraryInternal(F.getName())) continue;

        totalFunctions++;
        bool IsKern = isKernelFunction(F);
        if (Verbose)
            errs() << "[FPPass] Visiting function: " << F.getName()
                   << (IsKern ? " [KERNEL]\n" : " [device]\n");

        std::vector<WorklistEntry> Worklist;
        collectInstructions(F, Worklist);

        // Assign dense per-(file:func:line) site indices. SiteMap is a pass
        // member, so indices stay consistent across all functions in the module.
        for (WorklistEntry &E : Worklist) {
            E.SiteIndex = getSiteIndex(E.FileName, E.FuncName, E.LineNumber, IsKern, E.OpTag);        
        }

        if (Verbose)
            errs() << "[FPPass]   Collected " << Worklist.size()
                << " instructions to instrument\n";

        for (WorklistEntry &Entry : Worklist) {
            bool instrumented = instrumentInstruction(Entry, M);
            if (instrumented) {
                Changed = true;
                totalInstructions++;
            }
        }
    }

    errs() << "[FPPass] SUMMARY: visited " << totalFunctions
        << " functions, instrumented " << totalInstructions
        << " instructions, " << SiteList.size() << " sites\n";
    if (SpilledSites > 0)
        errs() << "[FPPass] WARNING: " << SpilledSites
               << " distinct site(s) exceeded kMaxSites and were folded into the "
               << "spill bucket (index " << kSpillSite << "). Per-site numbers for "
               << "this module are incomplete.\n";
    if (UnknownLocSites > 0)
        errs() << "[FPPass] NOTE: " << UnknownLocSites
               << " site(s) have no source location. Compile device code with "
               << "-gline-tables-only (or -g) to get file:line attribution.\n";

    // Dump the site map for offline join with the per-site counter readback.
    // Format: index<TAB>file<TAB>func<TAB>line<TAB>func_pretty<TAB>is_kernel
    // (first four columns unchanged from the previous layout).
    if (!SiteList.empty()) {
        std::error_code EC;
        raw_fd_ostream CSV(SitesCSVPath, EC);
        if (!EC) {
            CSV << "index\tfile\tfunc\tline\tfunc_pretty\tis_kernel\top\n";
            for (unsigned i = 0; i < SiteList.size(); ++i)
                CSV << i << "\t" << SiteList[i] << "\n";
            errs() << "[FPPass] Wrote " << SitesCSVPath << " with "
                   << SiteList.size() << " sites\n";
        } else {
            errs() << "[FPPass] WARNING: could not write " << SitesCSVPath
                   << ": " << EC.message() << "\n";
        }
    }

    return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
}

void DevicePass::declareDeviceCounters(Module &M) {
    LLVMContext &Ctx = M.getContext();
    Type *I64 = Type::getInt64Ty(Ctx);

    // --- aggregate array ---
    ArrayType *ArrTy = ArrayType::get(I64, 6);
    const char *Name = kAggSymbol;
    if (!M.getNamedGlobal(Name)) {
        GlobalVariable *GV = new GlobalVariable(
            M, ArrTy, /*isConstant=*/false,
            GlobalValue::ExternalLinkage,
            ConstantAggregateZero::get(ArrTy),
            Name, nullptr,
            GlobalValue::NotThreadLocal,
            GPU_GLOBAL_AS);
        GV->setAlignment(MaybeAlign(8));
        errs() << "[FPPass] Declared device counter array: " << Name << "[6]\n";
    }

    // --- per-site array ---
    ArrayType *SiteArrTy = ArrayType::get(I64, kMaxSites * kSiteStride);
    const char *SiteName = kSiteSymbol;
    if (!M.getNamedGlobal(SiteName)) {
        GlobalVariable *SiteGV = new GlobalVariable(
            M, SiteArrTy, /*isConstant=*/false,
            GlobalValue::ExternalLinkage,
            ConstantAggregateZero::get(SiteArrTy),
            SiteName, nullptr,
            GlobalValue::NotThreadLocal,
            GPU_GLOBAL_AS);
        SiteGV->setAlignment(MaybeAlign(8));
        errs() << "[FPPass] Declared device site array: " << SiteName
               << "[" << (kMaxSites * kSiteStride) << "]\n";
    }

    // --- per-site RESULT-CLASS array (GPU-FPX-style: classify by result bits) ---
    // Only meaningfully populated when -result-class is on, but always declared
    // so the host accessor/readback symbol resolves either way.
    ArrayType *ResArrTy = ArrayType::get(I64, kMaxSites * kResultStride);
    const char *ResName = kResultSymbol;
    if (!M.getNamedGlobal(ResName)) {
        GlobalVariable *ResGV = new GlobalVariable(
            M, ResArrTy, /*isConstant=*/false,
            GlobalValue::ExternalLinkage,
            ConstantAggregateZero::get(ResArrTy),
            ResName, nullptr,
            GlobalValue::NotThreadLocal,
            GPU_GLOBAL_AS);
        ResGV->setAlignment(MaybeAlign(8));
        errs() << "[FPPass] Declared device result-class array: " << ResName
               << "[" << (kMaxSites * kResultStride) << "]\n";
    }
}

void DevicePass::collectInstructions(Function &F, std::vector<WorklistEntry> &WL) {
    std::string FuncName = F.getName().str();
    SmallPtrSet<Instruction*, 16> FusedMuls, FmaAdds;
    if (FaithfulFMA) {
        for (BasicBlock &BB : F)
            for (Instruction &Inst : BB) {
                Value *A, *B, *C; Instruction *Mul = nullptr;
                if (matchContractFMA(&Inst, A, B, C, &Mul)) {
                    FmaAdds.insert(&Inst);
                    FusedMuls.insert(Mul);
                }
            }
    }

    for (BasicBlock &BB : F) {
        for (Instruction &I : BB) {
            // Library-internal ops that were inlined into this function keep their
            // origin tag through inlining; the function-name filter at line 392
            // cannot see them because the callee's name no longer exists.
            if (!InstrumentLibInternals && I.getMetadata("pafex.libinternal"))
                continue;

            int LineNum = -1;
            std::string FileName = "";
            if (const DebugLoc &DL = I.getDebugLoc()) {
                LineNum = (int)DL.getLine();
                if (DILocation *Loc = DL.get()) {
                    FileName = Loc->getFilename().str();
                }
            }

            Type *Ty = I.getType();
            bool isF64 = Ty->isDoubleTy();
            bool isF32 = Ty->isFloatTy();

            auto collect = [&](OperationID Op, bool F64Flag, const char *Tag,
                               StringRef Detail = "") {
                WL.push_back({&I, Op, FuncName, LineNum, FileName, F64Flag, 0, Tag});
                if (Verbose)
                    errs() << "[FPPass]   COLLECT " << Tag
                           << (Detail.empty() ? "" : " '") << Detail
                           << (Detail.empty() ? "" : "'")
                           << " @ " << FuncName << ":" << LineNum << "\n";
            };

            switch (I.getOpcode()) {
                case Instruction::FAdd:
                    if (FaithfulFMA && FmaAdds.count(&I)) { collect(OP_FMA, isF64, "contract-fma"); break; }
                    if (isF32 || isF64) collect(OP_ADD, isF64, "fadd");
                    break;
                case Instruction::FSub:
                    if (FaithfulFMA && FmaAdds.count(&I)) { collect(OP_FMA, isF64, "contract-fma"); break; }
                    if (isF32 || isF64) collect(OP_SUB, isF64, "fsub");
                    break;
                case Instruction::FMul:
                    if (FaithfulFMA && FusedMuls.count(&I)) break;   // consumed by an FMA
                    if (isF32 || isF64) collect(OP_MUL, isF64, "fmul");
                    break;

                case Instruction::FDiv:
                    if (isF32 || isF64) collect(OP_DIV, isF64, "fdiv");
                    break;

                case Instruction::FRem:
                    if (isF32 || isF64) collect(OP_REM, isF64, "frem");
                    break;

                case Instruction::Call: {
                    auto *CI = dyn_cast<CallInst>(&I);
                    if (!CI) break;

                    Function *Callee = CI->getCalledFunction();
                    if (!Callee || !Callee->hasName()) break;

                    StringRef Name = Callee->getName();

                    // --- sqrt: generic, NVPTX, AMDGPU ---
                    if (Name.starts_with("llvm.sqrt") ||
                        Name.starts_with("llvm.nvvm.sqrt") ||
                        Name.starts_with("llvm.amdgcn.sqrt") ||
                        Name.contains("__ocml_sqrt_")) {
                        if (CI->arg_size() >= 1) {
                            Type *ArgTy = CI->getArgOperand(0)->getType();
                            if (ArgTy->isFloatTy() || ArgTy->isDoubleTy())
                                collect(OP_SQRT, ArgTy->isDoubleTy(), "sqrt", Name);
                        }
                    }
                    // --- fma: generic, NVPTX, AMDGPU ---
                    // NOTE: "llvm.fma." with trailing dot — bare "llvm.fma"
                    // also prefixes unrelated names.
                    else if (Name.starts_with("llvm.fma.") ||
                             Name.starts_with("llvm.fmuladd") ||
                             Name.starts_with("llvm.nvvm.fma") ||
                             Name.starts_with("llvm.amdgcn.fma")) {
                        if (isF32 || isF64)
                            collect(OP_FMA, isF64, "fma", Name);
                    }
                    // --- AMDGPU reciprocal: rcp(x) = 1/x. One argument, so it
                    // gets its own OperationID rather than masquerading as
                    // OP_DIV (whose detectors expect dividend+divisor). ---
                    else if (Name.starts_with("llvm.amdgcn.rcp")) {
                        if (CI->arg_size() >= 1) {
                            Type *ArgTy = CI->getArgOperand(0)->getType();
                            if (ArgTy->isFloatTy() || ArgTy->isDoubleTy())
                                collect(OP_RCP, ArgTy->isDoubleTy(), "rcp", Name);
                        }
                    }
                    // NVPTX rounding-mode arithmetic intrinsics
                    // (llvm.nvvm.{add,sub,mul,div}.{rn,rz,rd,ru}.{f,d})
                    // Emitted by clang when inlining libdevice transcendentals or when
                    // user code calls __fadd_rn / __fmul_rd / etc. Fast-math
                    // approx forms (llvm.nvvm.div.approx.*, .full.*) match the
                    // same prefixes and are collected identically.
                    else if (Name.starts_with("llvm.nvvm.add.")) {
                        if (isF32 || isF64) collect(OP_ADD, isF64, "nvvm.add", Name);
                    }
                    else if (Name.starts_with("llvm.nvvm.sub.")) {
                        if (isF32 || isF64) collect(OP_SUB, isF64, "nvvm.sub", Name);
                    }
                    else if (Name.starts_with("llvm.nvvm.mul.")) {
                        if (isF32 || isF64) collect(OP_MUL, isF64, "nvvm.mul", Name);
                    }
                    else if (Name.starts_with("llvm.nvvm.div.")) {
                        if (isF32 || isF64) collect(OP_DIV, isF64, "nvvm.div", Name);
                    }
                    // AMDGPU rounding-mode arithmetic wrappers
                    // (__ocml_{add,sub,mul,fma}_rt{e,n,p,z}_f{16,32,64})
                    //
                    // HIP's __fadd_rz / __fmul_rd / __fmaf_ru / __dadd_rz etc.
                    // lower to these -- but ONLY when the translation unit is
                    // compiled with -DOCML_BASIC_ROUNDED_OPERATIONS. Without
                    // that macro the identifiers do not exist at all (hard
                    // front-end error) and the only rounding entry points are
                    // __fadd_rn / __fmul_rn / __fmaf_rn, which expand to plain
                    // fadd / fmul / llvm.fma and are collected by those cases.
                    //
                    // Unlike NVPTX, the mode is NOT in the instruction. The
                    // wrapper body is:
                    //     llvm.amdgcn.s.setreg(hwreg(HW_REG_MODE,0,2), <mode>)
                    //     llvm.experimental.constrained.fadd.f32(
                    //         ..., metadata !"round.dynamic", ...)
                    //     llvm.amdgcn.s.setreg(hwreg(HW_REG_MODE,0,2), 0)
                    // The constrained intrinsic says "round.dynamic" -- it
                    // deliberately does not name the mode, which lives in the
                    // MODE.FP_ROUND hardware register. The callee NAME is the
                    // only place the rounding mode is legible in the IR, which
                    // is why getRoundingMode matches on it.
                    //
                    // That name survives optimization: these wrappers carry
                    // `strictfp`, and LLVM refuses to inline a strictfp callee
                    // into a non-strictfp caller (it would have to convert every
                    // FP op in the caller to constrained form). Under the
                    // default FP model a HIP kernel is never strictfp, so the
                    // calls remain intact at -O0 through -O3. Verified on
                    // gfx942/ROCm 7.2.4. NOTE: -ffp-model=strict would make the
                    // caller strictfp and this property would no longer hold.
                    //
                    // _rte_ (round-to-nearest-even) is collected here even
                    // though it maps to RM_DEFAULT: with the macro on, __fadd_rn
                    // is a CALL to __ocml_add_rte_f32 at -O0 and there is no
                    // fadd for the FAdd case to catch. The rte wrapper is the
                    // one that lacks `strictfp` (its mode is the default, so the
                    // setreg pair is a no-op sandwich), so at -O1+ it inlines
                    // and folds back to a bare fadd. Collecting the call keeps
                    // -O0 and -O1+ counting the same operation.
                    else if (Name.starts_with("__ocml_add_rt")) {
                        if (isF32 || isF64) collect(OP_ADD, isF64, "ocml.add", Name);
                    }
                    else if (Name.starts_with("__ocml_sub_rt")) {
                        if (isF32 || isF64) collect(OP_SUB, isF64, "ocml.sub", Name);
                    }
                    else if (Name.starts_with("__ocml_mul_rt")) {
                        if (isF32 || isF64) collect(OP_MUL, isF64, "ocml.mul", Name);
                    }
                    else if (Name.starts_with("__ocml_fma_rt")) {
                        if (isF32 || isF64) collect(OP_FMA, isF64, "ocml.fma", Name);
                    }
                    // __ocml_div_rt{e,n,p,z}_f{32,64}: deliberately NOT
                    // collected. ROCm 7.2.4 declares __fdiv_rd/rn/ru/rz and
                    // __ddiv_* in __clang_hip_math.h, and they compile, but NO
                    // device-lib bitcode in the distribution defines the
                    // corresponding __ocml_div_rt* symbols -- they appear in the
                    // IR as `declare`, never `define`. Instrumenting a call that
                    // cannot resolve buys nothing. This is a vendor gap, not a
                    // PaFEx limitation: NVPTX has llvm.nvvm.div.{rn,rz,rm,rp},
                    // AMD has no counterpart to compare against.
                    // f16 wrappers (__ocml_add_rtz_f16 etc.) also exist but are
                    // filtered by the isF32/isF64 guards above -- the detectors
                    // only model f32/f64 exception semantics.
                    // logb / __ocml_logb_*; excludes ilogb (integer result, no
                    // FP exception semantics at the result level)
                    else if (Name.contains("logb") && !Name.contains("ilogb")) {
                        Type *ResTy = CI->getType();
                        if (ResTy->isFloatTy() || ResTy->isDoubleTy())
                            collect(OP_LOGB, ResTy->isDoubleTy(), "logb call", Name);
                    }

                    break;
                }

                // Decomposed/inlined logb shows up as a bitcast anchor.
                case Instruction::BitCast: {
                    Value *LogBArg = nullptr;
                    if (matchDecomposedLogB(&I, LogBArg)) {
                        bool dbl = LogBArg->getType()->isDoubleTy();
                        collect(OP_LOGB, dbl, "decomposed-logb bitcast");
                    }
                    break;
                }

                default:
                    break;
            }
        }
    }
}

bool DevicePass::instrumentInstruction(WorklistEntry &Entry, Module &M) {
    Instruction *I = Entry.Instr;
    OperationID OpID = Entry.OpID;

    if (!I->getParent()) {
        errs() << "[FPPass]   WARN: instruction has no parent BB, skipping\n";
        return false;
    }

    bool Changed = false;

    if (Verbose)
        errs() << "[FPPass]   INSTRUMENT " << Entry.FuncName
            << ":" << Entry.LineNumber << " op=" << OpID << "\n";

    // Count this FP op toward EX_FP_TOTAL unconditionally, BEFORE the per-class
    // detectors (which only fire inside exception guards). Without this,
    // fp_counters[EX_FP_TOTAL] stays 0 and exception density is undefined.
    // Gated by -count-total: one atomic per FP op is the dominant cost on
    // exception-sparse kernels, so pass -count-total=false to drop it when you
    // only need exception counts (e.g. GPU-FPX comparison runs).
    if (CountTotal) {
        injectTotalIncrement(I, M);
        Changed = true;
    }

    // The pre-op detectors (invalid, divzero) split the block at I, so fetch
    // NextI for the post-op detectors only AFTER they have run. I and its
    // successor stay adjacent across those splits, but re-fetching makes the
    // invariant explicit instead of relying on it.
    switch (OpID) {
        case OP_DIV:
            Changed |= detectInvalidOp(I, M, OP_DIV, Entry);
            Changed |= detectDivByZero(I, M, OP_DIV, Entry);
            break;

        case OP_RCP:
            Changed |= detectInvalidOp(I, M, OP_RCP, Entry);
            Changed |= detectDivByZero(I, M, OP_RCP, Entry);
            break;

        case OP_ADD:
        case OP_SUB:
        case OP_MUL:
        case OP_FMA:
            Changed |= detectInvalidOp(I, M, OpID, Entry);
            break;

        case OP_SQRT:
            Changed |= detectInvalidOp(I, M, OP_SQRT, Entry);
            break;

        case OP_CVT:
            Changed |= detectInvalidOp(I, M, OP_CVT, Entry);
            break;

        case OP_REM:
            Changed |= detectInvalidOp(I, M, OP_REM, Entry);
            break;

        case OP_LOGB:
            Changed |= detectLogB(I, M, Entry);
            break;

        default:
            break;
    }

    Instruction *NextI = I->getNextNode();

    switch (OpID) {
        case OP_DIV:
        case OP_RCP:
        case OP_ADD:
        case OP_SUB:
        case OP_MUL:
        case OP_FMA:
            Changed |= detectOverflow(I, NextI, M, OpID, Entry);
            Changed |= detectUnderflow(I, NextI, M, OpID, Entry);
            Changed |= detectSubnormal(I, NextI, M, OpID, Entry);
            break;
        default:
            break;
    }

    // GPU-FPX-style result-bit classification into the separate fp_result_counters
    // array. Independent of the IEEE detectors above; runs only under -result-class.
    if (ResultClass)
        Changed |= detectResultClass(I, NextI, OpID, Entry, M);

    return Changed;
}

// Bit-level helper functions

Value* DevicePass::toInt(IRBuilder<> &B, Value *V) {
    Type *Ty = V->getType();
    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) {
        errs() << "[FPPass] WARN: toInt() got non-FP type, skipping\n";
        return UndefValue::get(Type::getInt64Ty(B.getContext()));
    }
    unsigned Width = Ty->getPrimitiveSizeInBits();
    return B.CreateBitCast(V, Type::getIntNTy(B.getContext(), Width));
}

Value* DevicePass::isInf(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Value *Bits = toInt(B, V);
    Type *ITy = Bits->getType();
    uint64_t ExpM = Ty->isDoubleTy() ? F64_EXP_MASK : F32_EXP_MASK;
    uint64_t ManM = Ty->isDoubleTy() ? F64_MANT_MASK : F32_MANT_MASK;

    Value *ExpBits = B.CreateAnd(Bits, ConstantInt::get(ITy, ExpM));
    Value *ExpIsMax = B.CreateICmpEQ(ExpBits, ConstantInt::get(ITy, ExpM));
    Value *MantBits = B.CreateAnd(Bits, ConstantInt::get(ITy, ManM));
    Value *MantIsZero = B.CreateICmpEQ(MantBits, ConstantInt::get(ITy, 0));
    return B.CreateAnd(ExpIsMax, MantIsZero, "is_inf");
}

Value* DevicePass::isNaN(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Value *Bits = toInt(B, V);
    Type *ITy = Bits->getType();
    uint64_t ExpM = Ty->isDoubleTy() ? F64_EXP_MASK : F32_EXP_MASK;
    uint64_t ManM = Ty->isDoubleTy() ? F64_MANT_MASK : F32_MANT_MASK;

    Value *ExpBits = B.CreateAnd(Bits, ConstantInt::get(ITy, ExpM));
    Value *ExpIsMax = B.CreateICmpEQ(ExpBits, ConstantInt::get(ITy, ExpM));
    Value *MantBits = B.CreateAnd(Bits, ConstantInt::get(ITy, ManM));
    Value *MantNonZero = B.CreateICmpNE(MantBits, ConstantInt::get(ITy, 0));
    return B.CreateAnd(ExpIsMax, MantNonZero, "is_nan");
}

Value* DevicePass::isSNaN(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Value *Bits = toInt(B, V);
    Type *ITy = Bits->getType();
    uint64_t QBit = Ty->isDoubleTy() ? F64_QNAN_BIT : F32_QNAN_BIT;

    Value *IsNaN_ = isNaN(B, V, Ty);
    Value *QBitVal = B.CreateAnd(Bits, ConstantInt::get(ITy, QBit));
    Value *QBitZero = B.CreateICmpEQ(QBitVal, ConstantInt::get(ITy, 0));
    return B.CreateAnd(IsNaN_, QBitZero, "is_snan");
}

Value* DevicePass::isZero(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Value *Bits = toInt(B, V);
    Type *ITy = Bits->getType();
    uint64_t AbsM = Ty->isDoubleTy() ? F64_ABS_MASK : F32_ABS_MASK;

    Value *AbsBits = B.CreateAnd(Bits, ConstantInt::get(ITy, AbsM));
    return B.CreateICmpEQ(AbsBits, ConstantInt::get(ITy, 0), "is_zero");
}

Value* DevicePass::isNeg(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Value *Bits = toInt(B, V);
    Type *ITy = Bits->getType();
    uint64_t SignM = Ty->isDoubleTy() ? F64_SIGN_MASK : F32_SIGN_MASK;

    Value *SignBit = B.CreateAnd(Bits, ConstantInt::get(ITy, SignM));
    return B.CreateICmpNE(SignBit, ConstantInt::get(ITy, 0), "is_neg");
}

Value* DevicePass::isFinite(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Value *Bits = toInt(B, V);
    Type *ITy = Bits->getType();
    uint64_t ExpM = Ty->isDoubleTy() ? F64_EXP_MASK : F32_EXP_MASK;

    Value *ExpBits = B.CreateAnd(Bits, ConstantInt::get(ITy, ExpM));
    return B.CreateICmpNE(ExpBits, ConstantInt::get(ITy, ExpM), "is_finite");
}

Value* DevicePass::isSubnormal(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Value *Bits = toInt(B, V);
    Type *ITy = Bits->getType();
    uint64_t ExpM = Ty->isDoubleTy() ? F64_EXP_MASK : F32_EXP_MASK;
    uint64_t ManM = Ty->isDoubleTy() ? F64_MANT_MASK : F32_MANT_MASK;

    Value *ExpBits = B.CreateAnd(Bits, ConstantInt::get(ITy, ExpM));
    Value *ExpIsZero = B.CreateICmpEQ(ExpBits, ConstantInt::get(ITy, 0));
    Value *MantBits = B.CreateAnd(Bits, ConstantInt::get(ITy, ManM));
    Value *MantNonZero = B.CreateICmpNE(MantBits, ConstantInt::get(ITy, 0));
    return B.CreateAnd(ExpIsZero, MantNonZero, "is_subnormal");
}

Value* DevicePass::isMaxFinite(IRBuilder<> &B, Value *V, Type *Ty) {
    if (!Ty->isFloatTy() && !Ty->isDoubleTy())
        return ConstantInt::getFalse(B.getContext());

    Type *ITy = Type::getIntNTy(B.getContext(), Ty->getPrimitiveSizeInBits());
    Value *Bits = B.CreateBitCast(V, ITy);
    uint64_t MaxFin = Ty->isDoubleTy() ? F64_MAX_FIN : F32_MAX_FIN;
    uint64_t AbsM = Ty->isDoubleTy() ? F64_ABS_MASK : F32_ABS_MASK;

    Value *Abs = B.CreateAnd(Bits, ConstantInt::get(ITy, AbsM));
    return B.CreateICmpEQ(Abs, ConstantInt::get(ITy, MaxFin), "is_maxfinite");
}

RoundingModeID DevicePass::getRoundingMode(Instruction *I) {
    if (auto *CI = dyn_cast<CallInst>(I)) {
        if (Function *F = CI->getCalledFunction()) {
            StringRef Name = F->getName();
            // NVPTX: llvm.nvvm.{add,sub,mul,div}.{rn,rz,rm,rp}.{f,d}
            // (.rm = toward -inf, .rp = toward +inf; .rd/.ru are cvt's
            //  spelling, not arithmetic's, and never appear here.)
            if (Name.contains(".rz")) return RM_ZERO;
            if (Name.contains(".rm")) return RM_MINF;
            if (Name.contains(".rp")) return RM_PINF;
            // AMDGPU: __ocml_{add,sub,mul,fma}_rt{e,n,p,z}_f{16,32,64}
            // (_rtn_ = toward negative inf, _rtp_ = toward positive inf.)
            // No collision with the NVPTX arms above: NVVM spells the mode
            // with dots, OCML with underscores.
            if (Name.contains("_rtz_")) return RM_ZERO;
            if (Name.contains("_rtn_")) return RM_MINF;
            if (Name.contains("_rtp_")) return RM_PINF;
            // _rte_ / .rn = round-to-nearest-even = the IEEE default; both
            // fall through to RM_DEFAULT below. Listing them explicitly would
            // be a no-op.
        }
    }
    return RM_DEFAULT;
}

void DevicePass::injectExceptionCheck(Value *Condition, Instruction *InsertBefore,
                                    ExceptionID ExID, OperationID OpID,
                                    RoundingModeID RMode, bool IsF64,
                                    const WorklistEntry &Entry, Module &M,
                                    int ExtraSiteCol) {
    LLVMContext &Ctx = M.getContext();

    Instruction *ThenTerm = SplitBlockAndInsertIfThen(Condition, InsertBefore, false);
    IRBuilder<> B(ThenTerm);

    // --- aggregate atomic (feeds fp_counters[6] -> PAPI) ---
    GlobalVariable *Counters = M.getNamedGlobal(kAggSymbol);
    if (Counters) {
        Type *I32 = Type::getInt32Ty(Ctx);
        Type *I64 = Type::getInt64Ty(Ctx);
        Value *Idx[] = {
            ConstantInt::get(I32, 0),       // strip outer pointer
            ConstantInt::get(I32, ExID)     // pick element [ExID]
        };
        Value *Ptr = B.CreateInBoundsGEP(Counters->getValueType(), Counters, Idx);
        B.CreateAtomicRMW(
            AtomicRMWInst::Add,
            Ptr,
            ConstantInt::get(I64, 1),
            MaybeAlign(8),
            AtomicOrdering::Monotonic
        );
    }

    // --- per-site atomic (additive; does not touch the aggregate path) ---
    GlobalVariable *SiteCounters = M.getNamedGlobal(kSiteSymbol);
    if (SiteCounters) {
        Type *I32s = Type::getInt32Ty(Ctx);
        Type *I64s = Type::getInt64Ty(Ctx);

        // Remap sparse ExceptionID (0,1,2,3,5) to dense column (0..4).
        // EX_FP_TOTAL (4) is not an exception type and never reaches here.
        unsigned Col;
        switch (ExID) {
            case EX_INVALID:   Col = 0; break;
            case EX_DIVZERO:   Col = 1; break;
            case EX_OVERFLOW:  Col = 2; break;
            case EX_UNDERFLOW: Col = 3; break;
            case EX_SUBNORMAL: Col = 4; break;
            default:           Col = 0; break;   // defensive; shouldn't happen
        }
        unsigned Slot = Entry.SiteIndex * kSiteStride + Col;

        Value *SiteIdx[] = {
            ConstantInt::get(I32s, 0),
            ConstantInt::get(I32s, Slot)
        };
        Value *SitePtr = B.CreateInBoundsGEP(SiteCounters->getValueType(), SiteCounters, SiteIdx);
        B.CreateAtomicRMW(
            AtomicRMWInst::Add,
            SitePtr,
            ConstantInt::get(I64s, 1),
            MaybeAlign(8),
            AtomicOrdering::Monotonic
        );

        // Optional breakdown column (same condition, same then-block): used by
        // detectInvalidOp to also tally division-sourced invalids into col 5,
        // so the report can split NAN vs DIV0 exactly. col 0 still holds ALL
        // invalids, so this is purely additive (non-div invalid = col0 - col5).
        if (ExtraSiteCol >= 0) {
            unsigned ExSlot = Entry.SiteIndex * kSiteStride + (unsigned)ExtraSiteCol;
            Value *ExIdx[] = {
                ConstantInt::get(I32s, 0),
                ConstantInt::get(I32s, ExSlot)
            };
            Value *ExPtr = B.CreateInBoundsGEP(SiteCounters->getValueType(), SiteCounters, ExIdx);
            B.CreateAtomicRMW(
                AtomicRMWInst::Add,
                ExPtr,
                ConstantInt::get(I64s, 1),
                MaybeAlign(8),
                AtomicOrdering::Monotonic
            );
        }
    }

    if (Verbose)
        errs() << "[FPPass]     -> Injected check: ex=" << ExID
            << " op=" << OpID << " line=" << Entry.LineNumber << "\n";
}

// Unconditional per-op increment of fp_counters[EX_FP_TOTAL]. Fires for every
// instrumented FP op (no condition guard), so it is the denominator for
// exception density. Aggregate-array path only:
//   - does NOT touch fp_site_counters: that array's stride-6 columns are the
//     five exception classes plus the division-invalid breakdown; total has
//     no per-site column, which is exactly why injectExceptionCheck's
//     per-site block was written to never see EX_FP_TOTAL.
void DevicePass::injectTotalIncrement(Instruction *InsertBefore, Module &M) {
    LLVMContext &Ctx = M.getContext();
    IRBuilder<> B(InsertBefore);

    GlobalVariable *Counters = M.getNamedGlobal(kAggSymbol);
    if (!Counters) return;

    Type *I32 = Type::getInt32Ty(Ctx);
    Type *I64 = Type::getInt64Ty(Ctx);
    Value *Idx[] = {
        ConstantInt::get(I32, 0),
        ConstantInt::get(I32, EX_FP_TOTAL)
    };
    Value *Ptr = B.CreateInBoundsGEP(Counters->getValueType(), Counters, Idx);
    B.CreateAtomicRMW(
        AtomicRMWInst::Add,
        Ptr,
        ConstantInt::get(I64, 1),
        MaybeAlign(8),
        AtomicOrdering::Monotonic
    );
}

bool DevicePass::detectDivByZero(Instruction *I, Module &M,
                                OperationID OpID, const WorklistEntry &Entry) {
    // OP_LOGB/OP_RCP take their type from the argument, not the result. The
    // OP_LOGB arm is unreachable today (instrumentInstruction routes OP_LOGB to
    // detectLogB, which handles both the call and the decomposed-bitcast form),
    // but an unconditional cast<CallInst> here would abort if it ever were
    // reached with the bitcast anchor. dyn_cast + bail instead of cast + crash.
    Type *Ty = I->getType();
    if (OpID == OP_LOGB || OpID == OP_RCP) {
        auto *CI = dyn_cast<CallInst>(I);
        if (!CI || CI->arg_size() < 1) return false;
        Ty = CI->getArgOperand(0)->getType();
    }

    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;

    // Fresh builder at I's CURRENT position (see note on the declaration:
    // a previous detector may have split the block at I).
    IRBuilder<> B(I);
    Value *Condition = nullptr;

    if (OpID == OP_DIV) {
        Value *Dividend = I->getOperand(0);
        Value *Divisor = I->getOperand(1);

        Value *DivisorIsZero = isZero(B, Divisor, Ty);
        Value *DividendFinite = isFinite(B, Dividend, Ty);
        Value *DividendNonZero = B.CreateNot(isZero(B, Dividend, Ty));
        Value *ValidDividend = B.CreateAnd(DividendFinite, DividendNonZero);
        Condition = B.CreateAnd(DivisorIsZero, ValidDividend, "divzero_cond");
    }
    else if (OpID == OP_RCP) {
        // rcp(±0) -> ±inf: divideByZero with an implicit finite, non-zero
        // dividend of 1.0, so the zero check on the (single) operand suffices.
        Value *Arg = cast<CallInst>(I)->getArgOperand(0);
        Condition = isZero(B, Arg, Ty);
    }
    else if (OpID == OP_LOGB) {
        Value *Arg = cast<CallInst>(I)->getArgOperand(0);
        Condition = isZero(B, Arg, Ty);
    }

    if (!Condition) return false;

    injectExceptionCheck(Condition, I, EX_DIVZERO, OpID,
                        RM_DEFAULT, Ty->isDoubleTy(), Entry, M);
    return true;
}

// GPU-FPX-style classification by RESULT-register bits, inserted AFTER the op
// (at NextI) so the result value is live. This is a faithful transcription of
// GPU-FPX's inject_funcs logic:
//   - DIVIDE ops: if the result is Inf OR NaN, count as DIV0 only. GPU-FPX's
//     divide path (_FPC_IS_0) does not separately bucket NAN/INF/SUB. This is
//     why GPU-FPX's DIV0 absorbs both x/0 (->inf) and 0/0 (->nan), which our
//     IEEE path splits into divzero vs invalid.
//   - non-DIVIDE ops: classify the result as NAN / INF / SUB independently,
//     exactly like _FPC_IS_NAN/INF/SUBNORMAL.
// Note: this counts result-bit appearances, so it INCLUDES propagation (an op
// merely passing a NaN/Inf through), unlike our operand-pattern IEEE detectors
// which count only origination. That difference is intentional and is what
// makes these numbers comparable to GPU-FPX's.
bool DevicePass::detectResultClass(Instruction *I, Instruction *NextI,
                                   OperationID OpID, const WorklistEntry &Entry,
                                   Module &M) {
    if (!NextI) return false;                  // need an insertion point after I
    Type *Ty = I->getType();
    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) // result-bit classification only
        return false;                          //   meaningful for FP results (skips CVT-to-int)

    if (OpID == OP_DIV || OpID == OP_RCP) {
        IRBuilder<> B(NextI);
        Value *Bad = B.CreateOr(isNaN(B, I, Ty), isInf(B, I, Ty));
        injectResultCheck(Bad, NextI, RC_DIV0, Entry, M);
    } else {
        { IRBuilder<> B(NextI); injectResultCheck(isNaN(B, I, Ty),       NextI, RC_NAN, Entry, M); }
        { IRBuilder<> B(NextI); injectResultCheck(isInf(B, I, Ty),       NextI, RC_INF, Entry, M); }
        { IRBuilder<> B(NextI); injectResultCheck(isSubnormal(B, I, Ty), NextI, RC_SUB, Entry, M); }
    }
    return true;
}

// Conditional per-site increment into fp_result_counters (stride-4). Mirrors the
// per-site block of injectExceptionCheck, but for the result-class array and
// columns.
void DevicePass::injectResultCheck(Value *Condition, Instruction *InsertBefore,
                                   unsigned ResultCol, const WorklistEntry &Entry,
                                   Module &M) {
    LLVMContext &Ctx = M.getContext();
    Instruction *ThenTerm = SplitBlockAndInsertIfThen(Condition, InsertBefore, false);
    IRBuilder<> B(ThenTerm);

    GlobalVariable *RC = M.getNamedGlobal(kResultSymbol);
    if (!RC) return;
    Type *I32 = Type::getInt32Ty(Ctx);
    Type *I64 = Type::getInt64Ty(Ctx);
    unsigned Slot = Entry.SiteIndex * kResultStride + ResultCol;
    Value *Idx[] = {
        ConstantInt::get(I32, 0),
        ConstantInt::get(I32, Slot)
    };
    Value *Ptr = B.CreateInBoundsGEP(RC->getValueType(), RC, Idx);
    B.CreateAtomicRMW(
        AtomicRMWInst::Add,
        Ptr,
        ConstantInt::get(I64, 1),
        MaybeAlign(8),
        AtomicOrdering::Monotonic
    );
}

bool DevicePass::detectLogB(Instruction *I, Module &M, const WorklistEntry &Entry) {
    // ---- call form: states 1 & 2 (call site intact) ----
    if (auto *CI = dyn_cast<CallInst>(I)) {
        if (CI->arg_size() < 1) return false;
        Value *Arg = CI->getArgOperand(0);
        Type  *Ty  = Arg->getType();
        if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;

        IRBuilder<> B(CI);                       // insert guard BEFORE the call
        Value *Cond = isZero(B, Arg, Ty);        // +/-0 input -> divideByZero (-inf)
        injectExceptionCheck(Cond, CI, EX_DIVZERO, OP_LOGB,
                             RM_DEFAULT, Ty->isDoubleTy(), Entry, M);
        return true;
    }

    // ---- decomposed/inlined form: state 3 (bitcast anchor) ----
    Value *OrigArg = nullptr;
    if (matchDecomposedLogB(I, OrigArg)) {
        Type *Ty = OrigArg->getType();
        IRBuilder<> B(I);                        // insert guard BEFORE the bitcast
        Value *Cond = isZero(B, OrigArg, Ty);    // same trigger as the call form
        injectExceptionCheck(Cond, I, EX_DIVZERO, OP_LOGB,
                             RM_DEFAULT, Ty->isDoubleTy(), Entry, M);
        return true;
    }

    return false;
}

bool DevicePass::detectInvalidOp(Instruction *I, Module &M,
                        OperationID OpID, const WorklistEntry &Entry) {
    Type *Ty = I->getType();
    if (OpID == OP_CVT) {
        Ty = I->getOperand(0)->getType();
    } else if (OpID == OP_RCP) {
        Ty = cast<CallInst>(I)->getArgOperand(0)->getType();
    }

    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;

    // Fresh builder at I's CURRENT position (see note on the declaration).
    IRBuilder<> B(I);

    Value *Op0 = nullptr;
    Value *Op1 = nullptr;
    Value *Op2 = nullptr;

    Value *fa = nullptr, *fb = nullptr, *fc = nullptr;                // [faithful-fma]
    if (FaithfulFMA && matchContractFMA(I, fa, fb, fc)) {             // [faithful-fma]
        Op0 = fa; Op1 = fb; Op2 = fc;                                // [faithful-fma]
    } else if (auto *CI = dyn_cast<CallInst>(I)) {                    // was: if (auto *CI ...)
        unsigned NArgs = CI->arg_size();
        if (NArgs > 0) Op0 = CI->getArgOperand(0);
        if (NArgs > 1) Op1 = CI->getArgOperand(1);
        if (NArgs > 2) Op2 = CI->getArgOperand(2);
    } else {
        // Binary FP ops (fadd/fmul/fdiv/fsub): operands are direct.
        if (I->getNumOperands() > 0) Op0 = I->getOperand(0);
        if (I->getNumOperands() > 1) Op1 = I->getOperand(1);
    }

    Value *AnySNaN = Op0 ? isSNaN(B, Op0, Ty) : nullptr;
    if (Op1 && OpID != OP_CVT)
        AnySNaN = AnySNaN ? B.CreateOr(AnySNaN, isSNaN(B, Op1, Ty))
                          : isSNaN(B, Op1, Ty);
    if (Op2)
        AnySNaN = AnySNaN ? B.CreateOr(AnySNaN, isSNaN(B, Op2, Ty))
                          : isSNaN(B, Op2, Ty);

    Value *OpInvalid = nullptr;

    if ((OpID == OP_MUL || OpID == OP_FMA) && Op0 && Op1) {
        Value *Case1 = B.CreateAnd(isZero(B, Op0, Ty), isInf(B, Op1, Ty));
        Value *Case2 = B.CreateAnd(isInf(B, Op0, Ty), isZero(B, Op1, Ty));
        OpInvalid = B.CreateOr(Case1, Case2);
    }
    else if ((OpID == OP_ADD || OpID == OP_SUB) && Op0 && Op1) {
        Value *BothInf = B.CreateAnd(isInf(B, Op0, Ty), isInf(B, Op1, Ty));

        Value *Op0Bits = toInt(B, Op0);
        Value *Op1Bits = toInt(B, Op1);
        Type *ITy = Op0Bits->getType();
        uint64_t SgnM = Ty->isDoubleTy() ? F64_SIGN_MASK : F32_SIGN_MASK;
        Value *S0 = B.CreateAnd(Op0Bits, ConstantInt::get(ITy, SgnM));
        Value *S1 = B.CreateAnd(Op1Bits, ConstantInt::get(ITy, SgnM));

        if (OpID == OP_ADD) {
            Value *SignsDiff = B.CreateICmpNE(S0, S1);
            OpInvalid = B.CreateAnd(BothInf, SignsDiff);
        } else {
            Value *SignsSame = B.CreateICmpEQ(S0, S1);
            OpInvalid = B.CreateAnd(BothInf, SignsSame);
        }
    }
    else if (OpID == OP_DIV && Op0 && Op1) {
        Value *Case1 = B.CreateAnd(isZero(B, Op0, Ty), isZero(B, Op1, Ty));
        Value *Case2 = B.CreateAnd(isInf(B, Op0, Ty), isInf(B, Op1, Ty));
        OpInvalid = B.CreateOr(Case1, Case2);
    }
    else if (OpID == OP_SQRT && Op0) {
        OpInvalid = isNeg(B, Op0, Ty);
    }
    else if (OpID == OP_REM && Op0 && Op1) {
        Value *Op1IsZero = isZero(B, Op1, Ty);
        Value *Op0IsInf = isInf(B, Op0, Ty);
        OpInvalid = B.CreateOr(Op0IsInf, Op1IsZero);
    }
    // OP_RCP: rcp(0) is divideByZero (handled in detectDivByZero), rcp(inf)=0
    // is fine; only the sNaN-operand path above applies here.
    // OP_CVT: no specific invalid condition beyond sNaN.

    // [faithful-fma] inf-inf invalid for the fused form. In a true FMA a*b+c,
    // NaN also arises when the product a*b is a genuine infinity (a or b inf,
    // the other operand nonzero) and c is an opposite-signed infinity. The
    // decomposed OP_ADD arm caught this via BothInf + SignsDiff; once the pair
    // is folded to OP_FMA that arm no longer runs, so it is restored here.
    // Note on scope: this also fires for a genuine llvm.fma/llvm.fmuladd
    // intrinsic (Op2 comes from its 3rd arg), closing the same inf-inf gap the
    // OP_FMA path never checked. It is gated on FaithfulFMA so flag-off counts
    // are byte-identical to today for BOTH reconstructed pairs and real
    // intrinsics; turning the flag on is what enables full FMA-invalid fidelity.
    if (OpID == OP_FMA && FaithfulFMA && Op0 && Op1 && Op2) {
        Value *ProdInf = B.CreateOr(
            B.CreateAnd(isInf(B, Op0, Ty), B.CreateNot(isZero(B, Op1, Ty))),
            B.CreateAnd(isInf(B, Op1, Ty), B.CreateNot(isZero(B, Op0, Ty))),
            "fma_prod_inf");
        Value *ProdSign = B.CreateXor(isNeg(B, Op0, Ty), isNeg(B, Op1, Ty),
                                      "fma_prod_sign");                 // true = negative
        Value *AddendInf = isInf(B, Op2, Ty);
        Value *SignsDiff = B.CreateICmpNE(ProdSign, isNeg(B, Op2, Ty)); // product vs addend
        Value *InfMinusInf = B.CreateAnd(B.CreateAnd(ProdInf, AddendInf),
                                         SignsDiff, "fma_inf_minus_inf");
        OpInvalid = OpInvalid ? B.CreateOr(OpInvalid, InfMinusInf) : InfMinusInf;
    }

    Value *FinalCondition = AnySNaN;
    if (OpInvalid) {
        FinalCondition = FinalCondition ? B.CreateOr(FinalCondition, OpInvalid) : OpInvalid;
    }

    if (!FinalCondition) return false;
    // For divides, also tally into the division-invalid breakdown column so the
    // report can map exactly: division-invalid (0/0, inf/inf) folds into GPU-FPX
    // DIV0; the remainder of col 0 is non-division invalid -> NAN.
    int ExtraCol = (OpID == OP_DIV) ? (int)kColDivInvalid : -1;

    injectExceptionCheck(FinalCondition, I, EX_INVALID, OpID,
                        RM_DEFAULT, Ty->isDoubleTy(), Entry, M, ExtraCol);
    return true;
}

bool DevicePass::detectOverflow(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry) {
    Type *Ty = I->getType();
    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;
    if (!NextI) return false;

    IRBuilder<> B(NextI);

    Value *Op0 = nullptr;
    Value *Op1 = nullptr;
    Value *Op2 = nullptr;

    Value *fa = nullptr, *fb = nullptr, *fc = nullptr;              // NEW
    if (FaithfulFMA && matchContractFMA(I, fa, fb, fc)) {           // NEW: recover a,b,c
        Op0 = fa; Op1 = fb; Op2 = fc;                              // NEW
    } else if (auto *CI = dyn_cast<CallInst>(I)) {                  // was: if (auto *CI ...)
        unsigned NArgs = CI->arg_size();
        if (NArgs > 0) Op0 = CI->getArgOperand(0);
        if (NArgs > 1) Op1 = CI->getArgOperand(1);
        if (NArgs > 2) Op2 = CI->getArgOperand(2);
    } else {
        if (I->getNumOperands() > 0) Op0 = I->getOperand(0);
        if (I->getNumOperands() > 1) Op1 = I->getOperand(1);
    }

    Value *InputsFinite = ConstantInt::getTrue(M.getContext());

    if (Op0) InputsFinite = B.CreateAnd(InputsFinite, isFinite(B, Op0, Ty));
    if (Op1 && OpID != OP_SQRT) InputsFinite = B.CreateAnd(InputsFinite, isFinite(B, Op1, Ty));
    if (Op2) InputsFinite = B.CreateAnd(InputsFinite, isFinite(B, Op2, Ty));  // FMA addend — parity with detectUnderflow/detectSubnormal

    if (OpID == OP_DIV && Op1) {
        Value *DenomNonZero = B.CreateNot(isZero(B, Op1, Ty));
        InputsFinite = B.CreateAnd(InputsFinite, DenomNonZero, "overflow_denom_nonzero");
    }
    if (OpID == OP_RCP && Op0) {
        // rcp's denominator IS the single operand: rcp(0)=inf is divideByZero,
        // not overflow, so exclude it here exactly like the OP_DIV case.
        Value *DenomNonZero = B.CreateNot(isZero(B, Op0, Ty));
        InputsFinite = B.CreateAnd(InputsFinite, DenomNonZero, "overflow_denom_nonzero");
    }

    Value *ResultIsInf = isInf(B, I, Ty);
    Value *ResultIsMaxFin = isMaxFinite(B, I, Ty);

    Value *Bits = toInt(B, I);
    Type *ITy = Bits->getType();
    uint64_t SgnM = Ty->isDoubleTy() ? F64_SIGN_MASK : F32_SIGN_MASK;
    Value *SignBit = B.CreateAnd(Bits, ConstantInt::get(ITy, SgnM));
    Value *IsPos = B.CreateICmpEQ(SignBit, ConstantInt::get(ITy, 0));
    Value *IsNeg = B.CreateICmpNE(SignBit, ConstantInt::get(ITy, 0));

    Value *IsPosInf = B.CreateAnd(ResultIsInf, IsPos, "is_pos_inf");
    Value *IsNegInf = B.CreateAnd(ResultIsInf, IsNeg, "is_neg_inf");
    Value *IsPosMax = B.CreateAnd(ResultIsMaxFin, IsPos, "is_pos_max");
    Value *IsNegMax = B.CreateAnd(ResultIsMaxFin, IsNeg, "is_neg_max");

    RoundingModeID RMode = getRoundingMode(I);

    Value *OverflowCondition = nullptr;
    switch (RMode) {
        case RM_DEFAULT:
            OverflowCondition = ResultIsInf;
            break;
        case RM_ZERO:
            OverflowCondition = ResultIsMaxFin;
            break;
        case RM_PINF:
            OverflowCondition = B.CreateOr(IsPosInf, IsNegMax, "overflow_rp");
            break;
        case RM_MINF:
            OverflowCondition = B.CreateOr(IsNegInf, IsPosMax, "overflow_rm");
            break;
    }

    if (!OverflowCondition) return false;

    Value *FinalCondition = B.CreateAnd(InputsFinite, OverflowCondition, "overflow_cond");

    injectExceptionCheck(FinalCondition, NextI, EX_OVERFLOW, OpID,
                        RMode, Ty->isDoubleTy(), Entry, M);
    return true;
}


bool DevicePass::detectUnderflow(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry) {
    Type *Ty = I->getType();
    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;
    if (!NextI) return false;

    IRBuilder<> B(NextI);

    Value *Op0 = nullptr;
    Value *Op1 = nullptr;
    Value *Op2 = nullptr;

    Value *fa = nullptr, *fb = nullptr, *fc = nullptr;               // [faithful-fma]
    if (FaithfulFMA && matchContractFMA(I, fa, fb, fc)) {            // [faithful-fma]
        Op0 = fa; Op1 = fb; Op2 = fc;                               // [faithful-fma]
    } else if (auto *CI = dyn_cast<CallInst>(I)) {                   // was: if (auto *CI ...)
        unsigned NArgs = CI->arg_size();
        if (NArgs > 0) Op0 = CI->getArgOperand(0);
        if (NArgs > 1) Op1 = CI->getArgOperand(1);
        if (NArgs > 2) Op2 = CI->getArgOperand(2);
    } else {
        if (I->getNumOperands() > 0) Op0 = I->getOperand(0);
        if (I->getNumOperands() > 1) Op1 = I->getOperand(1);
    }

    Value *InputsNotTiny = ConstantInt::getTrue(M.getContext());
    if (Op0) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op0, Ty)));
    if (Op1) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op1, Ty)));
    if (Op2) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op2, Ty)));

    Value *IsSubnorm = isSubnormal(B, I, Ty);

    Value *FlushedToZero = ConstantInt::getFalse(B.getContext());

    if ((OpID == OP_MUL || OpID == OP_DIV) && Op0 && Op1) {
        // Multiplicative: result is exactly zero but neither operand was zero.
        Value *ResultZero = isZero(B, I, Ty);
        Value *Op0NonZero = B.CreateNot(isZero(B, Op0, Ty));
        Value *Op1NonZero = B.CreateNot(isZero(B, Op1, Ty));
        Value *BothNonZero = B.CreateAnd(Op0NonZero, Op1NonZero);
        FlushedToZero = B.CreateAnd(ResultZero, BothNonZero);
    }
    // Additive (ADD/SUB) and FMA flush-to-zero detection intentionally
    // disabled: result==0 with non-zero operands is indistinguishable from
    // genuine cancellation (e.g. 1.0 + -1.0) at the bit level, so counting it
    // would misattribute cancellation as FTZ. Multiplicative ops have no such
    // ambiguity (x*y == 0 exactly iff an operand is zero, absent FTZ).

    Value *IsTiny = B.CreateOr(IsSubnorm, FlushedToZero, "is_tiny");

    Value *FinalCondition = B.CreateAnd(InputsNotTiny, IsTiny, "underflow_cond");

    RoundingModeID RMode = getRoundingMode(I);
    injectExceptionCheck(FinalCondition, NextI, EX_UNDERFLOW, OpID,
                        RMode, Ty->isDoubleTy(), Entry, M);
    return true;
}

bool DevicePass::detectSubnormal(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry) {
    Type *Ty = I->getType();
    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;
    if (!NextI) return false;

    IRBuilder<> B(NextI);

    Value *Op0 = nullptr;
    Value *Op1 = nullptr;
    Value *Op2 = nullptr;

    Value *fa = nullptr, *fb = nullptr, *fc = nullptr;               // [faithful-fma]
    if (FaithfulFMA && matchContractFMA(I, fa, fb, fc)) {            // [faithful-fma]
        Op0 = fa; Op1 = fb; Op2 = fc;                               // [faithful-fma]
    } else if (auto *CI = dyn_cast<CallInst>(I)) {                   // was: if (auto *CI ...)
        unsigned NArgs = CI->arg_size();
        if (NArgs > 0) Op0 = CI->getArgOperand(0);
        if (NArgs > 1) Op1 = CI->getArgOperand(1);
        if (NArgs > 2) Op2 = CI->getArgOperand(2);
    } else {
        if (I->getNumOperands() > 0) Op0 = I->getOperand(0);
        if (I->getNumOperands() > 1) Op1 = I->getOperand(1);
    }

    // "Subnormal originated here": result is subnormal AND none of the inputs
    // were already subnormal. Distinct from underflow because we DON'T fold in
    // FlushedToZero — under FTZ mode subnormal count stays 0 while underflow
    // count includes flushed events. The gap (underflow - subnormal) is exactly
    // the count of flushed-to-zero events that IEEE 754 says should have raised
    // underflow but the GPU silently discarded.
    Value *InputsNotTiny = ConstantInt::getTrue(M.getContext());
    if (Op0) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op0, Ty)));
    if (Op1) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op1, Ty)));
    if (Op2) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op2, Ty)));

    Value *IsSubnorm = isSubnormal(B, I, Ty);
    Value *FinalCondition = B.CreateAnd(InputsNotTiny, IsSubnorm, "subnormal_cond");

    RoundingModeID RMode = getRoundingMode(I);
    injectExceptionCheck(FinalCondition, NextI, EX_SUBNORMAL, OpID,
                        RMode, Ty->isDoubleTy(), Entry, M);
    return true;
}

bool DevicePass::isKernelFunction(const Function &F) {
    // NVPTX (LLVM 21+): kernels are marked by the ptx_kernel calling convention.
    if (F.getCallingConv() == CallingConv::PTX_Kernel)
        return true;
    // AMDGPU: kernels use the amdgpu_kernel calling convention.
    if (F.getCallingConv() == CallingConv::AMDGPU_KERNEL)
        return true;

    // Older NVPTX fallback: nvvm.annotations metadata.
    const Module *M = F.getParent();
    NamedMDNode *NvvmAnnot = M->getNamedMetadata("nvvm.annotations");
    if (!NvvmAnnot) return false;

    for (MDNode *Node : NvvmAnnot->operands()) {
        if (Node->getNumOperands() < 3) continue;
        auto *FuncMD = dyn_cast<ValueAsMetadata>(Node->getOperand(0));
        if (!FuncMD || FuncMD->getValue() != &F) continue;
        auto *Key = dyn_cast<MDString>(Node->getOperand(1));
        if (!Key || Key->getString() != "kernel") continue;
        auto *Val = dyn_cast<ConstantAsMetadata>(Node->getOperand(2));
        if (Val && cast<ConstantInt>(Val->getValue())->isOne())
            return true;
    }
    return false;
}

} // end anonymous namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION,
        "DevicePass",
        "v0.3",
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "fp-exception") {
                        MPM.addPass(DevicePass());
                        return true;
                    }
                    return false;
                });
            // Optional in-pipeline registration for the O0..O3 study: with
            // -mllvm -fp-at-optimizer-last, the pass runs after the optimizer
            // at every -O level when the plugin is loaded via -fpass-plugin.
            // The new PM invokes OptimizerLast callbacks in the O0 pipeline
            // too, so O0 is covered.
#if LLVM_VERSION_MAJOR >= 20
            PB.registerOptimizerLastEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel,
                   ThinOrFullLTOPhase) {
                    if (AtOptimizerLast)
                        MPM.addPass(DevicePass());
                });
#else
            PB.registerOptimizerLastEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel) {
                    if (AtOptimizerLast)
                        MPM.addPass(DevicePass());
                });
#endif
        }
    };
}