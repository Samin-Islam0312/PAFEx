#include "hip/hip_runtime.h"
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <float.h>
#include <math.h>

__global__ void testOverflow_RoundNearest(float *result) {
    int idx = threadIdx.x;
    
    float large = FLT_MAX;
    
    // IEEE 754 Clause 7.4.0.a: roundTiesToEven carries all overflows to ∞
    
    if (idx == 0) {
        // Positive overflow → +Inf
        result[0] = __fadd_rn(large, large);  // FLT_MAX + FLT_MAX
    }
    
    if (idx == 1) {
        // Positive overflow → +Inf
        result[1] = __fmul_rn(large, 2.0f);   // FLT_MAX × 2
    }
    
    if (idx == 2) {
        // Negative overflow → -Inf
        result[2] = __fmul_rn(-large, 2.0f);  // -FLT_MAX × 2
    }
    
    if (idx == 3) {
        // FMA overflow → +Inf
        result[3] = __fmaf_rn(large, 1.5f, large);  // (FLT_MAX × 1.5) + FLT_MAX
    }
}

int main() {
    const int N = 4;
    float *d_result, h_result[N];
    
    hipMalloc(&d_result, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Overflow - Round to Nearest Even\n");
    printf("[IEEE 754 Clause 7.4.0.a]\n");
    printf("========================================\n");
    printf("Rule: roundTiesToEven → all overflows to ±Inf\n");
    printf("FLT_MAX = %e\n\n", FLT_MAX);
    
    testOverflow_RoundNearest<<<1, N>>>(d_result);
    hipDeviceSynchronize();
    
    hipMemcpy(h_result, d_result, N * sizeof(float), hipMemcpyDeviceToHost);
    
    const char* operations[] = {
        "__fadd_rn(FLT_MAX, FLT_MAX)",
        "__fmul_rn(FLT_MAX, 2.0)",
        "__fmul_rn(-FLT_MAX, 2.0)",
        "__fmaf_rn(FLT_MAX, 1.5, FLT_MAX)"
    };
    
    const char* expected[] = {"+Inf", "+Inf", "-Inf", "+Inf"};
    
    int passed = 0;
    for (int i = 0; i < N; i++) {
        bool is_inf = isinf(h_result[i]);
        bool correct_sign = (i == 2) ? signbit(h_result[i]) : !signbit(h_result[i]);
        
        printf("[%d] %s\n", i, operations[i]);
        printf("    Result: ");
        if (is_inf) {
            printf("%cInf", signbit(h_result[i]) ? '-' : '+');
        } else {
            printf("%e (finite)", h_result[i]);
        }
        printf("\n");
        printf("    Expected: %s\n", expected[i]);
        printf("    Status: %s\n\n", (is_inf && correct_sign) ? "PASS ✓" : "FAIL ✗");
        
        if (is_inf && correct_sign) passed++;
    }
    
    printf("========================================\n");
    printf("Result: %d/%d tests passed\n", passed, N);
    printf("========================================\n");
    
    hipFree(d_result);
    return 0;
}