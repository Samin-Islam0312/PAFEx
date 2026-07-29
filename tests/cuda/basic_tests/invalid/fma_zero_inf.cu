#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>

__global__ void testInvalidFMA(float *result) {
    int idx = threadIdx.x;
    
    float zero = 0.0f;
    float inf = 1.0f / 0.0f;
    float c = 5.0f;  // Normal finite value
    
    // Invalid operations: FMA(0, ∞, c) → NaN when c is not qNaN
    if (idx == 0) result[0] = fmaf(zero, inf, c);     // FMA(0, +Inf, 5) = NaN
    if (idx == 1) result[1] = fmaf(inf, zero, c);     // FMA(+Inf, 0, 5) = NaN
    if (idx == 2) result[2] = fmaf(zero, -inf, c);    // FMA(0, -Inf, 5) = NaN
    if (idx == 3) result[3] = fmaf(-inf, zero, c);    // FMA(-Inf, 0, 5) = NaN
    
    // When c is already qNaN, behavior is implementation-defined
    float qnan = 0.0f / 0.0f;  // Quiet NaN
    if (idx == 4) result[4] = fmaf(zero, inf, qnan);  // FMA(0, Inf, NaN) - impl defined
}

int main() {
    const int N = 5;
    float *d_result, h_result[N];
    
    cudaMalloc(&d_result, N * sizeof(float));
    cudaMemset(d_result, 0, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Invalid Operation: FMA(0, ∞, c)\n");
    printf("[IEEE 754 Clause 7.2.0.c]\n");
    printf("========================================\n");
    printf("Expected: First 4 results = NaN\n");
    printf("          Last result = implementation defined\n\n");
    
    testInvalidFMA<<<1, N>>>(d_result);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
    
    for (int i = 0; i < N; i++) {
        int is_nan = isnan(h_result[i]);
        printf("[RESULT %d] value = %f, isNaN = %s", 
               i, h_result[i], is_nan ? "YES" : "NO");
        if (i < 4 && is_nan) printf(" ✓");
        else if (i < 4 && !is_nan) printf(" ✗");
        printf("\n");
    }
    
    printf("========================================\n");
    
    cudaFree(d_result);
    return 0;
}