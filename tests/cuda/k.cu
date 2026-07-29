// k.cu — FMA contraction shape probes for PaFEx (NVIDIA / sm_80).
//
// Emit IR with:
//   clang++ -x cuda --cuda-gpu-arch=sm_80 -O2 --cuda-device-only \
//           -emit-llvm -S k.cu -o - | grep -E 'fmul|fadd|fmuladd|fma\.'
//
// Read the result:
//   call ... @llvm.fmuladd.f32   -> Shape 1 (intrinsic): pass already covers it.
//   fmul contract / fadd contract-> Shape 3 (flagged pair): -faithful-fma needed.
//   fmul / fadd  (no flag)       -> Shape 2 (bare): contraction off, count as-is.
//
// To force each shape explicitly, add one of:
//   -ffp-contract=off | -ffp-contract=on | -ffp-contract=fast | -ffast-math
// The default (no flag) is what your normal build sees — that's the one to trust.

// (1) Canonical single-statement contraction. The one op every "which shape?"
//     question reduces to.
__global__ void single_fma(const float *a, const float *b,
                           const float *c, float *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) out[i] = a[i] * b[i] + c[i];
}

// (2) Accumulation / sum-of-products — the pattern in correlation, lu,
//     gramschmidt. Under -ffp-contract=fast (esp. with reassociation) this is
//     where contract-flagged fmul/fadd pairs proliferate across iterations.
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

// (3) Explicit fma builtin — forces llvm.fma/llvm.fmuladd (Shape 1) regardless
//     of -ffp-contract. This is the clean C1 probe: the 3-arg intrinsic
//     guarantees detectOverflow sees Op2 (the addend), so the FMA-addend
//     finiteness gate is actually exercised.
__global__ void explicit_fma(const float *a, const float *b,
                             const float *c, float *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) out[i] = fmaf(a[i], b[i], c[i]);
}

// (4) f64 variant of (1): confirms the double path emits the same shape, since
//     the masks/detectors branch on isDoubleTy.
__global__ void single_fma_f64(const double *a, const double *b,
                               const double *c, double *out, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) out[i] = a[i] * b[i] + c[i];
}
