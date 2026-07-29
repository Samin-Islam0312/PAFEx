#include "hip/hip_runtime.h"
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <math.h>

__global__ void testInvalidInfSub(float *result) {
    int idx = threadIdx.x;
    
    float pos_inf = 1.0f / 0.0f;   // +Infinity
    float neg_inf = -1.0f / 0.0f;  // -Infinity
    
    // Invalid operations: magnitude subtraction of infinities → NaN
    if (idx == 0) result[0] = pos_inf + neg_inf;  // +Inf + (-Inf) = NaN
    if (idx == 1) result[1] = pos_inf - pos_inf;  // +Inf - (+Inf) = NaN
    if (idx == 2) result[2] = neg_inf - neg_inf;  // -Inf - (-Inf) = NaN
    if (idx == 3) result[3] = neg_inf + pos_inf;  // -Inf + (+Inf) = NaN
    
    // FMA version: FMA(a, b, c) where a*b and c cancel infinities
    if (idx == 4) {
        result[4] = fmaf(2.0f, pos_inf, neg_inf);  // 2×(+Inf) + (-Inf) = NaN
    }
}

int main() {
    const int N = 5;
    float *d_result, h_result[N];
    
    hipMalloc(&d_result, N * sizeof(float));
    hipMemset(d_result, 0, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Invalid Operation: Inf - Inf\n");
    printf("[IEEE 754 Clause 7.2.0.d]\n");
    printf("========================================\n");
    printf("Operations:\n");
    printf("  [0] +Inf + (-Inf)\n");
    printf("  [1] +Inf - (+Inf)\n");
    printf("  [2] -Inf - (-Inf)\n");
    printf("  [3] -Inf + (+Inf)\n");
    printf("  [4] FMA(2, +Inf, -Inf)\n");
    printf("Expected: All results = NaN\n\n");
    
    testInvalidInfSub<<<1, N>>>(d_result);
    hipDeviceSynchronize();
    
    hipMemcpy(h_result, d_result, N * sizeof(float), hipMemcpyDeviceToHost);
    
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
    
    hipFree(d_result);
    return 0;
}