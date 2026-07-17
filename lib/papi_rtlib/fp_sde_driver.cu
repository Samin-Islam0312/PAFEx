/*
fp_sde_driver — PaFEx PAPI SDE runtime driver.

Pure HOST code (no device kernels): pulls the pass-maintained device counter
arrays back through the HostPass-emitted accessors, publishes aggregates to
PAPI SDE, dumps machine-readable per-site CSVs, and prints a human-readable
per-site exception report joined against the compile-time site table
(fp_sites.csv, written by the DevicePass).

PORTABILITY: compiles against either GPU runtime via the gpu* shim below.
  NVIDIA: compile as before (nvcc / clang -x cuda); cuda_runtime.h is used.
  AMD:    compile with hipcc (or clang -x hip); __HIP_PLATFORM_AMD__ selects
          hip_runtime.h. Since this file contains no device code, hipcc will
          happily build it; if your build insists on extensions, a symlink
          fp_sde_driver.hip.cpp -> fp_sde_driver.cu works.
The HostPass emits identically named extern "C" accessors for both runtimes,
so nothing else here changes per target.

ARRAY SIZES come from fp_abi.h, shared with both passes. (Historical note:
this file previously hardcoded 1024*6 / 1024*4 slot counts while the device
pass had grown to 8192 sites — per-site readback was silently truncated, and
once the host accessor copies the full array, the undersized buffers here
would have been a 336KB heap overflow.)

ENVIRONMENT VARIABLES:
  FP_DEBUG=1          print raw counter values on every publish
  FP_SITES_CSV=path   location of the compile-time site table
                      (default ./fp_sites.csv)
  FP_REPORT=0         disable the human-readable per-site report
  FP_REPORT_TOP=N     rows in the report (default 20)
*/

#include <papi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "fp_abi.h"
#include "fp_sde.h"

// ---------------------------------------------------------------------------
// GPU runtime shim: the only runtime calls this file makes.
// ---------------------------------------------------------------------------
#if defined(__HIP_PLATFORM_AMD__) || defined(__HIP_PLATFORM_NVIDIA__)
  #include <hip/hip_runtime.h>
  typedef hipError_t gpuError_t;
  #define gpuSuccess            hipSuccess
  #define gpuDeviceSynchronize  hipDeviceSynchronize
  #define gpuGetErrorString     hipGetErrorString
#else
  #include <cuda_runtime.h>
  typedef cudaError_t gpuError_t;
  #define gpuSuccess            cudaSuccess
  #define gpuDeviceSynchronize  cudaDeviceSynchronize
  #define gpuGetErrorString     cudaGetErrorString
#endif

using namespace pafex;

// Provided by the HostPass-instrumented application TU (the one with the
// fatbin/module handle, where the device globals are registered). Declared
// as int: the emitted IR returns i32, which is the underlying type of both
// cudaError_t and hipError_t.
extern "C" int fp_read_counters(
    unsigned long long *invalid,
    unsigned long long *divzero,
    unsigned long long *overflow,
    unsigned long long *underflow,
    unsigned long long *total,
    unsigned long long *subnormal);

extern "C" int fp_reset_counters(void);
extern "C" int fp_read_site_counters(unsigned long long *dst);    // dst[kNumSiteSlots]
extern "C" int fp_read_result_counters(unsigned long long *dst);  // dst[kNumResultSlots]

static char benchmark_name[256] = "unknown";
static bool initialized  = false;
static bool papi_started = false;

// 10 registered SDE counters (NaN input/created, NaN prop rate, subnormal
// rate, and instability score removed).
#define FP_NUM_EVENTS 10
static int EventSet = PAPI_NULL;
static long long papi_values[FP_NUM_EVENTS] = {0};

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

    // Order MUST match the registration order in fp_sde_counters.cpp and the
    // papi_values[] indices in fp_instrument_print_summary().
    const char* sde_events[FP_NUM_EVENTS] = {
        "sde:::CUDA_FP_ANALYSIS::FP_TOTAL_OPS",        // [0]
        "sde:::CUDA_FP_ANALYSIS::FP_DIVBYZERO",        // [1]
        "sde:::CUDA_FP_ANALYSIS::FP_INVALID",          // [2]
        "sde:::CUDA_FP_ANALYSIS::FP_OVERFLOW",         // [3]
        "sde:::CUDA_FP_ANALYSIS::FP_UNDERFLOW",        // [4]
        "sde:::CUDA_FP_ANALYSIS::DENORMAL_PRODUCED",   // [5]
        "sde:::CUDA_FP_ANALYSIS::KERNELS_LAUNCHED",    // [6]
        "sde:::CUDA_FP_ANALYSIS::OPERATIONS_TOTAL",    // [7]
        "sde:::CUDA_FP_ANALYSIS::TOTAL_EXCEPTIONS",    // [8]
        "sde:::CUDA_FP_ANALYSIS::EXCEPTION_DENSITY"    // [9]
    };

    for (int i = 0; i < FP_NUM_EVENTS; i++) {
        if ((ret = PAPI_add_named_event(EventSet, sde_events[i])) != PAPI_OK) {
            fprintf(stderr, "PAPI failed to add %s: %s\n", sde_events[i], PAPI_strerror(ret));
            exit(1);
        }
    }
}

extern "C" void fp_instrument_reset(void) {
    int e = fp_reset_counters();
    if (e != (int)gpuSuccess)
        fprintf(stderr, "[FP_INSTRUMENT] reset failed: %s\n",
                gpuGetErrorString((gpuError_t)e));
}

extern "C" void fp_instrument_read_and_publish(void) {
    unsigned long long h_invalid = 0, h_divzero = 0;
    unsigned long long h_overflow = 0, h_underflow = 0;
    unsigned long long h_total = 0, h_subnormal = 0;

    // Self-synchronizing read: do NOT trust the caller (or srad's deprecated
    // cudaThreadSynchronize) to have drained the device. Block until all
    // outstanding kernels have finished writing fp_counters before copying.
    gpuError_t s = gpuDeviceSynchronize();
    if (s != gpuSuccess) {
        fprintf(stderr, "[FP_INSTRUMENT] sync before read failed: %s\n",
                gpuGetErrorString(s));
        return;
    }

    int e = fp_read_counters(
        &h_invalid, &h_divzero, &h_overflow, &h_underflow,
        &h_total, &h_subnormal);

    if (e != (int)gpuSuccess) {
        fprintf(stderr, "[FP_INSTRUMENT] read failed: %s\n",
                gpuGetErrorString((gpuError_t)e));
        return;
    }

    if (getenv("FP_DEBUG")) {
        fprintf(stderr,
            "[DBG] invalid=%llu divzero=%llu overflow=%llu underflow=%llu total=%llu subnormal=%llu\n",
            h_invalid, h_divzero, h_overflow, h_underflow, h_total, h_subnormal);
    }

    sde_publish_counts(
        h_total, h_divzero, h_invalid, h_overflow, h_underflow, h_subnormal
    );
    sde_inc_kernels();
}

extern "C" void fp_instrument_region_start(void) {
    if (!initialized) return;
    int ret;
    if (papi_started) {
        long long tmp[FP_NUM_EVENTS];
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
    fp_instrument_read_and_publish();   // self-synchronizing
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
    printf("  Denormals Produced: %lld\n", papi_values[5]);

    printf("\nWorkload Stats\n");
    printf("  Kernels Launched:   %lld\n", papi_values[6]);
    printf("  Operations Total:   %lld\n", papi_values[7]);

    printf("\nDerived Metrics\n");
    printf("  Total Exceptions:   %lld\n", papi_values[8]);
    printf("  Exception Density:  %lld (per million ops)\n", papi_values[9]);
}

// ===========================================================================
// Per-site report: join the compile-time site table (fp_sites.csv, written
// by the DevicePass) against the runtime per-site counters, for direct
// "kernel + file:line -> exception counts" debugging output.
// ===========================================================================

typedef struct {
    char file[160];
    char pretty[160];   // demangled function name (falls back to mangled)
    int  line;
    int  is_kernel;
    int  valid;
} SiteInfo;

static SiteInfo *g_sites = NULL;
static int g_sites_loaded = 0;   // attempted load (even if file missing)

// fp_sites.csv format (tab-separated), per the DevicePass:
//   index  file  func  line  func_pretty  is_kernel
// The last two columns are accepted as optional so older 4-column tables
// still join.
static void load_site_table(void) {
    if (g_sites_loaded) return;
    g_sites_loaded = 1;

    const char *path = getenv("FP_SITES_CSV");
    if (!path) path = "fp_sites.csv";
    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "[FP_INSTRUMENT] note: site table '%s' not found "
                "(set FP_SITES_CSV); report will show site indices only\n", path);
        return;
    }

    g_sites = (SiteInfo*)calloc(kMaxSites, sizeof(SiteInfo));
    if (!g_sites) { fclose(f); return; }

    char line[2048];
    if (!fgets(line, sizeof line, f)) { fclose(f); return; }  // skip header

    while (fgets(line, sizeof line, f)) {
        char *save = NULL;
        char *tIdx    = strtok_r(line, "\t\n", &save);
        char *tFile   = strtok_r(NULL, "\t\n", &save);
        char *tFunc   = strtok_r(NULL, "\t\n", &save);
        char *tLine   = strtok_r(NULL, "\t\n", &save);
        char *tPretty = strtok_r(NULL, "\t\n", &save);
        char *tKern   = strtok_r(NULL, "\t\n", &save);
        if (!tIdx || !tFile || !tFunc || !tLine) continue;

        unsigned idx = (unsigned)strtoul(tIdx, NULL, 10);
        if (idx >= kMaxSites) continue;

        SiteInfo *si = &g_sites[idx];
        snprintf(si->file, sizeof si->file, "%s", tFile);
        si->line = atoi(tLine);
        snprintf(si->pretty, sizeof si->pretty, "%s", tPretty ? tPretty : tFunc);
        si->is_kernel = tKern ? atoi(tKern) : 0;
        si->valid = 1;
    }
    fclose(f);
}

static const char *path_basename(const char *p) {
    const char *s = strrchr(p, '/');
    return s ? s + 1 : p;
}

typedef struct { unsigned site; unsigned long long total; } SiteRank;

static int cmp_site_rank(const void *a, const void *b) {
    const SiteRank *ra = (const SiteRank*)a, *rb = (const SiteRank*)b;
    if (rb->total > ra->total) return 1;
    if (rb->total < ra->total) return -1;
    return (ra->site > rb->site) - (ra->site < rb->site);
}

static void print_site_report(const unsigned long long *buf) {
    const char *rep = getenv("FP_REPORT");
    if (rep && atoi(rep) == 0) return;

    int topn = 20;
    if (const char *t = getenv("FP_REPORT_TOP")) {
        topn = atoi(t);
        if (topn <= 0) return;
    }

    load_site_table();

    // Rank sites by total exception count. Column 5 (division-invalid) is a
    // subset of column 0, so the total sums columns 0..4 only.
    SiteRank *ranks = (SiteRank*)malloc(kMaxSites * sizeof(SiteRank));
    if (!ranks) return;
    unsigned nactive = 0;
    for (unsigned s = 0; s < kMaxSites; ++s) {
        const unsigned long long *r = &buf[s * kSiteStride];
        unsigned long long tot = r[0] + r[1] + r[2] + r[3] + r[4];
        if (tot) { ranks[nactive].site = s; ranks[nactive].total = tot; ++nactive; }
    }
    if (!nactive) {
        printf("\n[FP_INSTRUMENT] Per-site report: no exception sites recorded.\n");
        free(ranks);
        return;
    }
    qsort(ranks, nactive, sizeof(SiteRank), cmp_site_rank);

    unsigned shown = (unsigned)topn < nactive ? (unsigned)topn : nactive;
    printf("\n[FP_INSTRUMENT] Per-site exception report — top %u of %u active sites"
           " (full data: fp_site_counts.csv)\n", shown, nactive);
    printf("  %-5s %-12s %-10s %-10s %-10s %-10s %-10s %s\n",
           "rank", "total", "invalid", "divzero", "overflow", "underflow",
           "subnormal", "location");

    for (unsigned i = 0; i < shown; ++i) {
        unsigned s = ranks[i].site;
        const unsigned long long *r = &buf[s * kSiteStride];
        printf("  %-5u %-12llu %-10llu %-10llu %-10llu %-10llu %-10llu ",
               i + 1, ranks[i].total, r[0], r[1], r[2], r[3], r[4]);

        if (g_sites && g_sites[s].valid) {
            const SiteInfo *si = &g_sites[s];
            if (si->line >= 0)
                printf("%s%s:%d %.60s\n", si->is_kernel ? "[K] " : "",
                       path_basename(si->file), si->line, si->pretty);
            else
                printf("%s<no debug loc> %.60s\n",
                       si->is_kernel ? "[K] " : "", si->pretty);
        } else if (s == kMaxSites - 1) {
            printf("site %u [SPILL slot: site table overflowed kMaxSites]\n", s);
        } else {
            printf("site %u [no site-table entry]\n", s);
        }
    }
    free(ranks);
}

extern "C" void fp_instrument_dump_sites(void) {
    unsigned long long *buf =
        (unsigned long long*)calloc(kNumSiteSlots, sizeof(unsigned long long));
    if (!buf) return;

    gpuDeviceSynchronize();
    int e = fp_read_site_counters(buf);
    if (e != (int)gpuSuccess) {
        fprintf(stderr, "[FP_INSTRUMENT] site read failed: %s\n",
                gpuGetErrorString((gpuError_t)e));
        free(buf);
        return;
    }

    FILE *f = fopen("fp_site_counts.csv", "w");
    if (f) {
        fprintf(f, "index,invalid,divzero,overflow,underflow,subnormal,div_invalid\n");
        for (unsigned s = 0; s < kMaxSites; ++s) {
            unsigned long long *r = &buf[s * kSiteStride];
            if (r[0] || r[1] || r[2] || r[3] || r[4])
                fprintf(f, "%u,%llu,%llu,%llu,%llu,%llu,%llu\n",
                        s, r[0], r[1], r[2], r[3], r[4], r[5]);
        }
        fclose(f);
        fprintf(stderr, "[FP_INSTRUMENT] wrote fp_site_counts.csv\n");
    }

    print_site_report(buf);
    free(buf);
}

// GPU-FPX-comparable per-site result-class counts (only nonzero under -result-class).
extern "C" void fp_instrument_dump_results(void) {
    unsigned long long *buf =
        (unsigned long long*)calloc(kNumResultSlots, sizeof(unsigned long long));
    if (!buf) return;

    gpuDeviceSynchronize();
    int e = fp_read_result_counters(buf);
    if (e != (int)gpuSuccess) {
        fprintf(stderr, "[FP_INSTRUMENT] result read failed: %s\n",
                gpuGetErrorString((gpuError_t)e));
        free(buf);
        return;
    }

    // If the run wasn't built with -result-class, the array is all zero; skip
    // writing an empty CSV so the report cleanly reports "none".
    bool any = false;
    for (unsigned i = 0; i < kNumResultSlots && !any; ++i) any = (buf[i] != 0);
    if (!any) { free(buf); return; }

    FILE *f = fopen("fp_result_counts.csv", "w");
    if (!f) { free(buf); return; }
    fprintf(f, "index,nan,inf,sub,div0\n");
    for (unsigned s = 0; s < kMaxSites; ++s) {
        unsigned long long *r = &buf[s * kResultStride];
        if (r[0] || r[1] || r[2] || r[3])
            fprintf(f, "%u,%llu,%llu,%llu,%llu\n", s, r[0], r[1], r[2], r[3]);
    }
    fclose(f);
    fprintf(stderr, "[FP_INSTRUMENT] wrote fp_result_counts.csv\n");
    free(buf);
}

extern "C" void fp_instrument_finalize(void) {
#ifdef FP_INSTRUMENT_QUIET
    return;
#else
    if (papi_started) {
        int ret;
        fp_instrument_read_and_publish();   // self-synchronizing
        fp_instrument_dump_sites();
        fp_instrument_dump_results();
        if ((ret = PAPI_stop(EventSet, papi_values)) != PAPI_OK)
            fprintf(stderr, "PAPI_stop (finalize) failed: %s\n", PAPI_strerror(ret));
        papi_started = false;
    }
    fp_instrument_print_summary();
    printf("\n[FP_INSTRUMENT] Finalized.\n");
#endif
}
