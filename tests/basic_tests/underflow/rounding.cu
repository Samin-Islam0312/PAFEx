#include <stdio.h>
#include <cuda_runtime.h>
#include <float.h>
#include <math.h>

// Helper function to check if a number is denormal/subnormal
__device__ bool is_subnormal(float x) {
    return (x != 0.0f) && (fabsf(x) < FLT_MIN);
}

__global__ void testUnderflow_RoundNearest(float *result, int *is_denormal) {
    int idx = threadIdx.x;
    
    float tiny = FLT_MIN;  // Smallest normalized positive float: 2^-126
    
    // IEEE 754 Clause 7.5.0.a: Underflow when result < FLT_MIN (after rounding)
    
    if (idx == 0) {
        // Division causing underflow → denormal
        result[0] = __fdiv_rn(tiny, 2.0f);  // FLT_MIN / 2
        is_denormal[0] = is_subnormal(result[0]) ? 1 : 0;
    }
    
    if (idx == 1) {
        // Multiplication causing underflow → denormal
        result[1] = __fmul_rn(tiny, 0.5f);  // FLT_MIN × 0.5
        is_denormal[1] = is_subnormal(result[1]) ? 1 : 0;
    }
    
    if (idx == 2) {
        // Severe underflow → might flush to zero or stay denormal
        result[2] = __fmul_rn(tiny, 1e-20f);
        is_denormal[2] = is_subnormal(result[2]) ? 1 : 0;
    }
    
    if (idx == 3) {
        // Subtraction causing underflow (near-equal values)
        float a = tiny * 1.0000001f;
        float b = tiny;
        result[3] = __fsub_rn(a, b);  // Very small difference
        is_denormal[3] = is_subnormal(result[3]) ? 1 : 0;
    }
    
    if (idx == 4) {
        // FMA causing underflow
        result[4] = __fmaf_rn(tiny, 0.25f, 0.0f);  // (FLT_MIN × 0.25) + 0
        is_denormal[4] = is_subnormal(result[4]) ? 1 : 0;
    }
}

__global__ void testUnderflow_RoundZero(float *result, int *is_denormal) {
    int idx = threadIdx.x;
    
    float tiny = FLT_MIN;
    
    // roundTowardZero: underflow → result rounded toward zero
    
    if (idx == 0) {
        result[0] = __fdiv_rz(tiny, 2.0f);
        is_denormal[0] = is_subnormal(result[0]) ? 1 : 0;
    }
    
    if (idx == 1) {
        result[1] = __fmul_rz(tiny, 0.5f);
        is_denormal[1] = is_subnormal(result[1]) ? 1 : 0;
    }
    
    if (idx == 2) {
        // Severe underflow with rz → may flush to zero
        result[2] = __fmul_rz(tiny, 1e-30f);
        is_denormal[2] = is_subnormal(result[2]) ? 1 : 0;
    }
}

__global__ void testUnderflow_RoundUp(float *result, int *is_denormal) {
    int idx = threadIdx.x;
    
    float tiny = FLT_MIN;
    
    // roundTowardPositive: positive underflow rounded up
    
    if (idx == 0) {
        // Positive underflow
        result[0] = __fdiv_ru(tiny, 2.0f);
        is_denormal[0] = is_subnormal(result[0]) ? 1 : 0;
    }
    
    if (idx == 1) {
        result[1] = __fmul_ru(tiny, 0.5f);
        is_denormal[1] = is_subnormal(result[1]) ? 1 : 0;
    }
    
    if (idx == 2) {
        // Negative underflow with ru
        result[2] = __fmul_ru(-tiny, 0.5f);
        is_denormal[2] = is_subnormal(result[2]) ? 1 : 0;
    }
}

__global__ void testUnderflow_RoundDown(float *result, int *is_denormal) {
    int idx = threadIdx.x;
    
    float tiny = FLT_MIN;
    
    // roundTowardNegative: negative underflow rounded down
    
    if (idx == 0) {
        // Positive underflow with rd
        result[0] = __fdiv_rd(tiny, 2.0f);
        is_denormal[0] = is_subnormal(result[0]) ? 1 : 0;
    }
    
    if (idx == 1) {
        // Negative underflow
        result[1] = __fmul_rd(-tiny, 0.5f);
        is_denormal[1] = is_subnormal(result[1]) ? 1 : 0;
    }
    
    if (idx == 2) {
        result[2] = __fmul_rd(-tiny, 0.25f);
        is_denormal[2] = is_subnormal(result[2]) ? 1 : 0;
    }
}

void print_underflow_result(float value, int is_denorm, const char* desc) {
    printf("  %s\n", desc);
    printf("    Value: %e\n", value);
    printf("    Is denormal: %s\n", is_denorm ? "YES" : "NO");
    printf("    Is zero: %s\n", (value == 0.0f) ? "YES" : "NO");
    printf("    Abs < FLT_MIN: %s\n", (fabsf(value) < FLT_MIN && value != 0.0f) ? "YES" : "NO");
}

int main() {
    const int N = 5;
    float *d_result1, *d_result2, *d_result3, *d_result4;
    float h_result1[N], h_result2[3], h_result3[3], h_result4[3];
    int *d_denorm1, *d_denorm2, *d_denorm3, *d_denorm4;
    int h_denorm1[N], h_denorm2[3], h_denorm3[3], h_denorm4[3];
    
    cudaMalloc(&d_result1, N * sizeof(float));
    cudaMalloc(&d_result2, 3 * sizeof(float));
    cudaMalloc(&d_result3, 3 * sizeof(float));
    cudaMalloc(&d_result4, 3 * sizeof(float));
    cudaMalloc(&d_denorm1, N * sizeof(int));
    cudaMalloc(&d_denorm2, 3 * sizeof(int));
    cudaMalloc(&d_denorm3, 3 * sizeof(int));
    cudaMalloc(&d_denorm4, 3 * sizeof(int));
    
    printf("========================================\n");
    printf("[TEST] Underflow Exception\n");
    printf("[IEEE 754 Clause 7.5.0]\n");
    printf("========================================\n");
    printf("FLT_MIN = %e (smallest normalized)\n", FLT_MIN);
    printf("Underflow: result strictly between ±FLT_MIN and 0\n");
    printf("Result: denormal (subnormal) number or flush to zero\n\n");
    
    // Test 1: Round to Nearest
    printf("--- Test 1: Underflow with Round Nearest ---\n");
    testUnderflow_RoundNearest<<<1, N>>>(d_result1, d_denorm1);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result1, d_result1, N * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_denorm1, d_denorm1, N * sizeof(int), cudaMemcpyDeviceToHost);
    
    print_underflow_result(h_result1[0], h_denorm1[0], "__fdiv_rn(FLT_MIN, 2.0)");
    print_underflow_result(h_result1[1], h_denorm1[1], "__fmul_rn(FLT_MIN, 0.5)");
    print_underflow_result(h_result1[2], h_denorm1[2], "__fmul_rn(FLT_MIN, 1e-20)");
    print_underflow_result(h_result1[3], h_denorm1[3], "__fsub_rn(tiny+ε, tiny)");
    print_underflow_result(h_result1[4], h_denorm1[4], "__fmaf_rn(FLT_MIN, 0.25, 0)");
    
    int denorm_count1 = 0;
    for (int i = 0; i < N; i++) denorm_count1 += h_denorm1[i];
    printf("\n  Denormals produced: %d/%d\n", denorm_count1, N);
    
    // Test 2: Round Toward Zero
    printf("\n--- Test 2: Underflow with Round Toward Zero ---\n");
    testUnderflow_RoundZero<<<1, 3>>>(d_result2, d_denorm2);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result2, d_result2, 3 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_denorm2, d_denorm2, 3 * sizeof(int), cudaMemcpyDeviceToHost);
    
    print_underflow_result(h_result2[0], h_denorm2[0], "__fdiv_rz(FLT_MIN, 2.0)");
    print_underflow_result(h_result2[1], h_denorm2[1], "__fmul_rz(FLT_MIN, 0.5)");
    print_underflow_result(h_result2[2], h_denorm2[2], "__fmul_rz(FLT_MIN, 1e-30)");
    
    int denorm_count2 = 0;
    for (int i = 0; i < 3; i++) denorm_count2 += h_denorm2[i];
    printf("\n  Denormals produced: %d/3\n", denorm_count2);
    
    // Test 3: Round Toward Positive
    printf("\n--- Test 3: Underflow with Round Up ---\n");
    testUnderflow_RoundUp<<<1, 3>>>(d_result3, d_denorm3);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result3, d_result3, 3 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_denorm3, d_denorm3, 3 * sizeof(int), cudaMemcpyDeviceToHost);
    
    print_underflow_result(h_result3[0], h_denorm3[0], "__fdiv_ru(+FLT_MIN, 2.0)");
    print_underflow_result(h_result3[1], h_denorm3[1], "__fmul_ru(+FLT_MIN, 0.5)");
    print_underflow_result(h_result3[2], h_denorm3[2], "__fmul_ru(-FLT_MIN, 0.5)");
    
    // Test 4: Round Toward Negative
    printf("\n--- Test 4: Underflow with Round Down ---\n");
    testUnderflow_RoundDown<<<1, 3>>>(d_result4, d_denorm4);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result4, d_result4, 3 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_denorm4, d_denorm4, 3 * sizeof(int), cudaMemcpyDeviceToHost);
    
    print_underflow_result(h_result4[0], h_denorm4[0], "__fdiv_rd(+FLT_MIN, 2.0)");
    print_underflow_result(h_result4[1], h_denorm4[1], "__fmul_rd(-FLT_MIN, 0.5)");
    print_underflow_result(h_result4[2], h_denorm4[2], "__fmul_rd(-FLT_MIN, 0.25)");
    
    printf("\n========================================\n");
    printf("Summary:\n");
    printf("  Underflow detected when: 0 < |result| < FLT_MIN\n");
    printf("  Result options:\n");
    printf("    1. Denormal/subnormal number (gradual underflow)\n");
    printf("    2. Flush to zero (FTZ mode)\n");
    printf("  Your pass should detect all underflow-causing operations\n");
    printf("========================================\n");
    
    cudaFree(d_result1); cudaFree(d_result2);
    cudaFree(d_result3); cudaFree(d_result4);
    cudaFree(d_denorm1); cudaFree(d_denorm2);
    cudaFree(d_denorm3); cudaFree(d_denorm4);
    
    return 0;
}