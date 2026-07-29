#include "hip/hip_runtime.h"
#include <cstdio>
#include <cmath>
#include <hip/hip_runtime.h>

// even tid -> logbf(0) -> divideByZero (-inf);  odd tid -> logbf(1) -> finite.
// 256 threads => exactly 128 divide-by-zero events expected.
__global__ void testLogBZero(float* out, int* dummy) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    float x = (tid % 2 == 0) ? 0.0f : 1.0f;
    out[tid] = logbf(x);
}

int main() {
    const int N = 256;
    float* d_out; int* d_dummy;
    hipMalloc(&d_out, N * sizeof(float));
    hipMalloc(&d_dummy, sizeof(int));
    testLogBZero<<<1, N>>>(d_out, d_dummy);
    hipDeviceSynchronize();
    hipFree(d_out); hipFree(d_dummy);
    return 0;
}
