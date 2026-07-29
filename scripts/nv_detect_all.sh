#!/usr/bin/env bash
set -uo pipefail                      # NOT -e: one benchmark failing must not kill the sweep
export TIMEOUT=${TIMEOUT:-1800}
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$ROOT/scripts/buildScripts/run_single_tu.sh"
MAN="$ROOT/scripts/nv_detect.manifest"
D_AMD="$ROOT/tests/amd/benchmarks/rodinia"        # arch-independent input data
mkdir -p "$ROOT/results"

# name|group|src|inc|args|expect  (CUDA-native, args mirrored from AMD sweep_hip.manifest)
cat > "$MAN" <<EOF
LU       | invalid   | tests/cuda/benchmarks/polybench/CUDA/LU/lu.cu               | -                                          | -       | -
GRAMSCHM | invalid   | tests/cuda/benchmarks/polybench/CUDA/GRAMSCHM/gramschmidt.cu | tests/cuda/benchmarks/polybench/CUDA/GRAMSCHM | -       | -
CORR     | -         | tests/cuda/benchmarks/polybench/CUDA/CORR/correlation.cu    | tests/cuda/benchmarks/polybench/CUDA/CORR  | -       | -
ADI      | -         | tests/cuda/benchmarks/polybench/CUDA/ADI/adi.cu            | tests/cuda/benchmarks/polybench/CUDA/ADI   | -       | -
cfd      | underflow | tests/cuda/benchmarks/rodinia/cfd/euler3d.cu               | tests/cuda/benchmarks/rodinia/cfd          | $D_AMD/cfd/data/fvcorr.domn.097K | -
gaussian | none      | tests/cuda/benchmarks/rodinia/gaussian/gaussian.cu        | tests/cuda/benchmarks/rodinia/gaussian     | -s 16   | -
hotspot  | none      | tests/cuda/benchmarks/rodinia/hotspot/hotspot.cu          | tests/cuda/benchmarks/rodinia/hotspot      | 512 2 2 $D_AMD/hotspot/data/temp_512 $D_AMD/hotspot/data/power_512 output.out | -
myocyte  | divzero   | tests/cuda/benchmarks/rodinia/myocyte/main.cu             | tests/cuda/benchmarks/rodinia/myocyte      | 100 1 0 | -
EOF
echo "--- manifest ---"; cat "$MAN"; echo

run_one() {
  local name="$1" log="$ROOT/results/nv_${1}_O0_ieee.log"
  echo "=== $name (O0/ieee/tag1, detection) ==="
  MANIFEST="$MAN" OPT_LEVEL=0 FP_MODE=ieee TAGGED=1 RUNS=1 \
    bash "$RUNNER" "$name" instrumented 2>&1 | tee "$log"
  grep -qE 'counts:.*kernels=[1-9]' "$log" \
    || echo "  !! $name: no completed kernel run — inspect $log"
}

for b in LU GRAMSCHM ADI CORR gaussian hotspot cfd myocyte; do run_one "$b"; done

echo; echo "===== SUMMARY (O0/ieee/tag1) ====="
for b in LU GRAMSCHM ADI CORR gaussian hotspot cfd myocyte; do
  printf '%-9s ' "$b"
  grep -oE 'counts:.*' "$ROOT/results/nv_${b}_O0_ieee.log" 2>/dev/null | tail -1 || echo "(no run)"
done
