#include <stdio.h>
#include <math.h>

// Kernel taking runtime arguments — compiler can't constant-fold these
__global__ void probe(float *x, float *out, int n) {
    int idx = threadIdx.x;
    if (idx < n) {
        float v = x[idx];
        out[idx * 4 + 0] = expf(v);          // exp — software libdevice
        out[idx * 4 + 1] = logf(v);          // log — software libdevice
        out[idx * 4 + 2] = powf(v, 2.5f);    // pow — software libdevice
        out[idx * 4 + 3] = sinf(v);          // sin — software libdevice
    }
}

int main() {
    int n = 4;
    float h_x[4] = {1.0f, 2.0f, 3.0f, 4.0f};
    float h_out[16] = {0};

    float *d_x, *d_out;
    cudaMalloc(&d_x, n * sizeof(float));
    cudaMalloc(&d_out, n * 4 * sizeof(float));
    cudaMemcpy(d_x, h_x, n * sizeof(float), cudaMemcpyHostToDevice);

    probe<<<1, n>>>(d_x, d_out, n);
    cudaDeviceSynchronize();

    cudaMemcpy(h_out, d_out, n * 4 * sizeof(float), cudaMemcpyDeviceToHost);
    for (int i = 0; i < n; i++) {
        printf("x=%f exp=%f log=%f pow=%f sin=%f\n",
               h_x[i], h_out[i*4], h_out[i*4+1], h_out[i*4+2], h_out[i*4+3]);
    }
    cudaFree(d_x);
    cudaFree(d_out);
    return 0;
}