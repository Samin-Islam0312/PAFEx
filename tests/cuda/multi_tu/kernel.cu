#include <cuda_runtime.h>
#include <cstdio>

// Forward declaration — definition lives in helpers.cu
extern __device__ float divide_helper(float a, float b);

__global__ void test_kernel(float *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        // Call into the other TU. divide_helper does a/b where b can be 0.
        float a = (float)(i + 1);
        float b = (float)(i % 2);  // zero on even threads
        out[i] = divide_helper(a, b);
    }
}

int main() {
    const int N = 32;
    float *d_out;
    cudaMalloc(&d_out, N * sizeof(float));
    test_kernel<<<1, N>>>(d_out, N);
    cudaDeviceSynchronize();
    
    float h_out[N];
    cudaMemcpy(h_out, d_out, N * sizeof(float), cudaMemcpyDeviceToHost);
    
    printf("Multi-TU test: results[0..4] = %f %f %f %f %f\n",
           h_out[0], h_out[1], h_out[2], h_out[3], h_out[4]);
    
    cudaFree(d_out);
    return 0;
}