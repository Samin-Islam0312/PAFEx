/*
pass_plugin_compat.h — locate PassPlugin.h across install layouts.
Standard LLVM installs it at llvm/Passes/PassPlugin.h; the LLVM 22 build on
athena (~/opt/llvm-22) installs it at llvm/Plugins/PassPlugin.h instead.
Both declare the identical PassPluginLibraryInfo struct.
*/
#pragma once

#if __has_include("llvm/Passes/PassPlugin.h")
#include "llvm/Passes/PassPlugin.h"
#elif __has_include("llvm/Plugins/PassPlugin.h")
#include "llvm/Plugins/PassPlugin.h"
#else
#error "PassPlugin.h not found under llvm/Passes/ or llvm/Plugins/ — check the LLVM install"
#endif
