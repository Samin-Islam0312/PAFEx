export ROCM=/opt/rocm-7.2.4
export LLVM=$ROCM/lib/llvm/bin
export CLANG=$LLVM/clang++
export OPT=$LLVM/opt
export REPO=$HOME/SBAC-PAD-opt
export BC=$ROCM/amdgcn/bitcode
export TAG=$REPO/build-rocm/lib/tag/TagPass.so
export DEV=$REPO/build-rocm/lib/device/DevicePass.so
export HOST=$REPO/build-rocm/lib/host/HostPass.so
echo "odyssey env: REPO=$REPO  clang=$([ -x $CLANG ] && echo ok || echo MISSING)"
export DP=$REPO/lib/device/device_pass.cpp
export S=$REPO/runs/amd_bench/myocyte/O0-ieee-tag1-instrumented export DP=$REPO/lib/device/device_pass.cpp
export S=$REPO/runs/amd_bench/myocyte/O0-ieee-tag1-instrumented
source $REPO/scripts/extract_sites.sh
export TIMEOUT=1800
