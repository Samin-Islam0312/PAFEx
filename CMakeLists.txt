cmake_minimum_required(VERSION 3.13)
project(FPExceptionPass LANGUAGES C CXX) 

# Enforce C++17 for modern LLVM Pass Manager compatibility
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find LLVM and set up the global environment
find_package(LLVM REQUIRED CONFIG)
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

link_directories(${LLVM_LIBRARY_DIRS})
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

# Point CMake to the subdirectories containing the passes
add_subdirectory(lib/device)
add_subdirectory(lib/host)
add_subdirectory(lib/tag)

# We will add add_subdirectory(runtime) and add_subdirectory(tests) later!
