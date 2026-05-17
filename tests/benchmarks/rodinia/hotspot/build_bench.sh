#!/bin/bash
set -u
module load cuda/12.8 2>/dev/null || true

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# script is at: SBAC-PAD/tests/benchmarks/rodinia/hotspot/
# project root: 4 levels up
PROJ_ROOT=$(cd "$SCRIPT_DIR/../../../.." && pwd)
HOTSPOT_SRC="$SCRIPT_DIR/hotspot.cu"
HOTSPOT_UTIL="$SCRIPT_DIR/../util"
OUTDIR="$SCRIPT_DIR/build"
mkdir -p "$OUTDIR"

echo "Paths:"
echo "  PROJ_ROOT:    $PROJ_ROOT"
echo "  HOTSPOT_SRC:  $HOTSPOT_SRC"
echo "  HOTSPOT_UTIL: $HOTSPOT_UTIL"
echo "  OUTDIR:       $OUTDIR"

[ -f "$HOTSPOT_SRC" ] || { echo "ERROR: hotspot.cu not at $HOTSPOT_SRC"; exit 1; }
[ -d "$HOTSPOT_UTIL" ] || { echo "ERROR: util not at $HOTSPOT_UTIL"; exit 1; }
[ -d "$PROJ_ROOT/build/lib/device" ] || { echo "ERROR: device pass not built. Run ./build.sh first"; exit 1; }

GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}
export LLVM_DIR=$HOME/opt/llvm-22
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
[ -f "$LIBDEVICE" ] || { echo "ERROR: libdevice not at $LIBDEVICE"; exit 1; }

# Use an array for stub flags — avoids bash word-split issues
STUB_FLAGS=(
    "-DMY_START_CLOCK(...)="
    "-DMY_STOP_CLOCK(...)="
    "-DMY_VERIFY_FLOAT_EXACT(...)="
)

echo ""
echo "=== BASELINE (nvcc -O2) ==="
nvcc -O2 -arch=$GPU_ARCH "${STUB_FLAGS[@]}" -I"$HOTSPOT_UTIL" \
    "$HOTSPOT_SRC" -o "$OUTDIR/hotspot_baseline" 2>&1 | tail -10

[ ! -x "$OUTDIR/hotspot_baseline" ] && { echo "BASELINE FAILED"; exit 1; }
echo "  -> $OUTDIR/hotspot_baseline"

echo ""
echo "=== INSTRUMENTED ==="

echo "  [1] device bitcode"
$LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only \
    "${STUB_FLAGS[@]}" -I"$HOTSPOT_UTIL" \
    -x cuda "$HOTSPOT_SRC" \
    --cuda-gpu-arch=$GPU_ARCH \
    -c -o "$OUTDIR/device.bc" 2>&1 | tail -5
[ ! -f "$OUTDIR/device.bc" ] && { echo "FAILED at device.bc"; exit 1; }

echo "  [2] llvm-link libdevice"
$LLVM_DIR/bin/llvm-link --only-needed \
    "$OUTDIR/device.bc" "$LIBDEVICE" \
    -o "$OUTDIR/device_linked.bc" 2>&1 | tail -3

echo "  [3] device pass"
$LLVM_DIR/bin/opt -load-pass-plugin="$PROJ_ROOT/build/lib/device/DevicePass.so" \
    -passes="fp-exception" "$OUTDIR/device_linked.bc" \
    -o "$OUTDIR/instrumented_device.bc" 2>&1 | grep -E "SUMMARY|FAIL|error" | tail -3
[ ! -f "$OUTDIR/instrumented_device.bc" ] && { echo "FAILED at device pass"; exit 1; }

echo "  [4] opt -O2"
$LLVM_DIR/bin/opt -O2 "$OUTDIR/instrumented_device.bc" \
    -o "$OUTDIR/optimized_device.bc" 2>&1 | tail -3

echo "  [5] llc -> PTX"
$LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH \
    "$OUTDIR/optimized_device.bc" -o "$OUTDIR/instrumented.ptx" 2>&1 | tail -3

ptxas --gpu-name $GPU_ARCH "$OUTDIR/instrumented.ptx" \
    -o "$OUTDIR/instrumented.cubin" 2>&1 | tail -3
fatbinary --64 --create "$OUTDIR/instrumented.fatbin" \
    --image3=kind=elf,sm=$GPU_SM,file="$OUTDIR/instrumented.cubin" 2>&1 | tail -3

echo "  [6] host bitcode"
$LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only \
    "${STUB_FLAGS[@]}" -I"$HOTSPOT_UTIL" \
    -Xclang -fcuda-include-gpubinary -Xclang "$OUTDIR/instrumented.fatbin" \
    -x cuda "$HOTSPOT_SRC" \
    -c -o "$OUTDIR/host.bc" 2>&1 | tail -5

echo "  [7] host pass"
$LLVM_DIR/bin/opt -load-pass-plugin="$PROJ_ROOT/build/lib/host/HostPass.so" \
    -passes="fp-host-instrument" "$OUTDIR/host.bc" \
    -o "$OUTDIR/instrumented_host.bc" 2>&1 | grep -E "Instrumented|shadow" | tail -5

$LLVM_DIR/bin/opt -O2 "$OUTDIR/instrumented_host.bc" \
    -o "$OUTDIR/optimized_host.bc" 2>&1 | tail -3
$LLVM_DIR/bin/clang++ -O2 -c "$OUTDIR/optimized_host.bc" -o "$OUTDIR/host.o" 2>&1 | tail -3

echo "  [8] link"
clang++ "$OUTDIR/host.o" \
    "$PROJ_ROOT/results/_fp_sde_counters.o" \
    "$PROJ_ROOT/results/_fp_sde_driver.o" \
    -o "$OUTDIR/hotspot_instrumented" \
    -L$CUDA_HOME/lib64 -lcudart \
    -L$PAPI_DIR/lib -lpapi -lsde \
    -Wl,-rpath,$CUDA_HOME/lib64 \
    -Wl,-rpath,$PAPI_DIR/lib 2>&1 | tail -3

[ ! -x "$OUTDIR/hotspot_instrumented" ] && { echo "LINK FAILED"; exit 1; }

echo ""
echo "DONE."
ls -la "$OUTDIR/hotspot_baseline" "$OUTDIR/hotspot_instrumented"
