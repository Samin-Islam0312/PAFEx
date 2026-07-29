#!/bin/bash
# PaFEx NVIDIA overhead — nsys passive kernel time (matches AMD rocprofv3 kernel-trace).
source scripts/athena_env.sh 2>/dev/null || true
set -uo pipefail
export TMPDIR="${TMPDIR:-$HOME/.ncu_tmp}"; mkdir -p "$TMPDIR"
NSYS=/packages/cuda/12.8.1/nsight-systems-2024.6.2/bin/nsys
REPO=$(pwd); RUNNER=$REPO/scripts/buildScripts/run_single_tu.sh; MAN=$REPO/scripts/nv_detect.manifest

BENCHES="${BENCHES:-myocyte LU GRAMSCHM cfd CORR}"     # real-work set; add ADI gaussian hotspot if wanted
OPTLVL="${OPTLVL:-0}"; FPM="${FPM:-ieee}"
NPROF="${NPROF:-3}"
export TIMEOUT="${TIMEOUT:-1800}"
mkdir -p "$REPO/results/summary"; TSV=$REPO/results/summary/overhead_nv.tsv

_median(){ sort -g | awk '{a[NR]=$1} END{if(NR==0){print "NA";exit} m=(NR%2)?a[(NR+1)/2]:(a[NR/2]+a[NR/2+1])/2; printf "%.4f",m}'; }
_minmax(){ sort -g | awk '{a[NR]=$1} END{if(NR==0){print "NA";exit} printf "%.3f-%.3f",a[1],a[NR]}'; }
_app(){ ls "$1"/*app "$1"/app 2>/dev/null | head -1; }

# passive total GPU kernel seconds for one run (sums all kernels) via nsys
_kernel_s(){ local d=$1; shift; local bin rep; bin=$(_app "$d"); [ -x "$bin" ] || { echo NA; return; }
  rep=$(mktemp -u --tmpdir="$TMPDIR" nsysXXXX)
  ( cd "$d" && "$NSYS" profile --force-overwrite=true -o "$rep" "$bin" "$@" >/dev/null 2>&1 )
  local ns
  ns=$("$NSYS" stats --report cuda_gpu_kern_sum "$rep.nsys-rep" 2>/dev/null \
        | awk '/^[[:space:]]*[0-9]/{gsub(/,/,"",$2); s+=$2} END{printf "%d", s+0}')
  rm -f "$rep.nsys-rep" "$rep.sqlite" 2>/dev/null
  echo "scale=6;$ns/1000000000"|bc
}

printf "bench\topt\tfp\tkern_base_s\tkern_instr_s\tkern_ratio\tkern_base_minmax\tkern_instr_minmax\n" | tee "$TSV"
echo "profiled runs (nsys): $NPROF   metric: passive GPU kernel time (cuda_gpu_kern_sum)"

for b in $BENCHES; do
  echo "=== building $b ==="
  MANIFEST=$MAN OPT_LEVEL=$OPTLVL FP_MODE=$FPM TAGGED=1 RUNS=1 bash "$RUNNER" "$b" baseline     >/dev/null 2>&1
  MANIFEST=$MAN OPT_LEVEL=$OPTLVL FP_MODE=$FPM TAGGED=1 RUNS=1 bash "$RUNNER" "$b" instrumented >/dev/null 2>&1
  dbase=$REPO/scratch/$b/baseline; dinst=$REPO/scratch/$b/instrumented
  args=$(awk -F'|' -v n="$b" '{gsub(/ /,"",$1)} $1==n{a=$5; gsub(/^ *| *$/,"",a); if(a=="-")a=""; print a; exit}' "$MAN")
  [ -x "$(_app "$dbase")" ] && [ -x "$(_app "$dinst")" ] || { echo "  !! $b: missing binary"; \
     printf "%s\tO%s\t%s\tNA\tNA\tNA\tNA\tNA\n" "$b" "$OPTLVL" "$FPM" | tee -a "$TSV"; continue; }

  kfb=$(mktemp); kfi=$(mktemp)
  for ((i=0;i<NPROF;i++)); do _kernel_s "$dbase" $args; done > "$kfb"
  for ((i=0;i<NPROF;i++)); do _kernel_s "$dinst" $args; done > "$kfi"
  kbm=$(_median<"$kfb"); kim=$(_median<"$kfi")
  kr=$(echo "scale=3;$kim/$kbm"|bc 2>/dev/null)
  printf "%s\tO%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$b" "$OPTLVL" "$FPM" "$kbm" "$kim" "$kr" "$(_minmax<"$kfb")" "$(_minmax<"$kfi")" | tee -a "$TSV"
  rm -f "$kfb" "$kfi"
done
echo "=== done -> $TSV ==="; column -t "$TSV"
