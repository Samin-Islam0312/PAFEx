### Architecture Summary: FP_INSTRUMENT on OACISS

**Target Hardware:** NVIDIA A100 GPUs
**Objective:** Catching and exporting IEEE 754 floating-point exceptions (NaNs, Infs, DivZero) at the intermediate representation (IR) level.

#### 1. Base Environment

* **Platform:** OACISS Compute Nodes (`athena` / A100 partitions)
* **Core Modules:** `gcc`, `cmake`, `python`, `cuda/12.5`
* **Activation Strategy:** Centralized `activate_env.sh` script to align all paths prior to compilation.

#### 2. Compiler Infrastructure: LLVM 22

* **Source:** Built from scratch (`llvm-project` main branch / 22.x).
* **Configuration:** * `Release` build type.
* **NVPTX** target enabled for A100 compatibility.
* **Assertions Enabled** (`-DLLVM_ENABLE_ASSERTIONS=ON`) — *Critical for debugging malformed IR when injecting math checks.*


* **Installation Path:** `~/opt/llvm-latest`

#### 3. Profiling Backend: PAPI

* **Source:** Built from source (icl-utk-edu/papi).
* **Configuration:**
* Configured explicitly with `--with-components="cuda sde"`.
* *Build Note:* Required dynamic CUDA path discovery (`--with-cuda-dir`) because OACISS hides the toolkit from default search paths.


* **Installation Path:** `~/opt/papi`

#### 4. The Instrumentation Pass (Out-of-Tree)

* **API:** Uses the modern LLVM **New Pass Manager**.
* **Build System:** Custom `CMakeLists.txt` that automatically links the localized LLVM 22 APIs and PAPI SDE libraries.
* **Output:** A shared object plugin (`FPInstrument.so`) that can be loaded dynamically via the `opt` tool.

---

### The Activation Script (`~/workspace/activate_env.sh`)

*Keep a record of this script in your documentation, as the tool cannot compile without it:*

```bash
#!/bin/bash
# 1. Base System

module purge
module load llvm
module load papi
module load cuda/12.8  # This matches your driver perfectly

# module load gcc-
# module load cmake
# module load python
~/opt/llvm-22/bin/llvm-config --version
~/opt/llvm-22/bin/clang --version

# Update this line (was pointing to llvm-latest, should be llvm-22)
export LLVM_DIR=$HOME/opt/llvm-22
export CC=$LLVM_DIR/bin/clang
export CXX=$LLVM_DIR/bin/clang++
export PATH=$LLVM_DIR/bin:$PATH
export LD_LIBRARY_PATH=$LLVM_DIR/lib:$LD_LIBRARY_PATH

# 3. PAPI Environment
export PAPI_DIR=$HOME/opt/papi
export PATH=$PAPI_DIR/bin:$PATH
export LD_LIBRARY_PATH=$PAPI_DIR/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$PAPI_DIR/include:$C_INCLUDE_PATH

echo "OACISS H100/A100 FP Instrumentation Environment Activated."
* 

### Compilation Process


### Benchmark program selection

```bash
cp -r rodinia/cuda/hotspot SBAC-PAD/tests/benchmarks/rodinia
cp -r rodinia/cuda/gaussian SBAC-PAD/tests/benchmarks/rodinia
cp -r rodinia/cuda/backprop SBAC-PAD/tests/benchmarks/rodinia
cp -r rodinia/cuda/cfd SBAC-PAD/tests/benchmarks/rodinia
cp -r rodinia/cuda/myocyte SBAC-PAD/tests/benchmarks/rodinia
```
### Current Status

- Generic build_bench.sh script for any single-TU Rodinia kernel
- 3 benchmarks measured: hotspot 27x, gaussian 3-5x, cfd 51x
- FTZ disable flag added for accurate subnormal detection
- cfd produces 0 exceptions despite GPU-FPX reporting 13 subnormals
  (compile-time difference between clang and nvcc)

Next: warp-level dedup OR multi-TU host pass for backprop/myocyte, LULESH, MiniFPE