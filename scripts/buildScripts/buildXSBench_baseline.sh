#!/bin/bash
# Multi-TU build for XSBench with Thrust/CUB safety patches.
# Device IR is pre-optimized to collapse templates before instrumentation.
# ALL Host TUs embed the fatbin to satisfy auto-generated Thrust stubs.

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

# XSBench source dir & header dir
XS_DIR=tests/benchmarks/ECP_proxy/XSBench/cuda

FP_MODE=${FP_MODE:-default}
case "$FP_MODE" in
    ieee) FP_FLAGS="-fno-cuda-flush-denormals-to-zero" ;;
    fast) FP_FLAGS="-fcuda-flush-denormals-to-zero" ;;
    *)    FP_FLAGS="" ;;
esac
echo "FP_MODE=$FP_MODE  FP_FLAGS='$FP_FLAGS'"

# Source list
SOURCES=(
    "$XS_DIR/Main.cu"
    "$XS_DIR/io.cu"
    "$XS_DIR/Simulation.cu"
    "$XS_DIR/GridInit.cu"
    "$XS_DIR/XSutils.cu"
    "$XS_DIR/Materials.cu"
)

echo "=========================================="
echo " XSBench multi-TU build (FP_MODE=$FP_MODE)"
echo " Files: ${#SOURCES[@]} files total"
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

# --- BASELINE: no instrumentation runtime objects needed ---

# --- Per-TU device pipeline ---
DEVICE_BCS=()
for src in "${SOURCES[@]}"; do
    base=$(basename "$src" .cu)
    echo ""
    echo "--- Device pipeline for $src ---"

    # 1. Compile to unoptimized device IR
    $LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only \
        $FP_FLAGS \
        -I$SAMPLES_INC -I$XS_DIR \
        -x cuda "$src" --cuda-gpu-arch=$GPU_ARCH -c -o ${base}_device.bc

    # 2. Link libdevice
    $LLVM_DIR/bin/llvm-link --only-needed ${base}_device.bc $LIBDEVICE \
        -o ${base}_device_linked.bc

    # 3. FIX 1: TARGETED PRE-OPTIMIZATION (Collapses Thrust without deleting kernels)
    # 3. FIX 1: TARGETED PRE-OPTIMIZATION
    echo "Running targeted pre-optimization pass..."
    $LLVM_DIR/bin/opt -passes="always-inline,function(mem2reg,instcombine)" ${base}_device_linked.bc \
        -o ${base}_device_preopt.bc

    # 4. BASELINE: no instrumentation — pass the pre-optimized IR through unchanged.
    echo "Baseline: skipping DevicePass (no instrumentation)..."
    cp ${base}_device_preopt.bc ${base}_instrumented_device.bc

    # Add directly to the link array without running opt -O2
    DEVICE_BCS+=("${base}_instrumented_device.bc")

done

# --- Merge device bitcodes ---
echo ""
echo "--- Merging device bitcodes ---"
$LLVM_DIR/bin/llvm-link "${DEVICE_BCS[@]}" -o merged_device.bc

# --- Lower merged → fatbin ---
echo "Lowering merged device → PTX/cubin/fatbin..."
$LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH merged_device.bc -o merged.ptx
nvcc -arch=$GPU_ARCH -dc merged.ptx -o merged_dev.o
nvcc -arch=$GPU_ARCH -dlink merged_dev.o -fatbin -o merged.fatbin

# --- Per-TU host pipeline ---
HOST_OBJS=()
for src in "${SOURCES[@]}"; do
    base=$(basename "$src" .cu)
    echo ""
    echo "--- Host pipeline for $src ---"

    # FIX 2: UNIVERSAL FATBIN EMBEDDING
    # Every TU must embed the fatbin so Thrust's auto-generated host stubs can resolve their kernels.
    $LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only --cuda-gpu-arch=$GPU_ARCH \
         --cuda-gpu-arch=$GPU_ARCH \
         -I$SAMPLES_INC -I$XS_DIR \
         -Xclang -fcuda-include-gpubinary -Xclang merged.fatbin \
         -x cuda "$src" -c -o ${base}_host.bc


    # BASELINE: skip HostPass — compile the plain host bitcode directly.
    $LLVM_DIR/bin/clang++ -O1 -c ${base}_host.bc \
        -o ${base}.o
        

    HOST_OBJS+=("${base}.o")
done

# --- Final link ---
echo ""
echo "--- Linking app_xsbench_baseline (NO instrumentation) ---"
# BASELINE: no instrumentation runtime — drop fp_sde_*.o, papi, sde.
clang++ "${HOST_OBJS[@]}" \
    -o app_xsbench_baseline \
    -L$CUDA_HOME/lib64 -lcudart -lm -ldl \
    -Wl,-rpath,$CUDA_HOME/lib64

echo ""
echo "Built: app_xsbench_baseline"
ls -la app_xsbench_baseline