/*
ARCHITECTURE:
   - Module pass, declaring __device__ globals
   - Worklist: collect instructions first, instrument after. Avoids causing undefined behavior
   - Only runs on nvptx64 target triple
   - Declares () which runtime lib must implement

EXCEPTION COVERAGE (per IEEE 754-2019):
   EX_DIVZERO   §7.3  — fdiv(finite_nonzero, ±0), logB(0)
   EX_INVALID   §7.2  — 0/0, ∞/∞, 0×∞, ∞-∞, sqrt(neg), sNaN operands
   EX_OVERFLOW  §7.4  — result exceeds MAX_FINITE (rounding-mode aware)
   EX_UNDERFLOW §7.5  — result is subnormal (rounding-mode aware)

CALLING CONVENTION into runtime lib:
(int fmt_idx,       // 1=f32, 2=f64
                int exception_id,  // ExceptionID enum
                int operation_id,  // OperationID enum
                int rounding_mode, // RoundingModeID enum
                int line_number,   // from DILocation, -1 if unavailable
                int func_name_idx) // reserved for future string table
*/ 

#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"

#if __has_include("llvm/Plugins/PassPlugin.h")
  #include "llvm/Plugins/PassPlugin.h"   // LLVM 22+
#else
  #include "llvm/Passes/PassPlugin.h"   // LLVM 21 and older
#endif

#include "llvm/TargetParser/Triple.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/SmallVector.h"
#include <vector>
#include <string>
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/IR/DebugInfoMetadata.h"   
#include "llvm/IR/DebugLoc.h"

using namespace llvm;

namespace {
 
    constexpr unsigned NVPTX_GLOBAL_AS = 1;

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

    enum ExceptionID {
        EX_INVALID   = 0,   
        EX_DIVZERO   = 1,   
        EX_OVERFLOW  = 2,   
        EX_UNDERFLOW = 3    
    };

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
        OP_LOGB = 9
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
    };

    // Returns true only for CUDA device modules
    static bool isNVPTXModule(const Module &M) {
        Triple T(M.getTargetTriple());
        return T.getArch() == Triple::nvptx64;
    }

    class DevicePass : public PassInfoMixin<DevicePass> {
    public:
        PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);

    private:
        void declareDeviceCounters(Module &M);
        void collectInstructions(Function &F, std::vector<WorklistEntry> &WL);
        bool instrumentInstruction(WorklistEntry &Entry, Module &M);
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
                                const WorklistEntry &Entry, Module &M);
        bool detectDivByZero(Instruction *I, IRBuilder<> &B, Module &M,
                            OperationID OpID, const WorklistEntry &Entry);
        bool detectDecomposedLogBZero(Instruction *I, Module &M,
                                    const WorklistEntry &Entry);
        bool detectInvalidOp(Instruction *I, IRBuilder<> &B, Module &M,
                        OperationID OpID, const WorklistEntry &Entry);
        bool detectOverflow(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry);
        bool detectUnderflow(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry);
        bool isKernelFunction(const Function &F);
    };

// ============================================================================
// IMPLEMENTATIONS
// ============================================================================

PreservedAnalyses DevicePass::run(Module &M, ModuleAnalysisManager &MAM) {
    if (!isNVPTXModule(M)) {
        errs() << "[FPPass] Skipping non-device module: "
            << M.getTargetTriple().str() << "\n";
        return PreservedAnalyses::all();
    }
    errs() << "[FPPass] Running on device module: "
        << M.getTargetTriple().str() << "\n";

    declareDeviceCounters(M);

    bool Changed = false;
    int totalFunctions = 0;
    int totalInstructions = 0;

    for (Function &F : M) {
        if (F.isDeclaration()) continue;
        if (F.getName().starts_with("__fppass_")) continue;

        totalFunctions++;
        errs() << "[FPPass] Visiting function: " << F.getName();

        if (isKernelFunction(F))
            errs() << " [KERNEL]\n";
        else
            errs() << " [device]\n";

        std::vector<WorklistEntry> Worklist;
        collectInstructions(F, Worklist);

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
        << " instructions\n";

    return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
}

void DevicePass::declareDeviceCounters(Module &M) {
    LLVMContext &Ctx = M.getContext();
    Type *I64 = Type::getInt64Ty(Ctx);

    const char *CounterNames[] = {
    "fp_invalid_counter",
    "fp_divbyzero_counter",
    "fp_overflow_counter",
    "fp_underflow_counter",
    "fp_total_counter",
    "fp_subnormal_counter"
    };

    for (const char *Name : CounterNames) {
        if (M.getNamedGlobal(Name)) continue;

        GlobalVariable *GV = new GlobalVariable(
            M, I64, false,
            GlobalValue::ExternalLinkage,
            ConstantInt::get(I64, 0),
            Name, nullptr,
            GlobalValue::NotThreadLocal,
            NVPTX_GLOBAL_AS
        );
        GV->setAlignment(MaybeAlign(8));
        errs() << "[FPPass] Declared device counter: " << Name << "\n";
    }
}

void DevicePass::collectInstructions(Function &F, std::vector<WorklistEntry> &WL) {
    std::string FuncName = F.getName().str();

    for (BasicBlock &BB : F) {
        for (Instruction &I : BB) {
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

            switch (I.getOpcode()) {
                case Instruction::FAdd:
                    if (isF32 || isF64) {
                        WL.push_back({&I, OP_ADD, FuncName, LineNum, FileName, isF64});
                        errs() << "[FPPass]   COLLECT fadd @ " << FuncName << ":" << LineNum << "\n";
                    }
                    break;

                case Instruction::FSub:
                    if (isF32 || isF64) {
                        WL.push_back({&I, OP_SUB, FuncName, LineNum, FileName, isF64});
                        errs() << "[FPPass]   COLLECT fsub @ " << FuncName << ":" << LineNum << "\n";
                    }
                    break;

                case Instruction::FMul:
                    if (isF32 || isF64) {
                        WL.push_back({&I, OP_MUL, FuncName, LineNum, FileName, isF64});
                        errs() << "[FPPass]   COLLECT fmul @ " << FuncName << ":" << LineNum << "\n";
                    }
                    break;

                case Instruction::FDiv:
                    if (isF32 || isF64) {
                        WL.push_back({&I, OP_DIV, FuncName, LineNum, FileName, isF64});
                        errs() << "[FPPass]   COLLECT fdiv @ " << FuncName << ":" << LineNum << "\n";
                    }
                    break;

                case Instruction::FRem:
                    if (isF32 || isF64) {
                        WL.push_back({&I, OP_REM, FuncName, LineNum, FileName, isF64});
                        errs() << "[FPPass]   COLLECT frem @ " << FuncName << ":" << LineNum << "\n";
                    }
                    break;

                case Instruction::Call: {
                    auto *CI = dyn_cast<CallInst>(&I);
                    if (!CI) break;

                    Function *Callee = CI->getCalledFunction();
                    if (!Callee || !Callee->hasName()) break;

                    StringRef Name = Callee->getName();
                    
                    if (Name.starts_with("llvm.sqrt") || Name.starts_with("llvm.nvvm.sqrt")) {
                        Type *ArgTy = CI->getArgOperand(0)->getType();
                        if (ArgTy->isFloatTy() || ArgTy->isDoubleTy()) {
                            WL.push_back({&I, OP_SQRT, FuncName, LineNum, FileName, ArgTy->isDoubleTy()});
                            errs() << "[FPPass]   COLLECT sqrt @ " << FuncName << ":" << LineNum << "\n";
                        }
                    }
                    else if (Name.starts_with("llvm.fma") || Name.starts_with("llvm.fmuladd") || Name.starts_with("llvm.nvvm.fma")) {
                        if (isF32 || isF64) {
                            WL.push_back({&I, OP_FMA, FuncName, LineNum, FileName, isF64});
                        }
                    }
                    else if (Name.contains("logb")) {
                        Type *ArgTy = CI->getArgOperand(0)->getType();
                        if (ArgTy->isFloatTy() || ArgTy->isDoubleTy()) {
                            WL.push_back({&I, OP_LOGB, FuncName, LineNum, FileName, ArgTy->isDoubleTy()});
                            errs() << "[FPPass]   COLLECT logb variant '" << Name << "' @ "
                                << FuncName << ":" << LineNum << "\n";
                        }
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

    Instruction *NextI = I->getNextNode();
    bool Changed = false;
    IRBuilder<> B(I);

    errs() << "[FPPass]   INSTRUMENT " << Entry.FuncName
        << ":" << Entry.LineNumber << " op=" << OpID << "\n";

    switch (OpID) {
        case OP_DIV:
            Changed |= detectInvalidOp(I, B, M, OP_DIV, Entry);
            Changed |= detectDivByZero(I, B, M, OP_DIV, Entry);
            Changed |= detectOverflow(I, NextI, M, OP_DIV, Entry);
            Changed |= detectUnderflow(I, NextI, M, OP_DIV, Entry);
            break;
        
        case OP_ADD:
        case OP_SUB:
            Changed |= detectInvalidOp(I, B, M, OpID, Entry);
            Changed |= detectOverflow(I, NextI, M, OpID, Entry);
            break;
        
        case OP_MUL:
            Changed |= detectInvalidOp(I, B, M, OP_MUL, Entry);
            Changed |= detectOverflow(I, NextI, M, OP_MUL, Entry);
            Changed |= detectUnderflow(I, NextI, M, OP_MUL, Entry);
            break;
        
        case OP_FMA:
            Changed |= detectInvalidOp(I, B, M, OP_FMA, Entry);
            Changed |= detectOverflow(I, NextI, M, OP_FMA, Entry);
            Changed |= detectUnderflow(I, NextI, M, OP_FMA, Entry);
            break;
        
        case OP_SQRT:
            Changed |= detectInvalidOp(I, B, M, OP_SQRT, Entry);
            break;
        
        case OP_CVT:
            Changed |= detectInvalidOp(I, B, M, OP_CVT, Entry);
            break;
        
        case OP_REM:
            Changed |= detectInvalidOp(I, B, M, OP_REM, Entry);
            break;
        
        case OP_LOGB:
            if (isa<PHINode>(I))
                Changed |= detectDecomposedLogBZero(I, M, Entry);
            else
                Changed |= detectDivByZero(I, B, M, OP_LOGB, Entry);
            break;
        
        default:
            break;
    }

    return Changed;
}

// Bit-level helper functions
Value* DevicePass::toInt(IRBuilder<> &B, Value *V) {
    Type *Ty = V->getType();
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
            if (Name.contains(".rz")) return RM_ZERO;
            if (Name.contains(".rm")) return RM_MINF;
            if (Name.contains(".rp")) return RM_PINF;
        }
    }
    return RM_DEFAULT;
}

void DevicePass::injectExceptionCheck(Value *Condition, Instruction *InsertBefore,
                                    ExceptionID ExID, OperationID OpID,
                                    RoundingModeID RMode, bool IsF64,
                                    const WorklistEntry &Entry, Module &M) {
    LLVMContext &Ctx = M.getContext();

    Instruction *ThenTerm = SplitBlockAndInsertIfThen(Condition, InsertBefore, false);
    IRBuilder<> B(ThenTerm);

    const char *CounterNames[] = {
        "fp_invalid_counter",
        "fp_divbyzero_counter",
        "fp_overflow_counter",
        "fp_underflow_counter"
    };
    
    GlobalVariable *Counter = M.getNamedGlobal(CounterNames[ExID]);
    if (Counter) {
        B.CreateAtomicRMW(
            AtomicRMWInst::Add,
            Counter,
            ConstantInt::get(Type::getInt64Ty(Ctx), 1),
            MaybeAlign(8),
            AtomicOrdering::Monotonic
        );
    }

    errs() << "[FPPass]     -> Injected check: ex=" << ExID
        << " op=" << OpID << " line=" << Entry.LineNumber << "\n";
}

bool DevicePass::detectDivByZero(Instruction *I, IRBuilder<> &B, Module &M,
                                OperationID OpID, const WorklistEntry &Entry) {
    Type *Ty = (OpID == OP_LOGB)
            ? cast<CallInst>(I)->getArgOperand(0)->getType()
            : I->getType();

    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;

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
    else if (OpID == OP_LOGB) {
        Value *Arg = cast<CallInst>(I)->getArgOperand(0);
        Condition = isZero(B, Arg, Ty);
    }

    if (!Condition) return false;

    injectExceptionCheck(Condition, I, EX_DIVZERO, OpID,
                        RM_DEFAULT, Ty->isDoubleTy(), Entry, M);
    return true;
}

bool DevicePass::detectDecomposedLogBZero(Instruction *I, Module &M,
                                        const WorklistEntry &Entry) {
    auto *BC = dyn_cast<BitCastInst>(I);
    if (!BC) return false;

    Type *SrcTy = BC->getOperand(0)->getType();
    if (!SrcTy->isFloatTy() && !SrcTy->isDoubleTy()) return false;

    Value *ArgX = BC->getOperand(0);
    IRBuilder<> B(BC);
    Value *Condition = isZero(B, ArgX, SrcTy);

    injectExceptionCheck(Condition, BC, EX_DIVZERO, OP_LOGB,
                        RM_DEFAULT, SrcTy->isDoubleTy(), Entry, M);
    return true;
}

bool DevicePass::detectInvalidOp(Instruction *I, IRBuilder<> &B, Module &M,
                        OperationID OpID, const WorklistEntry &Entry) {
    Type *Ty = I->getType();
    if (OpID == OP_CVT) {
        Ty = I->getOperand(0)->getType();
    }

    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;

    Value *Op0 = I->getNumOperands() > 0 ? I->getOperand(0) : nullptr;
    Value *Op1 = I->getNumOperands() > 1 ? I->getOperand(1) : nullptr;
    Value *Op2 = nullptr;

    if (OpID == OP_FMA && isa<CallInst>(I)) {
        auto *CI = cast<CallInst>(I);
        Op0 = CI->getArgOperand(0);
        Op1 = CI->getArgOperand(1);
        Op2 = CI->getArgOperand(2);
    }

    Value *AnySNaN = Op0 ? isSNaN(B, Op0, Ty) : nullptr;
    if (Op1 && OpID != OP_CVT)
        AnySNaN = AnySNaN ? B.CreateOr(AnySNaN, isSNaN(B, Op1, Ty))
                        : isSNaN(B, Op1, Ty);
    if (Op2)
        AnySNaN = AnySNaN ? B.CreateOr(AnySNaN, isSNaN(B, Op2, Ty))
                        : isSNaN(B, Op2, Ty);

    Value *OpInvalid = nullptr;

    if (OpID == OP_MUL || OpID == OP_FMA) {
        Value *Case1 = B.CreateAnd(isZero(B, Op0, Ty), isInf(B, Op1, Ty));
        Value *Case2 = B.CreateAnd(isInf(B, Op0, Ty), isZero(B, Op1, Ty));
        OpInvalid = B.CreateOr(Case1, Case2);
    }
    else if (OpID == OP_ADD || OpID == OP_SUB) {
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
    else if (OpID == OP_DIV) {
        Value *Case1 = B.CreateAnd(isZero(B, Op0, Ty), isZero(B, Op1, Ty));
        Value *Case2 = B.CreateAnd(isInf(B, Op0, Ty), isInf(B, Op1, Ty));
        OpInvalid = B.CreateOr(Case1, Case2);
    }
    else if (OpID == OP_SQRT) {
        OpInvalid = isNeg(B, Op0, Ty);
    }
    else if (OpID == OP_REM) {
        Value *Op1IsZero = isZero(B, Op1, Ty);
        Value *Op0IsInf = isInf(B, Op0, Ty);
        OpInvalid = B.CreateOr(Op0IsInf, Op1IsZero);
    }
    else if (OpID == OP_CVT) {
        // No specific invalid condition beyond sNaN — range check handled at runtime
    }

    Value *FinalCondition = AnySNaN;
    if (OpInvalid) {
        FinalCondition = FinalCondition ? B.CreateOr(FinalCondition, OpInvalid) : OpInvalid;
    }

    if (!FinalCondition) return false;

    injectExceptionCheck(FinalCondition, I, EX_INVALID, OpID,
                        RM_DEFAULT, Ty->isDoubleTy(), Entry, M);
    return true;
}

bool DevicePass::detectOverflow(Instruction *I, Instruction *NextI, Module &M,
                        OperationID OpID, const WorklistEntry &Entry) {
    Type *Ty = I->getType();
    if (!Ty->isFloatTy() && !Ty->isDoubleTy()) return false;
    if (!NextI) return false;

    IRBuilder<> B(NextI);

    Value *Op0 = I->getNumOperands() > 0 ? I->getOperand(0) : nullptr;
    Value *Op1 = I->getNumOperands() > 1 ? I->getOperand(1) : nullptr;

    Value *InputsFinite = ConstantInt::getTrue(M.getContext());
    if (Op0) InputsFinite = B.CreateAnd(InputsFinite, isFinite(B, Op0, Ty));
    if (Op1 && OpID != OP_SQRT) InputsFinite = B.CreateAnd(InputsFinite, isFinite(B, Op1, Ty));
    
    if (OpID == OP_DIV && Op1) {
        Value *DenomNonZero = B.CreateNot(isZero(B, Op1, Ty));
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

    Value *Op0 = I->getNumOperands() > 0 ? I->getOperand(0) : nullptr;
    Value *Op1 = I->getNumOperands() > 1 ? I->getOperand(1) : nullptr;
    Value *Op2 = nullptr;

    if (OpID == OP_FMA && isa<CallInst>(I)) {
        auto *CI = cast<CallInst>(I);
        Op0 = CI->getArgOperand(0);
        Op1 = CI->getArgOperand(1);
        Op2 = CI->getArgOperand(2);
    }

    Value *InputsNotTiny = ConstantInt::getTrue(M.getContext());
    if (Op0) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op0, Ty)));
    if (Op1) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op1, Ty)));
    if (Op2) InputsNotTiny = B.CreateAnd(InputsNotTiny, B.CreateNot(isSubnormal(B, Op2, Ty)));

    Value *IsSubnorm = isSubnormal(B, I, Ty);

    Value *FlushedToZero = ConstantInt::getFalse(B.getContext());
    if ((OpID == OP_MUL || OpID == OP_DIV) && Op0 && Op1) {
        Value *ResultZero = isZero(B, I, Ty);
        Value *Op0NonZero = B.CreateNot(isZero(B, Op0, Ty));
        Value *Op1NonZero = B.CreateNot(isZero(B, Op1, Ty));
        Value *BothNonZero = B.CreateAnd(Op0NonZero, Op1NonZero);
        FlushedToZero = B.CreateAnd(ResultZero, BothNonZero);
    }

    Value *IsTiny = B.CreateOr(IsSubnorm, FlushedToZero, "is_tiny");

    Value *FinalCondition = B.CreateAnd(InputsNotTiny, IsTiny, "underflow_cond");

    RoundingModeID RMode = getRoundingMode(I);
    injectExceptionCheck(FinalCondition, NextI, EX_UNDERFLOW, OpID,
                        RMode, Ty->isDoubleTy(), Entry, M);
    return true;
}

bool DevicePass::isKernelFunction(const Function &F) {
    // LLVM 21+: kernels are marked by ptx_kernel calling convention
    if (F.getCallingConv() == CallingConv::PTX_Kernel)
        return true;
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
        "v0.2",
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
        }
    };
}