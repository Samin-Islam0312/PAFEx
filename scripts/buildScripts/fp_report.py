#!/usr/bin/env python3
"""
fp_report.py — dual-view exception report for one PaeFEx run.

Reads the per-site CSVs the tool emits and prints two views of the same run:

  NATIVE (IEEE operation-semantics): invalid / divzero / overflow / underflow /
      subnormal. This is PaeFEx's own taxonomy, by operation pattern (origination).

  GPU-FPX-COMPARABLE (result-register bits): NAN / INF / SUB / DIV0. Only present
      if the run was built with -result-class. Counts result-bit appearances
      (includes propagation), and folds divide-producing-{inf,nan} into DIV0 —
      exactly GPU-FPX's classification, so the numbers line up with their table.

For each view it reports BOTH:
  - dynamic   : total dynamic occurrences (sum over executions)   <- PaeFEx's finer metric
  - sites      : number of DISTINCT static source locations         <- GPU-FPX's counting unit

Usage:
  fp_report.py <run_dir>            # dir containing fp_sites.csv, fp_site_counts.csv,
                                    # and (optionally) fp_result_counts.csv
  fp_report.py --sites a.csv --counts b.csv [--results c.csv]

Notes:
  - GPU-FPX reports DISTINCT SITES (it records each (location,type) once), so the
    'sites' column of the GPU-FPX view is the apples-to-apples comparison.
  - A nonzero gap between the NATIVE and GPU-FPX 'sites' counts is expected and
    meaningful: GPU-FPX counts propagation sites; PaeFEx-native counts origination.
"""

import argparse, csv, os, sys
from collections import defaultdict


def read_sites(path):
    """index -> (file, func, line). fp_sites.csv is TAB-separated."""
    sites = {}
    if not path or not os.path.exists(path):
        return sites
    with open(path) as f:
        r = csv.reader(f, delimiter="\t")
        header = next(r, None)
        for row in r:
            if len(row) < 4:
                continue
            try:
                idx = int(row[0])
            except ValueError:
                continue
            sites[idx] = (row[1], row[2], row[3])
    return sites


def read_counts(path, cols):
    """index -> {col: count}. Comma-separated, first column is index.
    Tolerant of rows with fewer/more columns than expected (pads missing with 0)."""
    data = {}
    if not path or not os.path.exists(path):
        return data
    with open(path) as f:
        r = csv.reader(f)
        next(r, None)  # header
        for row in r:
            if not row:
                continue
            try:
                idx = int(row[0])
            except ValueError:
                continue
            vals = []
            for i in range(len(cols)):
                try:
                    vals.append(int(row[1 + i]) if (1 + i) < len(row) else 0)
                except ValueError:
                    vals.append(0)
            data[idx] = dict(zip(cols, vals))
    return data


IEEE_COLS   = ["invalid", "divzero", "overflow", "underflow", "subnormal", "div_invalid"]
RESULT_COLS = ["nan", "inf", "sub", "div0"]


def summarize(counts, cols):
    """Return (dynamic_total_per_col, distinct_site_count_per_col)."""
    dyn = {c: 0 for c in cols}
    sites = {c: 0 for c in cols}
    for idx, row in counts.items():
        for c in cols:
            v = row.get(c, 0)
            dyn[c] += v
            if v > 0:
                sites[c] += 1
    return dyn, sites


def print_view(title, cols, dyn, sites):
    print(f"\n{title}")
    width = max(len(c) for c in cols)
    print(f"  {'class':<{width}}   {'dynamic':>14}   {'sites':>7}")
    for c in cols:
        print(f"  {c:<{width}}   {dyn[c]:>14}   {sites[c]:>7}")


def print_by_kernel(sites_map, counts, cols, label):
    """Aggregate distinct-site and dynamic counts grouped by kernel (func)."""
    if not sites_map or not counts:
        return
    by_func_dyn = defaultdict(lambda: {c: 0 for c in cols})
    by_func_sites = defaultdict(lambda: {c: 0 for c in cols})
    for idx, row in counts.items():
        func = sites_map.get(idx, ("?", "?", "?"))[1]
        for c in cols:
            v = row.get(c, 0)
            by_func_dyn[func][c] += v
            if v > 0:
                by_func_sites[func][c] += 1
    print(f"\n{label} — by kernel (dynamic; distinct-sites in parens)")
    for func in sorted(by_func_dyn):
        parts = []
        for c in cols:
            d = by_func_dyn[func][c]
            s = by_func_sites[func][c]
            if d:
                parts.append(f"{c}={d}({s})")
        if parts:
            short = func if len(func) <= 50 else func[:47] + "..."
            print(f"  {short}: " + "  ".join(parts))


def gpufpx_map_from_ieee(ieee):
    """Exact origination-based remap of IEEE per-site counts into GPU-FPX columns,
    using the div_invalid breakdown:
        NAN  <- invalid - div_invalid   (non-division invalid)
        INF  <- overflow
        SUB  <- subnormal
        DIV0 <- divzero + div_invalid    (GPU-FPX folds div->{inf,nan} into DIV0)
    Returns index -> {nan,inf,sub,div0}. Origination-only (no propagation)."""
    out = {}
    for idx, row in ieee.items():
        inv = row.get("invalid", 0)
        divinv = row.get("div_invalid", 0)
        out[idx] = {
            "nan":  max(inv - divinv, 0),
            "inf":  row.get("overflow", 0),
            "sub":  row.get("subnormal", 0),
            "div0": row.get("divzero", 0) + divinv,
        }
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("run_dir", nargs="?", help="dir with fp_sites.csv / fp_site_counts.csv / fp_result_counts.csv")
    ap.add_argument("--sites")
    ap.add_argument("--counts")
    ap.add_argument("--results")
    a = ap.parse_args()

    if a.run_dir:
        sites_path   = a.sites   or os.path.join(a.run_dir, "fp_sites.csv")
        counts_path  = a.counts  or os.path.join(a.run_dir, "fp_site_counts.csv")
        results_path = a.results or os.path.join(a.run_dir, "fp_result_counts.csv")
    else:
        sites_path, counts_path, results_path = a.sites, a.counts, a.results

    sites_map = read_sites(sites_path)
    ieee      = read_counts(counts_path, IEEE_COLS)
    result    = read_counts(results_path, RESULT_COLS)

    print("=" * 64)
    print(f"PaeFEx exception report")
    print(f"  sites file:   {sites_path}  ({len(sites_map)} sites)")
    print(f"  counts file:  {counts_path}  ({len(ieee)} sites with IEEE counts)")
    if result:
        print(f"  results file: {results_path}  ({len(result)} sites with result-class counts)")
    else:
        print(f"  results file: (none — run with -result-class to get the propagation view)")
    print("=" * 64)

    dyn_i, sites_i = summarize(ieee, IEEE_COLS)
    print_view("NATIVE view (IEEE operation-semantics, origination)", IEEE_COLS, dyn_i, sites_i)
    print_by_kernel(sites_map, ieee, IEEE_COLS, "NATIVE")

    # Exact origination remap into GPU-FPX columns (uses div_invalid breakdown).
    mapped = gpufpx_map_from_ieee(ieee)
    dyn_m, sites_m = summarize(mapped, RESULT_COLS)
    print_view("GPU-FPX columns, ORIGINATION (exact remap of native; no propagation)",
               RESULT_COLS, dyn_m, sites_m)

    if result:
        dyn_r, sites_r = summarize(result, RESULT_COLS)
        print_view("GPU-FPX columns, RESULT-BITS (propagation-inclusive; matches GPU-FPX semantics)",
                   RESULT_COLS, dyn_r, sites_r)
        print_by_kernel(sites_map, result, RESULT_COLS, "GPU-FPX result-bits")
        print("\nGap between ORIGINATION 'sites' and RESULT-BITS 'sites' = propagation spread.")
        print("Compare RESULT-BITS 'sites' against GPU-FPX's published table (their counting unit).")
    else:
        print("\n(ORIGINATION remap shown above is exact for creation sites; build with")
        print(" -result-class to also get the propagation-inclusive view that matches GPU-FPX.)")
    print()


if __name__ == "__main__":
    main()
