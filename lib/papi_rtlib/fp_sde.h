#ifndef CUFEX_SDE_H
#define CUFEX_SDE_H

#ifdef __cplusplus
extern "C" {
#endif

// THE CONSUMER API (Called by the LLVM-injected driver.cpp)
void sde_init(void);

// Used by the driver to pull data from the GPU into the SDE variables
void sde_publish_counts(
    unsigned long long fp_total_ops,
    unsigned long long fp_divbyzero,
    unsigned long long fp_invalid,
    unsigned long long fp_overflow,
    unsigned long long fp_underflow,
    unsigned long long nan_input,
    unsigned long long nan_created,
    unsigned long long denormal_produced
);

// THE PRODUCER API (Optional helpers for host-side tracking)
void sde_inc_kernels(void);
void sde_add_operations(unsigned long long n);
void sde_reset(void);

#ifdef __cplusplus
}
#endif

#endif // CUFEX_SDE_H