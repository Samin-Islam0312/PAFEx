#!/bin/bash
set -uo pipefail
export LLVM=$HOME/opt/llvm-22/bin
ROOT=${REPO:-$HOME/SBAC-PAD-opt}
DEV=$ROOT/build-cuda/lib/device/DevicePass.so
TAG=$ROOT/build-cuda/lib/tag/TagPass.so
: "${CUDA:=/usr/local/cuda}"
for p in "$DEV" "$TAG"; do [ -f "$p" ] || { echo "MISSING $p — build build-cuda first"; exit 2; }; done

OUT=$ROOT/runs_inlining/nv; mkdir -p "$OUT"
declare -A SRC=(
  [myocyte]=tests/cuda/benchmarks/rodinia/myocyte/main.cu
  [cfd]=tests/cuda/benchmarks/rodinia/cfd/euler3d.cu
  [lu]=tests/cuda/benchmarks/polybench/CUDA/LU/lu.cu
  [gramschmidt]=tests/cuda/benchmarks/polybench/CUDA/GRAMSCHM/gramschmidt.cu
  [correlation]=tests/cuda/benchmarks/polybench/CUDA/CORR/correlation.cu
  [adi]=tests/cuda/benchmarks/polybench/CUDA/ADI/adi.cu
)
printf "bench\topt\ttag\tinstr\tsites\n" > "$OUT/contamination.tsv"
for NAME in myocyte cfd lu gramschmidt correlation adi; do
  f="$ROOT/${SRC[$NAME]}"
  [ -f "$f" ] || { printf "%s\t-\t-\tNOSRC\t-\n" "$NAME" | tee -a "$OUT/contamination.tsv"; continue; }
  for O in 0 1 2 3; do for T in 0 1; do
    S="$OUT/$NAME/O$O-tag$T"; mkdir -p "$S"
    PLUG=""; [ "$T" = 1 ] && PLUG="-fpass-plugin=$TAG"
    if "$LLVM/clang++" -x cuda --cuda-path=$CUDA --cuda-device-only --cuda-gpu-arch=sm_80 \
         -O$O -g -w $PLUG -emit-llvm -c "$f" -I"$(dirname "$f")" -o "$S/dev.bc" 2>"$S/cc.log"; then
      "$LLVM/opt" -load-pass-plugin="$DEV" -passes=fp-exception \
        -fp-sites-csv="$S/sites.csv" "$S/dev.bc" -o /dev/null 2>"$S/pass.log"
      line=$(grep -oE 'instrumented [0-9]+ instructions, [0-9]+ sites' "$S/pass.log")
      instr=$(echo "$line"|grep -oE 'instrumented [0-9]+'|grep -oE '[0-9]+')
      sites=$(echo "$line"|grep -oE '[0-9]+ sites'|grep -oE '[0-9]+')
      printf "%s\t%s\ttag%s\t%s\t%s\n" "$NAME" "$O" "$T" "${instr:-NA}" "${sites:-NA}" | tee -a "$OUT/contamination.tsv"
    else
      printf "%s\t%s\ttag%s\tCCFAIL\t-\n" "$NAME" "$O" "$T" | tee -a "$OUT/contamination.tsv"
      echo "  ^ $(head -1 "$S/cc.log")"
    fi
  done; done
done
echo; echo "=== NVIDIA contamination ==="; cat "$OUT/contamination.tsv" | sed 's/\t/  /g'
