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
# $LLVM_DIR/bin/clang++ -emit-llvm --cuda-device-only -x cuda tests/gpu_fpx.cu --cuda-gpu-arch=$GPU_ARCH -c -o device.bc
$LLVM_DIR/bin/clang++ -g -emit-llvm --cuda-device-only -x cuda tests/gpu_fpx.cu --cuda-gpu-arch=$GPU_ARCH -c -o device.bc
$LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/device/DevicePass.so -passes="fp-exception" device.bc -o instrumented_device.bc
$LLVM_DIR/bin/llc -mcpu=$GPU_ARCH instrumented_device.bc -o instrumented.ptx
ptxas --gpu-name $GPU_ARCH instrumented.ptx -o instrumented.cubin
fatbinary --64 --create instrumented.fatbin \
  --image3=kind=elf,sm=$GPU_SM,file=instrumented.cubin

echo "PART 3: HOST PIPELINE (CPU Instrumentation)"

# 1. Compile gpu_fpx.cu to host bitcode WITH fatbin embedded (frontend runs here,
#    generates __cuda_module_ctor + __cudaRegisterFatBinary registration).
$LLVM_DIR/bin/clang++ -emit-llvm --cuda-host-only \
    -Xclang -fcuda-include-gpubinary -Xclang instrumented.fatbin \
    -x cuda tests/gpu_fpx.cu -c -o host.bc

# 2. Run host pass on host.bc (injects PAPI lifecycle + wraps cudaLaunchKernel).
$LLVM_DIR/bin/opt -load-pass-plugin=./build/lib/host/HostPass.so \
    -passes="fp-host-instrument" host.bc -o instrumented_host.bc

# 3. Compile bitcode -> object. No extra flags needed; fatbin is already baked in.
$LLVM_DIR/bin/clang++ -c instrumented_host.bc -o host.o
# $LLVM_DIR/bin/clang++ --cuda-host-only \
#     -Xclang -fcuda-include-gpubinary -Xclang instrumented.fatbin \
#     -x cuda lib/papi_rtlib/fp_dev_accessors.cu -c -o fp_dev_accessors.o

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

    