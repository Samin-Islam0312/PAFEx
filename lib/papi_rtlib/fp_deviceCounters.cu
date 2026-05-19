#include <cuda_runtime.h>

// Matched to the PAPI driver, types matched to the LLVM i64 injection.
// __device__ unsigned long long fp_total_counter      = 0;
// __device__ unsigned long long fp_divbyzero_counter  = 0;
// __device__ unsigned long long fp_invalid_counter    = 0;
// __device__ unsigned long long fp_overflow_counter   = 0;
// __device__ unsigned long long fp_underflow_counter  = 0;
// __device__ unsigned long long fp_subnormal_counter  = 0;
// Single coalesced counter array. Index mapping:
//   [0] = invalid
//   [1] = divbyzero
//   [2] = overflow
//   [3] = underflow
//   [4] = total       (reserved; not currently incremented)
//   [5] = subnormal   (reserved; not currently incremented)
__device__ unsigned long long fp_counters[6] = {0, 0, 0, 0, 0, 0};