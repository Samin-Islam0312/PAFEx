#include "hip/hip_runtime.h"
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <math.h>

__global__ void testInvalidSqrt(float *result) {
    int idx = threadIdx.x;
    
    // Invalid operations: sqrt of negative numbers → NaN
    if (idx == 0) result[0] = sqrtf(-1.0f);      // sqrt(-1) = NaN
    if (idx == 1) result[1] = sqrtf(-100.0f);    // sqrt(-100) = NaN
    if (idx == 2) result[2] = sqrtf(-0.5f);      // sqrt(-0.5) = NaN
    
    // Valid operations for comparison
    if (idx == 3) result[3] = sqrtf(0.0f);       // sqrt(0) = 0 (valid)
    if (idx == 4) result[4] = sqrtf(-0.0f);      // sqrt(-0) = -0 (valid)
    if (idx == 5) result[5] = sqrtf(4.0f);       // sqrt(4) = 2 (valid)
    
    // Edge case: sqrt of -Inf
    float neg_inf = -1.0f / 0.0f;
    if (idx == 6) result[6] = sqrtf(neg_inf);    // sqrt(-Inf) = NaN
}

int main() {
    const int N = 7;
    float *d_result, h_result[N];
    
    hipMalloc(&d_result, N * sizeof(float));
    hipMemset(d_result, 0, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Invalid Operation: sqrt(x) where x < 0\n");
    printf("[IEEE 754 Clause 7.2.0.g]\n");
    printf("========================================\n");
    printf("Operations:\n");
    printf("  [0] sqrt(-1)\n");
    printf("  [1] sqrt(-100)\n");
    printf("  [2] sqrt(-0.5)\n");
    printf("  [3] sqrt(0) - valid\n");
    printf("  [4] sqrt(-0) - valid\n");
    printf("  [5] sqrt(4) - valid\n");
    printf("  [6] sqrt(-Inf)\n");
    printf("Expected: [0-2,6] = NaN, [3-5] = valid results\n\n");
    
    testInvalidSqrt<<<1, N>>>(d_result);
    hipDeviceSynchronize();
    
    hipMemcpy(h_result, d_result, N * sizeof(float), hipMemcpyDeviceToHost);
    
    for (int i = 0; i < N; i++) {
        int is_nan = isnan(h_result[i]);
        printf("[RESULT %d] value = %f, isNaN = %s", 
               i, h_result[i], is_nan ? "YES" : "NO");
        
        if ((i <= 2 || i == 6) && is_nan) printf(" ✓");
        else if ((i >= 3 && i <= 5) && !is_nan) printf(" ✓");
        else printf(" ✗");
        printf("\n");
    }
    
    printf("========================================\n");
    
    hipFree(d_result);
    return 0;
}