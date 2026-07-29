#include <stdio.h>
#include <cuda_runtime.h>
#include <float.h>
#include <math.h>

__device__ bool is_subnormal(float x) {
    return (x != 0.0f) && (fabsf(x) < FLT_MIN);
}

__global__ void testDenormalOperations(float *result, int *flags) {
    int idx = threadIdx.x;
    
    // Create a denormal number
    float denorm = FLT_MIN / 2.0f;  // This should be denormal
    
    // Operations involving denormals
    
    if (idx == 0) {
        // Denormal + Denormal
        result[0] = __fadd_rn(denorm, denorm);
        flags[0] = is_subnormal(result[0]) ? 1 : 0;
    }
    
    if (idx == 1) {
        // Denormal × Normal
        result[1] = __fmul_rn(denorm, 2.0f);
        flags[1] = is_subnormal(result[1]) ? 1 : 0;
    }
    
    if (idx == 2) {
        // Denormal / Normal (stays denormal)
        result[2] = __fdiv_rn(denorm, 1.5f);
        flags[2] = is_subnormal(result[2]) ? 1 : 0;
    }
    
    if (idx == 3) {
        // Denormal × Denormal (might underflow to zero)
        result[3] = __fmul_rn(denorm, denorm);
        flags[3] = is_subnormal(result[3]) ? 1 : (result[3] == 0.0f ? 2 : 0);
    }
    
    if (idx == 4) {
        // Normal - Normal = Denormal (cancellation)
        float a = FLT_MIN * 1.5f;
        float b = FLT_MIN;
        result[4] = __fsub_rn(a, b);  // Should be FLT_MIN * 0.5 (denormal)
        flags[4] = is_subnormal(result[4]) ? 1 : 0;
    }
}

int main() {
    const int N = 5;
    float *d_result, h_result[N];
    int *d_flags, h_flags[N];
    
    cudaMalloc(&d_result, N * sizeof(float));
    cudaMalloc(&d_flags, N * sizeof(int));
    
    printf("========================================\n");
    printf("[TEST] Denormal Number Operations\n");
    printf("[IEEE 754 Clause 7.5.0]\n");
    printf("========================================\n");
    printf("Testing operations that produce or use denormals\n");
    printf("FLT_MIN = %e\n", FLT_MIN);
    printf("Denormal example: FLT_MIN/2 = %e\n\n", FLT_MIN / 2.0f);
    
    testDenormalOperations<<<1, N>>>(d_result, d_flags);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_flags, d_flags, N * sizeof(int), cudaMemcpyDeviceToHost);
    
    const char* operations[] = {
        "denorm + denorm",
        "denorm × 2.0",
        "denorm / 1.5",
        "denorm × denorm",
        "(FLT_MIN×1.5) - FLT_MIN"
    };
    
    for (int i = 0; i < N; i++) {
        printf("[%d] %s\n", i, operations[i]);
        printf("    Result: %e\n", h_result[i]);
        printf("    Is denormal: %s\n", (h_flags[i] == 1) ? "YES" : "NO");
        printf("    Is zero: %s\n", (h_flags[i] == 2 || h_result[i] == 0.0f) ? "YES" : "NO");
        printf("    Is normalized: %s\n", 
               (fabsf(h_result[i]) >= FLT_MIN) ? "YES" : "NO");
        printf("\n");
    }
    
    printf("========================================\n");
    printf("Note: GPU behavior depends on FTZ (Flush-To-Zero) mode\n");
    printf("  FTZ=0: Denormals supported (IEEE 754 compliant)\n");
    printf("  FTZ=1: Denormals flushed to zero (faster, non-compliant)\n");
    printf("========================================\n");
    
    cudaFree(d_result);
    cudaFree(d_flags);
    
    return 0;
}