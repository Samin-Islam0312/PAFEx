# Thrust/CUB Incompatibility

## Symptom
XSBench, LULESH build successfully through our pipeline but fail at runtime:
  cudaErrorSymbolNotFound: named symbol not found

## Diagnosis
LULESH merged.cubin: CUB symbols mangled as CUB_200700_800_NS
LULESH host bitcode: CUB device stubs mangled as CUB_200700_520_NS
Source preprocessor shows both sides reading CUB 1.15 (101500), so the
version skew comes from somewhere in Clang's internal CUDA header injection,
not from user source includes.

## Attempts
- Approach 1 (embed merged fatbin in every TU): same failure, confirmed
  not a registration-ordering issue.
- Approach 2 (nvcc-style per-TU fatbin + device-linker stub): architecturally
  identified, requires substantial pipeline restructure (1-2 days), deferred.

## Status
Documented as paper limitation. Both apps successfully build and instrument
through the pipeline; runtime fails on first Thrust kernel launch.
