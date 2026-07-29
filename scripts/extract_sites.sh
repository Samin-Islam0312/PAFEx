#!/bin/bash
# PaFEx AMD site-profile extraction. source this, then: profile <NAME> [O] [mode]
# NAME must match the manifest 'name' column exactly (LU/GRAMSCHM/ADI upper; rodinia lower).
RESULTS=$REPO/results/amd_sites
mkdir -p $RESULTS $REPO/results/summary

profile() {
  [[ "$(hostname)" == *odyssey* ]] || { echo "!! not on odyssey — refusing"; return 1; }
  local b=$1 O=${2:-0} mode=${3:-ieee}
  local Sdir=$REPO/runs/amd_bench/$b/O${O}-${mode}-tag1-instrumented
  local out=$(OPT_LEVEL=$O FP_MODE=$mode TAGGED=1 RUNS=${REPS:-1} \
    bash scripts/buildScripts/run_hip_single_tu.sh $b 2>&1)
  echo "$out" | grep -E 'SUMMARY|counts:' | sed "s/^/[$b O$O $mode] /"
  # did the run actually execute? (counts line present)
  if ! echo "$out" | grep -q 'counts:'; then
    echo "  !! run did not produce counts — likely build/run failure for $b"
    echo "$out" | tail -5 | sed 's/^/    /'
    return 1
  fi
  local f=$Sdir/fp_site_counts.csv
  echo "  --- SITE counts (distinct locations per class) ---"
  if [[ ! -f $f ]]; then
    echo "  (no per-site CSV — benchmark fired zero exceptions; clean negative control)"
    for c in invalid divzero overflow underflow subnormal; do printf "  %-10s 0 sites\n" "$c"; done
    return 0
  fi
  for c in invalid divzero overflow underflow subnormal; do
    local col=$(head -1 $f | tr ',' '\n' | grep -nx "$c" | cut -d: -f1)
    local n=$(awk -F, -v k=$col 'NR>1 && $k>0' $f | wc -l)
    printf "  %-10s %s sites\n" "$c" "$n"
  done
  cp $f $RESULTS/${b}_O${O}_${mode}_tag1.csv
  cp $Sdir/fp_sites.csv $RESULTS/${b}_O${O}_${mode}_tag1_map.csv 2>/dev/null
}

located() {
  [[ "$(hostname)" == *odyssey* ]] || { echo "!! not on odyssey — refusing"; return 1; }
  local b=$1 O=${2:-0} mode=${3:-ieee}
  local Sdir=$REPO/runs/amd_bench/$b/O${O}-${mode}-tag1-instrumented
  local cnt=$Sdir/fp_site_counts.csv map=$Sdir/fp_sites.csv
  if [[ ! -f $cnt ]]; then echo "  ($b: no fired sites — clean)"; return 0; fi
  echo "=== $b located exceptions (O$O $mode) ==="
  local hdr=$(head -1 $cnt)
  for c in invalid divzero overflow underflow subnormal; do
    local col=$(echo "$hdr" | tr ',' '\n' | grep -nx "$c" | cut -d: -f1)
    awk -F, -v k=$col 'NR>1 && $k>0{print $1","$k}' $cnt \
    | while IFS=, read idx count; do
        awk -F'\t' -v ix="$idx" -v c="$c" -v n="$count" \
          '$1==ix{printf "  %-10s %s:%s  op=%s  (fired %s)\n", c, $2, $4, $NF, n}' $map
      done
  done
}
