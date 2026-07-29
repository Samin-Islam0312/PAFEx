#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$ROOT/scripts/buildScripts/run_single_tu.sh"
MAN="$ROOT/scripts/nv_detect.manifest"

cat > "$MAN" <<'EOF'
CORR | - | tests/cuda/benchmarks/polybench/CUDA/CORR/correlation.cu | tests/cuda/benchmarks/polybench/CUDA/CORR | - | -
ADI  | - | tests/cuda/benchmarks/polybench/CUDA/ADI/adi.cu           | tests/cuda/benchmarks/polybench/CUDA/ADI  | - | -
EOF

run_one() {
  local name="$1" log="$ROOT/results/nv_${1}_O0_ieee.log"
  mkdir -p "$ROOT/results"
  echo "=== $name (O0/ieee/tag1, detection) ==="
  MANIFEST="$MAN" OPT_LEVEL=0 FP_MODE=ieee TAGGED=1 RUNS=1 \
    bash "$RUNNER" "$name" instrumented 2>&1 | tee "$log"
  # real marker for THIS runner: a completed kernel launch on the counts line
  grep -qE 'counts:.*kernels=[1-9]' "$log" \
    || { echo "ABORT: $name — no completed kernel run (usage text / launch fail)." >&2; exit 1; }
}

run_one CORR
run_one ADI
