//===- tag_pass.cpp - PaFEx library-internal origin tagging ---------------===//
//
// Marks every instruction inside a vendor math/support library function with
// !pafex.libinternal metadata. DevicePass skips tagged instructions.
//
// WHY THIS IS A SEPARATE PASS FROM DevicePass:
//
// DevicePass identifies library code by function name (isLibraryInternal).
// That works only while the library function still exists. Once the inliner
// runs, the body is copied into the caller and the callee is deleted: the
// name is gone, and the instructions are indistinguishable from user
// arithmetic. They are also indistinguishable by file:line, because the
// prebuilt device libraries ship without debug info, so the inliner stamps
// the inlined instructions with the *call site's* DILocation.
//
// Instruction metadata, unlike names, survives inlining -- the inliner copies
// it verbatim into the caller. So: tag before the inliner, check after.
//
// This forces the split. Tagging must happen inside clang's pipeline
// (-fpass-plugin=TagPass.so) at PipelineStartEP, which runs before both the
// AlwaysInliner (-O0, used by NVIDIA libdevice) and the ordinary inliner
// (-O1+, used by AMD OCML). DevicePass runs later in a separate `opt`
// invocation, by which point tagging is impossible.
//
// If this plugin is not loaded, no instruction carries the tag, DevicePass's
// check never fires, and behavior is byte-identical to the untagged tool.
// That is the A/B control: contamination = (untagged run) - (tagged run).
//
//===----------------------------------------------------------------------===//

#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/Triple.h"

#include "pass_plugin_compat.h"

using namespace llvm;

namespace {

static llvm::cl::opt<bool> TagVerbose(
    "tag-verbose",
    llvm::cl::desc("Print a summary of library-internal tagging. Pass via "
                   "-mllvm -tag-verbose when using -fpass-plugin."),
    llvm::cl::init(false));

// Vendor math/support libraries. Keep in sync with DevicePass's
// isLibraryInternal(), which handles the not-yet-inlined (-O0) case.
//   AMD:    OCML (math), OCKL (support). __ocml matches __ocmlpriv_* too.
//   NVIDIA: libdevice exports __nv_*; internal helpers use __internal_*.
static bool isLibraryFunction(StringRef N) {
  return N.contains("__ocml") || N.contains("__ockl") ||
         N.contains("__nv_")  || N.contains("__internal_");
}

struct TagLibInternals : PassInfoMixin<TagLibInternals> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
    LLVMContext &Ctx = M.getContext();
    MDNode *Tag = MDNode::get(Ctx, {});
    unsigned NFn = 0, NInst = 0;

    for (Function &F : M) {
      if (F.isDeclaration()) continue;
      if (!isLibraryFunction(F.getName())) continue;
      ++NFn;
      for (BasicBlock &BB : F)
        for (Instruction &I : BB) {
          I.setMetadata("pafex.libinternal", Tag);
          ++NInst;
        }
    }

    if (TagVerbose || NFn > 0)
      errs() << "[TagPass] " << Triple(M.getTargetTriple()).getArchName()
             << ": tagged " << NInst << " instructions across " << NFn
             << " library functions\n";

    // Metadata-only: no CFG, no analyses invalidated.
    return PreservedAnalyses::all();
  }
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "PaFExTagPass", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            // PipelineStartEP: before AlwaysInliner (-O0) and the inliner (-O1+).
            PB.registerPipelineStartEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel) {
                  MPM.addPass(TagLibInternals());
                });
            // Also expose as a named pass so `opt -passes=pafex-tag` works
            // for standalone inspection.
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "pafex-tag") {
                    MPM.addPass(TagLibInternals());
                    return true;
                  }
                  return false;
                });
          }};
}
