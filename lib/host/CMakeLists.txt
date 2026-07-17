# Target for the CPU Host Pass (Phase 3)
add_llvm_pass_plugin(HostPass
  host_pass.cpp
)
target_include_directories(HostPass PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)
