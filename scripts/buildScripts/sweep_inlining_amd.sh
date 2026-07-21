#!/bin/bash
# sweep_inlining_amd.sh — compile-only tagged/untagged contamination sweep, AMD.
# The inlining result is the DevicePass SUMMARY (compile-time counts): no
# libdevice link, no llc, no host pass, no run. Clean pipeline = clang does -O
# and inlining; TagPass tags at PipelineStartEP before the inliner; DevicePass
# reads the tag. No opt-side preopt (that would inline OCML un-tagged).
set -uo pipefail

export ROCM=${ROCM:-/opt/rocm-7.2.4}
export LLVM=$ROCM/lib/llvm/bin
ROOT=${REPO:-$HOME/SBAC-PAD-opt}
DEV=$ROOT/build-rocm/lib/device/DevicePass.so
TAG=$ROOT/build-rocm/lib/tag/TagPass.so
GFX=gfx942

for p in "$DEV" "$TAG"; do
  [ -f "$p" ] || { echo "MISSING pass: $p — build build-rocm first" >&2; exit 2; }
done

OUT=$ROOT/runs_inlining/amd; mkdir -p "$OUT"
TSV="$OUT/contamination.tsv"
printf "bench\topt\ttag\tinstr\tsites\ttagged_in_mod\n" > "$TSV"

# name : path  (AMD tree)
declare -A SRC=(
  [myocyte]=tests/amd/benchmarks/rodinia/myocyte/main.cu
  [cfd]=tests/amd/benchmarks/rodinia/cfd/euler3d.cu
  [lu]=tests/amd/benchmarks/polybench/CUDA/LU/lu.cu
  [gramschmidt]=tests/amd/benchmarks/polybench/CUDA/GRAMSCHM/gramschmidt.cu
  [correlation]=tests/amd/benchmarks/polybench/CUDA/CORR/correlation.cu
  [adi]=tests/amd/benchmarks/polybench/CUDA/ADI/adi.cu
)
ORDER="myocyte cfd lu gramschmidt correlation adi"

for NAME in $ORDER; do
  f="$ROOT/${SRC[$NAME]}"
  if [ ! -f "$f" ]; then
    printf "%s\t-\t-\tNOSRC\t-\t-\n" "$NAME" | tee -a "$TSV"
    continue
  fi
  INC="-I$(dirname "$f")"
  for O in 0 1 2 3; do
    for T in 0 1; do
      S="$OUT/$NAME/O$O-tag$T"; mkdir -p "$S"
      PLUG=""; [ "$T" = "1" ] && PLUG="-fpass-plugin=$TAG"
      if ! "$LLVM/clang++" -x hip --cuda-device-only --offload-arch=$GFX \
            -O$O -g -w $PLUG --no-gpu-bundle-output -emit-llvm -c "$f" $INC \
            -o "$S/dev.bc" 2>"$S/cc.log"; then
        printf "%s\t%s\ttag%s\tCCFAIL\t-\t-\n" "$NAME" "$O" "$T" | tee -a "$TSV"
        continue
      fi
      "$LLVM/opt" -load-pass-plugin="$DEV" -passes=fp-exception \
        -fp-sites-csv="$S/sites.csv" "$S/dev.bc" -o /dev/null 2>"$S/pass.log"
      instr=$(grep -oE 'instrumented [0-9]+ instructions' "$S/pass.log" | grep -oE '[0-9]+' | head -1)
      sites=$(grep -oE '[0-9]+ sites' "$S/pass.log" | grep -oE '[0-9]+' | head -1)
      "$LLVM/llvm-dis" "$S/dev.bc" -o "$S/dev.ll" 2>/dev/null
      tin=$(grep -c 'pafex.libinternal' "$S/dev.ll" 2>/dev/null || echo 0)
      printf "%s\t%s\ttag%s\t%s\t%s\t%s\n" "$NAME" "$O" "$T" \
        "${instr:-ERR}" "${sites:-ERR}" "$tin" | tee -a "$TSV"
    done
  done
done

echo; echo "=== contamination table ==="
column -t "$TSV"
