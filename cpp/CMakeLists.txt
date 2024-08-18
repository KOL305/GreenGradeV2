cmake_minimum_required(VERSION 3.22)

project(ffi_gmp_project)

# GMP library
add_subdirectory(gmp)

# Example C++ code
add_library(example SHARED src/example.cpp)

target_include_directories(example PRIVATE include gmp)
target_link_libraries(example gmp)
