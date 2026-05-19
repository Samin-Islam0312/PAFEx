#!/bin/bash
# Config C: full instrumentation (passes + runtime).
# Output: app_full
# Side effects: leaves host.o, fp_sde_counters.o, instrumented.fatbin in CWD
# for Config B to reuse.

set -e

module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}

export LLVM_DIR=$HOME/opt/llvm-22
export CC=$LLVM_DIR/bin/clang
export CXX=$LLVM_DIR/bin/clang++
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

# Helper headers (helper_cuda.h, helper_timer.h) for cfd and similar Rodinia apps.
SAMPLES_INC=/home/users/sislam3/rodinia/cuda/hybridsort

# FP_MODE controls IEEE 754 mode vs fast mode (per NVIDIA whitepaper §4.4).
#   FP_MODE=ieee → -fno-cuda-flush-denormals-to-zero (preserve subnormals)
#   FP_MODE=fast → -fcuda-flush-denormals-to-zero    (FTZ enabled)
#   FP_MODE unset/default → clang default
FP_MODE=${FP_MODE:-default}
case "$FP_MODE" in
    ieee) FP_FLAGS="-fno-cuda-flush-denormals-to-zero" ;;
    fast) FP_FLAGS="-fcuda-flush-denormals-to-zero" ;;
    *)    FP_FLAGS="" ;;
esac
echo "FP_MODE=$FP_MODE  FP_FLAGS='$FP_FLAGS'"

# === EDIT THIS to point at the test .cu you want to measure ===
APP_SRC=${APP_SRC:-tests/benchmarks/rodinia/cfd/euler3d.cu}

echo "=========================================="
echo " Config C: FULL INSTRUMENTATION"
echo " Source: $APP_SRC"
echo "=========================================="

# --- Make sure passes are built ---
if [ ! -f build/lib/device/DevicePass.so ] || [ ! -f build/lib/host/HostPass.so ]; then
    echo "Building passes..."
    mkdir -p build
    (
        cd build
        cmake \
            -DCMAKE_C_COMPILER=$LLVM_DIR/bin/clang \
            -DCMAKE_CXX_COMPILER=$LLVM_DIR/bin/clang++ \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm \
            ..
        make -j
    )
fi

# --- Build runtime objects (kept for Config B to reuse) ---
echo "Building runtime objects..."
g++ -fPIC -c lib/papi_rtlib/fp_sde_counters.cpp \
    -o fp_sde_counters.o -I$PAPI_DIR/include
nvcc -Xcompiler -fPIC -c lib/papi_rtlib/fp_sde_driver.cu \
    -o fp_sde_driver.o -I$PAPI_DIR/include

# --- Device pipeline ---
echo "Device pipeline..."
LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
[ -f "$LIBDEVICE" ] || LIBDEVICE=$(find $CUDA_HOME -name "libdevice*.bc" 2>/dev/null | head -1)

$LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only \
    $FP_FLAGS -I$SAMPLES_INC \
    -x cuda "$APP_SRC" --cuda-gpu-arch=$GPU_ARCH -c -o device.bc

$LLVM_DIR/bin/llvm-link --only-needed device.bc $LIBDEVICE -o device_linked.bc

$LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/device/DevicePass.so \
    -passes="fp-exception" device_linked.bc -o instrumented_device.bc

$LLVM_DIR/bin/opt -O2 instrumented_device.bc -o optimized_device.bc
$LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH optimized_device.bc -o instrumented.ptx
ptxas --gpu-name $GPU_ARCH instrumented.ptx -o instrumented.cubin
fatbinary --64 --create instrumented.fatbin \
    --image3=kind=elf,sm=$GPU_SM,file=instrumented.cubin

# --- Host pipeline ---
echo "Host pipeline..."
$LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only \
    -I$SAMPLES_INC \
    -Xclang -fcuda-include-gpubinary -Xclang instrumented.fatbin \
    -x cuda "$APP_SRC" -c -o host.bc

$LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/host/HostPass.so \
    -passes="fp-host-instrument" host.bc -o instrumented_host.bc

$LLVM_DIR/bin/opt -O2 instrumented_host.bc -o optimized_host.bc
$LLVM_DIR/bin/clang++ -O2 -c optimized_host.bc -o host.o

# --- Link ---
echo "Linking app_full..."
clang++ host.o fp_sde_counters.o fp_sde_driver.o \
    -o app_full \
    -L$CUDA_HOME/lib64 -lcudart \
    -L$PAPI_DIR/lib -lpapi -lsde \
    -Wl,-rpath,$CUDA_HOME/lib64 \
    -Wl,-rpath,$PAPI_DIR/lib

echo "Built: app_full"
ls -la app_full