#include <stdint.h>
#include <sde_lib.h>

#include "fp_sde.h"   // enforces that definitions below match the public API

// Registered Counters (DELTA type)
static long long c_fp_total_ops      = 0;
static long long c_fp_divbyzero      = 0;
static long long c_fp_invalid        = 0;
static long long c_fp_overflow       = 0;
static long long c_fp_underflow      = 0;

// Detailed breakdown (subnormal count kept; NaN input/created removed)
static long long c_denormal_produced = 0;

// Workload stats
static long long c_kernels_launched  = 0;
static long long c_operations_total  = 0;

// Derived Counters (Computed) — NaN propagation rate, subnormal rate, and
// instability score removed.
static long long c_total_exceptions  = 0;
static long long c_exception_density = 0;   // exceptions per MILLION ops

static papi_handle_t handle;
static int inited = 0;

// Helper to compute derived metrics
static void update_derived_counters(void) {
    c_total_exceptions = c_fp_divbyzero + c_fp_invalid +
                         c_fp_overflow + c_fp_underflow;

    if (c_fp_total_ops > 0) {
        c_exception_density = (c_total_exceptions * 1000000LL) / c_fp_total_ops;
    } else {
        c_exception_density = 0;
    }
}

// ============================================================================
// EXPORTED FUNCTIONS (Wrapped in extern "C" via fp_sde.h declarations)
// ============================================================================
extern "C" {

    void sde_init(void) {
        if (inited) return;

        // NOTE: the provider name is part of the PAPI event strings
        // (sde:::CUDA_FP_ANALYSIS::*) that measurement scripts and the
        // driver's event list depend on. It is intentionally kept stable
        // across the NVIDIA and AMD backends; renaming it is a breaking
        // change to every consumer.
        handle = papi_sde_init("CUDA_FP_ANALYSIS");

        // NOTE: registration order here MUST match sde_events[] and the
        // papi_values[] print indices in fp_sde_driver.
        papi_sde_register_counter(handle, "FP_TOTAL_OPS", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_total_ops);
        papi_sde_register_counter(handle, "FP_DIVBYZERO", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_divbyzero);
        papi_sde_register_counter(handle, "FP_INVALID", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_invalid);
        papi_sde_register_counter(handle, "FP_OVERFLOW", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_overflow);
        papi_sde_register_counter(handle, "FP_UNDERFLOW", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_underflow);

        papi_sde_register_counter(handle, "DENORMAL_PRODUCED", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_denormal_produced);

        papi_sde_register_counter(handle, "KERNELS_LAUNCHED", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_kernels_launched);
        papi_sde_register_counter(handle, "OPERATIONS_TOTAL", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_operations_total);

        papi_sde_register_counter(handle, "TOTAL_EXCEPTIONS", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_total_exceptions);
        papi_sde_register_counter(handle, "EXCEPTION_DENSITY", PAPI_SDE_RO | PAPI_SDE_INSTANT, PAPI_SDE_long_long, &c_exception_density);

        inited = 1;
    }

    void sde_publish_counts(
        unsigned long long fp_total_ops,
        unsigned long long fp_divbyzero,
        unsigned long long fp_invalid,
        unsigned long long fp_overflow,
        unsigned long long fp_underflow,
        unsigned long long denormal_produced)
    {
        c_fp_total_ops      += (long long)fp_total_ops;
        c_fp_divbyzero      += (long long)fp_divbyzero;
        c_fp_invalid        += (long long)fp_invalid;
        c_fp_overflow       += (long long)fp_overflow;
        c_fp_underflow      += (long long)fp_underflow;
        c_denormal_produced += (long long)denormal_produced;

        update_derived_counters();
    }

    void sde_inc_kernels(void) {
        c_kernels_launched += 1;
    }

    void sde_add_operations(unsigned long long n) {
        c_operations_total += (long long)n;
    }

    void sde_reset(void) {
        c_fp_total_ops      = 0;
        c_fp_divbyzero      = 0;
        c_fp_invalid        = 0;
        c_fp_overflow       = 0;
        c_fp_underflow      = 0;
        c_denormal_produced = 0;
        c_kernels_launched  = 0;
        c_operations_total  = 0;
        c_total_exceptions  = 0;
        c_exception_density = 0;
    }

    // Exceptions per million FP ops, matching the EXCEPTION_DENSITY counter's
    // unit. (The previous version divided by 10000.0, silently converting to
    // percent while everything else reported per-million.)
    double sde_get_exception_density(void) { return (double)c_exception_density; }

} // End of extern "C" block!