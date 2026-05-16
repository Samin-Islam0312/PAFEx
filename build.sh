#!/bin/bash
set -e          

module load cuda/12.8 2>/dev/null || true
# TARGET CONFIG 
GPU_ARCH=sm_80
GPU_SM=${GPU_ARCH#sm_}   # extracts "80"

export LLVM_DIR=$HOME/opt/llvm-22
export CC=$LLVM_DIR/bin/clang
export CXX=$LLVM_DIR/bin/clang++
export PATH=$LLVM_DIR/bin:$PATH
export PAPI_DIR=${PAPI_DIR:-$HOME/opt/papi}
export CUDA_HOME=$(dirname $(dirname $(realpath $(which nvcc))))
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$PAPI_DIR/lib:$CUDA_HOME/lib64:$LD_LIBRARY_PATH

echo "PART 0: BUILDING THE PASSES"
mkdir -p build
cd build
cmake \
  -DCMAKE_C_COMPILER=$LLVM_DIR/bin/clang \
  -DCMAKE_CXX_COMPILER=$LLVM_DIR/bin/clang++ \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_DIR=$LLVM_DIR/lib/cmake/llvm \
  ..
make
cd ..

echo "PART 1: BUILDING THE PAPI RUNTIME OBJECTS"
g++  -fPIC -c lib/papi_rtlib/fp_sde_counters.cpp -o fp_sde_counters.o -I$PAPI_DIR/include
nvcc -Xcompiler -fPIC -c lib/papi_rtlib/fp_sde_driver.cu -o fp_sde_driver.o -I$PAPI_DIR/include


echo "PART 2: DEVICE PIPELINE (GPU Instrumentation)"
# Locate libdevice.10.bc (NVIDIA ships it with CUDA toolkit)
LIBDEVICE=$CUDA_HOME/nvvm/libdevice/libdevice.10.bc
if [ ! -f "$LIBDEVICE" ]; then
    LIBDEVICE=$(find $CUDA_HOME -name "libdevice*.bc" 2>/dev/null | head -1)
fi
echo "Using libdevice: $LIBDEVICE"

# 1. Emit device bitcode at -O0
$LLVM_DIR/bin/clang++ -O0 -g -emit-llvm --cuda-device-only \
    -x cuda tests/gpu_fpx.cu --cuda-gpu-arch=$GPU_ARCH -c -o device.bc

# 2. NEW: link libdevice so math functions (__nv_sqrtf, __nv_expf, etc.) resolve.
#    Use --only-needed so we don't pull every libdevice function into our module
#    unless the kernel actually references it.
$LLVM_DIR/bin/llvm-link --only-needed device.bc $LIBDEVICE -o device_linked.bc

# 3. Run pass — sees user FP ops normally, skips __nv_* function bodies
$LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/device/DevicePass.so \
    -passes="fp-exception" device_linked.bc -o instrumented_device.bc

# 4. Optimize after instrumentation
$LLVM_DIR/bin/opt -O2 instrumented_device.bc -o optimized_device.bc

# 5. Lower to PTX
$LLVM_DIR/bin/llc -O2 -mcpu=$GPU_ARCH optimized_device.bc -o instrumented.ptx

ptxas --gpu-name $GPU_ARCH instrumented.ptx -o instrumented.cubin
fatbinary --64 --create instrumented.fatbin \
    --image3=kind=elf,sm=$GPU_SM,file=instrumented.cubin


echo "PART 3: HOST PIPELINE (CPU Instrumentation)"

# Emit host bitcode at -O0 with fatbin embedded
$LLVM_DIR/bin/clang++ -O0 -emit-llvm --cuda-host-only \
    -Xclang -fcuda-include-gpubinary -Xclang instrumented.fatbin \
    -x cuda tests/gpu_fpx.cu -c -o host.bc

# Run pass on -O0 host IR
$LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/host/HostPass.so \
    -passes="fp-host-instrument" host.bc -o instrumented_host.bc

# Optimize after pass
$LLVM_DIR/bin/opt -O2 instrumented_host.bc -o optimized_host.bc

# Compile to object with -O2
$LLVM_DIR/bin/clang++ -O2 -c optimized_host.bc -o host.o

echo "PART 4: LINKING & EXECUTION"
clang++ host.o fp_sde_counters.o fp_sde_driver.o \
    -o instrumented_app \
    -L$CUDA_HOME/lib64 -lcudart \
    -L$PAPI_DIR/lib -lpapi -lsde \
    -Wl,-rpath,$CUDA_HOME/lib64 \
    -Wl,-rpath,$PAPI_DIR/lib

    

ldd ./instrumented_app | grep -E "papi|cudart|sde|pfm"
echo "VERIFY DEVICE SYMBOLS IN CUBIN"
cuobjdump --dump-elf-symbols instrumented.cubin | grep -i "fp_.*counter" || \
  echo "  (no fp_*_counter symbols found in cubin — readback will fail)"
echo "RUN"
./instrumented_app

    