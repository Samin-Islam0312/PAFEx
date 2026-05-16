#!/bin/bash
# Measures kernel-only runtime overhead. Baseline vs instrumented.
# Assumes ./run_tests.sh has already been run.

set -u
module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export LD_LIBRARY_PATH=$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

ITERS=${ITERS:-100}    # iterations per measurement
WARMUP=${WARMUP:-10}

OVERHEAD_CSV=results/_overhead.csv
echo "category,test,baseline_ms,instrumented_ms,overhead_pct,slowdown_x" > $OVERHEAD_CSV

time_binary() {
    # Run binary $ITERS times, time with `date +%s%N` (nanoseconds since epoch).
    # End-to-end wallclock — includes setup, but consistent between baseline and instrumented.
    local bin=$1
    local total=0
    # Warmup
    for ((i=0; i<WARMUP; i++)); do "$bin" > /dev/null 2>&1; done
    # Measure
    for ((i=0; i<ITERS; i++)); do
        local start=$(date +%s%N)
        "$bin" > /dev/null 2>&1
        local end=$(date +%s%N)
        total=$((total + end - start))
    done
    # Average in milliseconds
    echo "scale=3; $total / $ITERS / 1000000" | bc
}

for test_dir in results/*/*/; do
    [ -d "$test_dir" ] || continue
    [ -x "$test_dir/instrumented_app" ] || continue
    category=$(basename $(dirname "$test_dir"))
    test_name=$(basename "$test_dir")
    [[ "$category" =~ ^_ ]] && continue   # skip _summary etc

    # Find the source .cu
    src="tests/basic_tests/$category/$test_name.cu"
    [ -f "$src" ] || { echo "skip $category/$test_name: no source"; continue; }

    echo ""
    echo "=== $category / $test_name ==="

    # Build baseline (vanilla nvcc, no passes)
    baseline_bin=$test_dir/baseline_app
    nvcc -O2 -arch=$GPU_ARCH "$src" -o "$baseline_bin" 2>/dev/null
    if [ ! -x "$baseline_bin" ]; then
        echo "  baseline build failed, skipping"
        echo "$category,$test_name,NA,NA,NA,NA" >> $OVERHEAD_CSV
        continue
    fi

    base_ms=$(time_binary "$baseline_bin")
    inst_ms=$(time_binary "$test_dir/instrumented_app")

    overhead=$(echo "scale=2; ($inst_ms - $base_ms) / $base_ms * 100" | bc)
    slowdown=$(echo "scale=2; $inst_ms / $base_ms" | bc)

    echo "  baseline:     ${base_ms} ms"
    echo "  instrumented: ${inst_ms} ms"
    echo "  overhead:     ${overhead}%  (${slowdown}x)"

    echo "$category,$test_name,$base_ms,$inst_ms,$overhead,$slowdown" >> $OVERHEAD_CSV
done

echo ""
echo "=== Overhead Summary ==="
column -t -s, $OVERHEAD_CSV
