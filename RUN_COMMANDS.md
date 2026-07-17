# PaeFEx — run & report commands

Always run from the repo root, and set the manifest path once per shell session:

    cd ~/SBAC-PAD-opt
    export MANIFEST=scripts/buildScripts/benchmarks.manifest

## Command 1 — RUN a benchmark (produces the CSVs)

    ./scripts/buildScripts/run_single_tu.sh <name> [mode]

  - <name>  : a benchmark key from the manifest (e.g. lu, gramschmidt, myocyte)
  - [mode]  : unstaged (default) | staged | baseline
  - Produces, in the CURRENT directory: fp_site_counts.csv, fp_sites.csv
  - Prints the aggregate counts and best wall time

This is the ONLY command that builds and runs. It writes the CSVs that the
report reads. Each run overwrites the CSVs in the current dir.

## Command 2 — GENERATE the exception report (reads the CSVs)

    python3 scripts/buildScripts/fp_report.py .

  - The "." means "read the CSVs in the current directory."
  - THIS is the exception report. Its output is what goes in the paper.
  - Shows: NATIVE view (your IEEE taxonomy) with `dynamic` and `sites` columns.

## Which numbers go in the tables

  - Use the `sites` column (distinct source locations), NOT `dynamic`.
    `dynamic` counts every execution (inflated by loop/dataset size);
    `sites` is dataset-independent and comparable to GPU-FPX.
  - Table (your IEEE taxonomy: Invalid / Div by Zero / Overflow / Underflow /
    Subnormals)  <-  NATIVE view `sites` column.

## Optional flags (NOT needed for the main tables)

    PASS_FLAGS="-result-class -count-total=false" ./scripts/buildScripts/run_single_tu.sh <name>

  - -result-class    : adds the GPU-FPX result-bit comparison view
                       (currently CRASHING — under diagnosis, do not rely on it yet)
  - -count-total=false : drops the per-op total atomic (faster; disables density)

## Run a whole set (native view, for the tables)

    export MANIFEST=scripts/buildScripts/benchmarks.manifest
    for b in myocyte srad hotspot gaussian nw backprop gramschmidt lu; do
        echo "==================== $b ===================="
        ./scripts/buildScripts/run_single_tu.sh "$b"
        python3 scripts/buildScripts/fp_report.py .
    done
