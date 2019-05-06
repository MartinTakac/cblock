/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

#pragma once

#include "boost/filesystem.hpp"

namespace { namespace bfs = boost::filesystem; }

// Delete the files in the runtime data directory
void delete_runtime_data(const bfs::path& path);
// Use the python templating script to generate a new runtime data
void generate_runtime_data(bfs::path config_file_path, bfs::path output_path, bfs::path current_dir);