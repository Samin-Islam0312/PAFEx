// k.hip — FMA contraction shape probes for PaFEx (AMD / gfx942).
//
// Emit IR with:
//   hipcc -x hip --offload-arch=gfx942 -O2 -emit-llvm -S k.hip -o - \
//         | grep -E 'fmul|fadd|fmuladd|fma\.'
//   (equivalently: clang++ -x hip --offload-arch=gfx942 ... if driving clang directly)
//
// Read the result:
//   call ... @llvm.fmuladd.f32   -> Shape 1 (intrinsic): pass already covers it.
//   fmul contract / fadd contract-> Shape 3 (flagged pair): -faithful-fma needed.
//   fmul / fadd  (no flag)       -> Shape 2 (bare): contraction off, count as-is.
//
// HIP device compilation commonly defaults to -ffp-contract=fast, so the
// expectation is Shape 3 here — but confirm from the actual output rather than
// assume. To force each shape explicitly, add one of:
//   -ffp-contract=off | -ffp-contract=on | -ffp-contract=fast | -ffast-math
//
// Kernel bodies are identical to k.cu so the two targets are compared like for
// like; only the runtime header differs.

#include <hip/hip_runtime.h>

// (1) Canonical single-statement contraction.
__global__ void single_fma(const float *a, const float *b,
                           const float *c, float *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) out[i] = a[i] * b[i] + c[i];
}

// (2) Accumulation / sum-of-products (correlation / lu / gramschmidt pattern).
__global__ void dot_accum(const float *a, const float *b,
                          float *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        float acc = 0.0f;
        for (int k = 0; k < n; ++k)
            acc += a[i * n + k] * b[k];   // fmul + dependent fadd per iter
        out[i] = acc;
    }
}

// (3) Explicit fma builtin — forces llvm.fma/llvm.fmuladd (Shape 1). Clean C1
//     probe: 3-arg intrinsic guarantees detectOverflow sees Op2 (the addend).
__global__ void explicit_fma(const float *a, const float *b,
                             const float *c, float *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) out[i] = fmaf(a[i], b[i], c[i]);
}

// (4) f64 variant of (1): confirms the double path emits the same shape.
__global__ void single_fma_f64(const double *a, const double *b,
                               const double *c, double *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) out[i] = a[i] * b[i] + c[i];
}
