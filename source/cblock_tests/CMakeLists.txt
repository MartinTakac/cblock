#*******************************************************************************
# Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
#
# FILE : CMakeLists.txt
#
# DESCRIPTION :
# cmake file for cblock_tests executable
# 
# Write project description here
# Separate tests based on the runtime data they will use.
#===============================================================================

#link_directories have to be before target is created
link_directories(${THIRD_PARTY}/gtest/googletest-release-1.8.0/builds/${OS_STATIC_LIB_DIR}/lib/)

# The boost lib dir is either 'lib' or 'libs' because hey why not
set(BOOST_DIR ${THIRD_PARTY}/boost/${USE_BOOST_VERSION}/builds/${OS_STATIC_LIB_DIR})

# Linux
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread")
link_directories(${BOOST_DIR}/lib)
link_directories(${CONDA_ENV_PATH}/lib)

link_directories(${SM_HOME}/${BL_BUILD_DIR}/SDK/BL)
link_directories(${SM_HOME}/${BL_BUILD_DIR}/SDK/BL_std)    
link_directories(${SM_HOME}/${BL_BUILD_DIR}/SDK/BL_interface)
link_directories(${SM_HOME}/${BL_BUILD_DIR}/SDK/BL_OpenGL_render)

set(CBLOCK_TESTS_SOURCES 
    main.cpp
    letters/letters_tests.cpp
    dialog/dialog_tests.cpp
	BL_test_utilities/source/test_expect_variable_value.cpp
	BL_test_utilities/include/test_expect_variable_value.h
	BL_test_utilities/source/run_in_BL.cpp
	BL_test_utilities/include/run_in_BL.hpp
	BL_test_utilities/source/dialog_helper_functions.cpp
    BL_test_utilities/include/dialog_helper_functions.h
    BL_test_utilities/source/runtime_data_generation.cpp
    BL_test_utilities/include/runtime_data_generation.hpp
    BL_test_utilities/source/bl_wrapper.cpp
    BL_test_utilities/include/bl_wrapper.hpp
)

set(TARGET_NAME cblock_tests)

add_executable(${TARGET_NAME} ${CBLOCK_TESTS_SOURCES})

target_compile_definitions(${TARGET_NAME} PRIVATE CMAKE_CURRENT_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_definitions(${TARGET_NAME} PRIVATE CONDA_ENV_PATH="${CONDA_ENV_PATH}")
target_compile_definitions(${TARGET_NAME} PRIVATE BL_LINUX)

target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL_std/include)
target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL/include)
target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL_interface/include)
target_include_directories(${TARGET_NAME} PRIVATE ${THIRD_PARTY}/gtest/googletest-release-1.8.0/builds/${OS_STATIC_LIB_DIR}/include)
target_include_directories(${TARGET_NAME} PRIVATE ${THIRD_PARTY}/boost/${USE_BOOST_VERSION}/builds/${OS_STATIC_LIB_DIR})
target_include_directories(${TARGET_NAME} PRIVATE BL_test_utilities/include)
target_include_directories(${TARGET_NAME} PRIVATE .)
target_include_directories(${TARGET_NAME} PRIVATE ${CONDA_ENV_PATH}/include/python3.7m)

target_link_libraries (${TARGET_NAME}
    PRIVATE debug gtestd optimized gtest
    PRIVATE debug gmockd optimized gmock
    PRIVATE debug gtest_maind optimized gtest_main)

target_link_libraries(${TARGET_NAME} PRIVATE BL)
target_link_libraries(${TARGET_NAME} PRIVATE BL_std)
target_link_libraries(${TARGET_NAME} PRIVATE ${BOOST_LIBS})
target_link_libraries(${TARGET_NAME} PRIVATE python3.7m)