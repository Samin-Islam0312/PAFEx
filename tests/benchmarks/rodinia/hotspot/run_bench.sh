#!/bin/bash
set -u
module load cuda/12.8 2>/dev/null || true

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OUTDIR="$SCRIPT_DIR/build"
DATA_DIR="$SCRIPT_DIR/data"
NCU=/packages/cuda/12.8.1/nsight-compute-2025.1.1/ncu

mkdir -p "$DATA_DIR"
GRID=512

# Generate synthetic input data if missing
if [ ! -f "$DATA_DIR/temp_${GRID}" ] || [ ! -f "$DATA_DIR/power_${GRID}" ]; then
    echo "Generating ${GRID}x${GRID} synthetic inputs..."
    python3 -c "
import random
random.seed(42)
N = $GRID
with open('$DATA_DIR/temp_${GRID}', 'w') as f:
    for _ in range(N*N): f.write(f'{random.uniform(78, 82):.6f}\n')
with open('$DATA_DIR/power_${GRID}', 'w') as f:
    for _ in range(N*N): f.write(f'{random.uniform(1.0e6, 2.0e6):.6f}\n')
print(f'  wrote {N*N} cells each')
"
fi

ARGS=("$GRID" "2" "2" "$DATA_DIR/temp_${GRID}" "$DATA_DIR/power_${GRID}" "$OUTDIR/output.out")

echo ""
echo "=== SANITY: baseline ==="
"$OUTDIR/hotspot_baseline" "${ARGS[@]}" 2>&1 | tail -10

echo ""
echo "=== SANITY: instrumented ==="
"$OUTDIR/hotspot_instrumented" "${ARGS[@]}" 2>&1 | tail -30

echo ""
echo "=== ncu: baseline ==="
"$NCU" --csv --metrics gpu__time_duration.sum \
    "$OUTDIR/hotspot_baseline" "${ARGS[@]}" 2>&1 | \
    grep -E "^\"[0-9]" | head -10

echo ""
echo "=== ncu: instrumented ==="
"$NCU" --csv --metrics gpu__time_duration.sum \
    "$OUTDIR/hotspot_instrumented" "${ARGS[@]}" 2>&1 | \
    grep -E "^\"[0-9]" | head -10

echo ""
echo "=== AGGREGATE ==="
BASE_TOTAL=$("$NCU" --csv --metrics gpu__time_duration.sum \
    "$OUTDIR/hotspot_baseline" "${ARGS[@]}" 2>&1 | \
    grep -E "^\"[0-9]" | awk -F, '{gsub(/"/, "", $NF); sum+=$NF} END {printf "%.0f", sum}')

INST_TOTAL=$("$NCU" --csv --metrics gpu__time_duration.sum \
    "$OUTDIR/hotspot_instrumented" "${ARGS[@]}" 2>&1 | \
    grep -E "^\"[0-9]" | awk -F, '{gsub(/"/, "", $NF); sum+=$NF} END {printf "%.0f", sum}')

BASE_COUNT=$("$NCU" --csv --metrics gpu__time_duration.sum \
    "$OUTDIR/hotspot_baseline" "${ARGS[@]}" 2>&1 | \
    grep -cE "^\"[0-9]")
INST_COUNT=$("$NCU" --csv --metrics gpu__time_duration.sum \
    "$OUTDIR/hotspot_instrumented" "${ARGS[@]}" 2>&1 | \
    grep -cE "^\"[0-9]")

echo "  baseline:     $BASE_TOTAL ns total over $BASE_COUNT kernel launches"
echo "  instrumented: $INST_TOTAL ns total over $INST_COUNT kernel launches"
if [ -n "$BASE_TOTAL" ] && [ "$BASE_TOTAL" -gt 0 ]; then
    SLOWDOWN=$(echo "scale=3; $INST_TOTAL / $BASE_TOTAL" | bc)
    OVERHEAD=$(echo "scale=2; ($INST_TOTAL - $BASE_TOTAL) * 100 / $BASE_TOTAL" | bc)
    echo "  slowdown: ${SLOWDOWN}x  (overhead: ${OVERHEAD}%)"
fi
