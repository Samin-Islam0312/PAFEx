#include <stdint.h>
// #include <papi.h>
#include <sde_lib.h>      

// INTERNAL VARIABLES (Safe from name mangling because they are static)
extern "C" {
    void sde_init(void);
    void sde_inc_kernels(void);
    void sde_publish_counts(unsigned long long, 
                            unsigned long long, 
                            unsigned long long, 
                            unsigned long long, 
                            unsigned long long, 
                            unsigned long long, 
                            unsigned long long, 
                            unsigned long long);
    void fp_instrument_reset(void);
    void fp_instrument_read_and_publish(void);
}
// Registered Counters (DELTA type) 
static long long c_fp_total_ops      = 0;
static long long c_fp_divbyzero      = 0;
static long long c_fp_invalid        = 0;
static long long c_fp_overflow       = 0;
static long long c_fp_underflow      = 0;

// Detailed breakdown
static long long c_nan_input         = 0;  
static long long c_nan_created       = 0;  
static long long c_denormal_produced = 0;  

// Workload stats
static long long c_kernels_launched  = 0;
static long long c_operations_total  = 0;

// Derived Counters (Computed) 
static long long c_total_exceptions  = 0;  
static long long c_exception_density = 0;  
static long long c_nan_prop_rate     = 0;  
static long long c_subnormal_rate    = 0;  
static long long c_instability_score = 0;  

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
    
    long long nan_total = c_nan_input + c_nan_created;
    if (nan_total > 0) {
        c_nan_prop_rate = (c_nan_created * 1000000LL) / nan_total;
    } else {
        c_nan_prop_rate = 0;
    }
    
    if (c_fp_underflow > 0) {
        c_subnormal_rate = (c_denormal_produced * 1000000LL) / c_fp_underflow;
    } else {
        c_subnormal_rate = 0;
    }
    
    c_instability_score = c_exception_density + (c_nan_prop_rate / 10);
}

// ============================================================================
// EXPORTED FUNCTIONS (Wrapped in extern "C" so driverPapi.o can find them!)
// ============================================================================
extern "C" {

    void sde_init(void) {
        if (inited) return;
        
        handle = papi_sde_init("CUDA_FP_ANALYSIS");
        
        papi_sde_register_counter(handle, "FP_TOTAL_OPS", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_total_ops);
        papi_sde_register_counter(handle, "FP_DIVBYZERO", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_divbyzero);
        papi_sde_register_counter(handle, "FP_INVALID", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_invalid);
        papi_sde_register_counter(handle, "FP_OVERFLOW", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_overflow);
        papi_sde_register_counter(handle, "FP_UNDERFLOW", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_fp_underflow);
        
        papi_sde_register_counter(handle, "NAN_INPUT", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_nan_input);
        papi_sde_register_counter(handle, "NAN_CREATED", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_nan_created);
        papi_sde_register_counter(handle, "DENORMAL_PRODUCED", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_denormal_produced);
        
        papi_sde_register_counter(handle, "KERNELS_LAUNCHED", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_kernels_launched);
        papi_sde_register_counter(handle, "OPERATIONS_TOTAL", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_operations_total);
        
        papi_sde_register_counter(handle, "TOTAL_EXCEPTIONS", PAPI_SDE_RO | PAPI_SDE_DELTA, PAPI_SDE_long_long, &c_total_exceptions);
        papi_sde_register_counter(handle, "EXCEPTION_DENSITY", PAPI_SDE_RO | PAPI_SDE_INSTANT, PAPI_SDE_long_long, &c_exception_density);
        papi_sde_register_counter(handle, "NAN_PROPAGATION_RATE", PAPI_SDE_RO | PAPI_SDE_INSTANT, PAPI_SDE_long_long, &c_nan_prop_rate);
        papi_sde_register_counter(handle, "SUBNORMAL_RATE", PAPI_SDE_RO | PAPI_SDE_INSTANT, PAPI_SDE_long_long, &c_subnormal_rate);
        papi_sde_register_counter(handle, "INSTABILITY_SCORE", PAPI_SDE_RO | PAPI_SDE_INSTANT, PAPI_SDE_long_long, &c_instability_score);
        
        inited = 1;
    }

    void sde_publish_counts(
        unsigned long long fp_total_ops,
        unsigned long long fp_divbyzero,
        unsigned long long fp_invalid,
        unsigned long long fp_overflow,
        unsigned long long fp_underflow,
        unsigned long long nan_input,
        unsigned long long nan_created,
        unsigned long long denormal_produced)
    {
        c_fp_total_ops      += (long long)fp_total_ops;
        c_fp_divbyzero      += (long long)fp_divbyzero;
        c_fp_invalid        += (long long)fp_invalid;
        c_fp_overflow       += (long long)fp_overflow;
        c_fp_underflow      += (long long)fp_underflow;
        c_nan_input         += (long long)nan_input;
        c_nan_created       += (long long)nan_created;
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
        c_nan_input         = 0;
        c_nan_created       = 0;
        c_denormal_produced = 0;
        c_kernels_launched  = 0;
        c_operations_total  = 0;
        c_total_exceptions  = 0;
        c_exception_density = 0;
        c_nan_prop_rate     = 0;
        c_subnormal_rate    = 0;
        c_instability_score = 0;
    }

    double sde_get_exception_density(void) { return (double)c_exception_density / 10000.0; }
    double sde_get_nan_propagation_rate(void) { return (double)c_nan_prop_rate / 10000.0; }
    double sde_get_subnormal_rate(void) { return (double)c_subnormal_rate / 10000.0; }
    double sde_get_instability_score(void) { return (double)c_instability_score / 10000.0; }

} // End of extern "C" block!