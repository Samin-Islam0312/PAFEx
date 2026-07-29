#!/bin/bash
# Multi-TU build for XSBench.
# Six .cu files compiled with -fgpu-rdc, linked via llvm-link, instrumented with
# the device pass; main TU (Main.cu) goes through full HostPass.

set -e

module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}

export LLVM_DIR=$HOME/opt/llvm-22
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

SAMPLES_INC=/home/users/sislam3/rodinia/cuda/hybridsort

# XSBench source dir & header dir (the .cu files include "XSbench_header.cuh")
XS_DIR=tests/benchmarks/ECP_proxy/XSBench/cuda

# FP_MODE controls IEEE vs fast mode (NVIDIA whitepaper §4.4).
FP_MODE=${FP_MODE:-default}
case "$FP_MODE" in
    ieee) FP_FLAGS="-fno-cuda-flush-denormals-to-zero" ;;
    fast) FP_FLAGS="-fcuda-flush-denormals-to-zero" ;;
    *)    FP_FLAGS="" ;;
esac
echo "FP_MODE=$FP_MODE  FP_FLAGS='$FP_FLAGS'"

# Source list — Main.cu MUST come first (it has main())
SOURCES=(
    "$XS_DIR/Main.cu"
    "$XS_DIR/io.cu"
    "$XS_DIR/Simulation.cu"
    "$XS_DIR/GridInit.cu"
    "$XS_DIR/XSutils.cu"
    "$XS_DIR/Materials.cu"
)
# MAIN_TU="${SOURCES[0]}"
# The TU that defines __global__/__device__ symbols — this one embeds the fatbin.
FATBIN_TU="$XS_DIR/Simulation.cu"

echo "=========================================="
echo " XSBench multi-TU build (FP_MODE=$FP_MODE)"
echo " Main TU: $MAIN_TU"
echo " Other TUs: ${#SOURCES[@]} files total"
echo "=========================================="

LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
[ -f "$LIBDEVICE" ] || LIBDEVICE=$(find $CUDA_HOME -name "libdevice*.bc" 2>/dev/null | head -1)

# --- Build passes if needed ---
if [ ! -f build/lib/device/DevicePass.so ] || [ ! -f build/lib/host/HostPass.so ]; then
    echo "Building passes..."
    mkdir -p build && (cd build && cmake \
        -DCMAKE_C_COMPILER=$LLVM_DIR/bin/clang \
        -DCMAKE_CXX_COMPILER=$LLVM_DIR/bin/clang++ \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm \
        .. && make -j)
fi

# --- Runtime objects ---
echo "Building runtime objects..."
g++ -fPIC -c lib/papi_rtlib/fp_sde_counters.cpp \
    -o fp_sde_counters.o -I$PAPI_DIR/include
nvcc -Xcompiler -fPIC -c lib/papi_rtlib/fp_sde_driver.cu \
    -o fp_sde_driver.o -I$PAPI_DIR/include

# --- Per-TU device pipeline ---
DEVICE_BCS=()
for src in "${SOURCES[@]}"; do
    base=$(basename "$src" .cu)
    echo ""
    echo "--- Device pipeline for $src ---"

    $LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only \
        -fgpu-rdc \
        $FP_FLAGS \
        -I$SAMPLES_INC -I$XS_DIR \
        -x cuda "$src" --cuda-gpu-arch=$GPU_ARCH -c -o ${base}_device.bc

    $LLVM_DIR/bin/llvm-link --only-needed ${base}_device.bc $LIBDEVICE \
    -o ${base}_device_linked.bc

    $LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/device/DevicePass.so \
        -passes="fp-exception" ${base}_device_linked.bc \
        -o ${base}_instrumented_device.bc

    $LLVM_DIR/bin/opt -O2 ${base}_instrumented_device.bc \
        -o ${base}_optimized_device.bc

    DEVICE_BCS+=("${base}_optimized_device.bc")
done

# --- Merge device bitcodes ---
echo ""
echo "--- Merging device bitcodes ---"
$LLVM_DIR/bin/llvm-link "${DEVICE_BCS[@]}" -o merged_device.bc

# --- Lower merged → fatbin ---
echo "Lowering merged device → PTX/cubin/fatbin..."
$LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH merged_device.bc -o merged.ptx
ptxas --gpu-name $GPU_ARCH merged.ptx -o merged.cubin
fatbinary --64 --create merged.fatbin \
    --image3=kind=elf,sm=$GPU_SM,file=merged.cubin

# --- Per-TU host pipeline ---
HOST_OBJS=()
for src in "${SOURCES[@]}"; do
    base=$(basename "$src" .cu)
    echo ""
    echo "--- Host pipeline for $src ---"

    # ALL TUs embed the fatbin (was only the FATBIN_TU before)
    $LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only \
        -I$SAMPLES_INC -I$XS_DIR \
        -Xclang -fcuda-include-gpubinary -Xclang merged.fatbin \
        -x cuda "$src" -c -o ${base}_host.bc

    $LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/host/HostPass.so \
        -passes="fp-host-instrument" ${base}_host.bc \
        -o ${base}_instrumented_host.bc

    $LLVM_DIR/bin/opt -O2 ${base}_instrumented_host.bc \
        -o ${base}_optimized_host.bc
    $LLVM_DIR/bin/clang++ -O2 -c ${base}_optimized_host.bc \
        -o ${base}.o

    HOST_OBJS+=("${base}.o")
done

# --- Final link ---
echo ""
echo "--- Linking app_xsbench ---"
clang++ "${HOST_OBJS[@]}" fp_sde_counters.o fp_sde_driver.o \
    -o app_xsbench \
    -L$CUDA_HOME/lib64 -lcudart \
    -L$PAPI_DIR/lib -lpapi -lsde -lm -ldl \
    -Wl,-rpath,$CUDA_HOME/lib64 \
    -Wl,-rpath,$PAPI_DIR/lib

echo ""
echo "Built: app_xsbench"
ls -la app_xsbench
