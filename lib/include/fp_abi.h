/*
fp_abi.h — PaFEx shared ABI between the DevicePass, the HostPass, and the
PAPI SDE runtime driver.

Every constant here describes the layout of the device counter arrays or the
names of the symbols/accessors that cross the device/host boundary. These
values MUST be identical in all three components; that is exactly why they
live in one header instead of being mirrored. (Historical note: the mirrored
copies drifted once — host kMaxSites=1024 vs device kMaxSites=8192 — which
silently truncated per-site readback for any benchmark with >1024 sites.)

This header is plain C++11 with no LLVM or CUDA/HIP dependencies, so it can
be included from the LLVM pass plugins and from the .cu/.hip runtime driver
alike.
*/
#pragma once

namespace pafex {

// ---- aggregate counter indices (ExceptionID) ----
enum ExceptionID {
    EX_INVALID   = 0,
    EX_DIVZERO   = 1,
    EX_OVERFLOW  = 2,
    EX_UNDERFLOW = 3,
    EX_FP_TOTAL  = 4,
    EX_SUBNORMAL = 5
};
constexpr unsigned kNumCounters = 6;

// ---- per-site array layout ----
// Per-site columns: 0=invalid(all) 1=divzero 2=overflow 3=underflow
//                   4=subnormal   5=invalid-from-divide (subset of col 0)
// col 5 lets the report split GPU-FPX-style NAN vs DIV0 exactly:
//   non-division invalid = col0 - col5  (-> NAN),  col5 folds into DIV0.
constexpr unsigned kSiteStride    = 6;
constexpr unsigned kColDivInvalid = 5;
constexpr unsigned kMaxSites      = 8192;  // device array capacity; last slot
                                           // is the spill bucket when exceeded
constexpr unsigned kNumSiteSlots  = kMaxSites * kSiteStride;

// ---- result-class array layout (GPU-FPX-style, gated by -result-class) ----
enum ResultClassID {
    RC_NAN  = 0,
    RC_INF  = 1,
    RC_SUB  = 2,
    RC_DIV0 = 3
};
constexpr unsigned kResultStride    = 4;   // NAN,INF,SUB,DIV0
constexpr unsigned kNumResultSlots  = kMaxSites * kResultStride;

// ---- device symbol names (declared by DevicePass, registered by HostPass) ----
constexpr const char *kAggSymbol    = "fp_counters";
constexpr const char *kSiteSymbol   = "fp_site_counters";
constexpr const char *kResultSymbol = "fp_result_counters";

// ---- extern "C" accessors emitted by HostPass, called by the runtime ----
//   int fp_read_counters(u64*,u64*,u64*,u64*,u64*,u64*)  (one ptr per ExceptionID)
//   int fp_read_site_counters(u64 *dst)    dst[kNumSiteSlots]
//   int fp_read_result_counters(u64 *dst)  dst[kNumResultSlots]
//   int fp_reset_counters(void)            zeroes the aggregate array only
constexpr const char *kReadFn       = "fp_read_counters";
constexpr const char *kReadSiteFn   = "fp_read_site_counters";
constexpr const char *kReadResultFn = "fp_read_result_counters";
constexpr const char *kResetFn      = "fp_reset_counters";

} // namespace pafex
