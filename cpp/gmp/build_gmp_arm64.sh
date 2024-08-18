#!/bin/bash

export NDK_PATH=C:/Users/kadon/AppData/Local/Android/Sdk/ndk/23.1.7779620
export PATH=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin:$PATH
export AR=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-ar
export AS=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-as
export CC=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android21-clang
export CXX=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android21-clang++
export LD=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin/ld.lld
export RANLIB=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-ranlib
export STRIP=$NDK_PATH/toolchains/llvm/prebuilt/windows-x86_64/bin/llvm-strip

# Remove any existing build directory
rm -rf build_arm64 output_arm64

# Create a new build directory
mkdir -p build_arm64
cd build_arm64

# Configure GMP for Android with -fPIC flag
CFLAGS="-fPIC -O2" CXXFLAGS="-fPIC -O2" ../configure --host=aarch64-linux-android --enable-cxx --disable-assembly --prefix=$PWD/../output_arm64

# Build and install GMP
make
make check
make install
