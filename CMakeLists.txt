# Copyright 2017 Soul Machines Ltd. All Rights Reserved.
# Root cmake file for the SM solution.

# TODO:
#   Make conda environment
#   Install numpy (USE PIP OTHERWISE IT DOES MKL)

cmake_minimum_required(VERSION 3.9)

# Some things need to be set before the project statement to affect the generator.
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.12" CACHE STRING "Minimum OS X deployment version")

project(cblock_tests)

if (NOT DEFINED SM_HOME)
    set(SM_HOME "D:\\BL_Source\\SM")
endif()

# Load and parse version file
file (STRINGS "${SM_HOME}/SDK/version.txt" CM_BUILD_VERSION_STRING)
IF ("${CM_BUILD_VERSION_STRING}" STREQUAL "")
    set(CM_BUILD_VERSION_STRING "1.0.0")
ENDIF()
string(REPLACE "." ";" VERSION_LIST ${CM_BUILD_VERSION_STRING})
list(GET VERSION_LIST 0 CM_BUILD_VERSION_MAJOR)
list(GET VERSION_LIST 1 CM_BUILD_VERSION_MINOR)
list(GET VERSION_LIST 2 CM_BUILD_VERSION_PATCH)

# Global common build switches. These should disappear and become the defaults over time.
set(SDK_TIMESTEP_THREAD YES)

IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(OS_STATIC_LIB_DIR osx)
    set(BL_BUILD_DIR build_mac)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    set(OS_STATIC_LIB_DIR windows)
    set(BL_BUILD_DIR build_windows)
ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(OS_STATIC_LIB_DIR linux)
    set(BL_BUILD_DIR build_linux)
ENDIF()

set(BUILD_FROM_SM YES)
set(CMAKE_XCODE_GENERATE_TOP_LEVEL_PROJECT_ONLY TRUE)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if (NOT DEFINED SM_CMAKE_SCRIPTS)
    get_filename_component(SM_CMAKE_SCRIPTS ${SM_HOME}/cmake ABSOLUTE)
endif()

include(${SM_CMAKE_SCRIPTS}/find_third_party_root.cmake)
IF (NOT DEFINED THIRD_PARTY)
    find_third_party_root(THIRD_PARTY ${CMAKE_CURRENT_SOURCE_DIR})
    IF ("${THIRD_PARTY}" STREQUAL "")
        message(FATAL_ERROR "Cannot find third_party directory. You can set THIRD_PARTY manually if you wish.")
    ENDIF()
ENDIF()
set(ENV{THIRD_PARTY} ${THIRD_PARTY})
message("Using third party directory: " ${THIRD_PARTY})

include(${SM_CMAKE_SCRIPTS}/parse_versions.cmake)
parse_versions("${SM_HOME}/third_party_versions.txt")

message("Build number is: " $ENV{BUILD_NUMBER})
include(${THIRD_PARTY}/smart_update.cmake)
smart_update("${SM_HOME}/third_party_versions.txt")

include(${SM_CMAKE_SCRIPTS}/compile_options.cmake)

# Code Signing
# If SM code signing off, default to developer's personal signing key unless we're on Jenkins
if (DEFINED SM_CODE_SIGN)
    set(WINDOWS_SIGNTOOL "${SM_CMAKE_SCRIPTS}/signcode.bat")
    set(MAC_CODE_SIGN_IDENTITY "Developer ID Application: Soul Machines Limited")
elseif ("$ENV{BUILD_NUMBER}" STREQUAL "")
    set(MAC_CODE_SIGN_IDENTITY "Mac Developer")
endif()

set(CEF_VERSION_DESIGNATOR cef_binary_3.3239.1706.gcd33baa_custom)

if (DEFINED BUILD_THIRD_PARTY)
    add_subdirectory(../third_party third_party)
else()
    # This is the normal case: import prebuilt third party libraries.
    # The current version of each shared party component is set in the import..() function.
    include(${SM_CMAKE_SCRIPTS}/import_all.cmake)
    import_citar()
    import_tinyxml2()
    import_minizip()
endif()

# Create conda environment for tests
include(create_conda_env.cmake)
#message("CMake bin dir root: ${CMAKE_CURRENT_BINARY_DIR}")
create_conda_env(CONDA_ENV_PATH "cblock_tests_env" ${CMAKE_CURRENT_BINARY_DIR} "requirements.txt")

# CG: We're building against trunk_deployment so the thread pooling isn't there
# add_definitions(-DBEFORE_THREAD_POOLING)
# add_definitions(-DBEFORE_RENDER_THREAD_POOLING)
add_definitions(-DBEFORE_MODEL_TIME_TO_REAL_TIME_RATIO)

set(BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})
add_subdirectory(cblock_tests)
