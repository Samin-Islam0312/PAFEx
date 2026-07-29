#!/bin/bash
# sweep_amd_final.sh — final AMD results sweep.
# - PASS_FLAGS=-result-class : produces fp_result_counts.csv (GPU-FPX view)
# - reads counts.txt and fp_result_counts.csv FROM FILES, never scrapes stdout
#   (the stdout scrape was racy and produced phantom zeros)
# - aggregates result-class per-site dynamic counts into distinct-sites-per-class
# Run detached:  nohup ./scripts/buildScripts/sweep_amd_final.sh > runs/amd_bench/final.log 2>&1 &
set -u
ROOT="$(pwd)"
RUN="$ROOT/scripts/buildScripts/run_hip_single_tu.sh"
AGG="$ROOT/scripts/buildScripts/agg_result_sites.sh"
BENCHES="${BENCHES:-LU ADI CORR GRAMSCHM}"

for b in $BENCHES; do
  for O in 0 1 2 3; do
    for fp in ieee fast; do
      for tag in 0 1; do
        d="$ROOT/runs/amd_bench/$b/O$O-$fp-tag$tag-instrumented"
        OPT_LEVEL=$O FP_MODE=$fp TAGGED=$tag RUNS=1 PASS_FLAGS=-result-class \
          "$RUN" "$b" > /dev/null 2>&1
        echo "=== $b O$O $fp tag$tag ==="
        if [ -f "$d/counts.txt" ]; then
          echo "  native: $(cat "$d/counts.txt")"
        else
          echo "  native: counts.txt MISSING (run may have failed — see $d)"
        fi
        bash "$AGG" "$d"
      done
    done
  done
done
echo "=== SWEEP COMPLETE ==="
