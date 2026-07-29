#include <cuda_runtime.h>

// Definition of divide_helper, declared as extern in kernel.cu.
// This produces div-by-zero exceptions when b == 0.
__device__ float divide_helper(float a, float b) {
    return a / b;
}