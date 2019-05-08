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
#include "Python.h"
#include "boost/filesystem.hpp"

#include "BL_test_utilities/runtime_data_generation.hpp"

/*
	TODO:	
	Run initialize and finalize only once
	Load runtime generator from main()
	Update generator function to call the python function directly
		Should be easy with the boilerplate I already wrote
*/
int main(int argc, char* argv[])
{
	using namespace std;
	namespace bfs = boost::filesystem;

	auto current_dir = bfs::path(CMAKE_CURRENT_SOURCE_DIR);
	// Path to runtime generator module file
	auto module_path = current_dir / ".." / "runtime_data_generator" / "runtime_generator.py";
	// Resolve the absolute path of the script (no symlinks or ..)
	module_path = bfs::canonical(module_path);
	// Makes all slashes agree (\\ for windows, / for everything else)
	module_path.make_preferred();

	/* Set-up Python runtime */
	// This tells the python runtime where the executable that is using it is
	// e.g. this would be /usr/bin/python if the python binary was calling it
	// PyDecodelocal converts a char string into a w_char string
	std::unique_ptr<wchar_t> program(Py_DecodeLocale(argv[0], nullptr));
	if (!program)
	{
		throw std::runtime_error("Unable to decode argv[0]");
	}
	Py_SetProgramName(program.get());

	// TODO: Update when finalized
	wchar_t *home = Py_DecodeLocale("C:\\Users\\chris.gorman\\AppData\\Local\\Continuum\\anaconda3\\envs\\cblock_tests", nullptr);
	if (home == NULL)
	{
		cerr << "Unable to decode PYTHONHOME" << endl;
		exit(100);
	}
	Py_SetPythonHome(home);

	// Set the first path item to be the location of the runtime generator module
	auto current_path = Py_GetPath();
	auto path_string = Py_EncodeLocale(current_path, nullptr);
	stringstream new_path;
	new_path << module_path.parent_path().string() <<
#if defined (BL_WINDOWS)
		";"
#else
		":"
#endif
		<< path_string;
	Py_SetPath(Py_DecodeLocale(new_path.str().c_str(), nullptr));

	Py_Initialize();
	if (PyErr_Occurred())
	{
		PyErr_Print();
		cerr << "Error initializing Python" << endl;
		exit(101);
	}

	/* Load module */
	PyObject *pModuleName, *pModule;
	// Convert the module name to a Python string object (module name is file name without the extension)
	pModuleName = PyUnicode_DecodeFSDefault(module_path.replace_extension("").filename().string().c_str());
	if (pModuleName == nullptr)
	{
		PyErr_Print();
		throw runtime_error("Unable to convert module filename to Python string");
	}
	// FIXME: Currently does not load the numpy module. Probably a problem with pythonhome or something. Deal with tomorrow
	// Perform the actual import of the module
	try {
		pModule = PyImport_Import(pModuleName);
	}
	catch (exception &ex)
	{
		cerr << "Exception when loading runtime data generator module:" << endl << ex.what();
		exit(102);
	}
	if (pModule == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Unable to load runtime data generator module" << endl;
		exit(103);
	}

	// Update the static storage with the module object 
	RuntimeDataGenerator::setGeneratorModule(pModule);

	// Initialize and run googletest
	::testing::InitGoogleTest(&argc, argv);
	int res = RUN_ALL_TESTS();

	// Reference counting for Python variables
	Py_DECREF(pModuleName);
	Py_DECREF(pModule);
	if (Py_FinalizeEx() < 0)
	{
		cerr << "Error finalizing Python runtime" << endl;
		exit(99);
	}

	return res;
}