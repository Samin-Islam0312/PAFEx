#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>

__global__ void testInvalidMul(float *result) {
    int idx = threadIdx.x;
    
    float zero = 0.0f;
    float inf = 1.0f / 0.0f;  // Create +Infinity
    
    // Invalid operations: 0 × ∞ → NaN
    if (idx == 0) result[0] = zero * inf;      // 0 × +Inf = NaN
    if (idx == 1) result[1] = inf * zero;      // +Inf × 0 = NaN
    if (idx == 2) result[2] = zero * (-inf);   // 0 × -Inf = NaN
    if (idx == 3) result[3] = (-inf) * zero;   // -Inf × 0 = NaN
}

int main() {
    const int N = 4;
    float *d_result, h_result[N];
    
    cudaMalloc(&d_result, N * sizeof(float));
    cudaMemset(d_result, 0, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Invalid Operation: 0 × ∞\n");
    printf("[IEEE 754 Clause 7.2.0.b]\n");
    printf("========================================\n");
    printf("Expected: All results should be NaN\n\n");
    
    testInvalidMul<<<1, N>>>(d_result);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
    
    int nan_count = 0;
    for (int i = 0; i < N; i++) {
        int is_nan = isnan(h_result[i]);
        nan_count += is_nan;
        printf("[RESULT %d] value = %f, isNaN = %s\n", 
               i, h_result[i], is_nan ? "YES ✓" : "NO ✗");
    }
    
    printf("\nSummary: %d/%d results are NaN\n", nan_count, N);
    printf("Test %s\n", (nan_count == N) ? "PASSED ✓" : "FAILED ✗");
    printf("========================================\n");
    
    cudaFree(d_result);
    return 0;
}