#!/bin/bash
set -u
module load cuda/12.8 2>/dev/null || true

BENCH="${1:-}"
SRC_OVERRIDE=""
if [ "${2:-}" = "--src" ] && [ -n "${3:-}" ]; then
    SRC_OVERRIDE="$3"
fi

if [ -z "$BENCH" ]; then
    echo "Usage: $0 <benchmark> [--src <file.cu>]"
    SDIR=$(dirname "${BASH_SOURCE[0]}")
    echo "Available:"
    for d in "$SDIR"/*/; do
        [ -d "$d" ] && [ "$(basename "$d")" != "util" ] && basename "$d"
    done
    exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJ_ROOT=$(cd "$SCRIPT_DIR/../../.." && pwd)
BENCH_DIR="$SCRIPT_DIR/$BENCH"

if [ -n "$SRC_OVERRIDE" ]; then
    SRC="$BENCH_DIR/$SRC_OVERRIDE"
else
    SRC="$BENCH_DIR/$BENCH.cu"
fi

UTIL="$SCRIPT_DIR/util"
OUTDIR="$BENCH_DIR/build"
mkdir -p "$OUTDIR"

[ -f "$SRC" ] || { echo "ERROR: $SRC not found"; exit 1; }
[ -d "$PROJ_ROOT/build/lib/device" ] || { echo "ERROR: passes not built — run ./build.sh first"; exit 1; }

GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}
export LLVM_DIR=$HOME/opt/llvm-22
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
STUB_FLAGS=("-DMY_START_CLOCK(...)=" "-DMY_STOP_CLOCK(...)=" "-DMY_VERIFY_FLOAT_EXACT(...)=")
# INCLUDE_FLAGS=()
# [ -d "$UTIL" ] && INCLUDE_FLAGS+=("-I$UTIL")
INCLUDE_FLAGS=()
[ -d "$UTIL" ] && INCLUDE_FLAGS+=("-I$UTIL")
[ -d "/packages/cuda/11.4.1/samples/common/inc" ] && INCLUDE_FLAGS+=("-I/packages/cuda/11.4.1/samples/common/inc")
# CUDA Samples headers (helper_cuda.h, helper_timer.h) — required for cfd
[ -d "/packages/cuda/11.4.1/samples/common/inc" ] && INCLUDE_FLAGS+=("-I/packages/cuda/11.4.1/samples/common/inc")

LOG="$OUTDIR/bench_build.log"
exec > >(tee "$LOG") 2>&1

echo "Building: $BENCH  (source: $SRC)"

echo ""
echo "=== BASELINE ==="
nvcc -O2 -arch=$GPU_ARCH "${STUB_FLAGS[@]}" "${INCLUDE_FLAGS[@]}" \
    "$SRC" -o "$OUTDIR/${BENCH}_baseline" 2>&1 | tail -10
[ ! -x "$OUTDIR/${BENCH}_baseline" ] && { echo "BASELINE FAILED"; exit 1; }

echo ""
echo "=== INSTRUMENTED ==="
echo "  [1] device bitcode"
$LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only \
    "${STUB_FLAGS[@]}" "${INCLUDE_FLAGS[@]}" -x cuda "$SRC" \
    --cuda-gpu-arch=$GPU_ARCH -c -o "$OUTDIR/device.bc" 2>&1 | tail -5
[ ! -f "$OUTDIR/device.bc" ] && { echo "FAILED"; exit 1; }

echo "  [2] llvm-link libdevice"
$LLVM_DIR/bin/llvm-link --only-needed "$OUTDIR/device.bc" "$LIBDEVICE" \
    -o "$OUTDIR/device_linked.bc" 2>&1 | tail -3

echo "  [3] device pass"
$LLVM_DIR/bin/opt -load-pass-plugin="$PROJ_ROOT/build/lib/device/DevicePass.so" \
    -passes="fp-exception" "$OUTDIR/device_linked.bc" \
    -o "$OUTDIR/instrumented_device.bc" 2>&1 | grep -E "SUMMARY|FAIL|error" | tail -3
[ ! -f "$OUTDIR/instrumented_device.bc" ] && { echo "FAILED"; exit 1; }

echo "  [4] opt -O2"
$LLVM_DIR/bin/opt -O2 "$OUTDIR/instrumented_device.bc" \
    -o "$OUTDIR/optimized_device.bc" 2>&1 | tail -3

echo "  [5] llc -> PTX"
$LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH "$OUTDIR/optimized_device.bc" \
    -o "$OUTDIR/instrumented.ptx" 2>&1 | tail -3
ptxas --gpu-name $GPU_ARCH "$OUTDIR/instrumented.ptx" \
    -o "$OUTDIR/instrumented.cubin" 2>&1 | tail -3
fatbinary --64 --create "$OUTDIR/instrumented.fatbin" \
    --image3=kind=elf,sm=$GPU_SM,file="$OUTDIR/instrumented.cubin" 2>&1 | tail -3

echo "  [6] host bitcode"
$LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only \
    "${STUB_FLAGS[@]}" "${INCLUDE_FLAGS[@]}" \
    -Xclang -fcuda-include-gpubinary -Xclang "$OUTDIR/instrumented.fatbin" \
    -x cuda "$SRC" -c -o "$OUTDIR/host.bc" 2>&1 | tail -5

echo "  [7] host pass"
$LLVM_DIR/bin/opt -load-pass-plugin="$PROJ_ROOT/build/lib/host/HostPass.so" \
    -passes="fp-host-instrument" "$OUTDIR/host.bc" \
    -o "$OUTDIR/instrumented_host.bc" 2>&1 | grep -E "Instrumented|shadow|WARN|main" | tail -10

$LLVM_DIR/bin/opt -O2 "$OUTDIR/instrumented_host.bc" -o "$OUTDIR/optimized_host.bc" 2>&1 | tail -3
$LLVM_DIR/bin/clang++ -O2 -c "$OUTDIR/optimized_host.bc" -o "$OUTDIR/host.o" 2>&1 | tail -3

echo "  [8] link"
clang++ "$OUTDIR/host.o" \
    "$PROJ_ROOT/results/_fp_sde_counters.o" \
    "$PROJ_ROOT/results/_fp_sde_driver.o" \
    -o "$OUTDIR/${BENCH}_instrumented" \
    -L$CUDA_HOME/lib64 -lcudart -L$PAPI_DIR/lib -lpapi -lsde \
    -Wl,-rpath,$CUDA_HOME/lib64 -Wl,-rpath,$PAPI_DIR/lib 2>&1 | tail -3

[ ! -x "$OUTDIR/${BENCH}_instrumented" ] && { echo "LINK FAILED"; exit 1; }
echo ""
echo "DONE: $BENCH"
ls -la "$OUTDIR/${BENCH}_baseline" "$OUTDIR/${BENCH}_instrumented"
