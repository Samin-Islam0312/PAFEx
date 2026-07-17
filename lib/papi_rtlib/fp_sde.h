#ifndef PAFEX_SDE_H
#define PAFEX_SDE_H

/*
fp_sde.h — PAPI SDE counter layer API for PaFEx.

This header is the single source of truth for the sde_* signatures.
fp_sde_counters.cpp (the implementation) and fp_sde_driver (the consumer)
both include it, so a signature drift between the two is a compile error
instead of silent argument misalignment.

(Historical note: a previous version of this header declared an 8-argument
sde_publish_counts including nan_input/nan_created, which had already been
removed from the implementation. The driver only worked because it forward-
declared the 6-argument version locally instead of including this header.)
*/

#ifdef __cplusplus
extern "C" {
#endif

// ---- lifecycle ----
void sde_init(void);

// ---- publish: pull of GPU counters into the SDE-registered variables ----
// Argument order matches the registration order in fp_sde_counters.cpp.
void sde_publish_counts(
    unsigned long long fp_total_ops,
    unsigned long long fp_divbyzero,
    unsigned long long fp_invalid,
    unsigned long long fp_overflow,
    unsigned long long fp_underflow,
    unsigned long long denormal_produced);

// ---- host-side workload tracking ----
void sde_inc_kernels(void);
void sde_add_operations(unsigned long long n);
void sde_reset(void);

// Exception density in exceptions per million FP ops (same unit as the
// EXCEPTION_DENSITY SDE counter).
double sde_get_exception_density(void);

#ifdef __cplusplus
}
#endif

#endif // PAFEX_SDE_H