# lib/tag/CMakeLists.txt
add_llvm_pass_plugin(TagPass
  tag_pass.cpp
)
target_include_directories(TagPass PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)
