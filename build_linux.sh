#!/usr/bin/env bash

# report failure of script for any command failure
set -e

mkdir -p build_linux
cd build_linux

build=RelWithDebInfo
if [[ $1 == "Debug" ]]; then
    build=Debug
fi

cmake -D CMAKE_BUILD_TYPE=${build} -D CMAKE_VERBOSE_MAKEFILE:BOOL=OFF -D BUILD_SDK=yes -G "Unix Makefiles" $@ ..
cmake --build . -- -j$(nproc)

cd ..
