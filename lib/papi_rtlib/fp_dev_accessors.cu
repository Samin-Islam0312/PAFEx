// fp_dev_accessors.cu
// Compiled with --cuda-host-only + -fcuda-include-gpubinary instrumented.fatbin
// so clang generates a host shadow + __cudaRegisterVar call against the
// device-side fp_counters array (defined in fp_deviceCounters.cu).

#include <cuda_runtime.h>
#include <stdio.h>
#include <string.h>

// NOTE: no `extern` — with --cuda-host-only, this declares the host shadow
// that __cudaRegisterVar will bind to the device symbol in the fatbin.
__device__ unsigned long long fp_counters[6];

extern "C" cudaError_t fp_read_counters(
    unsigned long long *invalid,
    unsigned long long *divzero,
    unsigned long long *overflow,
    unsigned long long *underflow,
    unsigned long long *total,
    unsigned long long *subnormal)
{
    unsigned long long buf[6] = {0};
    cudaError_t e = cudaMemcpyFromSymbol(
        buf, fp_counters, sizeof(buf));
    if (e != cudaSuccess) {
        fprintf(stderr, "[FP_DEV] read fp_counters failed: %s\n",
                cudaGetErrorString(e));
        return e;
    }
    *invalid   = buf[0];
    *divzero   = buf[1];
    *overflow  = buf[2];
    *underflow = buf[3];
    *total     = buf[4];
    *subnormal = buf[5];
    return cudaSuccess;
}

extern "C" cudaError_t fp_reset_counters(void) {
    unsigned long long zeros[6] = {0, 0, 0, 0, 0, 0};
    cudaError_t e = cudaMemcpyToSymbol(
        fp_counters, zeros, sizeof(zeros));
    if (e != cudaSuccess) {
        fprintf(stderr, "[FP_DEV] reset fp_counters failed: %s\n",
                cudaGetErrorString(e));
        return e;
    }
    return cudaSuccess;
}