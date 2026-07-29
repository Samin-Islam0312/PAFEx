#!/bin/bash
# PaFEx AMD full sweep driver.
#   Usage:  source scripts/sweep_all.sh
#           run_all ieee          # IEEE  (default contract)
#           run_all fast          # -ffast-math -fdenormal-fp-math=preserve-sign
#           run_all ieee "-ffp-contract=off"
#
# Writes one TSV row per cell to results/summary/sweep_<mode><tag>.tsv
# Retries a cell up to MAX_TRY times if it fails to produce counts.

BENCHES="${BENCHES:-myocyte LU GRAMSCHM ADI cfd gaussian hotspot CORR}"
OPTS="${OPTS:-0 1 2 3}"
MAX_TRY="${MAX_TRY:-3}"
GAP="${GAP:-15}"          # seconds between cells
REPS_IN="${REPS_IN:-3}"   # in-build repeats (reuses one build, no rebuild race)

cell() {   # cell <bench> <opt> <mode> [extra_flags]
  local b=$1 O=$2 mode=$3 extra="${4:-}"
  local Sdir=$REPO/runs/amd_bench/$b/O${O}-${mode}-tag1-instrumented
  local out try=1 counts="" summary=""

  while (( try <= MAX_TRY )); do
    out=$(FP_EXTRA="$extra" OPT_LEVEL=$O FP_MODE=$mode TAGGED=1 RUNS=$REPS_IN \
          bash $REPO/scripts/buildScripts/run_hip_single_tu.sh $b 2>&1)
    counts=$(echo "$out" | grep -m1 'counts:')
    summary=$(echo "$out" | grep -m1 'SUMMARY')
    [[ -n "$counts" ]] && break
    echo "   retry $try/$MAX_TRY : $b O$O $mode $extra" >&2
    sleep $GAP
    ((try++))
  done

  local instr sites
  instr=$(echo "$summary" | grep -oE 'instrumented [0-9]+' | grep -oE '[0-9]+')
  sites=$(echo "$summary" | grep -oE '[0-9]+ sites' | grep -oE '[0-9]+')

  if [[ -z "$counts" ]]; then
    printf "%s\t%s\t%s\t%s\t%s\t%s\tFAIL\tFAIL\tFAIL\tFAIL\tFAIL\tFAILED\n" \
      "$b" "O$O" "$mode" "${extra:-default}" "${instr:-?}" "${sites:-?}"
    return 1
  fi

  # distinct fired sites per class
  local f=$Sdir/fp_site_counts.csv
  local vals=()
  for c in invalid divzero overflow underflow subnormal; do
    if [[ -f $f ]]; then
      local col n
      col=$(head -1 $f | tr ',' '\n' | grep -nx "$c" | cut -d: -f1)
      n=$(awk -F, -v k="$col" 'NR>1 && $k>0' $f | wc -l)
      vals+=("$n")
    else
      vals+=("0")
    fi
  done

  # archive raw artefacts under a config-specific name
  local tagdir=$REPO/results/amd_sites
  local key="${b}_O${O}_${mode}$([[ -n $extra ]] && echo _nocontract)"
  [[ -f $f ]] && cp "$f" "$tagdir/${key}_counts.csv"
  [[ -f $Sdir/fp_sites.csv ]] && cp "$Sdir/fp_sites.csv" "$tagdir/${key}_map.csv"

  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\tOK\n" \
    "$b" "O$O" "$mode" "${extra:-default}" "${instr:-?}" "${sites:-?}" \
    "${vals[0]}" "${vals[1]}" "${vals[2]}" "${vals[3]}" "${vals[4]}"
}

run_all() {   # run_all <mode> [extra_flags]
  [[ "$(hostname)" == *odyssey* ]] || { echo "!! not on odyssey"; return 1; }
  local mode=${1:-ieee} extra="${2:-}"
  local suffix="$mode$([[ -n $extra ]] && echo _nocontract)"
  local tsv=$REPO/results/summary/sweep_${suffix}.tsv
  mkdir -p $REPO/results/summary $REPO/results/amd_sites

  printf "bench\topt\tmode\tflags\tinstr\tsites\tinv\tdiv\tovf\tunf\tsub\tstatus\n" | tee "$tsv"
  for b in $BENCHES; do
    for O in $OPTS; do
      cell "$b" "$O" "$mode" "$extra" | tee -a "$tsv"
      sleep $GAP
    done
  done
  echo
  echo "=== wrote $tsv ==="
  awk -F'\t' 'NR>1 && $NF!="OK"{print "  STILL FAILING: "$1" "$2" "$3" "$4}' "$tsv"
}
