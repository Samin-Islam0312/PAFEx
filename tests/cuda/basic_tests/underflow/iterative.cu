#include <stdio.h>
#include <cuda_runtime.h>
#include <float.h>

__device__ bool is_subnormal(float x) {
    return (x != 0.0f) && (fabsf(x) < FLT_MIN);
}

__global__ void testIterativeUnderflow(float *results, int *underflow_step) {
    int idx = threadIdx.x;
    
    // Simulate iterative computation that gradually underflows
    // e.g., repeated multiplication by factor < 1
    
    if (idx == 0) {
        float value = 1.0f;
        float factor = 0.5f;  // Multiply by 0.5 each iteration
        int iterations = 150;
        
        for (int i = 0; i < iterations; i++) {
            value *= factor;
            
            // Detect when underflow first occurs
            if (is_subnormal(value) && underflow_step[0] == 0) {
                underflow_step[0] = i;
            }
            
            // Store some intermediate values
            if (i == 125) results[0] = value;
            if (i == 130) results[1] = value;
            if (i == 135) results[2] = value;
            if (i == 140) results[3] = value;
            if (i == 145) results[4] = value;
            if (i == 149) results[5] = value;
        }
    }
}

__global__ void testUnderflow_Summation(float *result) {
    int idx = threadIdx.x;
    
    // Summing many tiny values can cause underflow issues
    
    if (idx == 0) {
        float sum = 0.0f;
        float tiny = FLT_MIN / 1000.0f;  // Denormal
        
        // Add many denormals
        for (int i = 0; i < 1000; i++) {
            sum += tiny;
        }
        
        result[0] = sum;  // Should accumulate to something larger
    }
}

int main() {
    const int N = 6;
    float *d_results, *d_sum;
    float h_results[N], h_sum;
    int *d_underflow_step, h_underflow_step;
    
    cudaMalloc(&d_results, N * sizeof(float));
    cudaMalloc(&d_sum, sizeof(float));
    cudaMalloc(&d_underflow_step, sizeof(int));
    cudaMemset(d_underflow_step, 0, sizeof(int));
    
    printf("========================================\n");
    printf("[TEST] Underflow in Iterative Computation\n");
    printf("[IEEE 754 Clause 7.5.0]\n");
    printf("========================================\n\n");
    
    // Test 1: Repeated multiplication
    printf("--- Test 1: Repeated Multiplication by 0.5 ---\n");
    printf("Starting value: 1.0\n");
    printf("Operation: value *= 0.5 (150 iterations)\n\n");
    
    testIterativeUnderflow<<<1, 1>>>(d_results, d_underflow_step);
    cudaDeviceSynchronize();
    
    cudaMemcpy(h_results, d_results, N * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(&h_underflow_step, d_underflow_step, sizeof(int), cudaMemcpyDeviceToHost);
    
    printf("Underflow first occurred at iteration: %d\n", h_underflow_step);
    printf("FLT_MIN reached around: 1.0 × 0.5^127 ≈ iteration 127\n\n");
    
    printf("Iteration | Value\n");
    printf("----------|------------------\n");
    printf("   125    | %e %s\n", h_results[0], 
           (h_results[0] != 0 && fabsf(h_results[0]) < FLT_MIN) ? "(denormal)" : "");
    printf("   130    | %e %s\n", h_results[1],
           (h_results[1] != 0 && fabsf(h_results[1]) < FLT_MIN) ? "(denormal)" : "");
    printf("   135    | %e %s\n", h_results[2],
           (h_results[2] != 0 && fabsf(h_results[2]) < FLT_MIN) ? "(denormal)" : "");
    printf("   140    | %e %s\n", h_results[3],
           (h_results[3] != 0 && fabsf(h_results[3]) < FLT_MIN) ? "(denormal)" : "");
    printf("   145    | %e %s\n", h_results[4],
           (h_results[4] != 0 && fabsf(h_results[4]) < FLT_MIN) ? "(denormal)" : "");
    printf("   149    | %e %s\n", h_results[5],
           (h_results[5] == 0.0f) ? "(ZERO - flushed)" : 
           ((h_results[5] != 0 && fabsf(h_results[5]) < FLT_MIN) ? "(denormal)" : ""));
    
    // Test 2: Denormal summation
    printf("\n--- Test 2: Summing Denormals ---\n");
    testUnderflow_Summation<<<1, 1>>>(d_sum);
    cudaDeviceSynchronize();
    
    cudaMemcpy(&h_sum, d_sum, sizeof(float), cudaMemcpyDeviceToHost);
    
    printf("Sum of 1000 denormals: %e\n", h_sum);
    printf("Expected: ~%e\n", (FLT_MIN / 1000.0f) * 1000.0f);
    
    printf("\n========================================\n");
    printf("Key Observations:\n");
    printf("  - Underflow occurs gradually in iterations\n");
    printf("  - Denormals allow continued computation\n");
    printf("  - Eventually may flush to zero\n");
    printf("========================================\n");
    
    cudaFree(d_results);
    cudaFree(d_sum);
    cudaFree(d_underflow_step);
    
    return 0;
}