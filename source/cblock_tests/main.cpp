/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

/*
definitions
-----------
*/
#define PY_SSIZE_T_CLEAN

/*
includes
--------
*/
#include <memory>
#include <vector>

#include "gtest/gtest.h"
#include "boost/filesystem.hpp"

#include "runtime_data_generation.hpp"

int main(int argc, char *argv[])
{
    using namespace std;
    namespace bfs = boost::filesystem;
    auto current_dir = bfs::path(CMAKE_CURRENT_SOURCE_DIR);
    // Name of the runtime generator module
    // You can change this to be a bfs::path pointing to a custom module, too.
    string module_name = "bl_runtime_generator";

    RuntimeDataGenerator::initialize_python(module_name);

    // Initialize and run googletest
    ::testing::InitGoogleTest(&argc, argv);
    int res = RUN_ALL_TESTS();

    RuntimeDataGenerator::finalize_python();

    return res;
}