#!/bin/bash
# Multi-TU build: instrument multiple .cu files separately, link them together.
# Each .cu produces a relocatable device bitcode; nvlink merges them; one
# fatbin is embedded into the host object that contains main.

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

# === EDIT THESE ===
SOURCES=(
    "tests/multi_tu/kernel.cu"   # The one with main
    "tests/multi_tu/helpers.cu"  # The device helper TU
)
# The TU containing main MUST be listed first (we use it as the "host" TU).
MAIN_TU="${SOURCES[0]}"

echo "=========================================="
echo " Multi-TU build"
echo " Main TU:  $MAIN_TU"
echo " Other TUs: ${SOURCES[@]:1}"
echo "=========================================="

LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc

# --- Build runtime objects ---
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

    # Emit device bitcode in RDC mode (relocatable, allows cross-TU symbols)
    $LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only \
        -fgpu-rdc \
        -I$SAMPLES_INC \
        -x cuda "$src" --cuda-gpu-arch=$GPU_ARCH -c -o ${base}_device.bc

    # Link libdevice
    $LLVM_DIR/bin/llvm-link --only-needed ${base}_device.bc $LIBDEVICE \
        -o ${base}_device_linked.bc

    # Run the device pass
    $LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/device/DevicePass.so \
        -passes="fp-exception" ${base}_device_linked.bc \
        -o ${base}_instrumented_device.bc

    # Optimize
    $LLVM_DIR/bin/opt -O2 ${base}_instrumented_device.bc \
        -o ${base}_optimized_device.bc

    DEVICE_BCS+=("${base}_optimized_device.bc")
done

# --- Merge all device bitcodes ---
echo ""
echo "--- Merging device bitcodes ---"
$LLVM_DIR/bin/llvm-link "${DEVICE_BCS[@]}" -o merged_device.bc

# --- Lower the merged device bitcode to fatbin ---
echo "Lowering merged device code to PTX/cubin/fatbin..."
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

    # The TU containing main embeds the fatbin and goes through HostPass.
    # Other TUs are compiled host-only without fatbin embedding.
    if [ "$src" = "$MAIN_TU" ]; then
        $LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only \
            -I$SAMPLES_INC \
            -Xclang -fcuda-include-gpubinary -Xclang merged.fatbin \
            -x cuda "$src" -c -o ${base}_host.bc

        # HostPass: emits shadows, registration, accessors, lifecycle.
        $LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/host/HostPass.so \
            -passes="fp-host-instrument" ${base}_host.bc \
            -o ${base}_instrumented_host.bc

        $LLVM_DIR/bin/opt -O2 ${base}_instrumented_host.bc \
            -o ${base}_optimized_host.bc
        $LLVM_DIR/bin/clang++ -O2 -c ${base}_optimized_host.bc \
            -o ${base}.o
    else
        # Non-main TU: compile host-side without fatbin embedding,
        # HostPass will no-op on it (no main present).
        $LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only \
            -I$SAMPLES_INC \
            -x cuda "$src" -c -o ${base}_host.bc

        $LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/host/HostPass.so \
            -passes="fp-host-instrument" ${base}_host.bc \
            -o ${base}_instrumented_host.bc

        $LLVM_DIR/bin/opt -O2 ${base}_instrumented_host.bc \
            -o ${base}_optimized_host.bc
        $LLVM_DIR/bin/clang++ -O2 -c ${base}_optimized_host.bc \
            -o ${base}.o
    fi

    HOST_OBJS+=("${base}.o")
done

# --- Final link ---
echo ""
echo "--- Final link ---"
clang++ "${HOST_OBJS[@]}" fp_sde_counters.o fp_sde_driver.o \
    -o app_multi \
    -L$CUDA_HOME/lib64 -lcudart \
    -L$PAPI_DIR/lib -lpapi -lsde \
    -Wl,-rpath,$CUDA_HOME/lib64 \
    -Wl,-rpath,$PAPI_DIR/lib

echo ""
echo "Built: app_multi"
ls -la app_multi