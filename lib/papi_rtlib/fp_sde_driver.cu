
#include <papi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda_runtime.h>

// Forward declarations of sde_counters.cpp functions
extern "C" {
    void sde_init(void);
    void sde_inc_kernels(void);
    void sde_publish_counts(
        unsigned long long fp_total,
        unsigned long long fp_divbyzero,
        unsigned long long fp_invalid,
        unsigned long long fp_overflow,
        unsigned long long fp_underflow,
        unsigned long long nan_input,
        unsigned long long nan_created,
        unsigned long long denormal_produced
    );
}

// Provided by fp_dev_accessors.cu (compiled through host pipeline so it
// has the fatbin and can resolve the pass-defined device globals).
extern "C" cudaError_t fp_read_counters(
    unsigned long long *invalid,
    unsigned long long *divzero,
    unsigned long long *overflow,
    unsigned long long *underflow,
    unsigned long long *total,
    unsigned long long *subnormal);

extern "C" cudaError_t fp_reset_counters(void);

static char benchmark_name[256] = "unknown";
static bool initialized  = false;
static bool papi_started = false;

static int EventSet = PAPI_NULL;
static long long papi_values[15] = {0};

static void setup_PAPI() {
    int ret;

    if ((ret = PAPI_library_init(PAPI_VER_CURRENT)) != PAPI_VER_CURRENT) {
        fprintf(stderr, "PAPI_library_init failed: %s\n", PAPI_strerror(ret));
        exit(1);
    }

    if ((ret = PAPI_create_eventset(&EventSet)) != PAPI_OK) {
        fprintf(stderr, "PAPI_create_eventset failed: %s\n", PAPI_strerror(ret));
        exit(1);
    }

    const char* sde_events[15] = {
        "sde:::CUDA_FP_ANALYSIS::FP_TOTAL_OPS",
        "sde:::CUDA_FP_ANALYSIS::FP_DIVBYZERO",
        "sde:::CUDA_FP_ANALYSIS::FP_INVALID",
        "sde:::CUDA_FP_ANALYSIS::FP_OVERFLOW",
        "sde:::CUDA_FP_ANALYSIS::FP_UNDERFLOW",
        "sde:::CUDA_FP_ANALYSIS::NAN_INPUT",
        "sde:::CUDA_FP_ANALYSIS::NAN_CREATED",
        "sde:::CUDA_FP_ANALYSIS::DENORMAL_PRODUCED",
        "sde:::CUDA_FP_ANALYSIS::KERNELS_LAUNCHED",
        "sde:::CUDA_FP_ANALYSIS::OPERATIONS_TOTAL",
        "sde:::CUDA_FP_ANALYSIS::TOTAL_EXCEPTIONS",
        "sde:::CUDA_FP_ANALYSIS::EXCEPTION_DENSITY",
        "sde:::CUDA_FP_ANALYSIS::NAN_PROPAGATION_RATE",
        "sde:::CUDA_FP_ANALYSIS::SUBNORMAL_RATE",
        "sde:::CUDA_FP_ANALYSIS::INSTABILITY_SCORE"
    };

    for (int i = 0; i < 15; i++) {
        if ((ret = PAPI_add_named_event(EventSet, sde_events[i])) != PAPI_OK) {
            fprintf(stderr, "PAPI failed to add %s: %s\n", sde_events[i], PAPI_strerror(ret));
            exit(1);
        }
    }
}

extern "C" void fp_instrument_reset(void) {
    cudaError_t e = fp_reset_counters();
    if (e != cudaSuccess)
        fprintf(stderr, "[FP_INSTRUMENT] reset failed: %s\n", cudaGetErrorString(e));
}

extern "C" void fp_instrument_read_and_publish(void) {
    unsigned long long h_invalid = 0, h_divzero = 0;
    unsigned long long h_overflow = 0, h_underflow = 0;
    unsigned long long h_total = 0, h_subnormal = 0;

    cudaError_t e = fp_read_counters(
        &h_invalid, &h_divzero, &h_overflow, &h_underflow,
        &h_total, &h_subnormal);

    if (e != cudaSuccess) {
        fprintf(stderr, "[FP_INSTRUMENT] read failed: %s\n", cudaGetErrorString(e));
        return;
    }

    if (getenv("FP_DEBUG")) {
    fprintf(stderr,
            "[DBG] invalid=%llu divzero=%llu overflow=%llu underflow=%llu total=%llu subnormal=%llu\n",
            h_invalid, h_divzero, h_overflow, h_underflow, h_total, h_subnormal);
    }

    sde_publish_counts(
        h_total, h_divzero, h_invalid, h_overflow, h_underflow,
        /*nan_input=*/0ULL, /*nan_created=*/0ULL, h_subnormal
    );
    sde_inc_kernels();
}

extern "C" void fp_instrument_region_start(void) {
    if (!initialized) return;
    int ret;
    if (papi_started) {
        long long tmp[15];
        if ((ret = PAPI_stop(EventSet, tmp)) != PAPI_OK)
            fprintf(stderr, "PAPI_stop (region_start flush) failed: %s\n", PAPI_strerror(ret));
        papi_started = false;
    }
    fp_instrument_reset();
    if ((ret = PAPI_start(EventSet)) != PAPI_OK)
        fprintf(stderr, "PAPI_start failed: %s\n", PAPI_strerror(ret));
    else
        papi_started = true;
}

extern "C" void fp_instrument_region_stop(void) {
    if (!initialized || !papi_started) return;
    int ret;
    cudaDeviceSynchronize();
    fp_instrument_read_and_publish();
    if ((ret = PAPI_stop(EventSet, papi_values)) != PAPI_OK)
        fprintf(stderr, "PAPI_stop failed: %s\n", PAPI_strerror(ret));
    papi_started = false;
}

extern "C" void fp_instrument_init(const char* name) {
    #ifdef FP_INSTRUMENT_QUIET
        return;
    #else
        if (initialized) return;

    if (name) {
        strncpy(benchmark_name, name, sizeof(benchmark_name) - 1);
    }

    sde_init();
    setup_PAPI();

    printf("[FP_INSTRUMENT] Initialized for: %s\n", benchmark_name);
    printf("[FP_INSTRUMENT] PAPI SDE provider: CUDA_FP_ANALYSIS\n");

    initialized = true;

    int ret;
    if ((ret = PAPI_start(EventSet)) != PAPI_OK)
        fprintf(stderr, "PAPI_start (init) failed: %s\n", PAPI_strerror(ret));
    else
        papi_started = true;
    #endif
    }

static void fp_instrument_print_summary(void) {
    printf("\n[FP_INSTRUMENT] Summary for: %s\n", benchmark_name);

    printf("\nIEEE Exceptions According to the standard\n");
    printf("  Total FP Ops:       %lld\n", papi_values[0]);
    printf("  Div by Zero:        %lld\n", papi_values[1]);
    printf("  Invalid Ops:        %lld\n", papi_values[2]);
    printf("  Overflow:           %lld\n", papi_values[3]);
    printf("  Underflow:          %lld\n", papi_values[4]);

    printf("\nDetailed Breakdown\n");
    printf("  NaNs (Input):       %lld\n", papi_values[5]);
    printf("  NaNs (Created):     %lld\n", papi_values[6]);
    printf("  Denormals Produced: %lld\n", papi_values[7]);

    printf("\nWorkload Stats\n");
    printf("  Kernels Launched:   %lld\n", papi_values[8]);
    printf("  Operations Total:   %lld\n", papi_values[9]);

    printf("\nDerived Metrics\n");
    printf("  Total Exceptions:   %lld\n", papi_values[10]);
    printf("  Exception Density:  %lld (per million ops)\n", papi_values[11]);
    printf("  NaN Prop Rate:      %lld (per million NaNs)\n", papi_values[12]);
    printf("  Subnormal Rate:     %lld (per million underflows)\n", papi_values[13]);
    printf("  Instability Score:  %lld\n", papi_values[14]);
}

extern "C" void fp_instrument_finalize(void) {
#ifdef FP_INSTRUMENT_QUIET
    return;
#else
    if (papi_started) {
        int ret;
        cudaDeviceSynchronize();
        fp_instrument_read_and_publish();
        if ((ret = PAPI_stop(EventSet, papi_values)) != PAPI_OK)
            fprintf(stderr, "PAPI_stop (finalize) failed: %s\n", PAPI_strerror(ret));
        papi_started = false;
    }
   fp_instrument_print_summary();
    printf("\n[FP_INSTRUMENT] Finalized.\n");
#endif
}