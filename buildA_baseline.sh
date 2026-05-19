#!/bin/bash
# Config A: uninstrumented baseline.
# Compiles the test .cu file with clang's CUDA support, no passes, no runtime.
# Output: app_baseline

set -e

module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
export LLVM_DIR=$HOME/opt/llvm-22
export PATH=$LLVM_DIR/bin:$PATH
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

# === EDIT THIS to point at the test .cu you want to measure ===
APP_SRC=${APP_SRC:-tests/gpu_fpx.cu}

echo "=========================================="
echo " Config A: BASELINE (no instrumentation)"
echo " Source: $APP_SRC"
echo "=========================================="

$LLVM_DIR/bin/clang++ -O2 -x cuda "$APP_SRC" \
    --cuda-gpu-arch=$GPU_ARCH \
    -L$CUDA_HOME/lib64 -lcudart \
    -Wl,-rpath,$CUDA_HOME/lib64 \
    -o app_baseline

echo "Built: app_baseline"
ls -la app_baseline