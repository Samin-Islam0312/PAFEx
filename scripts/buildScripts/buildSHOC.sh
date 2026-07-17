#!/bin/bash
# Generalized SHOC single-TU build through the PaeFEx pipeline.
# Handles benchmarks whose device code is a single .cu but which depend on the
# SHOC framework (main() in src/cuda/common/main.cpp + libSHOCCommon.a).
#
# Usage:
#   BENCH=s3d|md|fft  MODE=instrumented|baseline  bash buildSHOC.sh
#   PASS_FLAGS defaults to "-count-total=false" (matches single-TU overhead runs)
#
# Examples:
#   BENCH=s3d bash buildSHOC.sh
#   BENCH=md  MODE=baseline bash buildSHOC.sh

set -e
module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}

export LLVM_DIR=$HOME/opt/llvm-22
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

BENCH=${BENCH:-s3d}
MODE=${MODE:-instrumented}
PASS_FLAGS=${PASS_FLAGS:--count-total=false}

# FP_MODE controls IEEE 754 mode vs fast mode (NVIDIA whitepaper §4.4).
#   FP_MODE=ieee    -> -fno-cuda-flush-denormals-to-zero (preserve subnormals)
#   FP_MODE=fast    -> -fcuda-flush-denormals-to-zero    (FTZ enabled)
#   FP_MODE unset   -> clang default
FP_MODE=${FP_MODE:-default}
case "$FP_MODE" in
    ieee) FP_FLAGS="-fno-cuda-flush-denormals-to-zero" ;;
    fast) FP_FLAGS="-fcuda-flush-denormals-to-zero" ;;
    *)    FP_FLAGS="" ;;
esac
echo "FP_MODE=$FP_MODE  FP_FLAGS='$FP_FLAGS'"

# SHOC chemistry headers use the pre-C++17 `register` keyword; downgrade to warning.
COMPAT_FLAGS="-Wno-register -Wno-deprecated-register -Wno-deprecated-gpu-targets"

# --- Resolve benchmark source (single .cu) and output suffix ---
SHOC=tests/benchmarks/shoc/src
EXTRA_HOST_SRC=""
case "$BENCH" in
    s3d) SRC=$SHOC/cuda/level2/s3d/S3D.cu ;;
    md)  SRC=$SHOC/cuda/level1/md/MD.cu ;;
    fft) SRC=$SHOC/cuda/level1/fft/fftlib.cu
         EXTRA_HOST_SRC=$SHOC/cuda/level1/fft/FFT.cpp ;;
    *) echo "Unknown BENCH=$BENCH (use s3d|md|fft)"; exit 1 ;;
esac
SRC_DIR=$(dirname "$SRC")

# --- SHOC include + framework paths ---
COMMON_CU=$SHOC/cuda/common           # cudacommon.h, main.cpp, support.h
COMMON=$SHOC/common                   # OptionParser.h, ResultDatabase.h, Timer.h, libSHOCCommon.a
CONFIG=tests/benchmarks/shoc/config   # config.h  (FIX: was missing)
SHOC_INC="-I$SRC_DIR -I$COMMON_CU -I$COMMON -I$CONFIG"
SHOC_LIB=$COMMON/libSHOCCommon.a
MAIN_CPP=$COMMON_CU/main.cpp
SAMPLES_INC=/home/users/sislam3/rodinia/cuda/hybridsort

APP=app_${BENCH}
[ "$MODE" = "baseline" ] && APP=app_${BENCH}_baseline

echo "=========================================="
echo " SHOC build: BENCH=$BENCH  MODE=$MODE"
echo " SRC=$SRC"
echo " PASS_FLAGS='$PASS_FLAGS'   ->  $APP"
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

# --- Runtime objects (instrumented only) ---
if [ "$MODE" = "instrumented" ]; then
    echo "Building runtime objects..."
    g++ -fPIC -c lib/papi_rtlib/fp_sde_counters.cpp -o fp_sde_counters.o -I$PAPI_DIR/include
    nvcc -Xcompiler -fPIC -c lib/papi_rtlib/fp_sde_driver.cu -o fp_sde_driver.o -I$PAPI_DIR/include
fi

# ============================================================
# DEVICE PIPELINE (single TU)
# ============================================================
echo ""
echo "--- Device pipeline for $(basename $SRC) ---"
clang++ -O0 -g -emit-llvm --cuda-device-only \
    $FP_FLAGS \
    $COMPAT_FLAGS $SHOC_INC -I$SAMPLES_INC \
    -x cuda "$SRC" --cuda-gpu-arch=$GPU_ARCH -c -o ${BENCH}_device.bc

llvm-link --only-needed ${BENCH}_device.bc $LIBDEVICE -o ${BENCH}_device_linked.bc

echo "Running targeted pre-optimization pass..."
opt -passes="always-inline,function(mem2reg,instcombine)" ${BENCH}_device_linked.bc -o ${BENCH}_device_preopt.bc

if [ "$MODE" = "instrumented" ]; then
    echo "Running DevicePass instrumentation ($PASS_FLAGS)..."
    opt -load-pass-plugin=./build/lib/device/DevicePass.so \
        -passes="fp-exception" $PASS_FLAGS ${BENCH}_device_preopt.bc \
        -o ${BENCH}_instrumented_device.bc
else
    echo "Baseline: skipping DevicePass..."
    cp ${BENCH}_device_preopt.bc ${BENCH}_instrumented_device.bc
fi

echo "Lowering device -> PTX/cubin/fatbin..."
llc -O2 -mcpu=$GPU_ARCH ${BENCH}_instrumented_device.bc -o ${BENCH}.ptx
nvcc -arch=$GPU_ARCH -dc ${BENCH}.ptx -o ${BENCH}_dev.o
nvcc -arch=$GPU_ARCH -dlink ${BENCH}_dev.o -fatbin -o ${BENCH}.fatbin

# ============================================================
# HOST PIPELINE
# ============================================================
echo ""
echo "--- Host pipeline for $(basename $SRC) ---"
clang++ -O0 -emit-llvm --cuda-host-only --cuda-gpu-arch=$GPU_ARCH \
    $COMPAT_FLAGS $SHOC_INC -I$SAMPLES_INC \
    -Xclang -fcuda-include-gpubinary -Xclang ${BENCH}.fatbin \
    -x cuda "$SRC" -c -o ${BENCH}_host.bc

if [ "$MODE" = "instrumented" ]; then
    opt -load-pass-plugin=./build/lib/host/HostPass.so \
        -passes="fp-host-instrument" ${BENCH}_host.bc -o ${BENCH}_instrumented_host.bc
    clang++ -O1 -c ${BENCH}_instrumented_host.bc -o ${BENCH}.o
else
    clang++ -O1 -c ${BENCH}_host.bc -o ${BENCH}.o
fi

echo "Compiling SHOC framework main.cpp..."
if [ "$MODE" = "instrumented" ]; then
    # main() lives here, so HostPass must process this TU to inject the PAPI
    # lifecycle that reads counters back and prints the [FP_INSTRUMENT] summary.
    clang++ -O2 $COMPAT_FLAGS -emit-llvm -c "$MAIN_CPP" $SHOC_INC -o shoc_main.bc
    opt -load-pass-plugin=./build/lib/host/HostPass.so \
        -passes="fp-host-instrument" shoc_main.bc -o shoc_main_instr.bc
    clang++ -O1 -c shoc_main_instr.bc -o shoc_main.o
else
    clang++ -O2 $COMPAT_FLAGS -c "$MAIN_CPP" $SHOC_INC -o shoc_main.o
fi

EXTRA_OBJ=""
if [ -n "$EXTRA_HOST_SRC" ]; then
    echo "Compiling extra host TU: $EXTRA_HOST_SRC ..."
    clang++ -O2 $COMPAT_FLAGS -c "$EXTRA_HOST_SRC" $SHOC_INC -I$SAMPLES_INC -o extra_host.o
    EXTRA_OBJ="extra_host.o"
fi

# ============================================================
# LINK
# ============================================================
echo ""
if [ "$MODE" = "instrumented" ]; then
    echo "--- Linking $APP (instrumented) ---"
    clang++ ${BENCH}.o shoc_main.o $EXTRA_OBJ "$SHOC_LIB" fp_sde_counters.o fp_sde_driver.o \
        -o $APP \
        -L$CUDA_HOME/lib64 -lcudart \
        -L$PAPI_DIR/lib -lpapi -lsde -lm -ldl -lstdc++ \
        -Wl,-rpath,$CUDA_HOME/lib64 -Wl,-rpath,$PAPI_DIR/lib
else
    echo "--- Linking $APP (NO instrumentation) ---"
    clang++ ${BENCH}.o shoc_main.o $EXTRA_OBJ "$SHOC_LIB" \
        -o $APP \
        -L$CUDA_HOME/lib64 -lcudart -lm -ldl -lstdc++ \
        -Wl,-rpath,$CUDA_HOME/lib64
fi
echo "Built: $APP"
ls -la $APP