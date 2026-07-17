#!/usr/bin/env bash
# hipify_benchmarks.sh
#
# Mirror CUDA benchmarks into a PARALLEL HIP tree and hipify the copy, leaving
# the CUDA sources untouched so the NVIDIA/athena build keeps working.
#
# hipify-perl is a textual CUDA->HIP API translator (cudaMalloc->hipMalloc,
# cuda_runtime.h->hip/hip_runtime.h, ...). It does NOT touch kernel arithmetic,
# so the a*b+c FMAs PaFEx instruments are unchanged. It also does NOT convert
# build systems (Makefiles, nvcc calls, -arch flags, -lcudart) -- fix those in
# your run/build scripts.
#
# Files keep their .cu / .cuh names (content becomes HIP). Compile them with
# `hipcc -x hip` (or `clang++ -x hip`), which is what your HIP run script does.
# Keeping names means internal `#include "foo.cuh"` still resolves -- renaming
# to .hip would require rewriting every include, which this avoids.
#
# Usage:
#   ./hipify_benchmarks.sh                          # FloatGuard-overlap set (default)
#   ./hipify_benchmarks.sh all                      # entire SRC_ROOT tree
#   ./hipify_benchmarks.sh rodinia/myocyte polybench/lu   # explicit dirs (rel. to SRC_ROOT)
#
# Override paths via env:
#   SRC_ROOT=tests/cuda/benchmarks DST_ROOT=tests/amd/benchmarks ./hipify_benchmarks.sh

set -euo pipefail

SRC_ROOT="${SRC_ROOT:-tests/cuda/benchmarks}"
DST_ROOT="${DST_ROOT:-tests/amd/benchmarks}"
HIPIFY="${HIPIFY:-$(command -v hipify-perl 2>/dev/null || echo /opt/rocm-7.2.4/bin/hipify-perl)}"

# FloatGuard-overlap validation set (paths relative to SRC_ROOT).
# Adjust the polybench sub-paths if your layout nests them differently.
DEFAULT_SET=(
    rodinia/myocyte
    polybench/correlation
    polybench/gramschmidt
    polybench/lu
)

if [[ ! -x "$HIPIFY" ]]; then
    echo "ERROR: hipify-perl not found or not executable at: $HIPIFY" >&2
    echo "       Set HIPIFY=/path/to/hipify-perl or add it to PATH." >&2
    exit 1
fi
if [[ ! -d "$SRC_ROOT" ]]; then
    echo "ERROR: SRC_ROOT does not exist: $SRC_ROOT" >&2
    exit 1
fi

echo "hipify : $HIPIFY"
echo "src    : $SRC_ROOT"
echo "dst    : $DST_ROOT"

# Hipify every .cu/.cuh under a directory, in place (keeps names, .prehip backups).
hipify_tree() {
    local root="$1" n=0
    while IFS= read -r -d '' f; do
        if "$HIPIFY" -inplace "$f" >/dev/null 2>&1; then
            echo "    hipified: ${f#"$root"/}"
            ((n++)) || true
        else
            echo "    FAIL:     ${f#"$root"/}  (hipify-perl error -- check manually)"
        fi
    done < <(find "$root" \( -name '*.cu' -o -name '*.cuh' \
                       -o -name '*.c'  -o -name '*.cpp' \
                       -o -name '*.cc' -o -name '*.h'   \
                       -o -name '*.hpp' \) -print0)


    [[ $n -eq 0 ]] && echo "    (no .cu/.cuh files found)"
    return 0
}

if [[ "${1:-}" == "all" ]]; then
    echo "mode   : all"
    echo
    echo "=== mirroring entire tree ==="
    mkdir -p "$DST_ROOT"
    cp -a "$SRC_ROOT/." "$DST_ROOT/"
    echo "=== hipifying ==="
    hipify_tree "$DST_ROOT"
else
    if [[ $# -eq 0 ]]; then
        TARGETS=("${DEFAULT_SET[@]}")
        echo "mode   : default (FloatGuard-overlap set)"
    else
        TARGETS=("$@")
        echo "mode   : explicit"
    fi
    echo "targets: ${TARGETS[*]}"
    echo
    for t in "${TARGETS[@]}"; do
        src="$SRC_ROOT/$t"
        dst="$DST_ROOT/$t"
        echo "=== $t ==="
        if [[ ! -d "$src" ]]; then
            echo "    SKIP: no such dir ($src)"
            continue
        fi
        mkdir -p "$dst"
        cp -a "$src/." "$dst/"
        hipify_tree "$dst"
    done
fi

echo
echo "Done. HIP sources under $DST_ROOT ; CUDA sources untouched."
echo "Remove hipify backups when satisfied:  find $DST_ROOT -name '*.prehip' -delete"
