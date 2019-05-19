/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

/*
includes
--------
*/
#include "runtime_data_generation.hpp"

#include <iostream>
#include <sstream>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <memory>

#include "boost/filesystem.hpp"
#include "Python.h"
#include "bl_io.h"

namespace {
	namespace bfs = boost::filesystem;
	using namespace std;
}

/*
Variable definitions
--------------------
*/
PyObject* RuntimeDataGenerator::pGeneratorModule;

/*
Function definitions
--------------------
*/

/*
Getter and setter for the runtime_generator module pointer
*/
void RuntimeDataGenerator::setGeneratorModule(PyObject *_pGeneratorModule)
{	
	Py_XDECREF(getGeneratorModule());
	RuntimeDataGenerator::pGeneratorModule = _pGeneratorModule;
	Py_INCREF(_pGeneratorModule);
}

PyObject* RuntimeDataGenerator::getGeneratorModule()
{
	return RuntimeDataGenerator::pGeneratorModule;
}

/* Generates the runtime data based on the given config file and output path.
 * This function creates a RuntimeGenerator object from the runtime_generator Python module,
 * and calls its generate_runtime() function with the given variables.
 * This is essentially a C++ version of the 'generate_script.py' script.
 */
void RuntimeDataGenerator::generate_runtime_data(bfs::path config_file_path, bfs::path output_path)
{
	// Make sure we aren't in the runtime data directory. Otherwise we won't be able to delete or generate anything in the Python script
	change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);

	bfs::path current_dir(CMAKE_CURRENT_SOURCE_DIR);
	auto template_path = current_dir / ".." / "cblock_template";
	// Convert to canonical/absolute/fully-qualified paths and make directory separators agree
	// Note that these functions require the paths to exist, so we don't need to manually check that ourselves
	template_path = bfs::canonical(template_path).make_preferred();
	config_file_path = bfs::canonical(config_file_path).make_preferred();
	output_path = bfs::canonical(output_path).make_preferred();

	// Convert these paths to Python pathlib objects so we can pass them to the runtime generator function
	PyObject *pPathlibModule = PyImport_ImportModule("pathlib");
	if (pPathlibModule == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to load \"pathlib\" module");
	}
	PyObject *pPathClass = PyObject_GetAttrString(pPathlibModule, "Path");
	if (pPathClass == nullptr || !PyCallable_Check(pPathClass))
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to load \"Path\" class");
	}
	Py_DECREF(pPathlibModule);

	/* Create the Path objects */
	PyObject *pTemplatePath = PyObject_CallObject(pPathClass, Py_BuildValue("(s)", template_path.string().c_str()));
	if (pTemplatePath == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to create \"Path\" object: template_path");
	}
	PyObject *pOutputPath = PyObject_CallObject(pPathClass, Py_BuildValue("(s)", output_path.string().c_str()));
	if (pOutputPath == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to create \"Path\" object: output_path");
	}
	PyObject *pConfigFilePath = PyObject_CallObject(pPathClass, Py_BuildValue("(s)", config_file_path.string().c_str()));
	if (pConfigFilePath == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to create \"Path\" object: config_file_path");
	}
	Py_DECREF(pPathClass);

	// Create the RuntimeGenerator object 
	PyObject *pRuntimeGeneratorClass = PyObject_GetAttrString(RuntimeDataGenerator::getGeneratorModule(), "RuntimeGenerator");
	if (pRuntimeGeneratorClass == nullptr || !PyCallable_Check(pRuntimeGeneratorClass))
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to load RuntimeGenerator class");
	}

	// Call runtime generator constructor with no arguments
	PyObject *pRuntimeGeneratorInst = PyObject_CallObject(pRuntimeGeneratorClass, nullptr);
	if (pRuntimeGeneratorInst == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to instantiate RuntimeGenerator object");
	}

	// Get the generate_runtime function from the object
	PyObject *pGenerateRuntimeFunc = PyObject_GetAttrString(pRuntimeGeneratorInst, "generate_runtime");
	if (pGenerateRuntimeFunc == nullptr || !PyCallable_Check(pGenerateRuntimeFunc))
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Unable to get generate_runtime function");
	}

	// Make the tuple of arguments for the generate_runtime function
	PyObject *pGenRuntimeArgs = Py_BuildValue("OOO", pTemplatePath, pOutputPath, pConfigFilePath);
	Py_DECREF(pTemplatePath);
	Py_DECREF(pOutputPath);
	Py_DECREF(pConfigFilePath);

	// Call the generate_runtime function. The result is nullptr if the call failed
	PyObject *pGenFuncRes = PyObject_CallObject(pGenerateRuntimeFunc, pGenRuntimeArgs);
	if (pGenFuncRes == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		throw runtime_error("Error running function \"generate_runtime\"");
	}
	Py_DECREF(pGenFuncRes);
	Py_DECREF(pGenRuntimeArgs);
	Py_DECREF(pGenerateRuntimeFunc);
	Py_DECREF(pRuntimeGeneratorInst);
	Py_DECREF(pRuntimeGeneratorClass);
}