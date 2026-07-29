#!/usr/bin/env bash
# PaFEx athena (A100/sm_80) environment.
# Usage:  source scripts/athena_env.sh
# MUST be sourced, not executed — it sets shell variables.

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "ERROR: source this script, don't run it:  source ${0}"; exit 1
fi

_fail=0

# --- LLVM 22 (built from source) ---
for c in "$HOME/opt/llvm-22" "$HOME/llvm-22" "$HOME/opt/llvm"; do
  [[ -x "$c/bin/clang++" ]] && export LLVM_HOME="$c" && break
done
if [[ -z "$LLVM_HOME" ]]; then
  echo "ERROR: LLVM 22 not found. Set LLVM_HOME by hand."; _fail=1
else
  export LLVM="$LLVM_HOME/bin"
  export CLANG="$LLVM/clang++"
  export OPT="$LLVM/opt"
fi

# --- CUDA (for libdevice) ---
for c in "$CUDA_HOME" /usr/local/cuda /usr/local/cuda-12.8 /usr/local/cuda-12; do
  [[ -d "$c/nvvm/libdevice" ]] && export CUDA="$c" && break
done
[[ -z "$CUDA" ]] && { echo "WARN: CUDA/libdevice not found; --cuda-path will be needed explicitly."; }

# --- repo + build artifacts ---
export REPO="$HOME/SBAC-PAD-opt"
export TAG="$REPO/build-cuda/lib/tag/TagPass.so"
export DEV="$REPO/build-cuda/lib/device/DevicePass.so"
export HOST="$REPO/build-cuda/lib/host/HostPass.so"

# --- verify ---
echo "LLVM_HOME=$LLVM_HOME"
echo "CUDA=$CUDA"
echo "REPO=$REPO"
for f in "$CLANG" "$OPT"; do
  [[ -x "$f" ]] && echo "  ok  $f" || { echo "  MISSING  $f"; _fail=1; }
done
for f in "$TAG" "$DEV" "$HOST"; do
  [[ -f "$f" ]] && echo "  ok  $f" || echo "  not built yet: $f"
done
[[ $_fail -eq 0 ]] && echo "athena env ready." || echo "athena env INCOMPLETE — fix the above."
