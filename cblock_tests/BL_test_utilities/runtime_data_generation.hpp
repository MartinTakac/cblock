/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

#pragma once

#include "boost/filesystem.hpp"
#include "Python.h"

namespace { namespace bfs = boost::filesystem; }

/**
Static class for managing runtimg data generation.
I don't know if this is best practice, so feel free to make it better if you want
Mainly chose to do a class so I can manage the reference counting for the module object
*/
class RuntimeDataGenerator
{
public:
	// Generates the runtime data at the given output path
	static void generate_runtime_data(bfs::path config_file_path, bfs::path output_path);

	// Setter for the Python module object
	static void setGeneratorModule(PyObject *_pGeneratorModule);
	// Getter for the Python module object
	static PyObject* getGeneratorModule();

private:
	// Disallow creating an object
	RuntimeDataGenerator() {}
	static PyObject *pGeneratorModule;
};