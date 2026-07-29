#include <cstdio>
#include <cuda_runtime.h>

// Every thread divides by zero at one line -> max parallel atomic contention
// on a single exception counter. The workload CTA staging targets.
__global__ void stress(double *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    double z = 0.0;
    double v = (double)(i + 1);
    double r = v / z;            // divzero, every thread, same line
    out[i % n] = r;
}

int main() {
    const int N = 1 << 20;       // 1M threads per launch
    const int ITERS = 200;       // many launches so kernel time dominates
    double *d; cudaMalloc(&d, sizeof(double) * 256);

    // warmup (exclude one-time JIT / first-launch cost from the measurement)
    stress<<<N / 256, 256>>>(d, 256);
    cudaDeviceSynchronize();

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    for (int k = 0; k < ITERS; ++k)
        stress<<<N / 256, 256>>>(d, 256);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms = 0.0f;
    cudaEventElapsedTime(&ms, start, stop);
    printf("KERNEL_TIME_MS_TOTAL %.3f over %d launches\n", ms, ITERS);
    printf("KERNEL_TIME_MS_PER_LAUNCH %.4f\n", ms / ITERS);

    cudaDeviceSynchronize();
    cudaFree(d);
    return 0;
}
