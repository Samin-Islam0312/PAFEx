#!/bin/bash
# =============================================================================
# run_single_tu.sh — build + run ONE single-translation-unit benchmark through
# the PaFEx LLVM-IR FP-exception instrumentation pipeline.
#
# This is the *build primitive*. It builds and runs exactly one benchmark in
# exactly one configuration, writes all intermediates to a scratch dir (never
# the repo root), parses the counter summary, and emits one timing sample. The
# result harness (separate script) calls this per configuration.
#
# WHY a clean-slate rewrite: the old per-benchmark scripts (build.sh lineage)
# carried two correctness bugs — a missing pre-instrumentation normalization
# step, and an `opt -O2` *after* instrumentation that is free to move/merge the
# atomic counter increments away from the FP ops they count. This script
# encodes the corrected pipeline (buildmyocyte.sh lineage) as the single source
# of truth, parameterized so there is exactly one pipeline to maintain.
#
# CHANGES vs the previous revision of this script:
#   - `staged` mode REMOVED: CTA shared-memory staging was deleted from the
#     DevicePass (it never beat plain per-thread atomics). `unstaged` is kept
#     as an accepted alias of `instrumented` for harness compatibility.
#   - OPT_LEVEL env (0..3): the clang -O level for BOTH device and host
#     frontend steps, for the optimization-flag observation study.
#   - FP_MODE env (ieee|fast): NVIDIA whitepaper IEEE vs Fast mode axis.
#   - fp_sites.csv is written INTO the scratch dir via -fp-sites-csv, and the
#     runtime is pointed at it via FP_SITES_CSV; the runtime-written CSVs are
#     moved into OUTDIR after the run. Nothing lands in the repo root anymore,
#     and configurations can no longer clobber each other's site tables.
#   - runtime objects get -I lib/include (fp_abi.h) and are rebuilt when the
#     runtime sources/headers change, not only when missing.
#
# USAGE:
#   ./run_single_tu.sh <name> [mode]
#     <name>  : key in the manifest (MANIFEST env var, default ./benchmarks.manifest)
#     [mode]  : instrumented (default; alias: unstaged) | baseline
#
#   Env overrides:
#     MANIFEST=path        manifest file (default ./benchmarks.manifest)
#     OUTDIR=path          where to drop run.log/counts/timing (default scratch dir)
#     RUNS=N               timed repetitions of the run (default 3)
#     OPT_LEVEL=0|1|2|3    clang -O level (default 0, the validated baseline config)
#     FP_MODE=ieee|fast    FP compliance mode (default ieee)
#     PASS_FLAGS="..."     extra DevicePass flags (e.g. -fp-verbose, -result-class,
#                          -count-total=false)
#     TIMEOUT=secs         per-run timeout (default 120)
#
# ASSUMES: invoked from the repo root (~/SBAC-PAD-opt), same as the old scripts.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# 0. Arguments
# -----------------------------------------------------------------------------
NAME="${1:?usage: run_single_tu.sh <name> [instrumented|baseline]}"
MODE="${2:-instrumented}"

case "$MODE" in
    unstaged) MODE="instrumented" ;;   # legacy alias from the staging era
    instrumented|baseline) ;;
    staged)
        echo "ERROR: 'staged' mode no longer exists — CTA shared-memory staging" >&2
        echo "       was removed from the DevicePass (it never beat per-thread" >&2
        echo "       atomics). Update the harness to call baseline+instrumented." >&2
        exit 2 ;;
    *) echo "ERROR: mode must be instrumented|baseline, got '$MODE'" >&2; exit 2 ;;
esac

INSTRUMENT=1
[ "$MODE" = "baseline" ] && INSTRUMENT=0

# --- configuration axes ---
OPT_LEVEL=${OPT_LEVEL:-0}
case "$OPT_LEVEL" in 0|1|2|3) ;; *) echo "ERROR: OPT_LEVEL must be 0..3" >&2; exit 2 ;; esac

FP_MODE=${FP_MODE:-ieee}
case "$FP_MODE" in ieee|fast) ;; *) echo "ERROR: FP_MODE must be ieee|fast" >&2; exit 2 ;; esac

# Fast mode = NVIDIA's --use_fast_math posture, expressed in clang flags:
#   -ffast-math                          fast-math instruction flags (afn/arcp/...)
#                                        -> NVPTX lowers fdiv/sqrt to .approx forms
#   -fdenormal-fp-math-f32=preserve-sign FTZ for f32 (sets the function attr the
#                                        NVPTX backend and the libdevice
#                                        __nvvm_reflect(__CUDA_FTZ) resolution key on)
# NOTE: the legacy spelling -fcuda-flush-denormals-to-zero was REMOVED from
# clang; on LLVM 22 it is a hard driver error. Do not reintroduce it.
FAST_FLAGS=""
[ "$FP_MODE" = "fast" ] && FAST_FLAGS="-ffast-math -fdenormal-fp-math-f32=preserve-sign"

# -----------------------------------------------------------------------------
# 1. Environment (mirrors the existing per-benchmark scripts exactly)
# -----------------------------------------------------------------------------
module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}                  # "sm_80" -> "80" for fatbinary/ptxas

export LLVM_DIR=$HOME/opt/llvm-22
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname "$(dirname "$(realpath "$(which nvcc)")")")
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

ROOT=$(pwd)
MANIFEST=${MANIFEST:-$ROOT/benchmarks.manifest}
RUNS=${RUNS:-3}

DEVICE_PASS=$ROOT/build/lib/device/DevicePass.so
HOST_PASS=$ROOT/build/lib/host/HostPass.so

# libdevice carries __nv_* math (sqrt, exp, ...). We must link it into the
# device module before instrumenting so those symbols resolve; --only-needed
# (later) keeps us from dragging in the whole library. In FP_MODE=fast this
# ordering also resolves the __nv_fast_* references -ffast-math introduces.
LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
[ -f "$LIBDEVICE" ] || LIBDEVICE=$(find "$CUDA_HOME" -name "libdevice*.bc" 2>/dev/null | head -1)

# -----------------------------------------------------------------------------
# 2. Resolve the benchmark from the manifest
#    Format (pipe-delimited, '#' comments, '-' = empty field):
#      name | group | src | inc | args | expect
# -----------------------------------------------------------------------------
[ -f "$MANIFEST" ] || { echo "ERROR: manifest not found: $MANIFEST" >&2; exit 2; }

LINE=$(grep -v '^[[:space:]]*#' "$MANIFEST" | grep -v '^[[:space:]]*$' \
        | awk -F'|' -v n="$NAME" '{name=$1; gsub(/^[ \t]+|[ \t]+$/,"",name)} name==n {print; exit}')
[ -n "$LINE" ] || { echo "ERROR: '$NAME' not found in $MANIFEST" >&2; exit 2; }

# Split + trim each field.
IFS='|' read -r F_NAME F_GROUP F_SRC F_INC F_ARGS F_EXPECT <<< "$LINE"
trim() { echo "$1" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'; }
SRC=$(trim "$F_SRC")
INC=$(trim "$F_INC")
ARGS=$(trim "$F_ARGS")
EXPECT=$(trim "$F_EXPECT")
GROUP=$(trim "$F_GROUP")

[ -f "$ROOT/$SRC" ] || [ -f "$SRC" ] || { echo "ERROR: src not found: $SRC" >&2; exit 2; }
[ "$INC"    = "-" ] && INC=""
[ "$ARGS"   = "-" ] && ARGS=""
[ "$EXPECT" = "-" ] && EXPECT=""

INCFLAG=""
[ -n "$INC" ] && INCFLAG="-I$INC"        # single include dir; benchmarks need at most one

# -----------------------------------------------------------------------------
# 3. Scratch / output layout (NOT the repo root — the whole point of this rewrite)
#    The default configuration (O0, ieee) keeps the historical path
#    scratch/<name>/<mode> so the existing harness keeps working; non-default
#    axes get an explicit suffix so the O-level x FP-mode matrix can't collide.
# -----------------------------------------------------------------------------
CFG_SUFFIX=""
[ "$OPT_LEVEL" != "0" ]   && CFG_SUFFIX="${CFG_SUFFIX}_O${OPT_LEVEL}"
[ "$FP_MODE" != "ieee" ]  && CFG_SUFFIX="${CFG_SUFFIX}_${FP_MODE}"

SCRATCH=$ROOT/scratch/$NAME/${MODE}${CFG_SUFFIX}   # all .bc/.ptx/.cubin/.fatbin/.o live here
RTDIR=$ROOT/scratch/_rt                  # shared runtime objects, built once
OUTDIR=${OUTDIR:-$SCRATCH}               # harness can redirect logs/timings elsewhere
mkdir -p "$SCRATCH" "$RTDIR" "$OUTDIR"

S="$SCRATCH"                             # shorthand for the intermediate paths below

echo "=== $NAME [$MODE]  (group=$GROUP, O$OPT_LEVEL, $FP_MODE)"
echo "    src=$SRC  inc=${INC:-none}  args=${ARGS:-none}  expect=${EXPECT:-none}"
echo "    scratch=$S"
echo "    libdevice=$LIBDEVICE"

# -----------------------------------------------------------------------------
# 4. Build the passes once (only if missing). Kept in build/ so they persist.
# -----------------------------------------------------------------------------
if [ ! -f "$DEVICE_PASS" ] || [ ! -f "$HOST_PASS" ]; then
    echo "--- building passes (not found)"
    mkdir -p "$ROOT/build"
    ( cd "$ROOT/build"
      cmake -DCMAKE_C_COMPILER=$LLVM_DIR/bin/clang \
            -DCMAKE_CXX_COMPILER=$LLVM_DIR/bin/clang++ \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm .. >/dev/null
      make -j )
fi

# -----------------------------------------------------------------------------
# 5. Build the PAPI/SDE runtime objects. Rebuilt when missing OR older than
#    their sources/headers (fp_abi.h carries the array sizes — a stale driver
#    object with old sizes is exactly the truncation/overflow bug class).
#    The runtime does NOT depend on the pass, so it links fine even in
#    baseline (just stays unused).
# -----------------------------------------------------------------------------
RT_SRC=$ROOT/lib/papi_rtlib
RT_INC=$ROOT/lib/include                 # fp_abi.h lives here
need_rt_build=0
for o in "$RTDIR/fp_sde_counters.o" "$RTDIR/fp_sde_driver.o"; do
    [ -f "$o" ] || need_rt_build=1
done
for src in "$RT_SRC/fp_sde_counters.cpp" "$RT_SRC/fp_sde_driver.cu" \
           "$RT_SRC/fp_sde.h" "$RT_INC/fp_abi.h"; do
    [ "$src" -nt "$RTDIR/fp_sde_driver.o" ] 2>/dev/null && need_rt_build=1
done
if [ "$need_rt_build" -eq 1 ]; then
    echo "--- building runtime objects"
    g++  -fPIC -c "$RT_SRC/fp_sde_counters.cpp" \
         -o "$RTDIR/fp_sde_counters.o" -I"$PAPI_DIR/include" -I"$RT_INC"
    nvcc -Xcompiler -fPIC -c "$RT_SRC/fp_sde_driver.cu" \
         -o "$RTDIR/fp_sde_driver.o"  -I"$PAPI_DIR/include" -I"$RT_INC"
fi

# =============================================================================
# 6. DEVICE PIPELINE
# =============================================================================
echo "--- device pipeline"

# (1) Emit device bitcode at -O$OPT_LEVEL WITH -g.
#     At O0 (the validated default) the optimizer hasn't unrolled/vectorized/
#     hoisted FP ops, so !dbg-based source attribution is exact. At O1..O3 the
#     site counts and locations legitimately shift with the optimizer's
#     transformations — that movement is the OBSERVATION of the O-level study,
#     not an error. Expect some sites to lose locations at higher O; the pass
#     reports how many.
$LLVM_DIR/bin/clang++ -O$OPT_LEVEL -g -w -emit-llvm --cuda-device-only \
    $FAST_FLAGS \
    -x cuda "$SRC" $INCFLAG --cuda-gpu-arch=$GPU_ARCH -c -o "$S/device.bc"

# (2) Link libdevice so __nv_* math resolves. --only-needed pulls in just the
#     libdevice functions the kernel actually references, not the whole library.
$LLVM_DIR/bin/llvm-link --only-needed "$S/device.bc" "$LIBDEVICE" -o "$S/device_linked.bc"

# (3) PREOPT — mandatory normalization, the single most important fix vs the old
#     build.sh. Three sub-passes, each for a concrete reason:
#       always-inline : at -O0 clang does NOT inline __device__ helpers; they
#                        survive as linkonce_odr functions and the FP ops inside
#                        them sit behind a `call` the device pass can't see (or
#                        attributes to the call site, not the real op). Forcing
#                        the inline puts those FP ops directly in the kernel body
#                        at their true source location.
#       mem2reg       : at -O0 scalar FP values are alloca/load/store; the fadd/
#                        fmul/fdiv we want to instrument hide behind loads.
#                        Promoting to SSA surfaces the FP instructions where the
#                        pass's opcode matching can reach them.
#       instcombine   : canonicalizes the -O0 IR (kills redundant casts/identity
#                        ops) so the pass sees conventional forms, not -O0 noise.
#     At OPT_LEVEL>0 these are effectively no-ops (clang already did them) and
#     are kept unconditionally so every configuration runs the SAME pipeline.
#     (If preopt ever appears to do nothing at -O0, the cause is clang's
#     optnone attribute — add `-Xclang -disable-O0-optnone` to step (1).)
$LLVM_DIR/bin/opt -passes="always-inline,function(mem2reg,instcombine)" \
    "$S/device_linked.bc" -o "$S/device_preopt.bc"

if [ "$INSTRUMENT" -eq 1 ]; then
    # (4) Instrument. The site table is written into the scratch dir so the
    #     O-level x FP-mode matrix can't clobber tables across configurations,
    #     and so build/run pairing (the CSV discipline) is per-config automatic.
    $LLVM_DIR/bin/opt -load-pass-plugin="$DEVICE_PASS" \
        -passes="fp-exception" \
        -fp-sites-csv="$S/fp_sites.csv" ${PASS_FLAGS:-} \
        "$S/device_preopt.bc" -o "$S/instrumented_device.bc" 2> "$S/instrument_device.log"
    DEVBC="$S/instrumented_device.bc"
else
    # baseline: skip the pass entirely, carry the normalized-but-uninstrumented IR.
    DEVBC="$S/device_preopt.bc"
fi

# (5) Lower to PTX. CRITICAL: go straight from the (possibly instrumented) IR to
#     llc — do NOT run `opt -O2` here. llc -O2 is *code generation* (register
#     allocation / scheduling), which is safe; an IR-level -O2 would be free to
#     hoist, sink, merge or eliminate the atomic increments relative to the FP
#     ops they count, silently corrupting the counts.
#     In FP_MODE=fast no extra llc flags are needed: the fast-math instruction
#     flags and the f32 denormal function attribute set in step (1) are what
#     drive the NVPTX backend's .approx / .ftz selection.
$LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH "$DEVBC" -o "$S/instrumented.ptx"
ptxas --gpu-name $GPU_ARCH "$S/instrumented.ptx" -o "$S/instrumented.cubin"
fatbinary --64 --create "$S/instrumented.fatbin" \
    --image3=kind=elf,sm=$GPU_SM,file="$S/instrumented.cubin"

# =============================================================================
# 7. HOST PIPELINE
# =============================================================================
echo "--- host pipeline"

# (6) Emit host bitcode at -O$OPT_LEVEL with the device fatbin embedded.
#     (Host FP mode is irrelevant to the device measurements; FAST_FLAGS are
#     device-side only, so the host step doesn't take them.)
$LLVM_DIR/bin/clang++ -O$OPT_LEVEL -w -emit-llvm --cuda-host-only \
    -Xclang -fcuda-include-gpubinary -Xclang "$S/instrumented.fatbin" \
    -x cuda "$SRC" $INCFLAG -c -o "$S/host.bc"

if [ "$INSTRUMENT" -eq 1 ]; then
    # (7) Host pass: emits the host shadow counters, __cudaRegisterVar bindings,
    #     accessors, and the PAPI/SDE lifecycle + readback hooks.
    $LLVM_DIR/bin/opt -load-pass-plugin="$HOST_PASS" \
        -passes="fp-host-instrument" "$S/host.bc" -o "$S/instrumented_host.bc" 2> "$S/instrument_host.log"
    HOSTBC="$S/instrumented_host.bc"
else
    HOSTBC="$S/host.bc"
fi

# (8) Compile host IR to an object at -O1. NOT -O2: same reordering concern as
#     the device side, milder but not worth risking. -O1 codegen won't move the
#     inserted loads/stores/calls in ways that matter; -O0 also fine.
$LLVM_DIR/bin/clang++ -O1 -c "$HOSTBC" -o "$S/host.o"

# Disassemble instrumented IR to .ll for inspection / paper figures (cheap).
if [ "$INSTRUMENT" -eq 1 ]; then
    $LLVM_DIR/bin/llvm-dis "$S/instrumented_device.bc" -o "$S/instrumented_device.ll" 2>/dev/null || true
    $LLVM_DIR/bin/llvm-dis "$S/instrumented_host.bc"   -o "$S/instrumented_host.ll"   2>/dev/null || true
fi

# =============================================================================
# 8. LINK
# =============================================================================
echo "--- link"
if [ "$INSTRUMENT" -eq 1 ]; then
    clang++ "$S/host.o" "$RTDIR/fp_sde_counters.o" "$RTDIR/fp_sde_driver.o" \
        -o "$S/instrumented_app" \
        -L"$CUDA_HOME/lib64" -lcudart \
        -L"$PAPI_DIR/lib" -lpapi -lsde \
        -Wl,-rpath,"$CUDA_HOME/lib64" -Wl,-rpath,"$PAPI_DIR/lib"
else
    # baseline: native app only. The SDE runtime objects reference symbols the
    # host pass emits (fp_reset_counters / fp_read_counters /
    # fp_read_site_counters), so they cannot be linked without instrumentation.
    clang++ "$S/host.o" \
        -o "$S/instrumented_app" \
        -L"$CUDA_HOME/lib64" -lcudart \
        -Wl,-rpath,"$CUDA_HOME/lib64"
fi

# -----------------------------------------------------------------------------
# 9. Sanity checks (only meaningful when instrumented)
# -----------------------------------------------------------------------------
if [ "$INSTRUMENT" -eq 1 ]; then
    echo -n "    device counter symbol in cubin: "
    cuobjdump --dump-elf-symbols "$S/instrumented.cubin" | grep -i "fp_counters" >/dev/null \
        && echo "present" || echo "MISSING — readback will fail"
    echo "    atomicrmw sites in instrumented device IR: $(grep -c 'atomicrmw' "$S/instrumented_device.ll" 2>/dev/null || echo '?')"
fi

# =============================================================================
# 10. RUN (timed, $RUNS repetitions) and capture the counter summary
# =============================================================================
echo "--- run x$RUNS"
RUNLOG="$OUTDIR/run.log"
TIMING="$OUTDIR/timing_${MODE}${CFG_SUFFIX}.txt"
: > "$TIMING"

# ARGS expands UNQUOTED on purpose: "100 0.5 502 458" must become four argv
# words, not one. This is the one place word-splitting is intended.
set +e
best=""
for i in $(seq 1 "$RUNS"); do
    start=$(date +%s.%N)
    FP_DEBUG=1 FP_SITES_CSV="$S/fp_sites.csv" \
        timeout "${TIMEOUT:-120}" "$S/instrumented_app" $ARGS > "$RUNLOG" 2>&1
    rc=$?
    end=$(date +%s.%N)
    elapsed=$(awk -v a="$start" -v b="$end" 'BEGIN{printf "%.4f", b-a}')
    echo "run $i: ${elapsed}s rc=$rc" >> "$TIMING"
    # keep the fastest (least noisy) wall time
    if [ -z "$best" ] || awk -v e="$elapsed" -v b="$best" 'BEGIN{exit !(e<b)}'; then best="$elapsed"; fi
done
echo "best: ${best}s" >> "$TIMING"
set -e

# The driver writes its per-site / result-class CSVs to the CWD (repo root,
# since the app is invoked from here). Move them next to the rest of this
# configuration's outputs so configs can't clobber each other.
for f in fp_site_counts.csv fp_result_counts.csv; do
    [ -f "$ROOT/$f" ] && mv -f "$ROOT/$f" "$OUTDIR/$f"
done

echo "    wall (best of $RUNS): ${best}s   -> $TIMING"

# Parse the PAPI summary. Scope to the authoritative summary block (between
# "Summary for:" and "Finalized.") so a benchmark's own stdout — e.g. a test
# that prints its own "Underflow: ..." self-check line — can't be mistaken for
# the real counter. Within the block each label appears exactly once.
SUMMARY_BLOCK=$(awk '/\[FP_INSTRUMENT\] Summary for:/{f=1} f{print} /\[FP_INSTRUMENT\] Finalized\./{f=0}' "$RUNLOG")
getc() { printf '%s\n' "$SUMMARY_BLOCK" | grep -E "^[[:space:]]*$1" | head -1 | awk '{print $NF}'; }
INVALID=$(getc "Invalid Ops:");      INVALID=${INVALID:-0}
DIVZERO=$(getc "Div by Zero:");      DIVZERO=${DIVZERO:-0}
OVERFLOW=$(getc "Overflow:");        OVERFLOW=${OVERFLOW:-0}
UNDERFLOW=$(getc "Underflow:");      UNDERFLOW=${UNDERFLOW:-0}
TOTAL=$(getc "Total FP Ops:");       TOTAL=${TOTAL:-0}
SUBNORMAL=$(getc "Denormals Produced:"); SUBNORMAL=${SUBNORMAL:-0}
KLAUNCH=$(getc "Kernels Launched:"); KLAUNCH=${KLAUNCH:-0}

COUNTS="$OUTDIR/counts_${MODE}${CFG_SUFFIX}.txt"
{
    echo "invalid=$INVALID divzero=$DIVZERO overflow=$OVERFLOW underflow=$UNDERFLOW total=$TOTAL subnormal=$SUBNORMAL kernels=$KLAUNCH"
} > "$COUNTS"

if [ "$INSTRUMENT" -eq 1 ]; then
    echo "    counts: invalid=$INVALID divzero=$DIVZERO overflow=$OVERFLOW underflow=$UNDERFLOW total=$TOTAL subnormal=$SUBNORMAL kernels=$KLAUNCH"
else
    echo "    baseline (no counters)"
fi

# -----------------------------------------------------------------------------
# 11. Ground-truth assertion for basic_tests (expect = one of the 4 classes).
#     A basic test must fire its named class and NO other class. subnormal is
#     NOT one of the four classes — it is the expected companion of underflow
#     (gradual underflow produces a denormal) — so it is never treated as a leak.
# -----------------------------------------------------------------------------
if [ "$INSTRUMENT" -eq 1 ] && [ -n "$EXPECT" ]; then
    declare -A C=( [invalid]=$INVALID [divzero]=$DIVZERO [overflow]=$OVERFLOW [underflow]=$UNDERFLOW )
    want=${C[$EXPECT]:-0}
    leaks=""
    for k in invalid divzero overflow underflow; do
        [ "$k" = "$EXPECT" ] && continue
        [ "${C[$k]}" -ne 0 ] && leaks="$leaks $k=${C[$k]}"
    done
    if [ "$want" -eq 0 ]; then
        echo "    EXPECT: FAIL — expected '$EXPECT' but it is zero (test fired nothing)"
    elif [ -n "$leaks" ]; then
        echo "    EXPECT: WARN — '$EXPECT'=$want present, but cross-class:$leaks (inspect $SRC)"
    else
        echo "    EXPECT: PASS — only '$EXPECT'=$want fired"
    fi
fi

echo "=== done: $NAME [$MODE${CFG_SUFFIX}]"