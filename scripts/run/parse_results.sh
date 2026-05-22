#!/bin/bash
TAG=${1:?usage: ./parse_results.sh <tag>}
OUTDIR=timing_results/$TAG

python3 - "$OUTDIR" "$TAG" << 'PYEOF'
import statistics, sys
outdir, tag = sys.argv[1], sys.argv[2]

def parse(path):
    times = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                times.append(float(line))
            except ValueError:
                pass  # skip [DBG], "Command exited...", etc.
    return times

print()
print(f"=== Results for: {tag} ===")
print(f"{'Config':<12} {'Median(s)':>10} {'Min(s)':>10} {'Max(s)':>10} {'Stdev(s)':>10}  n")
print("-" * 65)

times_by_cfg = {}
for cfg in ["baseline", "quiet", "full"]:
    all_times = parse(f"{outdir}/{cfg}.txt")
    times = all_times[2:]  # drop warmup
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
