# lib/device/CMakeLists.txt
add_llvm_pass_plugin(DevicePass
  device_pass.cpp
)
target_include_directories(DevicePass PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)