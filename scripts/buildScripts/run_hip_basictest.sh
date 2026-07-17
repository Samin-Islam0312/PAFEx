#!/bin/bash
# =============================================================================
# run_hip_basictest.sh  —  PaFEx HIP instrumentation pipeline, ONE basic-test.
#
# LIBRARY-INLINING SYMMETRY WITH CUDA (important, see paper §Design):
#   The CUDA pipeline links libdevice then runs `always-inline` in preopt.
#   NVIDIA marks libdevice's __nv_* functions `alwaysinline`, so they fold into
#   the kernel BEFORE DevicePass runs => library-internal FP arithmetic is
#   instrumented and counted as origination.
#   AMD does NOT mark OCML's functions `alwaysinline`, so with the same preopt
#   they survive as separate functions, get caught by isLibraryInternal's name
#   filter, and their arithmetic is never counted. Same pipeline, different
#   vendor packaging => incomparable counts.
#   Fix: add cgscc(inline) (the cost-based inliner) to the AMD preopt so OCML
#   folds in too. This makes the OUTCOME symmetric (both targets instrument
#   library-internal arithmetic), which is what the cross-vendor comparison
#   requires. Do NOT add cgscc(inline) to the CUDA script: libdevice is already
#   inlined there, and adding it would inline additional user code and shift
#   the published NVIDIA numbers.
#
# USAGE:
#   ./run_hip_basictest.sh <name|class/name> [instrumented|baseline]
#   STOP_AFTER=devpass|lower|bundle|hostpass|link   halts after that stage
#   OPT_LEVEL=0..3 (default 0)   GFX=gfx942   PASS_FLAGS="..."
#   NO_LIB_INLINE=1   revert to always-inline only (OCML stays out-of-line)
# =============================================================================
set -euo pipefail

NAME="${1:?usage: run_hip_basictest.sh <name|class/name> [instrumented|baseline]}"
MODE="${2:-instrumented}"
OPT_LEVEL="${OPT_LEVEL:-0}"
GFX="${GFX:-gfx942}"
STOP_AFTER="${STOP_AFTER:-}"
NO_LIB_INLINE="${NO_LIB_INLINE:-0}"
INSTRUMENT=1; [ "$MODE" = baseline ] && INSTRUMENT=0

ROOT="$(pwd)"
ROCM="${ROCM:-/opt/rocm-7.2.4}"
LLVMBIN="$ROCM/lib/llvm/bin"
HIPCC="$(command -v hipcc)"
BCLIB="$ROCM/amdgcn/bitcode"
DEVICE_PASS="$ROOT/build-rocm/lib/device/DevicePass.so"
HOST_PASS="$ROOT/build-rocm/lib/host/HostPass.so"
BT_ROOT="$ROOT/tests/amd/basic_test"

# --- resolve source + expected class -----------------------------------------
if [[ "$NAME" == */* ]]; then
    SRC="$BT_ROOT/${NAME}.hip"; TESTID="$NAME"
else
    SRC="$(find "$BT_ROOT" -name "${NAME}.hip" | head -1)"
    if [ -n "$SRC" ]; then TESTID="${SRC#$BT_ROOT/}"; TESTID="${TESTID%.hip}"; fi
fi
if [ -z "${SRC:-}" ] || [ ! -f "$SRC" ]; then
    echo "ERROR: test not found: '$NAME' (resolved to '${SRC:-}')" >&2; exit 2
fi
CLASS_DIR="$(basename "$(dirname "$SRC")")"
case "$CLASS_DIR" in
    divZero)   EXPECT=divzero ;;
    invalid)   EXPECT=invalid ;;
    overflow)  EXPECT=overflow ;;
    underflow) EXPECT=underflow ;;
    *)         EXPECT="" ;;
esac

for p in "$DEVICE_PASS" "$HOST_PASS"; do
    [ -f "$p" ] || { echo "ERROR: pass not built: $p" >&2; exit 2; }
done

S="$ROOT/scratch/hip_basictest/$TESTID/$MODE"
RTDIR="$ROOT/scratch/hip_basictest/_rt"
mkdir -p "$S" "$RTDIR"
RT_SRC="$ROOT/lib/papi_rtlib"; RT_INC="$ROOT/lib/include"
PAPI_DIR="${PAPI_DIR:-$HOME/opt/papi}"

echo "=== $TESTID [$MODE]  gfx=$GFX O$OPT_LEVEL  expect=${EXPECT:-?}"
checkpoint() { if [ "$STOP_AFTER" = "$1" ]; then echo ">>> STOP_AFTER=$1"; exit 0; fi; }

# --- runtime objects (built once) --------------------------------------------
if [ ! -f "$RTDIR/fp_sde_driver.o" ] || [ "$RT_SRC/fp_sde_driver.cu" -nt "$RTDIR/fp_sde_driver.o" ]; then
    echo "--- runtime objects"
    g++ -fPIC -c "$RT_SRC/fp_sde_counters.cpp" -o "$RTDIR/fp_sde_counters.o" \
        -I"$PAPI_DIR/include" -I"$RT_INC" -I"$RT_SRC"
    cp -f "$RT_SRC/fp_sde_driver.cu" "$RTDIR/fp_sde_driver.hip"
    "$ROCM/bin/hipify-perl" -inplace "$RTDIR/fp_sde_driver.hip" >/dev/null 2>&1 || true
    rm -f "$RTDIR/fp_sde_driver.hip.prehip"
    "$HIPCC" -fPIC -c "$RTDIR/fp_sde_driver.hip" -o "$RTDIR/fp_sde_driver.o" \
        -I"$PAPI_DIR/include" -I"$RT_INC" -I"$RT_SRC" 2>/dev/null
fi

# --- device front half -------------------------------------------------------
echo "--- device: emit IR + preopt + DevicePass"
"$LLVMBIN/clang++" -x hip --cuda-device-only --offload-arch=$GFX -O$OPT_LEVEL -g -w \
    --no-gpu-bundle-output -emit-llvm -c "$SRC" -o "$S/device.bc"

NEED_OCML=0
if "$LLVMBIN/llvm-nm" "$S/device.bc" 2>/dev/null | grep -qE '__ocml_|__ockl_'; then
    NEED_OCML=1
fi
if [ "$NEED_OCML" -eq 1 ]; then
    "$LLVMBIN/llvm-link" "$S/device.bc" \
        "$BCLIB/ocml.bc" "$BCLIB/ockl.bc" \
        "$BCLIB/oclc_isa_version_942.bc" "$BCLIB/oclc_wavefrontsize64_on.bc" \
        "$BCLIB/oclc_daz_opt_off.bc" "$BCLIB/oclc_finite_only_off.bc" \
        "$BCLIB/oclc_correctly_rounded_sqrt_on.bc" "$BCLIB/oclc_unsafe_math_off.bc" \
        "$BCLIB/oclc_abi_version_600.bc" \
        -o "$S/device_linked.bc"
    DEVLINK="$S/device_linked.bc"
else
    DEVLINK="$S/device.bc"
fi

# PREOPT — the CUDA-parity line. cgscc(inline) forces OCML in (see header).
if [ "$NO_LIB_INLINE" -eq 1 ]; then
    PREOPT_PASSES="always-inline,function(mem2reg,instcombine)"
else
    PREOPT_PASSES="always-inline,cgscc(inline),function(mem2reg,instcombine)"
fi
"$LLVMBIN/opt" -passes="$PREOPT_PASSES" "$DEVLINK" -o "$S/device_preopt.bc"

# Report whether any vendor-library function survived preopt. If OCML functions
# remain, their arithmetic is name-filtered by the pass and NOT counted -> the
# counts are not comparable to the CUDA build.
LEFT=$("$LLVMBIN/llvm-nm" --defined-only "$S/device_preopt.bc" 2>/dev/null | grep -cE '__ocml|__ockl' || true)
echo "    ocml_linked=$NEED_OCML  ocml_funcs_surviving_preopt=${LEFT:-0}  (want 0 for CUDA parity)"

if [ "$INSTRUMENT" -eq 1 ]; then
    "$LLVMBIN/opt" -load-pass-plugin="$DEVICE_PASS" -passes="fp-exception" \
        -fp-sites-csv="$S/fp_sites.csv" ${PASS_FLAGS:-} \
        "$S/device_preopt.bc" -o "$S/instr_device.bc" 2> "$S/instrument_device.log"
    DEVBC="$S/instr_device.bc"
    "$LLVMBIN/llvm-dis" "$DEVBC" -o "$S/instr_device.ll"
    ARMW=$(grep -c atomicrmw "$S/instr_device.ll" || true)
    echo "    atomicrmw sites: ${ARMW:-0}"
else
    DEVBC="$S/device_preopt.bc"
fi
checkpoint devpass

# --- device tail -------------------------------------------------------------
echo "--- device: lower + bundle"
"$LLVMBIN/clang++" -x ir --target=amdgcn-amd-amdhsa -mcpu=$GFX "$DEVBC" -o "$S/device.hsaco"
checkpoint lower
"$LLVMBIN/clang-offload-bundler" -type=o \
    -targets=host-x86_64-unknown-linux-gnu,hipv4-amdgcn-amd-amdhsa--$GFX \
    -input=/dev/null -input="$S/device.hsaco" -output="$S/device.hipfb"
checkpoint bundle

# --- host half ---------------------------------------------------------------
echo "--- host: emit + HostPass"
"$LLVMBIN/clang++" -x hip --cuda-host-only --offload-arch=$GFX -O$OPT_LEVEL -w -emit-llvm \
    -Xclang -fcuda-include-gpubinary -Xclang "$S/device.hipfb" -c "$SRC" -o "$S/host.bc"
if [ "$INSTRUMENT" -eq 1 ]; then
    "$LLVMBIN/opt" -load-pass-plugin="$HOST_PASS" -passes="fp-host-instrument" \
        "$S/host.bc" -o "$S/instr_host.bc" 2> "$S/instrument_host.log"
    HOSTBC="$S/instr_host.bc"
else
    HOSTBC="$S/host.bc"
fi
checkpoint hostpass
"$LLVMBIN/clang++" -O1 -c "$HOSTBC" -o "$S/host.o"

# --- link --------------------------------------------------------------------
echo "--- link"
if [ "$INSTRUMENT" -eq 1 ]; then
    "$LLVMBIN/clang++" "$S/host.o" "$RTDIR/fp_sde_counters.o" "$RTDIR/fp_sde_driver.o" \
        -o "$S/app" -L"$ROCM/lib" -lamdhip64 -L"$PAPI_DIR/lib" -lpapi -lsde \
        -Wl,-rpath,"$ROCM/lib" -Wl,-rpath,"$PAPI_DIR/lib"
else
    "$LLVMBIN/clang++" "$S/host.o" -o "$S/app" -L"$ROCM/lib" -lamdhip64 -Wl,-rpath,"$ROCM/lib"
fi
checkpoint link

# --- run ---------------------------------------------------------------------
echo "--- run"
RUNLOG="$S/run.log"
FP_DEBUG=1 FP_SITES_CSV="$S/fp_sites.csv" "$S/app" > "$RUNLOG" 2>&1 || {
    echo "    RUN FAILED (rc=$?) — see $RUNLOG"; exit 1; }

set +e   # reporting only past this point; a parse hiccup must not fail the run
if [ "$INSTRUMENT" -eq 1 ]; then
    BLK=$(awk '/\[FP_INSTRUMENT\] Summary for:/{f=1} f{print} /\[FP_INSTRUMENT\] Finalized\./{f=0}' "$RUNLOG")
    getc(){ printf '%s\n' "$BLK" | grep -E "^[[:space:]]*$1" | head -1 | awk '{print $NF}'; }
    INV=$(getc 'Invalid Ops:');        INV=${INV:-0}
    DIV=$(getc 'Div by Zero:');        DIV=${DIV:-0}
    OVF=$(getc 'Overflow:');           OVF=${OVF:-0}
    UNF=$(getc 'Underflow:');          UNF=${UNF:-0}
    SUB=$(getc 'Denormals Produced:'); SUB=${SUB:-0}
    echo "invalid=$INV divzero=$DIV overflow=$OVF underflow=$UNF subnormal=$SUB" > "$S/counts.txt"
    echo "    counts: invalid=$INV divzero=$DIV overflow=$OVF underflow=$UNF subnormal=$SUB"
    if [ -n "$EXPECT" ]; then
        declare -A C=( [invalid]=$INV [divzero]=$DIV [overflow]=$OVF [underflow]=$UNF )
        if [ "${C[$EXPECT]:-0}" -ne 0 ]; then
            echo "    EXPECT[$EXPECT]: PASS (${C[$EXPECT]})"
        else
            echo "    EXPECT[$EXPECT]: FAIL (zero)"
        fi
    fi
fi
echo "=== done: $TESTID [$MODE]"
exit 0
