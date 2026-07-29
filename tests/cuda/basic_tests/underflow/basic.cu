#include <stdio.h>
#include <cuda_runtime.h>
#include <float.h>
#include <math.h>

__device__ bool is_subnormal(float x) {
    return (x != 0.0f) && (fabsf(x) < FLT_MIN);
}

__global__ void testUnderflow_Operations(float *result, int *is_denorm) {
    int idx = threadIdx.x;
    
    float tiny = FLT_MIN;  // 2^-126 ≈ 1.175494e-38
    
    // Different operations that cause underflow
    
    if (idx == 0) {
        // DIVISION by large number → underflow
        result[0] = tiny / 100.0f;
        is_denorm[0] = is_subnormal(result[0]) ? 1 : 0;
    }
    
    if (idx == 1) {
        // MULTIPLICATION by small number → underflow
        result[1] = tiny * 0.01f;
        is_denorm[1] = is_subnormal(result[1]) ? 1 : 0;
    }
    
    if (idx == 2) {
        // SUBTRACTION of nearly equal values → underflow (cancellation)
        float a = FLT_MIN + FLT_MIN * 0.1f;
        float b = FLT_MIN;
        result[2] = a - b;  // Result: FLT_MIN * 0.1 (denormal)
        is_denorm[2] = is_subnormal(result[2]) ? 1 : 0;
    }
    
    if (idx == 3) {
        // ADDITION of denormals
        float denorm = FLT_MIN / 10.0f;
        result[3] = denorm + denorm;
        is_denorm[3] = is_subnormal(result[3]) ? 1 : 0;
    }
    
    if (idx == 4) {
        // SQUARE ROOT of very small number → underflow
        result[4] = sqrtf(tiny);  // sqrt(FLT_MIN) is still small
        is_denorm[4] = is_subnormal(result[4]) ? 1 : 0;
    }
    
    if (idx == 5) {
        // EXPONENTIAL causing underflow
        result[5] = expf(-100.0f);  // e^-100 is extremely small
        is_denorm[5] = is_subnormal(result[5]) ? 1 : 0;
    }
    
    if (idx == 6) {
        // POWER causing underflow
        result[6] = powf(0.1f, 40.0f);  // 0.1^40 is tiny
        is_denorm[6] = is_subnormal(result[6]) ? 1 : 0;
    }
    
    if (idx == 7) {
        // LOG of number very close to 1
        result[7] = logf(1.0f + FLT_MIN);  // log(1+ε) ≈ ε for small ε
        is_denorm[7] = is_subnormal(result[7]) ? 1 : 0;
    }
}

int main() {
    const int N = 8;
    float *d_result, h_result[N];
    int *d_denorm, h_denorm[N];
    
    cudaMalloc(&d_result, N * sizeof(float));
    cudaMalloc(&d_denorm, N * sizeof(int));
    
    printf("========================================\n");
    printf("[TEST] Underflow - Different Operations\n");
    printf("[IEEE 754 Clause 7.5.0]\n");
    printf("========================================\n");
    printf("FLT_MIN = %e\n", FLT_MIN);
    printf("Testing: DIV, MUL, SUB, ADD, SQRT, EXP, POW, LOG\n\n");
    
    testUnderflow_Operations<<<1, N>>>(d_result, d_denorm);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_denorm, d_denorm, N * sizeof(int), cudaMemcpyDeviceToHost);
    
    const char* operations[] = {
        "FLT_MIN / 100",
        "FLT_MIN × 0.01",
        "(FLT_MIN + ε) - FLT_MIN",
        "denorm + denorm",
        "sqrt(FLT_MIN)",
        "exp(-100)",
        "pow(0.1, 40)",
        "log(1 + FLT_MIN)"
    };
    
    int underflow_count = 0;
    for (int i = 0; i < N; i++) {
        bool is_underflow = (h_denorm[i] == 1) || (h_result[i] == 0.0f && i < 7);
        if (is_underflow) underflow_count++;
        
        printf("[%d] %s\n", i, operations[i]);
        printf("    Result: %e\n", h_result[i]);
        printf("    Is denormal: %s\n", h_denorm[i] ? "YES" : "NO");
        printf("    Is zero: %s\n", (h_result[i] == 0.0f) ? "YES (flushed)" : "NO");
        printf("    Underflow: %s\n\n", is_underflow ? "YES ✓" : "NO");
    }
    
    printf("========================================\n");
    printf("Underflow operations: %d/%d\n", underflow_count, N);
    printf("========================================\n");
    
    cudaFree(d_result);
    cudaFree(d_denorm);
    
    return 0;
}