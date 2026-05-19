#!/bin/bash
# Config B: instrumented passes, no-op PAPI runtime.
# REQUIRES: build_C_full.sh has already run (we reuse its host.o + fp_sde_counters.o).
# Output: app_quiet

set -e

module load cuda/12.8 2>/dev/null || true

export LLVM_DIR=$HOME/opt/llvm-22
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

echo "=========================================="
echo " Config B: INSTRUMENTED + QUIET RUNTIME"
echo "=========================================="

# Sanity check: did Config C run first?
if [ ! -f host.o ] || [ ! -f fp_sde_counters.o ]; then
    echo "ERROR: host.o or fp_sde_counters.o missing."
    echo "       Run ./build_C_full.sh first."
    exit 1
fi

# Rebuild ONLY the driver with the quiet flag.
echo "Rebuilding driver with -DFP_INSTRUMENT_QUIET=1..."
nvcc -Xcompiler -fPIC \
     -Xcompiler -DFP_INSTRUMENT_QUIET=1 \
     -DFP_INSTRUMENT_QUIET=1 \
     -c lib/papi_rtlib/fp_sde_driver.cu \
     -I$PAPI_DIR/include \
     -o fp_sde_driver_quiet.o

# Relink with the quiet driver, reusing host.o and fp_sde_counters.o.
echo "Linking app_quiet..."
clang++ host.o fp_sde_counters.o fp_sde_driver_quiet.o \
    -o app_quiet \
    -L$CUDA_HOME/lib64 -lcudart \
    -L$PAPI_DIR/lib -lpapi -lsde \
    -Wl,-rpath,$CUDA_HOME/lib64 \
    -Wl,-rpath,$PAPI_DIR/lib

echo "Built: app_quiet"
ls -la app_quiet