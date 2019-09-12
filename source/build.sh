#!/bin/bash

set -e

mkdir -p build_linux
cd build_linux

build=Release
if [[ $1 == "Debug" ]]; then
    build=Debug
fi


cmake -D CMAKE_BUILD_TYPE=${build} -D CMAKE_VERBOSE_MAKEFILE:BOOL=OFF -D THIRD_PARTY:STRING=/usr/src/third_party -G "Unix Makefiles" $@ ..
cmake --build . -- -j$(nproc)

cd ..