#!/bin/bash
# Usage: ./measure.sh <tag>
# Looks for binaries: app_baseline_<tag>, app_quiet_<tag>, app_full_<tag>
# If those don't exist, falls back to: app_baseline, app_quiet, app_full
set -u

TAG=${1:?usage: ./measure.sh <tag>}
ROUNDS=${ROUNDS:-20}
OUTDIR=timing_results/$TAG
mkdir -p $OUTDIR

# Decide which binaries to use
if [ -x "./app_baseline_$TAG" ]; then
    A=./app_baseline_$TAG
    B=./app_quiet_$TAG
    C=./app_full_$TAG
else
    A=./app_baseline
    B=./app_quiet
    C=./app_full
fi

# Sanity check
for bin in $A $B $C; do
    if [ ! -x "$bin" ]; then
        echo "ERROR: $bin missing or not executable"
        exit 1
    fi
done

echo "=========================================="
echo " Measuring: $TAG"
echo " Binaries:  $A  $B  $C"
echo " Rounds:    $ROUNDS (will drop first 2 as warmup)"
echo "=========================================="

> $OUTDIR/baseline.txt
> $OUTDIR/quiet.txt
> $OUTDIR/full.txt

echo "Warming up..."
for i in 1 2 3; do $A > /dev/null 2>&1; done

echo "Measuring..."
for round in $(seq 1 $ROUNDS); do
    printf "  round %2d/%d\n" $round $ROUNDS
    /usr/bin/time -f "%e" $A 2>>$OUTDIR/baseline.txt >/dev/null
    /usr/bin/time -f "%e" $B 2>>$OUTDIR/quiet.txt    >/dev/null
    /usr/bin/time -f "%e" $C 2>>$OUTDIR/full.txt     >/dev/null
done

python3 - "$OUTDIR" "$TAG" << 'PYEOF'
import statistics, sys
outdir, tag = sys.argv[1], sys.argv[2]

print()
print(f"=== Results for: {tag} ===")
print(f"{'Config':<12} {'Median(s)':>10} {'Min(s)':>10} {'Max(s)':>10} {'Stdev(s)':>10}  n")
print("-" * 65)

times_by_cfg = {}
for cfg in ["baseline", "quiet", "full"]:
    with open(f"{outdir}/{cfg}.txt") as f:
        all_times = [float(line.strip()) for line in f if line.strip()]
    times = all_times[2:]
    times_by_cfg[cfg] = times
    med = statistics.median(times)
    print(f"{cfg:<12} {med:>10.4f} {min(times):>10.4f} {max(times):>10.4f} "
          f"{statistics.stdev(times):>10.4f}  {len(times)}")

t_a = statistics.median(times_by_cfg["baseline"])
t_b = statistics.median(times_by_cfg["quiet"])
t_c = statistics.median(times_by_cfg["full"])

print()
print(f"=== Delta analysis ===")
print(f"T_A (baseline)             = {t_a:.4f}s")
print(f"T_B (instrumented quiet)   = {t_b:.4f}s")
print(f"T_C (instrumented full)    = {t_c:.4f}s")
print()
print(f"T_B - T_A (in-kernel cost) = {(t_b - t_a)*1000:.2f} ms  ({(t_b-t_a)/t_a*100:+.1f}% over baseline)")
print(f"T_C - T_B (PAPI/SDE cost)  = {(t_c - t_b)*1000:.2f} ms  ({(t_c-t_b)/t_a*100:+.1f}% over baseline)")
print(f"T_C - T_A (total overhead) = {(t_c - t_a)*1000:.2f} ms  ({(t_c-t_a)/t_a*100:+.1f}% over baseline)")
PYEOF
