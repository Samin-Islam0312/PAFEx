# Deferred cleanups (post-paper)

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

Either delete from printer, or add atomic-RMW counters in device pass to populate them.

## 2. Kernels Launched counter is incorrect
The host pass reports "Kernels Launched: 1" but cfd actually runs 14,004 kernels.
Verified by ncu. The counter increment is somewhere wrong in the host pass
(maybe wraps only the first launch site, or counter type/scope issue).

## 3. cfd subnormals — explore if time permits
Try larger meshes (193K, missile.0.2M) to see if any input produces subnormals.
Try with nvcc-compiled cfd as cross-check (would require building GPU-FPX
locally for true apples-to-apples comparison).
