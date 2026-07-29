#!/bin/bash
# =============================================================================
# run_hip_single_tu.sh — build + run ONE single-TU benchmark through the PaFEx
# HIP FP-exception instrumentation pipeline on gfx942.
#
# This is the AMD counterpart of run_single_tu.sh. The DEVICE/HOST pipeline is
# lifted verbatim from run_hip_basictest.sh (the version verified 17/17 on the
# basic-test suite), so the only new surface here vs the basictest runner is:
#   - manifest-driven source resolution (name -> src/inc/args)
#   - config-suffixed output dirs for the O-level x FP-mode x tag matrix
#   - RUNS timed repetitions + timing sample emission
#
# SINGLE-TU ONLY. Every device TU now DEFINES the counters (ExternalLinkage), so
# a benchmark whose kernels live in separate .cu TUs hits duplicate-symbol at
# device link. myocyte is single-TU IFF main.cu #includes the other .cu files;
# S3D (needs SHOC infra) and stencil (split host/kernel TUs) are multi-TU and
# are intentionally NOT in the HIP manifest. Do not add them without the
# one-definition-TU fix from the handoff.
#
# USAGE:
#   ./run_hip_single_tu.sh <name> [instrumented|baseline]
# ENV:
#   MANIFEST=path        default $ROOT/scripts/buildScripts/sweep_hip.manifest
#   OPT_LEVEL=0..3       clang -O for device AND host frontend (default 0)
#   FP_MODE=ieee|fast    default ieee
#   TAGGED=0|1           run TagPass in-clang (default 1); 0 = A/B control
#   RUNS=N               timed repetitions (default 3)
#   GFX=gfx942
#   OUT_ROOT=<dir>       default $ROOT/runs/amd_bench
#   TIMEOUT=secs         per-run wall clock cap (default 300)
#   PASS_FLAGS="..."     extra DevicePass flags (e.g. -result-class)
#   STOP_AFTER=devpass|lower|bundle|hostpass|link
# =============================================================================
set -euo pipefail

NAME="${1:?usage: run_hip_single_tu.sh <name> [instrumented|baseline]}"
MODE="${2:-instrumented}"
case "$MODE" in
    unstaged) MODE="instrumented" ;;
    instrumented|baseline) ;;
    *) echo "ERROR: mode must be instrumented|baseline, got '$MODE'" >&2; exit 2 ;;
esac
INSTRUMENT=1; [ "$MODE" = baseline ] && INSTRUMENT=0

OPT_LEVEL="${OPT_LEVEL:-0}"
case "$OPT_LEVEL" in 0|1|2|3) ;; *) echo "ERROR: OPT_LEVEL must be 0..3" >&2; exit 2 ;; esac
FP_MODE="${FP_MODE:-ieee}"
case "$FP_MODE" in ieee|fast) ;; *) echo "ERROR: FP_MODE must be ieee|fast" >&2; exit 2 ;; esac
TAGGED="${TAGGED:-1}"
RUNS="${RUNS:-3}"
GFX="${GFX:-gfx942}"
TIMEOUT="${TIMEOUT:-300}"
STOP_AFTER="${STOP_AFTER:-}"

ROOT="$(pwd)"
ROCM="${ROCM:-/opt/rocm-7.2.4}"
LLVMBIN="$ROCM/lib/llvm/bin"
DEVICE_PASS="$ROOT/build-rocm/lib/device/DevicePass.so"
HOST_PASS="$ROOT/build-rocm/lib/host/HostPass.so"
TAG_PASS="$ROOT/build-rocm/lib/tag/TagPass.so"
MANIFEST="${MANIFEST:-$ROOT/scripts/buildScripts/sweep_hip.manifest}"
OUT_ROOT="${OUT_ROOT:-$ROOT/runs/amd_bench}"
PAPI_DIR="${PAPI_DIR:-$HOME/opt/papi}"
RT_SRC="$ROOT/lib/papi_rtlib"; RT_INC="$ROOT/lib/include"

for p in "$DEVICE_PASS" "$HOST_PASS"; do
    [ -f "$p" ] || { echo "ERROR: pass not built: $p" >&2; exit 2; }
done
[ -f "$MANIFEST" ] || { echo "ERROR: manifest not found: $MANIFEST" >&2; exit 2; }

# --- resolve benchmark from manifest: name | group | src | inc | args | expect
LINE=$(grep -v '^[[:space:]]*#' "$MANIFEST" | grep -v '^[[:space:]]*$' \
        | awk -F'|' -v n="$NAME" '{name=$1; gsub(/^[ \t]+|[ \t]+$/,"",name)} name==n {print; exit}')
[ -n "$LINE" ] || { echo "ERROR: '$NAME' not in $MANIFEST" >&2; exit 2; }
IFS='|' read -r F_NAME F_GROUP F_SRC F_INC F_ARGS F_EXPECT <<< "$LINE"
trim(){ echo "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'; }
GROUP=$(trim "$F_GROUP"); SRC=$(trim "$F_SRC"); INC=$(trim "$F_INC")
ARGS=$(trim "$F_ARGS");   EXPECT=$(trim "$F_EXPECT")
[ "$INC" = "-" ] && INC=""; [ "$ARGS" = "-" ] && ARGS=""; [ "$EXPECT" = "-" ] && EXPECT=""
[ -f "$ROOT/$SRC" ] || [ -f "$SRC" ] || { echo "ERROR: src not found: $SRC" >&2; exit 2; }
[ -f "$ROOT/$SRC" ] && SRC="$ROOT/$SRC"
INCFLAG=""; [ -n "$INC" ] && INCFLAG="-I$ROOT/$INC"

case "$FP_MODE" in
    ieee) FP_FLAGS="" ;;
    # AMD Fast posture: bare -ffast-math (see the fast) case below).
    # amdgcn: -ffast-math already implies FTZ/DAZ (selects oclc_daz_opt_on).
    # The NVIDIA runner spells the f32 denormal knob as a driver flag; on the
    # ROCm clang it must be -Xclang, so rather than special-case it we drop it.
    # Bare -ffast-math is the cleaner cross-vendor "fast" axis and gives the same
    # FTZ posture on this target.
    fast) FP_FLAGS="-ffast-math" ;;
esac

S="$OUT_ROOT/$NAME/O$OPT_LEVEL-$FP_MODE-tag$TAGGED-$MODE"
RTDIR="$OUT_ROOT/_rt"
rm -rf "$S"; mkdir -p "$S" "$RTDIR"

echo "=== $NAME [$MODE]  group=$GROUP  gfx=$GFX  O$OPT_LEVEL  fp=$FP_MODE  tag=$TAGGED"
echo "    src=$SRC  inc=${INC:-none}  args=${ARGS:-none}  expect=${EXPECT:-?}"
echo "    out=$S"
checkpoint(){ if [ "$STOP_AFTER" = "$1" ]; then echo ">>> STOP_AFTER=$1"; exit 0; fi; }

# --- runtime objects (no hipify; -D__HIP_PLATFORM_AMD__=1; from the basictest fix)
if [ ! -f "$RTDIR/fp_sde_driver.o" ] || [ "$RT_SRC/fp_sde_driver.cu" -nt "$RTDIR/fp_sde_driver.o" ]; then
    echo "--- runtime objects"
    g++ -fPIC -c "$RT_SRC/fp_sde_counters.cpp" -o "$RTDIR/fp_sde_counters.o" \
        -I"$PAPI_DIR/include" -I"$RT_INC" -I"$RT_SRC"
    "$LLVMBIN/clang++" -x hip --cuda-host-only --offload-arch=$GFX \
        -D__HIP_PLATFORM_AMD__=1 -fPIC -c "$RT_SRC/fp_sde_driver.cu" \
        -o "$RTDIR/fp_sde_driver.o" -I"$ROCM/include" -I"$PAPI_DIR/include" \
        -I"$RT_INC" -I"$RT_SRC"
fi

# =============================================================================
# DEVICE PIPELINE (verbatim from run_hip_basictest.sh)
# =============================================================================
echo "--- device: emit IR + DevicePass"
TAG_FLAG=""
if [ "$TAGGED" -eq 1 ] && [ "$INSTRUMENT" -eq 1 ]; then
    [ -f "$TAG_PASS" ] || { echo "ERROR: TAGGED=1 but $TAG_PASS missing" >&2; exit 2; }
    TAG_FLAG="-fpass-plugin=$TAG_PASS"
fi

"$LLVMBIN/clang++" -x hip --cuda-device-only --offload-arch=$GFX \
    -O$OPT_LEVEL -g -w $FP_FLAGS $INCFLAG $TAG_FLAG \
    ${FP_EXTRA:-} --no-gpu-bundle-output -emit-llvm -c "$SRC" -o "$S/device.bc"

OCML_LEFT=$("$LLVMBIN/llvm-nm" --defined-only "$S/device.bc" 2>/dev/null | grep -cE '__ocml|__ockl' || true)
echo "    ocml/ockl funcs present: ${OCML_LEFT:-0}"

if [ "$INSTRUMENT" -eq 1 ]; then
    "$LLVMBIN/opt" -load-pass-plugin="$DEVICE_PASS" -passes="fp-exception" \
        -fp-sites-csv="$S/fp_sites.csv" ${PASS_FLAGS:-} \
        "$S/device.bc" -o "$S/instr_device.bc" 2> "$S/instrument_device.log"
    DEVBC="$S/instr_device.bc"
    SUMMARY=$(grep -E "SUMMARY" "$S/instrument_device.log" || true)
    [ -n "$SUMMARY" ] && echo "    $SUMMARY"
else
    DEVBC="$S/device.bc"
fi
checkpoint devpass

echo "--- device: lower + bundle"
"$LLVMBIN/clang++" -x ir -O2 --target=amdgcn-amd-amdhsa -mcpu=$GFX "$DEVBC" -o "$S/device.hsaco"
checkpoint lower
"$LLVMBIN/clang-offload-bundler" -type=o \
    -targets=host-x86_64-unknown-linux-gnu,hipv4-amdgcn-amd-amdhsa--$GFX \
    -input=/dev/null -input="$S/device.hsaco" -output="$S/device.hipfb"
checkpoint bundle

echo "--- host: emit + HostPass"
"$LLVMBIN/clang++" -x hip --cuda-host-only --offload-arch=$GFX \
    -O$OPT_LEVEL -w $FP_FLAGS $INCFLAG -emit-llvm \
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

echo "--- link"
if [ "$INSTRUMENT" -eq 1 ]; then
    "$LLVMBIN/clang++" "$S/host.o" "$RTDIR/fp_sde_counters.o" "$RTDIR/fp_sde_driver.o" \
        -o "$S/app" -L"$ROCM/lib" -lamdhip64 -L"$PAPI_DIR/lib" -lpapi -lsde \
        -Wl,-rpath,"$ROCM/lib" -Wl,-rpath,"$PAPI_DIR/lib"
else
    "$LLVMBIN/clang++" "$S/host.o" -o "$S/app" -L"$ROCM/lib" -lamdhip64 -Wl,-rpath,"$ROCM/lib"
fi
checkpoint link

# =============================================================================
# RUN — RUNS timed repetitions, from the per-run dir (fp_*_counts.csv are
# cwd-relative with no override). First run captures counts; all runs timed.
# =============================================================================
echo "--- run ($RUNS reps)"
TIMES=()
for r in $(seq 1 "$RUNS"); do
    RUNLOG="$S/run.$r.log"
    T0=$(date +%s.%N)
    (
        cd "$S"
        FP_DEBUG=1 FP_SITES_CSV="$S/fp_sites.csv" timeout "$TIMEOUT" ./app $ARGS > "$RUNLOG" 2>&1
    ) || { echo "    RUN $r FAILED (rc=$?) — see $RUNLOG"; exit 1; }
    T1=$(date +%s.%N)
    TIMES+=("$(echo "$T1 - $T0" | bc)")
done
set +e

# Timing: min of RUNS (least-perturbed sample), plus all samples for the harness.
printf '%s\n' "${TIMES[@]}" > "$S/timing.raw"
TMIN=$(printf '%s\n' "${TIMES[@]}" | sort -g | head -1)
echo "    times: ${TIMES[*]}  -> min ${TMIN}s"
echo "$NAME,$MODE,O$OPT_LEVEL,$FP_MODE,tag$TAGGED,$TMIN" > "$S/timing.csv"

# Counts from the first run's log.
if [ "$INSTRUMENT" -eq 1 ]; then
    BLK=$(awk '/\[FP_INSTRUMENT\] Summary for:/{f=1} f{print} /\[FP_INSTRUMENT\] Finalized\./{f=0}' "$S/run.1.log")
    getc(){ printf '%s\n' "$BLK" | grep -E "^[[:space:]]*$1" | head -1 | awk '{print $NF}'; }
    INV=$(getc 'Invalid Ops:');        INV=${INV:-0}
    DIV=$(getc 'Div by Zero:');        DIV=${DIV:-0}
    OVF=$(getc 'Overflow:');           OVF=${OVF:-0}
    UNF=$(getc 'Underflow:');          UNF=${UNF:-0}
    SUB=$(getc 'Denormals Produced:'); SUB=${SUB:-0}
    echo "invalid=$INV divzero=$DIV overflow=$OVF underflow=$UNF subnormal=$SUB" > "$S/counts.txt"
    echo "    counts: invalid=$INV divzero=$DIV overflow=$OVF underflow=$UNF subnormal=$SUB"
    for f in fp_site_counts.csv fp_result_counts.csv; do
        [ -f "$S/$f" ] && echo "    $f: $(wc -l < "$S/$f") lines"
    done
    if [ -n "$EXPECT" ]; then
        declare -A C=( [invalid]=$INV [divzero]=$DIV [overflow]=$OVF [underflow]=$UNF )
        if [ "${C[$EXPECT]:-0}" -ne 0 ]; then echo "    EXPECT[$EXPECT]: PASS (${C[$EXPECT]})"
        else echo "    EXPECT[$EXPECT]: (zero — verify against CUDA)"; fi
    fi
fi
echo "=== done: $NAME [$MODE]"
