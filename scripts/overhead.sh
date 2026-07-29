#!/bin/bash
# PaFEx AMD overhead harness.
#   source scripts/overhead.sh
#   overhead_all                     # default benchmark set
#   BENCHES="LU gaussian" overhead_all
#
# For each benchmark it builds a baseline and an instrumented binary ONCE,
# then executes each binary repeatedly WITHOUT rebuilding:
#   - WARMUP runs discarded (context creation, module load, first-touch alloc)
#   - NREPS   runs timed by wall clock
#   - NPROF   runs under rocprofv3 for device kernel time
# Reports median and min-max for both quantities, and the ratio.
#
# Output: results/summary/overhead.tsv

BENCHES="${BENCHES:-LU GRAMSCHM gaussian hotspot}"
OPTLVL="${OPTLVL:-0}"
FPM="${FPM:-ieee}"
WARMUP="${WARMUP:-3}"
NREPS="${NREPS:-10}"
NPROF="${NPROF:-3}"
export TIMEOUT="${TIMEOUT:-1800}"

_median() {   # stdin: one number per line
  sort -g | awk '{a[NR]=$1} END{ if(NR==0){print "NA"; exit}
    if(NR%2) print a[(NR+1)/2]; else printf "%.6f\n", (a[NR/2]+a[NR/2+1])/2 }'
}
_min() { sort -g | head -1; }
_max() { sort -g | tail -1; }

_args_for() {  # pull the args column from the manifest, '-' means none
  local b=$1
  local line
  line=$(grep -E "^\s*${b}\s*\|" $REPO/scripts/buildScripts/sweep_hip.manifest | head -1)
  local a
  a=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/,"",$5); print $5}')
  [[ "$a" == "-" ]] && a=""
  echo "$a"
}

_build() {   # _build <bench> <instrumented|baseline> -> echoes app dir
  local b=$1 what=$2
  OPT_LEVEL=$OPTLVL FP_MODE=$FPM TAGGED=1 RUNS=1 \
    bash $REPO/scripts/buildScripts/run_hip_single_tu.sh "$b" "$what" >/dev/null 2>&1
  echo "$REPO/runs/amd_bench/$b/O${OPTLVL}-${FPM}-tag1-${what}"
}

_kernel_ns() {   # _kernel_ns <appdir> <args...> -> total kernel ns for one run
  local d=$1; shift
  local out; out=$(mktemp -d)
  ( cd "$d" && rocprofv3 --kernel-trace --stats --output-format csv -d "$out" -o prof -- ./app "$@" \
      >/dev/null 2>&1 )
  local csv; csv=$(find "$out" -name '*kernel_stats*.csv' | head -1)
  if [[ -z "$csv" ]]; then rm -rf "$out"; echo "NA"; return 1; fi
  # strip the quoted kernel-name field first: it contains commas
  sed 's/^"[^"]*",//' "$csv" | awk -F, '
    NR==1{ for(i=1;i<=NF;i++){ gsub(/"/,"",$i); if($i=="TotalDurationNs") c=i } next }
    { s+=$c } END{ printf "%.0f\n", s }'
  rm -rf "$out"
}

overhead_one() {   # overhead_one <bench>
  local b=$1
  local args; args=$(_args_for "$b")
  echo "=== $b (O$OPTLVL $FPM) args='${args:-none}' ===" >&2

  local dbase dinst
  dbase=$(_build "$b" baseline)
  dinst=$(_build "$b" instrumented)
  if [[ ! -x "$dbase/app" || ! -x "$dinst/app" ]]; then
    printf "%s\tBUILD_FAIL\t-\t-\t-\t-\t-\t-\t-\n" "$b"; return 1
  fi

  _walls() {   # _walls <dir> -> one wall time per line
    local d=$1 i t0 t1
    for ((i=0;i<WARMUP;i++)); do ( cd "$d" && ./app $args >/dev/null 2>&1 ); done
    for ((i=0;i<NREPS;i++)); do
      t0=$(date +%s.%N); ( cd "$d" && ./app $args >/dev/null 2>&1 ); t1=$(date +%s.%N)
      echo "$t1 - $t0" | bc -l
    done
  }
  _kerns() {   # _kerns <dir> -> one kernel-seconds per line
    local d=$1 i ns
    for ((i=0;i<NPROF;i++)); do
      ns=$(_kernel_ns "$d" $args)
      [[ "$ns" != "NA" && -n "$ns" ]] && echo "scale=6; $ns/1000000000" | bc -l
    done
  }

  local wbf wif kbf kif
  wbf=$(mktemp); wif=$(mktemp); kbf=$(mktemp); kif=$(mktemp)
  _walls "$dbase" > "$wbf"
  _walls "$dinst" > "$wif"
  _kerns "$dbase" > "$kbf"
  _kerns "$dinst" > "$kif"

  local wbm wim kbm kim wr kr rng
  wbm=$(_median < "$wbf"); wim=$(_median < "$wif")
  kbm=$(_median < "$kbf"); kim=$(_median < "$kif")
  wr=$(echo "scale=3; $wim / $wbm" | bc -l 2>/dev/null || echo NA)
  if [[ "$kbm" != "NA" && -n "$kbm" && "$kbm" != "0" ]]; then
    kr=$(echo "scale=3; $kim / $kbm" | bc -l); else kr=NA; fi
  rng="$(_min < "$wif")-$(_max < "$wif")"

  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
    "$b" "O$OPTLVL" "$wbm" "$wim" "$wr" "${kbm:-NA}" "${kim:-NA}" "$kr" "$rng"
  rm -f "$wbf" "$wif" "$kbf" "$kif"
}

overhead_all() {
  [[ "$(hostname)" == *odyssey* ]] || { echo "!! not on odyssey"; return 1; }
  local tsv=$REPO/results/summary/overhead.tsv
  mkdir -p $REPO/results/summary
  printf "bench\topt\twall_base_s\twall_instr_s\twall_ratio\tkern_base_s\tkern_instr_s\tkern_ratio\twall_instr_min-max\n" | tee -a "$tsv"
  for b in $BENCHES; do overhead_one "$b" | tee -a "$tsv"; done
  echo
  echo "warm-up discarded: $WARMUP   timed runs: $NREPS   profiled runs: $NPROF"
  echo "=== wrote $tsv ==="
}
