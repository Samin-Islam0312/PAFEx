#include <stdio.h>
#include <cuda_runtime.h>
#include <float.h>
#include <math.h>

__global__ void testOverflow_RoundNegative(float *result) {
    int idx = threadIdx.x;
    
    float large = FLT_MAX;
    
    // IEEE 754 Clause 7.4.0.c:
    // roundTowardNegative:
    //   - positive overflow → FLT_MAX
    //   - negative overflow → -Inf
    
    if (idx == 0) {
        // POSITIVE overflow → FLT_MAX (saturate, not Inf)
        result[0] = __fadd_rd(large, large);
    }
    
    if (idx == 1) {
        // POSITIVE overflow → FLT_MAX
        result[1] = __fmul_rd(large, 2.0f);
    }
    
    if (idx == 2) {
        // NEGATIVE overflow → -Inf
        result[2] = __fmul_rd(-large, 2.0f);
    }
    
    if (idx == 3) {
        // NEGATIVE overflow → -Inf
        result[3] = __fadd_rd(-large, -large);
    }
}

int main() {
    const int N = 4;
    float *d_result, h_result[N];
    
    cudaMalloc(&d_result, N * sizeof(float));
    
    printf("========================================\n");
    printf("[TEST] Overflow - Round Toward Negative\n");
    printf("[IEEE 754 Clause 7.4.0.c]\n");
    printf("========================================\n");
    printf("Rule: roundTowardNegative:\n");
    printf("  - Positive overflow → FLT_MAX\n");
    printf("  - Negative overflow → -Inf\n");
    printf("FLT_MAX = %e\n\n", FLT_MAX);
    
    testOverflow_RoundNegative<<<1, N>>>(d_result);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
    
    const char* operations[] = {
        "__fadd_rd(+FLT_MAX, +FLT_MAX)",
        "__fmul_rd(+FLT_MAX, 2.0)",
        "__fmul_rd(-FLT_MAX, 2.0)",
        "__fadd_rd(-FLT_MAX, -FLT_MAX)"
    };
    
    const char* expected[] = {"FLT_MAX", "FLT_MAX", "-Inf", "-Inf"};
    const bool expect_inf[] = {false, false, true, true};
    
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
            test_passed = (is_inf && signbit(h_result[i]));  // Must be -Inf
        } else {
            test_passed = (is_finite && fabs(h_result[i]) == FLT_MAX);
        }
        
        printf("    Status: %s\n\n", test_passed ? "PASS ✓" : "FAIL ✗");
        if (test_passed) passed++;
    }
    
    printf("========================================\n");
    printf("Result: %d/%d tests passed\n", passed, N);
    printf("========================================\n");
    
    cudaFree(d_result);
    return 0;
}