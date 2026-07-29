#include "hip/hip_runtime.h"
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <math.h>

__global__ void testDivByZero(float *result, int *sign_check,
                               float pos_num, float neg_num,
                               float pos_zero, float neg_zero) {
    int idx = threadIdx.x;

    // Positive / Positive Zero → +Inf
    if (idx == 0) {
        result[0] = pos_num / pos_zero;
        sign_check[0] = signbit(result[0]) ? -1 : 1;
    }

    // Positive / Negative Zero → -Inf
    if (idx == 1) {
        result[1] = pos_num / neg_zero;
        sign_check[1] = signbit(result[1]) ? -1 : 1;
    }

    // Negative / Positive Zero → -Inf
    if (idx == 2) {
        result[2] = neg_num / pos_zero;
        sign_check[2] = signbit(result[2]) ? -1 : 1;
    }

    // Negative / Negative Zero → +Inf
    if (idx == 3) {
        result[3] = neg_num / neg_zero;
        sign_check[3] = signbit(result[3]) ? -1 : 1;
    }

    // 1 / +0 → +Inf
    if (idx == 4) {
        result[4] = 1.0f / pos_zero;
        sign_check[4] = signbit(result[4]) ? -1 : 1;
    }

    // 1 / -0 → -Inf
    if (idx == 5) {
        result[5] = 1.0f / neg_zero;
        sign_check[5] = signbit(result[5]) ? -1 : 1;
    }

    // small+ / +0 → +Inf
    if (idx == 6) {
        result[6] = 0.0001f / pos_zero;
        sign_check[6] = signbit(result[6]) ? -1 : 1;
    }

    // small- / +0 → -Inf
    if (idx == 7) {
        result[7] = -0.0001f / pos_zero;
        sign_check[7] = signbit(result[7]) ? -1 : 1;
    }

    // 0 / 0 → NaN (invalid op, NOT div-by-zero)
    if (idx == 8) {
        result[8] = pos_zero / pos_zero;
        sign_check[8] = 0;
    }
}

int main() {
    const int N = 9;
    float *d_result, h_result[N];
    int *d_sign, h_sign[N];

    hipMalloc(&d_result, N * sizeof(float));
    hipMalloc(&d_sign,   N * sizeof(int));
    hipMemset(d_result, 0, N * sizeof(float));
    hipMemset(d_sign,   0, N * sizeof(int));

    printf("========================================\n");
    printf("[TEST] Division by Zero Exception\n");
    printf("[IEEE 754 Clause 7.3.0]\n");
    printf("========================================\n");
    printf("Rule: x/0 = +/-Inf (sign = XOR of operands)\n");
    printf("Note: 0/0 = NaN (invalid op, not divByZero)\n\n");

    // Pass as runtime arguments so compiler cannot constant-fold
    float h_pos_zero =  0.0f;
    float h_neg_zero = -0.0f;
    float h_pos_num  =  5.0f;
    float h_neg_num  = -5.0f;

    testDivByZero<<<1, N>>>(d_result, d_sign,
                             h_pos_num, h_neg_num,
                             h_pos_zero, h_neg_zero);
    hipDeviceSynchronize();

    hipMemcpy(h_result, d_result, N * sizeof(float), hipMemcpyDeviceToHost);
    hipMemcpy(h_sign,   d_sign,   N * sizeof(int),   hipMemcpyDeviceToHost);

    const char* operations[] = {
        "+5 / +0",
        "+5 / -0",
        "-5 / +0",
        "-5 / -0",
        "+1 / +0",
        "+1 / -0",
        "+0.0001 / +0",
        "-0.0001 / +0",
        "0 / 0 (invalid op)"
    };

    const int expected_signs[] = {1, -1, -1, 1, 1, -1, 1, -1, 0};

    int passed = 0;
    for (int i = 0; i < N; i++) {
        int is_inf = isinf(h_result[i]);
        int is_nan = isnan(h_result[i]);

        printf("[TEST %d] %s\n", i, operations[i]);
        printf("  Result: %f\n", h_result[i]);
        printf("  isInf: %s, Sign: %s\n",
               is_inf ? "YES" : "NO",
               h_sign[i] ==  1 ? "+1" :
               h_sign[i] == -1 ? "-1" : "N/A");

        bool test_passed = false;
        if (i < 8)
            test_passed = (is_inf && h_sign[i] == expected_signs[i]);
        else
            test_passed = is_nan;

        printf("  Expected: %s\n",
               i < 8 ? (expected_signs[i] == 1 ? "+Inf" : "-Inf") : "NaN");
        printf("  Got:      %s\n",
               is_inf ? (h_sign[i] == 1 ? "+Inf" : "-Inf") :
               is_nan ? "NaN" : "???");
        printf("  Status: %s\n\n", test_passed ? "PASS" : "FAIL");

        if (test_passed) passed++;
    }

    printf("========================================\n");
    printf("Summary: %d/%d tests passed\n", passed, N);
    printf("Overall: %s\n", passed == N ? "PASSED" : "FAILED");
    printf("========================================\n");

    hipFree(d_result);
    hipFree(d_sign);
    return 0;
}