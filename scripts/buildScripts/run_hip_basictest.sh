#!/bin/bash
# =============================================================================
# run_hip_basictest.sh  —  PaFEx HIP instrumentation pipeline, ONE basic-test.
#
# PIPELINE (see CHANGES below for why this differs from the previous version):
#   clang++ -x hip --cuda-device-only -O$N [-fpass-plugin=TagPass]  -> device.bc
#   opt -load-pass-plugin=DevicePass -passes=fp-exception           -> instr.bc
#   clang++ -x ir --target=amdgcn-amd-amdhsa -mcpu=$GFX             -> .hsaco
#   clang-offload-bundler                                            -> .hipfb
#   clang++ -x hip --cuda-host-only -fcuda-include-gpubinary        -> host.bc
#   opt -load-pass-plugin=HostPass -passes=fp-host-instrument       -> instr_host.bc
#   link  -lamdhip64 -lpapi -lsde ; run with cwd = per-run output dir
#
# LIBRARY-INTERNAL FILTERING (replaces this script's previous rationale):
#   The old header argued for adding cgscc(inline) to the AMD preopt so OCML
#   folds into kernels "for CUDA parity", on the theory that instrumenting
#   library-internal arithmetic is the desired coverage. That is exactly
#   backwards and was disproved on myocyte: forcing OCML inlining added ~6,905
#   spurious ops at -O1 and REVERSED the sign of the optimization-level trend
#   (a monotonic 4.5x "rise" that was 72-76% exp() polynomial, masking a true
#   curve that dips at -O1 then rises through -O3).
#
#   Parity comes from FILTERING library internals on both vendors, not from
#   inlining them on both. Two regimes, two mechanisms:
#     - not-yet-inlined: DevicePass's isLibraryInternal callee-NAME filter
#     - already-inlined: !pafex.libinternal METADATA stamped by TagPass at
#       PipelineStartEP (before any inliner runs). Names die under inlining;
#       metadata survives. file:line cannot separate them either -- prebuilt
#       ocml.bc ships with no debug info, so inlined instructions inherit the
#       CALL SITE's DILocation.
#   TAGGED=0 disables the tag plugin: no tags exist, the metadata check never
#   fires, behavior is byte-identical to the untagged build. That is the A/B
#   control and it is what keeps the published SBAC-PAD numbers reproducible.
#
# USAGE:
#   ./run_hip_basictest.sh <name|class/name> [instrumented|baseline]
#
# ENV:
#   OPT_LEVEL=0..3      (default 0)   -O level, applied at the CLANG step only
#   FP_MODE=ieee|fast   (default ieee)
#   TAGGED=0|1          (default 1)   run TagPass in-clang; 0 = A/B control
#   GFX=gfx942
#   OUT_ROOT=<dir>      (default $ROOT/runs/amd)
#   STOP_AFTER=devpass|lower|bundle|hostpass|link
#   PASS_FLAGS="..."    extra flags forwarded to DevicePass
#   LEGACY_PREOPT=1     reproduce the OLD pipeline (llvm-link + opt preopt) for
#                       A/B against previously-recorded numbers. See CHANGES.
#
# CHANGES vs the previous version (each one is a correction to a recorded bug):
#   1. cwd. The app is now run FROM its per-run output dir. fp_site_counts.csv
#      and fp_result_counts.csv are hardcoded relative to cwd in the driver with
#      NO env override (only fp_sites.csv has -fp-sites-csv=/FP_SITES_CSV). The
#      old script ran the app from the repo root, so every test shared one pair
#      of count files -> a stale compile-time site table joined against fresh
#      runtime counts -> a plausible, wrong report.
#   2. -DOCML_BASIC_ROUNDED_OPERATIONS, scoped to the rounding tests only. See
#      the EXTRA_DEFS block.
#   3. No llvm-link of OCML. clang links the device libs via
#      -mlink-builtin-bitcode BEFORE the opt pipeline; device.bc already
#      contains `define internal ... @__ocml_*`. Verified on ROCm 7.2.4. The
#      manual link (and its `[if __ocml_ referenced]` gate) was redundant, and
#      it hardcoded oclc_daz_opt_off / oclc_finite_only_off / oclc_unsafe_math_off
#      -- pinning the very FP-mode knobs the IEEE-vs-Fast axis is supposed to
#      vary. Those are now selected by clang from FP_MODE.
#   4. No `opt` preopt. -O must be applied at the clang step, never at opt:
#      clang -O0 stamps `optnone noinline`, after which an opt-side inliner can
#      do nothing, so `always-inline,cgscc(inline),mem2reg,instcombine` was
#      measuring a pipeline nobody ships.
#   5. No hipify of fp_sde_driver.cu. It has a __HIP_PLATFORM_AMD__ shim and no
#      device code; it compiles as-is. The old path hipified it in place and
#      sent the compile to /dev/null, hiding failures.
#   6. Output root defaults to runs/, NOT scratch/. scratch/ holds SBAC-PAD
#      evaluation data and is frozen until the rebuttal closes 2026-07-27.
#
# WARNING -- RE-BASELINE REQUIRED:
#   Items 3 and 4 change the IR that DevicePass sees, most visibly at -O0 (no
#   more mem2reg/instcombine before instrumentation). Counts from this script
#   are NOT directly comparable to numbers recorded with the old one. Re-run any
#   AMD baseline you intend to cite. Use LEGACY_PREOPT=1 to reproduce the old
#   path if you need a controlled A/B.
# =============================================================================
set -euo pipefail

NAME="${1:?usage: run_hip_basictest.sh <name|class/name> [instrumented|baseline]}"
MODE="${2:-instrumented}"
OPT_LEVEL="${OPT_LEVEL:-0}"
FP_MODE="${FP_MODE:-ieee}"
TAGGED="${TAGGED:-1}"
GFX="${GFX:-gfx942}"
STOP_AFTER="${STOP_AFTER:-}"
LEGACY_PREOPT="${LEGACY_PREOPT:-0}"

INSTRUMENT=1; [ "$MODE" = baseline ] && INSTRUMENT=0

ROOT="$(pwd)"
ROCM="${ROCM:-/opt/rocm-7.2.4}"
LLVMBIN="$ROCM/lib/llvm/bin"
BCLIB="$ROCM/amdgcn/bitcode"
DEVICE_PASS="$ROOT/build-rocm/lib/device/DevicePass.so"
HOST_PASS="$ROOT/build-rocm/lib/host/HostPass.so"
TAG_PASS="$ROOT/build-rocm/lib/tag/TagPass.so"
BT_ROOT="$ROOT/tests/amd/basic_test"
OUT_ROOT="${OUT_ROOT:-$ROOT/runs/amd}"

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

# --- FIX 2: OCML_BASIC_ROUNDED_OPERATIONS, scoped ----------------------------
# HIP's __fadd_rz / __fmul_rd / __fmaf_ru / __dadd_rz etc. live behind this
# macro in __clang_hip_math.h. NOTHING in ROCm defines it (grep -r across
# $ROCM returns only the header itself) -- it is purely opt-in. Without it the
# identifiers do not exist and the rounding tests fail in the FRONT END:
#     error: use of undeclared identifier '__fadd_rz'; did you mean '__fadd_rn'?
# They never reach opt, never reach DevicePass.
#
# Scoped to the rounding tests deliberately. __fadd_rn / __fmul_rn / __fmaf_rn
# appear in BOTH arms of the #if: without the macro they are plain
# fadd/fmul/llvm.fma, with it they become calls to __ocml_*_rte_*. Defining it
# globally would change the representation of every nearest-mode op across the
# benchmarks for no benefit.
#
# Needed on BOTH clang lines -- --cuda-host-only still parses device bodies.
EXTRA_DEFS=""
case "$TESTID" in
    overflow/round_*|underflow/rounding)
        EXTRA_DEFS="-DOCML_BASIC_ROUNDED_OPERATIONS"
        ;;
esac

# --- FP mode -----------------------------------------------------------------
# clang selects the oclc_* control bitcodes from these; do not hand-link them.
case "$FP_MODE" in
    ieee) FP_FLAGS="" ;;
    fast) FP_FLAGS="-ffast-math" ;;
    *)    echo "ERROR: FP_MODE must be ieee|fast (got '$FP_MODE')" >&2; exit 2 ;;
esac

for p in "$DEVICE_PASS" "$HOST_PASS"; do
    [ -f "$p" ] || { echo "ERROR: pass not built: $p" >&2; exit 2; }
done
if [ "$TAGGED" -eq 1 ] && [ "$INSTRUMENT" -eq 1 ]; then
    [ -f "$TAG_PASS" ] || { echo "ERROR: TAGGED=1 but pass not built: $TAG_PASS" >&2; exit 2; }
fi

# --- FIX 1 + 6: per-run output dir, under runs/ not scratch/ ------------------
# EVERY axis is in the path. Two runs that differ in any axis must not share a
# directory, or the hardcoded fp_site_counts.csv / fp_result_counts.csv collide.
S="$OUT_ROOT/$TESTID/O$OPT_LEVEL-$FP_MODE-tag$TAGGED-$MODE"
RTDIR="$OUT_ROOT/_rt"
rm -rf "$S"; mkdir -p "$S" "$RTDIR"

RT_SRC="$ROOT/lib/papi_rtlib"; RT_INC="$ROOT/lib/include"
PAPI_DIR="${PAPI_DIR:-$HOME/opt/papi}"

echo "=== $TESTID [$MODE]  gfx=$GFX  O$OPT_LEVEL  fp=$FP_MODE  tag=$TAGGED  expect=${EXPECT:-?}"
echo "    out: $S"
[ -n "$EXTRA_DEFS" ] && echo "    defs: $EXTRA_DEFS"
[ "$LEGACY_PREOPT" -eq 1 ] && echo "    *** LEGACY_PREOPT=1: old pipeline, for A/B only ***"

checkpoint() { if [ "$STOP_AFTER" = "$1" ]; then echo ">>> STOP_AFTER=$1"; exit 0; fi; }

# --- FIX 5: runtime objects, no hipify, no /dev/null -------------------------
if [ ! -f "$RTDIR/fp_sde_driver.o" ] || [ "$RT_SRC/fp_sde_driver.cu" -nt "$RTDIR/fp_sde_driver.o" ]; then
    echo "--- runtime objects"
    g++ -fPIC -c "$RT_SRC/fp_sde_counters.cpp" -o "$RTDIR/fp_sde_counters.o" \
        -I"$PAPI_DIR/include" -I"$RT_INC" -I"$RT_SRC"
    # fp_sde_driver.cu has a runtime shim keyed on __HIP_PLATFORM_AMD__ /
    # __HIP_PLATFORM_NVIDIA__ and contains no device code.
    #   -x hip                    the .cu extension would otherwise mean CUDA
    #   -D__HIP_PLATFORM_AMD__=1  REQUIRED. hipcc injects this; plain clang++
    #                             does not, and without it the shim falls
    #                             through to #include <cuda_runtime.h> and dies
    #                             on a machine that has no CUDA.
    #   --cuda-host-only          no device code here; skip device codegen
    "$LLVMBIN/clang++" -x hip --cuda-host-only --offload-arch=$GFX \
        -D__HIP_PLATFORM_AMD__=1 -fPIC -c "$RT_SRC/fp_sde_driver.cu" \
        -o "$RTDIR/fp_sde_driver.o" -I"$ROCM/include" -I"$PAPI_DIR/include" \
        -I"$RT_INC" -I"$RT_SRC"
fi

# --- device front half -------------------------------------------------------
echo "--- device: emit IR + DevicePass"

TAG_FLAG=""
if [ "$TAGGED" -eq 1 ] && [ "$INSTRUMENT" -eq 1 ]; then
    # PipelineStartEP: runs before AlwaysInliner (-O0) and before the cost-based
    # inliner (-O1+), so library bodies are stamped while they still exist.
    TAG_FLAG="-fpass-plugin=$TAG_PASS"
fi

# FIX 3+4: -O at clang, device libs linked by clang, no opt preopt.
"$LLVMBIN/clang++" -x hip --cuda-device-only --offload-arch=$GFX \
    -O$OPT_LEVEL -g -w $FP_FLAGS $EXTRA_DEFS $TAG_FLAG \
    --no-gpu-bundle-output -emit-llvm -c "$SRC" -o "$S/device.bc"

DEVLINK="$S/device.bc"

if [ "$LEGACY_PREOPT" -eq 1 ]; then
    # Reproduce the old path verbatim for controlled A/B. Do not use for new
    # numbers: opt-side -O after clang -O0 is a pipeline nobody ships, and
    # cgscc(inline) forces the OCML contamination this project measures.
    if "$LLVMBIN/llvm-nm" "$S/device.bc" 2>/dev/null | grep -qE '__ocml_|__ockl_'; then
        "$LLVMBIN/llvm-link" "$S/device.bc" \
            "$BCLIB/ocml.bc" "$BCLIB/ockl.bc" \
            "$BCLIB/oclc_isa_version_942.bc" "$BCLIB/oclc_wavefrontsize64_on.bc" \
            "$BCLIB/oclc_daz_opt_off.bc" "$BCLIB/oclc_finite_only_off.bc" \
            "$BCLIB/oclc_correctly_rounded_sqrt_on.bc" "$BCLIB/oclc_unsafe_math_off.bc" \
            "$BCLIB/oclc_abi_version_600.bc" \
            -o "$S/device_linked.bc"
        DEVLINK="$S/device_linked.bc"
    fi
    "$LLVMBIN/opt" -passes="always-inline,cgscc(inline),function(mem2reg,instcombine)" \
        "$DEVLINK" -o "$S/device_preopt.bc"
    DEVLINK="$S/device_preopt.bc"
fi

# Diagnostic only. OCML functions surviving into the instrumented module is
# EXPECTED and correct -- they are filtered by name (not-yet-inlined) or by
# !pafex.libinternal (inlined). The directed-rounding wrappers
# (__ocml_{add,sub,mul,fma}_rt{e,n,p,z}_f{32,64}) additionally CANNOT be inlined
# at any -O: they carry `strictfp`, and LLVM will not inline a strictfp callee
# into a non-strictfp caller. That is what makes name-based rounding-mode
# detection sound. (-ffp-model=strict would make the kernel strictfp and break
# this; we do not use it.)
OCML_LEFT=$("$LLVMBIN/llvm-nm" --defined-only "$DEVLINK" 2>/dev/null | grep -cE '__ocml|__ockl' || true)
echo "    ocml/ockl funcs present: ${OCML_LEFT:-0}  (informational; filtering is by name+metadata)"

if [ "$INSTRUMENT" -eq 1 ]; then
    "$LLVMBIN/opt" -load-pass-plugin="$DEVICE_PASS" -passes="fp-exception" \
        -fp-sites-csv="$S/fp_sites.csv" ${PASS_FLAGS:-} \
        "$DEVLINK" -o "$S/instr_device.bc" 2> "$S/instrument_device.log"
    DEVBC="$S/instr_device.bc"
    "$LLVMBIN/llvm-dis" "$DEVBC" -o "$S/instr_device.ll"
    ARMW=$(grep -c atomicrmw "$S/instr_device.ll" || true)
    SITES=$(grep -E "SUMMARY" "$S/instrument_device.log" || true)
    echo "    atomicrmw sites: ${ARMW:-0}"
    [ -n "$SITES" ] && echo "    $SITES"
    TAGGED_INSTR=$(grep -c "pafex.libinternal" "$S/instr_device.ll" || true)
    echo "    tagged instrs in module: ${TAGGED_INSTR:-0}"
else
    DEVBC="$DEVLINK"
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
"$LLVMBIN/clang++" -x hip --cuda-host-only --offload-arch=$GFX \
    -O$OPT_LEVEL -w $FP_FLAGS $EXTRA_DEFS -emit-llvm \
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

# --- FIX 1: run FROM the per-run dir -----------------------------------------
# fp_site_counts.csv and fp_result_counts.csv are opened relative to cwd by the
# driver with no env override. Running from $ROOT made every test overwrite one
# shared pair. The subshell keeps the cd local.
echo "--- run"
RUNLOG="$S/run.log"
(
    cd "$S"
    FP_DEBUG=1 FP_SITES_CSV="$S/fp_sites.csv" ./app > "$RUNLOG" 2>&1
) || { echo "    RUN FAILED (rc=$?) — see $RUNLOG"; exit 1; }

set +e   # reporting only past this point; a parse hiccup must not fail the run

# Prove the count files landed here and not in the repo root.
for f in fp_site_counts.csv fp_result_counts.csv; do
    if [ -f "$S/$f" ]; then
        echo "    $f: $(wc -l < "$S/$f") lines"
    else
        echo "    $f: ABSENT (driver may not have written it)"
    fi
done
if [ -f "$ROOT/fp_site_counts.csv" ]; then
    echo "    WARNING: $ROOT/fp_site_counts.csv exists — stale artifact from the"
    echo "             old shared-cwd behavior. Delete it; it is not this run's."
fi

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
        GOT=${C[$EXPECT]:-0}
        # EXPECT_N: exact-count check. The rounding tests need this, not a
        # nonzero check -- e.g. round_nearest must report overflow=4 at BOTH -O0
        # and -O2, via two different code paths (at -O0 __fadd_rn is a call to
        # __ocml_add_rte_f32 caught by the ocml.add collect arm; at -O1+ the rte
        # wrapper -- the one WITHOUT strictfp -- inlines and folds to a bare
        # fadd caught by the FAdd case). A nonzero check would pass while the
        # two levels silently disagreed.
        if [ -n "${EXPECT_N:-}" ]; then
            if [ "$GOT" -eq "$EXPECT_N" ]; then
                echo "    EXPECT[$EXPECT]=$EXPECT_N: PASS ($GOT)"
            else
                echo "    EXPECT[$EXPECT]=$EXPECT_N: FAIL (got $GOT)"
            fi
        elif [ "$GOT" -ne 0 ]; then
            echo "    EXPECT[$EXPECT]: PASS ($GOT)"
        else
            echo "    EXPECT[$EXPECT]: FAIL (zero)"
        fi
    fi
fi
echo "=== done: $TESTID [$MODE]"
exit 0
