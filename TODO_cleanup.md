### Current Status

- Generic build_bench.sh script for any single-TU Rodinia kernel
- 3 benchmarks measured: hotspot 27x, gaussian 3-5x, cfd 51x
- FTZ disable flag added for accurate subnormal detection
- cfd produces 0 exceptions despite GPU-FPX reporting 13 subnormals
  (compile-time difference between clang and nvcc)

Next: warp-level dedup 
Then: multi-TU host pass for backprop/myocyte, LULESH, MiniFE
Then: FTZ at cfd with disabling the option
Then: XSBench, and if MiniFE doesnt work try out MiniMD

# Some cleanups 
## 1. Runtime printer (fp_sde_counters.cpp or wherever the [FP_INSTRUMENT] Summary lives)
Remove or implement these metrics that currently print as 0:
- Total FP Ops
- Operations Total
- NaNs (Input)
- NaNs (Created)
- Denormals Produced
- Subnormal Rate
- NaN Prop Rate
- Instability Score

Either delete from printer, or add atomic-RMW counters in device pass

## 2. Kernels Launched counter is incorrect
The host pass reports "Kernels Launched: 1" but cfd actually runs 14,004 kernels.
Verified by ncu. The counter increment is somewhere wrong in the host pass
(maybe wraps only the first launch site, or counter type/scope issue).

## 3. cfd subnormals — explore if time permits
Try larger meshes (193K, missile.0.2M) to see if any input produces subnormals.
Try with nvcc-compiled cfd as cross-check (would require building GPU-FPX
locally for true apples-to-apples comparison).
