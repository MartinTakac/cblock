#*******************************************************************************
# Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
#
# FILE : CMakeLists.txt
#
# DESCRIPTION :
# cmake file for cblock_tests executable
#===============================================================================

#link_directories have to be before target is created
link_directories(${THIRD_PARTY}/gtest/googletest-release-1.8.0/builds/${OS_STATIC_LIB_DIR}/lib/)

# The boost lib dir is either 'lib' or 'libs' because hey why not
set(BOOST_DIR ${THIRD_PARTY}/boost/${USE_BOOST_VERSION}/builds/${OS_STATIC_LIB_DIR})

IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # Mac OS X
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread")
    link_directories(${BOOST_DIR}/lib)
    link_directories(${CONDA_ENV_PATH}/lib)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
IF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    # Windows
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    link_directories(${BOOST_DIR}/libs)
    link_directories(${CONDA_ENV_PATH}/libs)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    # Linux
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread")
    link_directories(${BOOST_DIR}/lib)
    link_directories(${CONDA_ENV_PATH}/lib)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")

link_directories(${SM_HOME}/${BL_BUILD_DIR}/SDK/BL)
link_directories(${SM_HOME}/${BL_BUILD_DIR}/SDK/BL_std)    
link_directories(${SM_HOME}/${BL_BUILD_DIR}/SDK/BL_interface/)

set(CBLOCK_TESTS_SOURCES 
    main.cpp
	cblock_dialog/cblock_dialog.cpp
	cblock_letters/cblock_letters.cpp
	BL_test_utilities/test_expect_variable_value.cpp
	BL_test_utilities/test_expect_variable_value.h
	BL_test_utilities/run_in_BL.cpp
	BL_test_utilities/run_in_BL.hpp
	BL_test_utilities/dialog_helper_functions.cpp
    BL_test_utilities/dialog_helper_functions.h
    BL_test_utilities/runtime_data_generation.cpp
    BL_test_utilities/runtime_data_generation.hpp
)

set(TARGET_NAME cblock_tests)

add_executable(${TARGET_NAME} ${CBLOCK_TESTS_SOURCES})

target_compile_definitions(${TARGET_NAME} PRIVATE CMAKE_CURRENT_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_definitions(${TARGET_NAME} PRIVATE CONDA_ENV_PATH="${CONDA_ENV_PATH}")
IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # Mac OS X
    target_compile_definitions(${TARGET_NAME} PRIVATE BL_OSX)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
IF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    # Windows
    target_compile_definitions(${TARGET_NAME} PRIVATE BL_WINDOWS)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    # Linux
    target_compile_definitions(${TARGET_NAME} PRIVATE BL_LINUX)
ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")

target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL_std/include)
target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL/include)
target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL_interface/include)
target_include_directories(${TARGET_NAME} PRIVATE ${THIRD_PARTY}/gtest/googletest-release-1.8.0/builds/${OS_STATIC_LIB_DIR}/include)
target_include_directories(${TARGET_NAME} PRIVATE ${THIRD_PARTY}/boost/${USE_BOOST_VERSION}/builds/${OS_STATIC_LIB_DIR})
target_include_directories(${TARGET_NAME} PRIVATE .)

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    target_include_directories(${TARGET_NAME} PRIVATE ${CONDA_ENV_PATH}/include)
else()
    target_include_directories(${TARGET_NAME} PRIVATE ${CONDA_ENV_PATH}/include/python3.7m)
endif()

target_link_libraries (${TARGET_NAME}
    PRIVATE debug gtestd optimized gtest
    PRIVATE debug gmockd optimized gmock
    PRIVATE debug gtest_maind optimized gtest_main)

target_link_libraries(${TARGET_NAME} PRIVATE BL)
target_link_libraries(${TARGET_NAME} PRIVATE BL_std)
target_link_libraries(${TARGET_NAME} PRIVATE ${BOOST_LIBS})

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    target_link_libraries(${TARGET_NAME} PRIVATE python37)
else()
    target_link_libraries(${TARGET_NAME} PRIVATE python37m)
endif()


set(TARGET_NAME cblock_tests_with_interface)

add_executable(${TARGET_NAME} ${CBLOCK_TESTS_SOURCES})

target_compile_definitions(${TARGET_NAME} PRIVATE CMAKE_CURRENT_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_definitions(${TARGET_NAME} PRIVATE USE_BL_INTERFACE=true)
target_compile_definitions(${TARGET_NAME} PRIVATE CONDA_ENV_PATH="${CONDA_ENV_PATH}")

target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL_std/include)
target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL/include)
target_include_directories(${TARGET_NAME} PRIVATE ${SM_HOME}/SDK/BL_interface/include)
target_include_directories(${TARGET_NAME} PRIVATE ${THIRD_PARTY}/gtest/googletest-release-1.8.0/builds/${OS_STATIC_LIB_DIR}/include)
target_include_directories(${TARGET_NAME} PRIVATE ${THIRD_PARTY}/boost/${USE_BOOST_VERSION}/builds/${OS_STATIC_LIB_DIR})
target_include_directories(${TARGET_NAME} PRIVATE .)

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    target_include_directories(${TARGET_NAME} PRIVATE ${CONDA_ENV_PATH}/include)
else()
    target_include_directories(${TARGET_NAME} PRIVATE ${CONDA_ENV_PATH}/include/python3.7m)
endif()

target_link_libraries (${TARGET_NAME}
    PRIVATE debug gtestd optimized gtest
    PRIVATE debug gmockd optimized gmock
    PRIVATE debug gtest_maind optimized gtest_main)

target_link_libraries(${TARGET_NAME} PRIVATE BL)
target_link_libraries(${TARGET_NAME} PRIVATE BL_std)
target_link_libraries(${TARGET_NAME} PRIVATE BL_interface)
target_link_libraries(${TARGET_NAME} PRIVATE ${BOOST_LIBS})

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    target_link_libraries(${TARGET_NAME} PRIVATE python37)
else()
    target_link_libraries(${TARGET_NAME} PRIVATE python37m)
endif()

IF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${SM_HOME}/${BL_BUILD_DIR}/SDK/BL/$<CONFIG>/BL.dll $<TARGET_FILE_DIR:${TARGET_NAME}>)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${SM_HOME}/${BL_BUILD_DIR}/SDK/BL_interface/$<CONFIG>/BL_interface.dll $<TARGET_FILE_DIR:${TARGET_NAME}>)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${SM_HOME}/${BL_BUILD_DIR}/SDK/BL_OpenGL_render/$<CONFIG>/BL_render.dll $<TARGET_FILE_DIR:${TARGET_NAME}>)
	add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND}
        -E copy_if_different ${THIRD_PARTY}/glew/builds/windows.vs2015/bin/Release/x64/glew32.dll $<TARGET_FILE_DIR:${TARGET_NAME}>)    
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${CONDA_ENV_PATH}/python37.dll $<TARGET_FILE_DIR:${TARGET_NAME}>)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${CONDA_ENV_PATH}/python37.pdb $<TARGET_FILE_DIR:${TARGET_NAME}>)        

ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin" AND NOT DEFINED IOS_PLATFORM)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${SM_HOME}/${BL_BUILD_DIR}/SDK/BL/$<CONFIG>/libBL.dylib $<TARGET_FILE_DIR:${TARGET_NAME}>)
    # TODO: Update with actual location of mac libs
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${CONDA_ENV_PATH}/python37.dylib $<TARGET_FILE_DIR:${TARGET_NAME}>)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD COMMAND ${CMAKE_COMMAND} 
        -E copy_if_different ${CONDA_ENV_PATH}/python37.pdb $<TARGET_FILE_DIR:${TARGET_NAME}>)
ENDIF()
