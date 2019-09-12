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
#include <fstream>
#include <cstdio>
#include <cstdlib>
#include <vector>
#include <memory>

#include "boost/filesystem.hpp"
#include "Python.h"
#include "bl_io.h"

namespace
{
namespace bfs = boost::filesystem;
using namespace std;
} // namespace

/*
Variable definitions
--------------------
*/
PyObject *RuntimeDataGenerator::pGeneratorModule;

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

PyObject *RuntimeDataGenerator::getGeneratorModule()
{
	return RuntimeDataGenerator::pGeneratorModule;
}

void RuntimeDataGenerator::finalize_python()
{
	if (Py_FinalizeEx() < 0)
	{
		cerr << "Error finalizing Python runtime" << endl;
		exit(99);
	}
}

/*
Initializes the Python runtime with a local module
*/
void RuntimeDataGenerator::initialize_python(bfs::path module_path)
{
	// Resolve the absolute path of the script (no symlinks or ..)
	module_path = bfs::canonical(module_path);
	// Makes all slashes agree (\\ for windows, / for everything else)
	module_path.make_preferred();

	/* Set-up Python runtime */
	string pyexe_path = CONDA_ENV_PATH "\\python.exe";

	// This tells the python runtime where the executable that is using it is
	// e.g. this would be /usr/bin/python if the python binary was calling it
	// PyDecodelocal converts a char string into a w_char string
	// We're making this point to the python binary so it will load the correct libraries
	std::unique_ptr<wchar_t> program(Py_DecodeLocale(pyexe_path.c_str(), nullptr));
	if (!program)
	{
		cerr << "Unable to decode Python executable path" << endl;
		exit(1);
	}
	Py_SetProgramName(program.get());

	unique_ptr<wchar_t> home(Py_DecodeLocale(CONDA_ENV_PATH, nullptr));
	if (!home)
	{
		cerr << "Unable to decode PYTHONHOME" << endl;
		exit(1);
	}
	Py_SetPythonHome(home.get());

	Py_Initialize();
	if (PyErr_Occurred())
	{
		PyErr_Print();
		cerr << "Error initializing Python" << endl;
		exit(1);
	}

	auto pModule = RuntimeDataGenerator::load_module(module_path);
	// Update the static storage with the module object
	RuntimeDataGenerator::setGeneratorModule(pModule);
	// We're done with this object here so decref it
	// (The setter above calls incref)
	Py_DECREF(pModule);
}

/* 
Initialize Python runtime with a package module 
*/
void RuntimeDataGenerator::initialize_python(std::string module_name)
{
	/* Set-up Python runtime */
	string pyexe_path = CONDA_ENV_PATH "\\python.exe";

	// This tells the python runtime where the executable that is using it is
	// e.g. this would be /usr/bin/python if the python binary was calling it
	// PyDecodelocal converts a char string into a w_char string
	// We're making this point to the python binary so it will load the correct libraries
	std::unique_ptr<wchar_t> program(Py_DecodeLocale(pyexe_path.c_str(), nullptr));
	if (!program)
	{
		cerr << "Unable to decode Python executable path" << endl;
		exit(1);
	}
	Py_SetProgramName(program.get());

	unique_ptr<wchar_t> home(Py_DecodeLocale(CONDA_ENV_PATH, nullptr));
	if (!home)
	{
		cerr << "Unable to decode PYTHONHOME" << endl;
		exit(1);
	}
	Py_SetPythonHome(home.get());

	Py_Initialize();
	if (PyErr_Occurred())
	{
		PyErr_Print();
		cerr << "Error initializing Python" << endl;
		exit(1);
	}

	// Loading a system module is really easy, so don't bother writing a separate function for it
	PyObject *pModuleName, *pModule;
	// Convert the module name to a Python string object (module name is file name without the extension)
	pModuleName = PyUnicode_DecodeFSDefault(module_name.c_str());
	if (pModuleName == nullptr)
	{
		cerr << "Unable to convert module name to Python string" << endl;
		PyErr_Print();
		exit(1);
	}

	// Perform the actual import of the module
	try
	{
		pModule = PyImport_Import(pModuleName);
	}
	catch (exception &ex)
	{
		cerr << "Exception when loading Python module \"" << module_name << "\":" << endl
			 << ex.what();
		exit(1);
	}
	if (pModule == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Unable to load Python module \"" << module_name << "\":" << endl;
		exit(1);
	}
	Py_DECREF(pModuleName);

	// Update the static storage with the module object
	RuntimeDataGenerator::setGeneratorModule(pModule);
	// We're done with this object here so decref it
	// (The setter above calls incref)
	Py_DECREF(pModule);
}

/*
Loads the given Python module
*/
PyObject *RuntimeDataGenerator::load_module(bfs::path module_path)
{
	/*
	Note: Calling Py_SetPath before initialization will not set the necessary variables sys.prefix and sys.exec_prefix.
	Quote from the documentation:
		"This also causes sys.executable to be set only to the raw program name (see Py_SetProgramName()) and for sys.prefix
		and sys.exec_prefix to be empty. It is up to the caller to modify these if required after calling Py_Initialize()."
	I think it's easier to modify sys.path after initialization rather than those, so that's what I do here.
	We need to add the module to sys.path for it to be able to import it.
	I tried to just use the high level string interpreter but it didn't work and I can't remmeber why.
	*/
	PyObject *pSysModuleName = PyUnicode_DecodeFSDefault("sys");
	if (pSysModuleName == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Unable to decode 'sys' to Python string" << endl;
		exit(1);
	}
	PyObject *pSysModule = PyImport_Import(pSysModuleName);
	Py_DECREF(pSysModuleName);
	if (pSysModule == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Unable to import 'sys' module" << endl;
		exit(1);
	}
	PyObject *pSysPathList = PyObject_GetAttrString(pSysModule, "path");
	Py_DECREF(pSysModule);
	if (pSysPathList == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Unable to get 'path' object from 'sys' module" << endl;
		exit(1);
	}
	PyObject *pSysPathInsertFunction = PyObject_GetAttrString(pSysPathList, "insert");
	Py_DECREF(pSysPathList);
	if (pSysPathInsertFunction == nullptr || !PyCallable_Check(pSysPathInsertFunction))
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Unable to get 'insert' function from 'sys.path' list" << endl;
		exit(1);
	}

	// Arguments to be passed to the sys.path.insert() function ("is" means integer and string)
	PyObject *pInsertArgs = Py_BuildValue("is", 0, module_path.parent_path().string().c_str());
	if (pInsertArgs == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Error building arguments tuple" << endl;
		exit(1);
	}

	// Call the insert method of sys.path
	PyObject *pInsertCallResult = PyObject_CallObject(pSysPathInsertFunction, pInsertArgs);
	Py_DECREF(pInsertArgs);
	if (pInsertCallResult == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Unable to call 'sys.path.insert()'" << endl;
		exit(1);
	}
	Py_DECREF(pSysPathInsertFunction);

	/* Load runtime generator module */
	PyObject *pModuleName, *pModule;
	// Convert the module name to a Python string object (module name is file name without the extension)
	pModuleName = PyUnicode_DecodeFSDefault(module_path.replace_extension("").filename().string().c_str());
	if (pModuleName == nullptr)
	{
		PyErr_Print();
		cerr << "Unable to convert module filename to Python string" << endl;
		exit(1);
	}

	// Perform the actual import of the module
	try
	{
		pModule = PyImport_Import(pModuleName);
	}
	catch (exception &ex)
	{
		cerr << "Exception when loading runtime data generator module:" << endl
			 << ex.what();
		exit(1);
	}
	if (pModule == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		cerr << "Unable to load runtime data generator module" << endl;
		exit(1);
	}
	Py_DECREF(pModuleName);

	return pModule;
}

/* Generates the runtime data based on the given config file and output path.
 * This function creates a RuntimeGenerator object from the runtime_generator Python module,
 * and calls its generate_runtime() function with the given variables.
 * This is essentially a C++ version of the 'generate_script.py' script.
 */
void RuntimeDataGenerator::generate_runtime_data(bfs::path config_file_path,
												 bfs::path output_path,
												 bfs::path template_path,
												 std::string class_name)
{
	// Make sure we aren't in the runtime data directory. Otherwise we won't be able to delete or generate anything in the Python script
	change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);

	if (chdir(config_file_path.parent_path().string().c_str()) < 0)
	{
		cerr << "Unable to change direcotry to " << config_file_path.parent_path().string() << endl;
		exit(1);
	}

	// Convert to canonical/absolute/fully-qualified paths and make directory separators agree
	// Note that these functions require the paths to exist, so we don't need to manually check that ourselves
	template_path = bfs::canonical(template_path).make_preferred();
	config_file_path = bfs::canonical(config_file_path).make_preferred();

	if (!bfs::exists(output_path))
	{
		if (!bfs::create_directory(output_path))
		{
			cerr << "Unable to create directory: " << output_path.string() << endl;
			exit(1);
		}
	}
	output_path = bfs::canonical(output_path).make_preferred();

	// Convert these paths to Python pathlib objects so we can pass them to the runtime generator function
	PyObject *pPathlibModule = PyImport_ImportModule("pathlib");
	if (pPathlibModule == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Unable to load \"pathlib\" module");
	}
	PyObject *pPathClass = PyObject_GetAttrString(pPathlibModule, "Path");
	if (pPathClass == nullptr || !PyCallable_Check(pPathClass))
	{
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Unable to load \"Path\" class");
	}
	Py_DECREF(pPathlibModule);

	/* Create the Path objects */
	PyObject *pTemplatePath = PyObject_CallObject(pPathClass, Py_BuildValue("(s)", template_path.string().c_str()));
	if (pTemplatePath == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Unable to create \"Path\" object: template_path");
	}
	PyObject *pOutputPath = PyObject_CallObject(pPathClass, Py_BuildValue("(s)", output_path.string().c_str()));
	if (pOutputPath == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Unable to create \"Path\" object: output_path");
	}
	PyObject *pConfigFilePath = PyObject_CallObject(pPathClass, Py_BuildValue("(s)", config_file_path.string().c_str()));
	if (pConfigFilePath == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Unable to create \"Path\" object: config_file_path");
	}
	Py_DECREF(pPathClass);

	// Create the RuntimeGenerator (or child) object
	PyObject *pRuntimeGeneratorClass = PyObject_GetAttrString(RuntimeDataGenerator::getGeneratorModule(), class_name.c_str());
	if (pRuntimeGeneratorClass == nullptr || !PyCallable_Check(pRuntimeGeneratorClass))
	{
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Unable to load RuntimeGenerator class");
	}

	// Call runtime generator constructor with no arguments
	PyObject *pRuntimeGeneratorInst = PyObject_CallObject(pRuntimeGeneratorClass, nullptr);
	if (pRuntimeGeneratorInst == nullptr)
	{
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Unable to instantiate RuntimeGenerator object");
	}

	// Get the generate_runtime function from the object
	PyObject *pGenerateRuntimeFunc = PyObject_GetAttrString(pRuntimeGeneratorInst, "generate_runtime");
	if (pGenerateRuntimeFunc == nullptr || !PyCallable_Check(pGenerateRuntimeFunc))
	{
		if (PyErr_Occurred())
			PyErr_Print();
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
		if (PyErr_Occurred())
			PyErr_Print();
		throw runtime_error("Error running function \"generate_runtime\"");
	}
	Py_DECREF(pGenFuncRes);
	Py_DECREF(pGenRuntimeArgs);
	Py_DECREF(pGenerateRuntimeFunc);
	Py_DECREF(pRuntimeGeneratorInst);
	Py_DECREF(pRuntimeGeneratorClass);

	// Create an empty .gitkeep file in the runtime data so the directory structure remains intact
	// Without this, the cblock folder would not exist in the git repo because it's otherwise empty
	fstream fs;
	auto gitkeep_path = output_path / ".gitkeep";
	fs.open(gitkeep_path.string(), ios::out);
	fs.close();
}