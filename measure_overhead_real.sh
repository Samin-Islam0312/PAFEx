#!/bin/bash
# Real kernel-only overhead using ncu.
# Assumes ./run_tests.sh has produced results/<cat>/<test>/instrumented_app
# and baseline_app (from measure_overhead.sh) or builds baseline on demand.

set -u
module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
NCU=/packages/cuda/12.8.1/nsight-compute-2025.1.1/ncu

OVERHEAD_CSV=results/_overhead_kernel.csv
echo "category,test,kernel,baseline_ns,instrumented_ns,overhead_pct,slowdown_x" > $OVERHEAD_CSV

# Strip lines other than the CSV data row from ncu output
parse_ncu_ns() {
    # Input: ncu --csv output containing a "Metric Value" row.
    # Output: just the integer ns value.
    grep -E "^\"[0-9]" | head -1 | awk -F, '{gsub(/"/, "", $NF); print $NF}'
}

parse_ncu_kernel() {
    grep -E "^\"[0-9]" | head -1 | awk -F, '{gsub(/"/, "", $5); print $5}' | sed 's/(.*//'
}

for test_dir in results/*/*/; do
    [ -d "$test_dir" ] || continue
    [ -x "$test_dir/instrumented_app" ] || continue
    category=$(basename $(dirname "$test_dir"))
    test_name=$(basename "$test_dir")
    [[ "$category" =~ ^_ ]] && continue

    src="tests/basic_tests/$category/$test_name.cu"
    [ -f "$src" ] || continue

    # Build baseline if not already present
    baseline_bin=$test_dir/baseline_app
    if [ ! -x "$baseline_bin" ]; then
        nvcc -O2 -arch=$GPU_ARCH "$src" -o "$baseline_bin" 2>/dev/null || continue
    fi

    echo ""
    echo "=== $category / $test_name ==="

    # Run ncu on both, capture kernel time
    base_ns=$($NCU --csv --metrics gpu__time_duration.sum "$baseline_bin" 2>&1 | parse_ncu_ns)
    inst_ns=$($NCU --csv --metrics gpu__time_duration.sum "$test_dir/instrumented_app" 2>&1 | parse_ncu_ns)
    kernel=$($NCU --csv --metrics gpu__time_duration.sum "$baseline_bin" 2>&1 | parse_ncu_kernel)

    if [ -z "$base_ns" ] || [ -z "$inst_ns" ]; then
        echo "  ncu measurement failed"
        echo "$category,$test_name,$kernel,NA,NA,NA,NA" >> $OVERHEAD_CSV
        continue
    fi

    overhead=$(echo "scale=2; ($inst_ns - $base_ns) * 100 / $base_ns" | bc)
    slowdown=$(echo "scale=2; $inst_ns / $base_ns" | bc)

    echo "  kernel:       $kernel"
    echo "  baseline:     ${base_ns} ns"
    echo "  instrumented: ${inst_ns} ns"
    echo "  overhead:     ${overhead}%  (${slowdown}x)"

    echo "$category,$test_name,$kernel,$base_ns,$inst_ns,$overhead,$slowdown" >> $OVERHEAD_CSV
done

echo ""
echo "=== Kernel-Only Overhead Summary ==="
column -t -s, $OVERHEAD_CSV
