# Sets the minimum version of CMake required to build the native library.
cmake_minimum_required(VERSION 3.18)

# Set the project name
project(ffi_gmp_project)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Define the path to the cpp directory relative to the current directory
set(CPP_DIR ${CMAKE_SOURCE_DIR}/../../../../../cpp)

# Define the GMP installation directories
set(GMP_INSTALL_DIR_ARM64 ${CPP_DIR}/gmp/output_arm64)
set(GMP_INSTALL_DIR_ARMEABI ${CPP_DIR}/gmp/output_armeabi)
set(GMP_INSTALL_DIR_X86 ${CPP_DIR}/gmp/output_x86)
set(GMP_INSTALL_DIR_X86_64 ${CPP_DIR}/gmp/output_x86_64)

# Add GMP library
#add_subdirectory(${CPP_DIR}/gmp ${CMAKE_BINARY_DIR}/gmp_build)

# Add example library
add_library(example SHARED ${CPP_DIR}/src/example.cpp)

# Include directories
#target_include_directories(example PRIVATE ${CPP_DIR}/include ${CPP_DIR}/gmp)

# Link the GMP library
#target_link_libraries(example gmp)

# Include directories
include_directories(${CPP_DIR}/include ${GMP_INSTALL_DIR_ARM64}/include ${GMP_INSTALL_DIR_ARMEABI}/include ${GMP_INSTALL_DIR_X86}/include ${GMP_INSTALL_DIR_X86_64}/include)
# Link the GMP library (adjust the path to where the libgmp.a is located)
#target_link_libraries(example ${CPP_DIR}/gmp/build/.libs/libgmp.a)

# Link the GMP library and Android log library
if(ANDROID_ABI STREQUAL "arm64-v8a")
    target_link_libraries(example ${GMP_INSTALL_DIR_ARM64}/lib/libgmp.a log)
elseif(ANDROID_ABI STREQUAL "armeabi-v7a")
    target_link_libraries(example ${GMP_INSTALL_DIR_ARMEABI}/lib/libgmp.a log)
elseif(ANDROID_ABI STREQUAL "x86")
    target_link_libraries(example ${GMP_INSTALL_DIR_X86}/lib/libgmp.a log)
elseif(ANDROID_ABI STREQUAL "x86_64")
    target_link_libraries(example ${GMP_INSTALL_DIR_X86_64}/lib/libgmp.a log)
endif()