#!/bin/sh

# NOTES :
# ./build_mac.sh -D BUILD_SDK=no
# ./build_mac.sh -D BUILD_SDK=no -D USE_MODEL_TIME_TO_REAL_TIME_RATIO=yes
# ./build_mac.sh -D BUILD_SDK=no -D USE_BL_MODEL_VALUE_TIME=yes
# ./build_mac.sh -D LINEAR_SHAPE_INTERPOLATOR=yes -D BUILD_SDK=no -DCMAKE_INSTALL_PREFIX=/Users/david/SM_install/
# ./build_mac.sh -DCMAKE_INSTALL_PREFIX=/Users/david/SM_install/
# To multi-thread time_step and render across modules
# ./build_mac.sh -D THREAD_POOLING=yes


# we need to ensure the PATH includes tools installed locally (via brew)
PATH=/usr/local/bin:$PATH

mkdir -p build_mac
cd build_mac

build=Release
if [[ $1 == "Debug" ]]; then
    build=Debug
fi

if [ -n "$BUILD_PASSWORD" ]; then
    echo "Attempting to unlock keychain"
    security unlock-keychain -p ${BUILD_PASSWORD} ${HOME}/Library/Keychains/login.keychain-db
fi

cmake -D BUILD_SDK=yes -D CMAKE_VERBOSE_MAKEFILE:BOOL=OFF -D BUILD_WEBSTREAMER=no -D SM_RTL_BUILD_INSTALLER=yes -G "Xcode" $@ .. || { echo 'CMake generate failed.' ; exit 1; }
cmake --build . --config ${build} || { echo 'Build failed.' ; exit 1; }

cd ..
