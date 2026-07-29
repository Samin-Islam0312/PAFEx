#include "hip/hip_runtime.h"
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <math.h>

__global__ void testLogBZero(float *result, int *sign_check) {
    int idx = threadIdx.x;
    
    // logB(0) when logBFormat is floating-point → -Inf
    // Note: CUDA provides logbf() function
    
    if (idx == 0) {
        result[0] = logbf(0.0f);   // logB(+0) = -Inf
        sign_check[0] = signbit(result[0]) ? -1 : 1;
    }
    
    if (idx == 1) {
        result[1] = logbf(-0.0f);  // logB(-0) = -Inf
        sign_check[1] = signbit(result[1]) ? -1 : 1;
    }
    
    // For comparison: valid logB operations
    if (idx == 2) {
        result[2] = logbf(1.0f);   // logB(1) = 0
        sign_check[2] = 0;
    }
    
    if (idx == 3) {
        result[3] = logbf(8.0f);   // logB(8) = 3 (8 = 2^3)
        sign_check[3] = 0;
    }
}

int main() {
    const int N = 4;
    float *d_result, h_result[N];
    int *d_sign, h_sign[N];
    
    hipMalloc(&d_result, N * sizeof(float));
    hipMalloc(&d_sign, N * sizeof(int));
    hipMemset(d_result, 0, N * sizeof(float));
    hipMemset(d_sign, 0, N * sizeof(int));
    
    printf("========================================\n");
    printf("[TEST] logB(0) Division by Zero\n");
    printf("[IEEE 754 Clause 7.3.0 - second bullet]\n");
    printf("========================================\n");
    printf("Rule: logB(0) = -Inf when result is FP format\n\n");
    
    testLogBZero<<<1, N>>>(d_result, d_sign);
    hipDeviceSynchronize();
    
    hipMemcpy(h_result, d_result, N * sizeof(float), hipMemcpyDeviceToHost);
    hipMemcpy(h_sign, d_sign, N * sizeof(int), hipMemcpyDeviceToHost);
    
    const char* operations[] = {
        "logB(+0)",
        "logB(-0)",
        "logB(1) - valid",
        "logB(8) - valid"
    };
    
    for (int i = 0; i < N; i++) {
        int is_inf = isinf(h_result[i]);
        
        printf("[TEST %d] %s\n", i, operations[i]);
        printf("  Result: %f\n", h_result[i]);
        printf("  isInf: %s, Sign: %s\n", 
               is_inf ? "YES" : "NO",
               h_sign[i] == -1 ? "NEGATIVE" : (h_sign[i] == 1 ? "POSITIVE" : "N/A"));
        
        if (i < 2) {
            printf("  Expected: -Inf, Got: %s\n", 
                   (is_inf && h_sign[i] == -1) ? "-Inf ✓" : "??? ✗");
        } else {
            printf("  Expected: Finite value, Got: %s ✓\n",
                   !is_inf ? "Finite" : "Inf");
        }
        printf("\n");
    }
    
    printf("========================================\n");
    
    hipFree(d_result);
    hipFree(d_sign);
    return 0;
}