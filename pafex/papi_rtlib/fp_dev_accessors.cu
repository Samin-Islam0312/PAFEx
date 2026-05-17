// fp_dev_accessors.cu
// Accessors for the pass-defined device counters. Compiled with
// --cuda-host-only + -fcuda-include-gpubinary instrumented.fatbin so
// clang generates host shadows + __cudaRegisterVar calls against the
// kernel's fatbin. The pass provides the device-side definitions.

#include <cuda_runtime.h>
#include <stdio.h>

// NOTE: no `extern` — with --cuda-host-only, this generates host shadow
// DEFINITIONS that __cudaRegisterVar binds to the device symbols inside
// instrumented.fatbin. With `extern`, only unresolved references would
// be emitted, and the host linker would fail.
__device__ unsigned long long fp_invalid_counter;
__device__ unsigned long long fp_divbyzero_counter;
__device__ unsigned long long fp_overflow_counter;
__device__ unsigned long long fp_underflow_counter;
__device__ unsigned long long fp_total_counter;
__device__ unsigned long long fp_subnormal_counter;

#define READ_ONE(out, sym)                                                     \
    do {                                                                       \
        cudaError_t e = cudaMemcpyFromSymbol(                                  \
            (out), (sym), sizeof(unsigned long long));                         \
        if (e != cudaSuccess) {                                                \
            fprintf(stderr, "[FP_DEV] read %s failed: %s\n",                   \
                    #sym, cudaGetErrorString(e));                              \
            return e;                                                          \
        }                                                                      \
    } while (0)

#define RESET_ONE(sym)                                                         \
    do {                                                                       \
        unsigned long long z = 0;                                              \
        cudaError_t e = cudaMemcpyToSymbol(                                    \
            (sym), &z, sizeof(unsigned long long));                            \
        if (e != cudaSuccess) {                                                \
            fprintf(stderr, "[FP_DEV] reset %s failed: %s\n",                  \
                    #sym, cudaGetErrorString(e));                              \
            return e;                                                          \
        }                                                                      \
    } while (0)

extern "C" cudaError_t fp_read_counters(
    unsigned long long *invalid,
    unsigned long long *divzero,
    unsigned long long *overflow,
    unsigned long long *underflow,
    unsigned long long *total,
    unsigned long long *subnormal)
{
    READ_ONE(invalid,   fp_invalid_counter);
    READ_ONE(divzero,   fp_divbyzero_counter);
    READ_ONE(overflow,  fp_overflow_counter);
    READ_ONE(underflow, fp_underflow_counter);
    READ_ONE(total,     fp_total_counter);
    READ_ONE(subnormal, fp_subnormal_counter);
    return cudaSuccess;
}

extern "C" cudaError_t fp_reset_counters(void) {
    RESET_ONE(fp_invalid_counter);
    RESET_ONE(fp_divbyzero_counter);
    RESET_ONE(fp_overflow_counter);
    RESET_ONE(fp_underflow_counter);
    RESET_ONE(fp_total_counter);
    RESET_ONE(fp_subnormal_counter);
    return cudaSuccess;
}
