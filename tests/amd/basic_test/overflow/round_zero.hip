#include "hip/hip_runtime.h"
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <float.h>
#include <math.h>

__global__ void testOverflow_RoundZero(float *result) {
    int idx = threadIdx.x;
    
    float large = FLT_MAX;
    
    // IEEE 754 Clause 7.4.0.b: roundTowardZero → largest finite number
    
    if (idx == 0) {
        // Positive overflow → FLT_MAX (saturate, not Inf)
        result[0] = __fadd_rz(large, large);
    }
    
    if (idx == 1) {
        // Positive overflow → FLT_MAX
        result[1] = __fmul_rz(large, 2.0f);
    }
    
    if (idx == 2) {
        // Negative overflow → -FLT_MAX (most negative finite)
        result[2] = __fmul_rz(-large, 2.0f);
    }
    
    if (idx == 3) {
        // FMA overflow → FLT_MAX
        result[3] = __fmaf_rz(large, 1.5f, large);
    }
}

int main() {
    const int N = 4;
    float *d_result, h_result[N];
    
    hipMalloc(&d_result, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Overflow - Round Toward Zero\n");
    printf("[IEEE 754 Clause 7.4.0.b]\n");
    printf("========================================\n");
    printf("Rule: roundTowardZero → largest finite number\n");
    printf("FLT_MAX = %e\n\n", FLT_MAX);
    
    testOverflow_RoundZero<<<1, N>>>(d_result);
    hipDeviceSynchronize();
    
    hipMemcpy(h_result, d_result, N * sizeof(float), hipMemcpyDeviceToHost);
    
    const char* operations[] = {
        "__fadd_rz(FLT_MAX, FLT_MAX)",
        "__fmul_rz(FLT_MAX, 2.0)",
        "__fmul_rz(-FLT_MAX, 2.0)",
        "__fmaf_rz(FLT_MAX, 1.5, FLT_MAX)"
    };
    
    const char* expected[] = {"FLT_MAX", "FLT_MAX", "-FLT_MAX", "FLT_MAX"};
    
    int passed = 0;
    for (int i = 0; i < N; i++) {
        bool is_finite = !isinf(h_result[i]) && !isnan(h_result[i]);
        bool is_max = (fabs(h_result[i]) == FLT_MAX);
        
        printf("[%d] %s\n", i, operations[i]);
        printf("    Result: %e\n", h_result[i]);
        printf("    Is finite: %s, Is FLT_MAX: %s\n", 
               is_finite ? "YES" : "NO",
               is_max ? "YES" : "NO");
        printf("    Expected: %s\n", expected[i]);
        printf("    Status: %s\n\n", (is_finite && is_max) ? "PASS ✓" : "FAIL ✗");
        
        if (is_finite && is_max) passed++;
    }
    
    printf("========================================\n");
    printf("Result: %d/%d tests passed\n", passed, N);
    printf("========================================\n");
    
    hipFree(d_result);
    return 0;
}