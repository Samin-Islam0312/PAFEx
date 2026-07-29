#include <cstdio>
#include <cmath>
#include <cuda_runtime.h>

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
    cudaMalloc(&d_out, N * sizeof(float));
    cudaMalloc(&d_dummy, sizeof(int));
    testLogBZero<<<1, N>>>(d_out, d_dummy);
    cudaDeviceSynchronize();
    cudaFree(d_out); cudaFree(d_dummy);
    return 0;
}
