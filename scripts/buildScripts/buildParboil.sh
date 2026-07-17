#!/bin/bash
# Parboil single-kernel benchmarks through the PaeFEx pipeline.
# These benchmarks #include the kernel .cu into main.cu (single device TU) and
# depend on the Parboil framework C sources (parboil.c, parboil_cuda.c, args.c)
# which provide pb_ReadParameters / pb_*Timer* etc.
#
# Usage:
#   BENCH=stencil|sgemm|mri-q|tpacf  MODE=instrumented|baseline  bash buildParboil.sh
#   PASS_FLAGS defaults to "-count-total=false"

set -e
module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
export LLVM_DIR=$HOME/opt/llvm-22
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

BENCH=${BENCH:-stencil}
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

COMPAT_FLAGS="-Wno-register -Wno-deprecated-declarations"

PB=tests/benchmarks/parboil
PB_COMMON_INC=$PB/common/include
PB_COMMON_SRC=$PB/common/src
SAMPLES_INC=/home/users/sislam3/rodinia/cuda/hybridsort

# Each benchmark: main TU (kernel is #included) + its own src include dir.
case "$BENCH" in
    stencil) SRC=$PB/benchmarks/stencil/src/cuda/main.cu ;;
    sgemm)   SRC=$PB/benchmarks/sgemm/src/cuda/main.cu ;;
    mri-q)   SRC=$PB/benchmarks/mri-q/src/cuda/main.cu ;;
    tpacf)   SRC=$PB/benchmarks/tpacf/src/cuda/main.cu ;;
    *) echo "Unknown BENCH=$BENCH"; exit 1 ;;
esac
SRC_DIR=$(dirname "$SRC")
INC="-I$SRC_DIR -I$PB_COMMON_INC -I$SAMPLES_INC"

APP=app_${BENCH}
[ "$MODE" = "baseline" ] && APP=app_${BENCH}_baseline

echo "=========================================="
echo " Parboil build: BENCH=$BENCH MODE=$MODE -> $APP"
echo " SRC=$SRC"
echo "=========================================="

LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
[ -f "$LIBDEVICE" ] || LIBDEVICE=$(find $CUDA_HOME -name "libdevice*.bc" 2>/dev/null | head -1)

if [ ! -f build/lib/device/DevicePass.so ] || [ ! -f build/lib/host/HostPass.so ]; then
    echo "Building passes..."
    mkdir -p build && (cd build && cmake \
        -DCMAKE_C_COMPILER=$LLVM_DIR/bin/clang \
        -DCMAKE_CXX_COMPILER=$LLVM_DIR/bin/clang++ \
        -DCMAKE_BUILD_TYPE=Release -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm .. && make -j)
fi

if [ "$MODE" = "instrumented" ]; then
    echo "Building runtime objects..."
    g++ -fPIC -c lib/papi_rtlib/fp_sde_counters.cpp -o fp_sde_counters.o -I$PAPI_DIR/include
    nvcc -Xcompiler -fPIC -c lib/papi_rtlib/fp_sde_driver.cu -o fp_sde_driver.o -I$PAPI_DIR/include
fi

# ---------------- DEVICE PIPELINE (single TU; kernel #included) ----------------
echo ""
echo "--- Device pipeline for $(basename $SRC) ---"
clang++ -O0 -g -emit-llvm --cuda-device-only $COMPAT_FLAGS \
    $FP_FLAGS \
    $INC -x cuda "$SRC" --cuda-gpu-arch=$GPU_ARCH -c -o ${BENCH}_device.bc
llvm-link --only-needed ${BENCH}_device.bc $LIBDEVICE -o ${BENCH}_device_linked.bc
echo "Pre-optimization..."
opt -passes="always-inline,function(mem2reg,instcombine)" ${BENCH}_device_linked.bc -o ${BENCH}_device_preopt.bc
if [ "$MODE" = "instrumented" ]; then
    echo "DevicePass instrumentation ($PASS_FLAGS)..."
    opt -load-pass-plugin=./build/lib/device/DevicePass.so \
        -passes="fp-exception" $PASS_FLAGS ${BENCH}_device_preopt.bc -o ${BENCH}_instrumented_device.bc
else
    cp ${BENCH}_device_preopt.bc ${BENCH}_instrumented_device.bc
fi
echo "Lowering device -> fatbin..."
llc -O2 -mcpu=$GPU_ARCH ${BENCH}_instrumented_device.bc -o ${BENCH}.ptx
nvcc -arch=$GPU_ARCH -dc ${BENCH}.ptx -o ${BENCH}_dev.o
nvcc -arch=$GPU_ARCH -dlink ${BENCH}_dev.o -fatbin -o ${BENCH}.fatbin

# ---------------- HOST PIPELINE (main.cu has main + globals) ----------------
echo ""
echo "--- Host pipeline for $(basename $SRC) ---"
clang++ -O0 -emit-llvm --cuda-host-only --cuda-gpu-arch=$GPU_ARCH $COMPAT_FLAGS \
    $INC -Xclang -fcuda-include-gpubinary -Xclang ${BENCH}.fatbin \
    -x cuda "$SRC" -c -o ${BENCH}_host.bc
if [ "$MODE" = "instrumented" ]; then
    opt -load-pass-plugin=./build/lib/host/HostPass.so \
        -passes="fp-host-instrument" ${BENCH}_host.bc -o ${BENCH}_instrumented_host.bc
    clang++ -O1 -c ${BENCH}_instrumented_host.bc -o ${BENCH}.o
else
    clang++ -O1 -c ${BENCH}_host.bc -o ${BENCH}.o
fi

# ---------------- PARBOIL FRAMEWORK SUPPORT (C sources) ----------------
echo "Compiling Parboil common support..."
# NOTE: parboil_cuda.c is the CUDA superset and redefines the pb_*Timer* symbols
# that are also in parboil.c -> link only one. We use parboil_cuda.c.
clang -O2 -c $PB_COMMON_SRC/parboil_cuda.c -I$PB_COMMON_INC -I$CUDA_HOME/include -o pb_cuda.o
clang -O2 -c $PB_COMMON_SRC/args.c         -I$PB_COMMON_INC -o pb_args.o
PB_OBJS="pb_cuda.o pb_args.o"

# Benchmark-local support: compile every .cc/.c helper in the benchmark src dir
# (e.g. file.cc, args.c, matrix I/O). The kernel (.cu) is #included into main, so
# we skip .cu files; only main.cu goes through the device/host pipeline above.
i=0
for hf in "$SRC_DIR"/*.cc "$SRC_DIR"/*.c; do
    [ -e "$hf" ] || continue
    obj="pb_local_${i}.o"
    echo "Compiling benchmark helper: $(basename $hf)"
    if [[ "$hf" == *.cc ]]; then
        clang++ -O2 $COMPAT_FLAGS -c "$hf" $INC -o "$obj"
    else
        clang -O2 -c "$hf" $INC -o "$obj"
    fi
    PB_OBJS="$PB_OBJS $obj"
    i=$((i+1))
done

# ---------------- LINK ----------------
echo ""
if [ "$MODE" = "instrumented" ]; then
    echo "--- Linking $APP (instrumented) ---"
    clang++ ${BENCH}.o $PB_OBJS fp_sde_counters.o fp_sde_driver.o \
        -o $APP \
        -L$CUDA_HOME/lib64 -lcudart \
        -L$PAPI_DIR/lib -lpapi -lsde -lm -ldl -lstdc++ \
        -Wl,-rpath,$CUDA_HOME/lib64 -Wl,-rpath,$PAPI_DIR/lib
else
    echo "--- Linking $APP (NO instrumentation) ---"
    clang++ ${BENCH}.o $PB_OBJS \
        -o $APP -L$CUDA_HOME/lib64 -lcudart -lm -ldl -lstdc++ \
        -Wl,-rpath,$CUDA_HOME/lib64
fi
echo "Built: $APP"; ls -la $APP