#include <stdio.h>
#include <cuda_runtime.h>
#include <float.h>

__device__ bool is_subnormal(float x) {
    return (x != 0.0f) && (fabsf(x) < FLT_MIN);
}

__global__ void testGradualUnderflow(float *result, int *status) {
    int idx = threadIdx.x;
    
    float base = FLT_MIN;
    
    // Create a sequence showing gradual underflow
    // As we divide by increasing powers of 2, we go deeper into denormals
    
    if (idx == 0) {
        result[0] = base;                    // Still normalized (exactly FLT_MIN)
        status[0] = is_subnormal(result[0]) ? 2 : 1;  // 1=normalized, 2=denormal
    }
    
    if (idx == 1) {
        result[1] = base / 2.0f;             // First denormal: FLT_MIN / 2
        status[1] = is_subnormal(result[1]) ? 2 : 1;
    }
    
    if (idx == 2) {
        result[2] = base / 4.0f;             // Deeper denormal
        status[2] = is_subnormal(result[2]) ? 2 : 1;
    }
    
    if (idx == 3) {
        result[3] = base / 8.0f;             // Even smaller denormal
        status[3] = is_subnormal(result[3]) ? 2 : 1;
    }
    
    if (idx == 4) {
        result[4] = base / 16.0f;
        status[4] = is_subnormal(result[4]) ? 2 : 1;
    }
    
    if (idx == 5) {
        result[5] = base / 1024.0f;          // Very small denormal
        status[5] = is_subnormal(result[5]) ? 2 : 1;
    }
    
    if (idx == 6) {
        result[6] = base / 1048576.0f;       // 2^20, extremely small
        status[6] = is_subnormal(result[6]) ? 2 : 1;
    }
    
    if (idx == 7) {
        result[7] = base / 1e20f;            // Likely flushed to zero
        status[7] = (result[7] == 0.0f) ? 0 : (is_subnormal(result[7]) ? 2 : 1);
    }
}

int main() {
    const int N = 8;
    float *d_result, h_result[N];
    int *d_status, h_status[N];
    
    cudaMalloc(&d_result, N * sizeof(float));
    cudaMalloc(&d_status, N * sizeof(int));
    
    printf("========================================\n");
    printf("[TEST] Gradual Underflow (Denormal Range)\n");
    printf("[IEEE 754 Clause 7.5.0]\n");
    printf("========================================\n");
    printf("FLT_MIN = %e\n", FLT_MIN);
    printf("Showing gradual underflow from normalized to zero\n\n");
    
    testGradualUnderflow<<<1, N>>>(d_result, d_status);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_result, d_result, N * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(h_status, d_status, N * sizeof(int), cudaMemcpyDeviceToHost);
    
    printf("Step | Value              | Status\n");
    printf("-----|--------------------|-----------------\n");
    
    for (int i = 0; i < N; i++) {
        const char* status_str;
        if (h_status[i] == 0) status_str = "ZERO (flushed)";
        else if (h_status[i] == 1) status_str = "NORMALIZED";
        else status_str = "DENORMAL ⚠";
        
        printf(" %d   | %e | %s\n", i, h_result[i], status_str);
    }
    
    printf("\n========================================\n");
    printf("Denormals allow gradual underflow:\n");
    printf("  Instead of: value → 0 (abrupt)\n");
    printf("  We get: value → denorm1 → denorm2 → ... → 0 (gradual)\n");
    printf("========================================\n");
    
    cudaFree(d_result);
    cudaFree(d_status);
    
    return 0;
}