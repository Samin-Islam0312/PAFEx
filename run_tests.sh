#!/bin/bash
# run_tests.sh — iterate tests/basic_tests/*/*.cu, build & run each,
# organize artifacts under results/<category>/<test>/, summarize.

set -u   # error on undefined vars, but NOT set -e (we want to keep going on test failure)

# --- Environment (mirror build.sh) ---
module load cuda/12.8 2>/dev/null || true

GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}

export LLVM_DIR=$HOME/opt/llvm-22
export CC=$LLVM_DIR/bin/clang
export CXX=$LLVM_DIR/bin/clang++
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:${LD_LIBRARY_PATH:-}

# Locate libdevice once (used in device pipeline for all tests)
LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
if [ ! -f "$LIBDEVICE" ]; then
    LIBDEVICE=$(find $CUDA_HOME -name "libdevice*.bc" 2>/dev/null | head -1)
fi
echo "Using libdevice: $LIBDEVICE"

ROOT=$(pwd)
RESULTS=$ROOT/results
mkdir -p $RESULTS

# --- Build passes once ---
echo "================================================================"
echo " BUILDING PASSES (once)"
echo "================================================================"
mkdir -p build
(
    cd build
    cmake \
        -DCMAKE_C_COMPILER=$LLVM_DIR/bin/clang \
        -DCMAKE_CXX_COMPILER=$LLVM_DIR/bin/clang++ \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm \
        .. > /dev/null
    make -j > $RESULTS/_pass_build.log 2>&1
) || { echo "Pass build failed — see $RESULTS/_pass_build.log"; exit 1; }
echo "  Passes built: build/lib/device/DevicePass.so, build/lib/host/HostPass.so"

# --- Build runtime objects once (shared across all tests) ---
echo ""
echo "================================================================"
echo " BUILDING RUNTIME OBJECTS (once)"
echo "================================================================"
g++ -fPIC -c lib/papi_rtlib/fp_sde_counters.cpp \
    -o $RESULTS/_fp_sde_counters.o -I$PAPI_DIR/include 2>&1 | tee -a $RESULTS/_runtime_build.log
nvcc -Xcompiler -fPIC -c lib/papi_rtlib/fp_sde_driver.cu \
    -o $RESULTS/_fp_sde_driver.o -I$PAPI_DIR/include 2>&1 | tee -a $RESULTS/_runtime_build.log
echo "  Runtime objects built."

# --- Master CSV header ---
CSV=$RESULTS/_summary.csv
echo "category,test,status,invalid,divzero,overflow,underflow,total,subnormal,kernels_launched,notes" > $CSV

# --- Per-test pipeline ---
run_one_test() {
    local category=$1
    local test_file=$2
    local test_name=$(basename "$test_file" .cu)
    local outdir=$RESULTS/$category/$test_name

    mkdir -p $outdir
    local log=$outdir/build.log
    local run=$outdir/run.log

    echo ""
    echo "----------------------------------------------------------------"
    echo " [$category / $test_name]"
    echo "----------------------------------------------------------------"

    # Part 2: DEVICE PIPELINE
    {
        echo "=== Part 2: Device pipeline ==="

        # Emit at -O0
        $LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only -x cuda "$test_file" \
            --cuda-gpu-arch=$GPU_ARCH -c -o $outdir/device.bc 2>&1

        # Link libdevice (only-needed = only pull in functions the kernel uses)
        $LLVM_DIR/bin/llvm-link --only-needed $outdir/device.bc $LIBDEVICE \
            -o $outdir/device_linked.bc 2>&1

        # Run pass
        $LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/device/DevicePass.so \
            -passes="fp-exception" $outdir/device_linked.bc \
            -o $outdir/instrumented_device.bc 2>&1

        # Optimize after instrumentation
        $LLVM_DIR/bin/opt -O2 $outdir/instrumented_device.bc \
            -o $outdir/optimized_device.bc 2>&1

        # Lower to PTX
        $LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH $outdir/optimized_device.bc \
            -o $outdir/instrumented.ptx 2>&1

        ptxas --gpu-name $GPU_ARCH $outdir/instrumented.ptx \
            -o $outdir/instrumented.cubin 2>&1
        fatbinary --64 --create $outdir/instrumented.fatbin \
            --image3=kind=elf,sm=$GPU_SM,file=$outdir/instrumented.cubin 2>&1
    } > $log 2>&1

    if [ ! -f $outdir/instrumented.fatbin ]; then
        echo "  STATUS: BUILD FAILED (device pipeline). See $log"
        echo "$category,$test_name,build_failed_device,,,,,,,device pipeline error" >> $CSV
        return
    fi

    # Part 3: HOST PIPELINE
    {
        echo "=== Part 3: Host pipeline ==="
        $LLVM_DIR/bin/clang++ -emit-llvm --cuda-host-only \
            -Xclang -fcuda-include-gpubinary -Xclang $outdir/instrumented.fatbin \
            -x cuda "$test_file" -c -o $outdir/host.bc 2>&1
        $LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/host/HostPass.so \
            -passes="fp-host-instrument" $outdir/host.bc \
            -o $outdir/instrumented_host.bc 2>&1
        $LLVM_DIR/bin/clang++ -c $outdir/instrumented_host.bc -o $outdir/host.o 2>&1
    } >> $log 2>&1

    if [ ! -f $outdir/host.o ]; then
        echo "  STATUS: BUILD FAILED (host pipeline). See $log"
        echo "$category,$test_name,build_failed_host,,,,,,,host pipeline error" >> $CSV
        return
    fi

    # Disassemble the BC files to LL for human inspection (paper figures!)
    $LLVM_DIR/bin/llvm-dis $outdir/instrumented_device.bc -o $outdir/instrumented_device.ll 2>/dev/null
    $LLVM_DIR/bin/llvm-dis $outdir/instrumented_host.bc -o $outdir/instrumented_host.ll 2>/dev/null

    # Part 4: LINK
    {
        echo "=== Part 4: Link ==="
        clang++ $outdir/host.o $RESULTS/_fp_sde_counters.o $RESULTS/_fp_sde_driver.o \
            -o $outdir/instrumented_app \
            -L$CUDA_HOME/lib64 -lcudart \
            -L$PAPI_DIR/lib -lpapi -lsde \
            -Wl,-rpath,$CUDA_HOME/lib64 \
            -Wl,-rpath,$PAPI_DIR/lib 2>&1
    } >> $log 2>&1

    if [ ! -x $outdir/instrumented_app ]; then
        echo "  STATUS: BUILD FAILED (link). See $log"
        echo "$category,$test_name,build_failed_link,,,,,,,link error" >> $CSV
        return
    fi

    # RUN
    timeout 30 $outdir/instrumented_app > $run 2>&1
    local rc=$?

    # PARSE the [DBG] line and Kernels Launched
    local dbg_line=$(grep -E "^\[DBG\]" $run | tail -1)
    local kl=$(grep -E "Kernels Launched:" $run | head -1 | awk '{print $NF}')
    kl=${kl:-0}

    if [ -z "$dbg_line" ]; then
        echo "  STATUS: RUN FAILED (no [DBG] output, rc=$rc). See $run"
        echo "$category,$test_name,run_failed,,,,,,,$kl,rc=$rc" >> $CSV
        return
    fi

    # Extract counter values: "[DBG] invalid=X divzero=Y overflow=Z underflow=W total=A subnormal=B"
    local invalid=$(echo "$dbg_line"   | grep -oP 'invalid=\K[0-9]+')
    local divzero=$(echo "$dbg_line"   | grep -oP 'divzero=\K[0-9]+')
    local overflow=$(echo "$dbg_line"  | grep -oP 'overflow=\K[0-9]+')
    local underflow=$(echo "$dbg_line" | grep -oP 'underflow=\K[0-9]+')
    local total=$(echo "$dbg_line"     | grep -oP 'total=\K[0-9]+')
    local subnormal=$(echo "$dbg_line" | grep -oP 'subnormal=\K[0-9]+')

    # Write per-test summary
    {
        echo "Test:     $category / $test_name"
        echo "Source:   $test_file"
        echo "Status:   OK (rc=$rc)"
        echo ""
        echo "Counters:"
        printf "  %-20s %s\n" "invalid"           "${invalid:-?}"
        printf "  %-20s %s\n" "divzero"           "${divzero:-?}"
        printf "  %-20s %s\n" "overflow"          "${overflow:-?}"
        printf "  %-20s %s\n" "underflow"         "${underflow:-?}"
        printf "  %-20s %s\n" "total"             "${total:-?}"
        printf "  %-20s %s\n" "subnormal"         "${subnormal:-?}"
        printf "  %-20s %s\n" "kernels_launched"  "${kl:-?}"
        echo ""
        echo "Full output: run.log"
    } > $outdir/summary.txt

    # Append CSV row
    echo "$category,$test_name,ok,${invalid:-0},${divzero:-0},${overflow:-0},${underflow:-0},${total:-0},${subnormal:-0},${kl:-0}," >> $CSV

    echo "  STATUS: OK"
    echo "  Counters: invalid=$invalid  divzero=$divzero  overflow=$overflow  underflow=$underflow  total=$total  subnormal=$subnormal"
}

# --- Walk all test files ---
echo ""
echo "================================================================"
echo " RUNNING TESTS"
echo "================================================================"

for category_dir in tests/basic_tests/*/; do
    [ -d "$category_dir" ] || continue
    category=$(basename "$category_dir")
    for test_file in "$category_dir"*.cu; do
        [ -f "$test_file" ] || continue
        run_one_test "$category" "$test_file"
    done
done

# --- Final summary ---
echo ""
echo "================================================================"
echo " DONE"
echo "================================================================"
echo "Results:   $RESULTS/"
echo "Master CSV: $CSV"
echo ""
echo "--- Master CSV ---"
column -t -s, $CSV | head -50
