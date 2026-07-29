#!/bin/bash
# PaFEx NVIDIA overhead — WHOLE-PROGRAM WALL-CLOCK (FloatGuard Eq.2 metric).
source scripts/odyssey_env.sh 2>/dev/null || true
set -uo pipefail
REPO=$(pwd); RUNNER=$REPO/scripts/buildScripts/run_hip_single_tu.sh; MAN=$REPO/scripts/buildScripts/sweep_hip.manifest

BENCHES="${BENCHES:-myocyte LU GRAMSCHM cfd CORR ADI gaussian hotspot}"
OPTLVL="${OPTLVL:-0}"; FPM="${FPM:-ieee}"
NREP="${NREP:-5}"; NWARM="${NWARM:-2}"
mkdir -p "$REPO/results/summary"; TSV=$REPO/results/summary/overhead_wall_amd.tsv

_median(){ sort -g | awk '{a[NR]=$1} END{if(NR==0){print "NA";exit} m=(NR%2)?a[(NR+1)/2]:(a[NR/2]+a[NR/2+1])/2; printf "%.4f",m}'; }
_minmax(){ sort -g | awk '{a[NR]=$1} END{if(NR==0){print "NA";exit} printf "%.3f-%.3f",a[1],a[NR]}'; }
_app(){ ls "$1"/*app "$1"/app 2>/dev/null | head -1; }

# whole-program wall seconds; RUN from the data dir if one is given, else the build dir
_wall_s(){ local d=$1 rundir=$2; shift 2; local bin; bin=$(_app "$d"); [ -x "$bin" ] || { echo NA; return; }
  local wd="${rundir:-$d}" t
  tf=$(mktemp); ( cd "$wd" && /usr/bin/time -o "$tf" -f '%e' "$bin" "$@" >/dev/null 2>&1 ); t=$(cat "$tf"); rm -f "$tf"
  rm -f /tmp/pfx_wall.$$ 2>/dev/null
  echo "$t"
}

printf "bench\topt\tfp\twall_base_s\twall_instr_s\twall_ratio\twall_base_minmax\twall_instr_minmax\n" | tee "$TSV"
echo "timed runs: $NREP (warm-ups: $NWARM)  metric: whole-program wall-clock"

for b in $BENCHES; do
  echo "=== building $b ==="
  MANIFEST=$MAN OPT_LEVEL=$OPTLVL FP_MODE=$FPM TAGGED=1 RUNS=1 bash "$RUNNER" "$b" baseline     >/dev/null 2>&1
  MANIFEST=$MAN OPT_LEVEL=$OPTLVL FP_MODE=$FPM TAGGED=1 RUNS=1 bash "$RUNNER" "$b" instrumented >/dev/null 2>&1
  dbase=$REPO/runs/amd_bench/$b/O$OPTLVL-$FPM-tag1-baseline; dinst=$REPO/runs/amd_bench/$b/O$OPTLVL-$FPM-tag1-instrumented
  args=$(awk -F'|' -v n="$b" '{gsub(/ /,"",$1)} $1==n{a=$5; gsub(/^ *| *$/,"",a); if(a=="-")a=""; print a; exit}' "$MAN")
  # optional per-benchmark run dir (where data files live); empty = run in build dir
  rundir=""
  case "$b" in
    myocyte)  rundir="$REPO/tests/amd/benchmarks/rodinia/myocyte" ;;
  esac
  [ -x "$(_app "$dbase")" ] && [ -x "$(_app "$dinst")" ] || { echo "  !! $b: missing binary"; \
     printf "%s\tO%s\t%s\tNA\tNA\tNA\tNA\tNA\n" "$b" "$OPTLVL" "$FPM" | tee -a "$TSV"; continue; }

  for ((i=0;i<NWARM;i++)); do _wall_s "$dbase" "$rundir" $args >/dev/null; _wall_s "$dinst" "$rundir" $args >/dev/null; done
  wfb=$(mktemp); wfi=$(mktemp)
  for ((i=0;i<NREP;i++)); do _wall_s "$dbase" "$rundir" $args; done > "$wfb"
  for ((i=0;i<NREP;i++)); do _wall_s "$dinst" "$rundir" $args; done > "$wfi"
  wbm=$(_median<"$wfb"); wim=$(_median<"$wfi")
  wr=$(echo "scale=3;$wim/$wbm"|bc 2>/dev/null)
  printf "%s\tO%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$b" "$OPTLVL" "$FPM" "$wbm" "$wim" "$wr" "$(_minmax<"$wfb")" "$(_minmax<"$wfi")" | tee -a "$TSV"
  rm -f "$wfb" "$wfi"
done
echo "=== done -> $TSV ==="; column -t "$TSV"
