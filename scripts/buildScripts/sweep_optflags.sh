#!/usr/bin/env bash
# ============================================================================
# sweep_optflags.sh — observe how exception counts change across optimization
# levels. Varies ONLY the optimization applied before the pass; the pass and
# everything downstream stay identical. Scrapes the [DBG] aggregate-count line
# (which prints before the known read-back crash) into one CSV.
#
# Usage:  ./sweep_optflags.sh <benchmark_name>
# Output: sweep_results.csv  (one row per config)
#
# HOW IT WORKS
# Your pipeline produces a linked device bitcode, then runs your pass on it.
# We insert one `opt` stage between those two points that applies the config's
# optimization. To do that, this script needs the path to the device bitcode
# that is fed INTO your pass. Set DEVICE_IN below to that file (the input to
# the `opt -passes="fp-exception"` step in run_single_tu.sh — likely
# device_preopt.bc or device_linked.bc in the scratch dir).
# ============================================================================
set -uo pipefail

BENCH="${1:?usage: ./sweep_optflags.sh <benchmark_name>}"
OPT="$HOME/opt/llvm-22/bin/opt"
RUNNER="./scripts/buildScripts/run_single_tu.sh"
OUT="sweep_results.csv"

# Config name -> opt pass pipeline applied BEFORE your pass.
# fastmath = O2 plus the no-nan/no-inf/contract assumptions; if your opt build
# ignores these at IR level, that row will match O2 — note it as a finding.
declare -A CFG=(
  [O0]="default<O0>"
  [O2]="default<O2>"
  [O3]="default<O3>"
  [fastmath]="default<O2>"
)
FASTMATH_EXTRA="-enable-no-nans-fp-math -enable-no-infs-fp-math -fp-contract=fast"

echo "config,invalid,divzero,overflow,underflow,total,subnormal" > "$OUT"

for NAME in O0 O2 O3 fastmath; do
  echo "=== config: $NAME ==="

  # 1) Run your normal pipeline once so the scratch dir + device bitcode exist.
  MANIFEST=./scripts/buildScripts/sweep.manifest "$RUNNER" "$BENCH" unstaged >/dev/null 2>&1

  S="scratch/$BENCH/unstaged"
  DEVICE_IN="$S/device_preopt.bc"   # <-- WIRE THIS to the actual input to your pass

  # 2) Apply this config's optimization to that bitcode (the only thing varying).
  EXTRA=""; [ "$NAME" = "fastmath" ] && EXTRA="$FASTMATH_EXTRA"
  "$OPT" -passes="${CFG[$NAME]}" $EXTRA "$DEVICE_IN" -o "$S/device_opt_$NAME.bc"

  # 3) Re-run the rest of your pipeline starting from the optimized bitcode.
  #    Easiest: overwrite the pass-input file, then re-run the pipeline; it will
  #    instrument the optimized version. (If run_single_tu.sh always regenerates
  #    device_preopt.bc, add an env hook there to skip regeneration and instead
  #    use $S/device_opt_$NAME.bc — one `if [ -n "$PREOPT_OVERRIDE" ]` guard.)
  cp "$S/device_opt_$NAME.bc" "$DEVICE_IN"
  PREOPT_OVERRIDE="$DEVICE_IN" MANIFEST=./scripts/buildScripts/sweep.manifest \
    "$RUNNER" "$BENCH" unstaged > "$S/sweep_$NAME.log" 2>&1

  # 4) Scrape the six counts from the [DBG] line (prints before the crash).
  LINE=$(grep -m1 '\[DBG\]' "$S/sweep_$NAME.log")
  if [ -z "$LINE" ]; then
    echo "  WARN: no [DBG] line for $NAME — check $S/sweep_$NAME.log"
    echo "$NAME,NA,NA,NA,NA,NA,NA" >> "$OUT"
    continue
  fi
  # parse "invalid=0 divzero=128 overflow=0 underflow=0 total=256 subnormal=0"
  vals=$(echo "$LINE" | grep -oE '[a-z]+=[0-9]+' | cut -d= -f2 | paste -sd,)
  echo "$NAME,$vals" >> "$OUT"
  echo "  $LINE"
done

echo
echo "=== results ==="
column -t -s, "$OUT"
echo
echo "Saved: $OUT"
echo "Report raw counts AND 'total' (operation count) together, not a ratio."
