#include "hip/hip_runtime.h"
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <float.h>
#include <math.h>

__global__ void testOverflow_RoundPositive(float *result) {
    int idx = threadIdx.x;
    
    float large = FLT_MAX;
    
    // IEEE 754 Clause 7.4.0.d:
    // roundTowardPositive:
    //   - positive overflow → +Inf
    //   - negative overflow → -FLT_MAX
    
    if (idx == 0) {
        // POSITIVE overflow → +Inf
        result[0] = __fadd_ru(large, large);
    }
    
    if (idx == 1) {
        // POSITIVE overflow → +Inf
        result[1] = __fmul_ru(large, 2.0f);
    }
    
    if (idx == 2) {
        // NEGATIVE overflow → -FLT_MAX (saturate, not -Inf)
        result[2] = __fmul_ru(-large, 2.0f);
    }
    
    if (idx == 3) {
        // NEGATIVE overflow → -FLT_MAX
        result[3] = __fadd_ru(-large, -large);
    }
}

int main() {
    const int N = 4;
    float *d_result, h_result[N];
    
    hipMalloc(&d_result, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Overflow - Round Toward Positive\n");
    printf("[IEEE 754 Clause 7.4.0.d]\n");
    printf("========================================\n");
    printf("Rule: roundTowardPositive:\n");
    printf("  - Positive overflow → +Inf\n");
    printf("  - Negative overflow → -FLT_MAX\n");
    printf("FLT_MAX = %e\n\n", FLT_MAX);
    
    testOverflow_RoundPositive<<<1, N>>>(d_result);
    hipDeviceSynchronize();
    
    hipMemcpy(h_result, d_result, N * sizeof(float), hipMemcpyDeviceToHost);
    
    const char* operations[] = {
        "__fadd_ru(+FLT_MAX, +FLT_MAX)",
        "__fmul_ru(+FLT_MAX, 2.0)",
        "__fmul_ru(-FLT_MAX, 2.0)",
        "__fadd_ru(-FLT_MAX, -FLT_MAX)"
    };
    
    const char* expected[] = {"+Inf", "+Inf", "-FLT_MAX", "-FLT_MAX"};
    const bool expect_inf[] = {true, true, false, false};
    
    int passed = 0;
    for (int i = 0; i < N; i++) {
        bool is_inf = isinf(h_result[i]);
        bool is_finite = !is_inf && !isnan(h_result[i]);
        
        printf("[%d] %s\n", i, operations[i]);
        printf("    Result: ");
        if (is_inf) {
            printf("%cInf\n", signbit(h_result[i]) ? '-' : '+');
        } else {
            printf("%e (finite)\n", h_result[i]);
        }
        printf("    Expected: %s\n", expected[i]);
        
        bool test_passed = false;
        if (expect_inf[i]) {
            test_passed = (is_inf && !signbit(h_result[i]));  // Must be +Inf
        } else {
            test_passed = (is_finite && fabs(h_result[i]) == FLT_MAX);
        }
        
        printf("    Status: %s\n\n", test_passed ? "PASS ✓" : "FAIL ✗");
        if (test_passed) passed++;
    }
    
    printf("========================================\n");
    printf("Result: %d/%d tests passed\n", passed, N);
    printf("========================================\n");
    
    hipFree(d_result);
    return 0;
}