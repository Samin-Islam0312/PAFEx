#include <stdio.h>
#include <cuda_runtime.h>
#include <math.h>

__global__ void testInvalidDiv(float *result) {
    int idx = threadIdx.x;
    
    float zero = 0.0f;
    float pos_inf = 1.0f / 0.0f;
    float neg_inf = -1.0f / 0.0f;
    
    // Invalid operations: 0/0 and Inf/Inf → NaN
    if (idx == 0) result[0] = zero / zero;         // 0 / 0 = NaN
    if (idx == 1) result[1] = pos_inf / pos_inf;   // +Inf / +Inf = NaN
    if (idx == 2) result[2] = neg_inf / neg_inf;   // -Inf / -Inf = NaN
    if (idx == 3) result[3] = pos_inf / neg_inf;   // +Inf / -Inf = NaN
    if (idx == 4) result[4] = neg_inf / pos_inf;   // -Inf / +Inf = NaN
    
    // Note: division by zero with non-zero numerator produces Inf, not NaN
    if (idx == 5) result[5] = 1.0f / zero;         // 1 / 0 = +Inf (valid!)
}

int main() {
    const int N = 6;
    float *d_result, h_result[N];
    
    cudaMalloc(&d_result, N * sizeof(float));
    cudaMemset(d_result, 0, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Invalid Operation: 0/0 and Inf/Inf\n");
    printf("[IEEE 754 Clause 7.2.0.e]\n");
    printf("========================================\n");
    printf("Operations:\n");
    printf("  [0] 0 / 0\n");
    printf("  [1] +Inf / +Inf\n");
    printf("  [2] -Inf / -Inf\n");
    printf("  [3] +Inf / -Inf\n");
    printf("  [4] -Inf / +Inf\n");
    printf("  [5] 1 / 0 (valid - should be Inf)\n");
    printf("Expected: [0-4] = NaN, [5] = Inf\n\n");
    
    testInvalidDiv<<<1, N>>>(d_result);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
    
    for (int i = 0; i < N; i++) {
        int is_nan = isnan(h_result[i]);
        int is_inf = isinf(h_result[i]);
        printf("[RESULT %d] value = %f, isNaN = %s, isInf = %s", 
               i, h_result[i], is_nan ? "YES" : "NO", is_inf ? "YES" : "NO");
        
        if (i < 5 && is_nan) printf(" ✓");
        else if (i == 5 && is_inf) printf(" ✓");
        else printf(" ✗");
        printf("\n");
    }
    
    printf("========================================\n");
    
    cudaFree(d_result);
    return 0;
}