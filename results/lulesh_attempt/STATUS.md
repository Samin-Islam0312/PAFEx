# LULESH Integration Attempt

## Result
- Build: SUCCEEDED through our pipeline (instrumented multi-TU build)
- Runtime: FAILED with cudaErrorSymbolNotFound on first Thrust kernel launch
- Error: thrust::system::system_error in parallel_for, cudaErrorSymbolNotFound

## Root cause
LULESH uses Thrust device_vector/host_vector heavily (vector.h defines
Vector_d : public thrust::device_vector<T> as the primary data container).
Thrust's runtime symbol resolution requires per-TU __cudaRegisterFunction
calls bound to per-TU fatbins. Our merged-fatbin pipeline produces a single
fatbin with all device symbols, but the host-side registration in each TU
expects its own fatbin layout, so symbol lookup fails at first kernel launch.

## Same class of failure as XSBench
XSBench (which uses thrust::reduce for histogram aggregation) exhibits
identical runtime failure mode. Confirmed Thrust-+-merged-fatbin incompatibility
is structural, not specific to either app.

## What's needed to fix
Restructure pipeline to preserve per-TU fatbin generation (substantial
rewrite — multiple days). Deferred to future work for SBAC-PAD submission.
