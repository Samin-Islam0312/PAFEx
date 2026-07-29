#!/usr/bin/env bash
set -uo pipefail                       # NOT -e: one cell must not kill 64 runs
export TIMEOUT=${TIMEOUT:-1800}
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$ROOT/scripts/buildScripts/run_single_tu.sh"
MAN="$ROOT/scripts/nv_detect.manifest"
OUT="$ROOT/results/nv_sweep.csv"
mkdir -p "$ROOT/results"
[ -f "$MAN" ] || { echo "manifest $MAN missing — run nv_detect_all.sh once first"; exit 1; }

BENCHES=(myocyte LU GRAMSCHM cfd ADI gaussian hotspot CORR)
CLASSES=(invalid divzero overflow underflow subnormal)
echo "benchmark,mode,opt,instr,sites,invalid,divzero,overflow,underflow,subnormal" > "$OUT"

fired() { local f="$1" c="$2" col
  [ -f "$f" ] || { echo 0; return; }
  col=$(head -1 "$f" | tr ',' '\n' | grep -nx "$c" | cut -d: -f1)
  [ -n "$col" ] || { echo 0; return; }
  awk -F, -v k="$col" 'NR>1 && $k>0' "$f" | wc -l
}

for mode in fast; do
  for O in 0 1 2 3; do
    for b in "${BENCHES[@]}"; do
      log="$ROOT/results/log_${b}_O${O}_${mode}.txt"
      echo "=== $b  O$O  $mode ==="
      MANIFEST="$MAN" OPT_LEVEL=$O FP_MODE=$mode TAGGED=1 RUNS=1 \
        bash "$RUNNER" "$b" instrumented > "$log" 2>&1
      if ! grep -qE 'counts:.*kernels=[1-9]' "$log"; then
        echo "  !! $b O$O $mode: no completed run — see $log"
        echo "$b,$mode,O$O,FAIL,FAIL,,,,," >> "$OUT"; continue
      fi
      S=$(grep -oE 'scratch=\S+' "$log" | head -1 | cut -d= -f2)
      instr=$(grep -rhE 'instrumented [0-9]+ instruction' "$S"/*.log 2>/dev/null \
                | grep -oE 'instrumented [0-9]+' | grep -oE '[0-9]+' | tail -1)
      instr=${instr:-NA}
      sites=$([ -f "$S/fp_sites.csv" ] && echo $(( $(wc -l < "$S/fp_sites.csv") - 1 )) || echo 0)
      row="$b,$mode,O$O,$instr,$sites"
      for c in "${CLASSES[@]}"; do row+=",$(fired "$S/fp_site_counts.csv" "$c")"; done
      echo "$row" >> "$OUT"
      echo "  -> instr=$instr sites=$sites | ${row#*O$O,}"
    done
  done
done
echo; echo "===== NV SWEEP DONE -> $OUT ====="
column -t -s, "$OUT"
