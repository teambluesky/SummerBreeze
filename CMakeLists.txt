cmake_minimum_required (VERSION 3.2)
project (SummerBreeze_RT)

if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 8)
  MESSAGE(FATAL_ERROR "Please use gcc >= 8.0, by setting `-D CMAKE_CXX_COMPILER=g++-8`" flag)
  return()
endif()

add_subdirectory(ext/glfw)
include_directories(ext/glm)

find_package(Vulkan REQUIRED)
message("Found vulkan: ${Vulkan_INCLUDE_DIRS}, ${Vulkan_LIBRARY}")

add_executable(app main.cc)

target_include_directories(app PUBLIC ${Vulkan_INCLUDE_DIRS})
target_include_directories(app PUBLIC include)


target_link_libraries(app glfw ${Vulkan_LIBRARY})

message("compiling shaders...")
execute_process (
    COMMAND bash -c "glslc ${CMAKE_CURRENT_SOURCE_DIR}/shaders/helloTriangle.vert -o vert.spv"
)

execute_process (
    COMMAND bash -c "glslc ${CMAKE_CURRENT_SOURCE_DIR}/shaders/helloTriangle.frag -o frag.spv"
)
