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
	// TODO: Update when finalized
	string env_path = "C:\\Users\\chris.gorman\\AppData\\Local\\Continuum\\anaconda3\\envs\\cblock_tests";
	string pyexe_path = env_path + "\\python.exe";
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

	unique_ptr<wchar_t> home(Py_DecodeLocale(env_path.c_str(), nullptr));
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

	/*
	Note: Calling Py_SetPath before initialization will not set the necessary variables sys.prefix and sys.exec_prefix.
	Quote from the documentation:
		"This also causes sys.executable to be set only to the raw program name (see Py_SetProgramName()) and for sys.prefix
		and sys.exec_prefix to be empty. It is up to the caller to modify these if required after calling Py_Initialize()."
	I think it's easier to modify sys.path after initialization rather than those, so that's what I do here.
	We need to add the module to sys.path for it to be able to import it.
	Since it's really simple and I don't need access to the PyObjects, we just run the high level interpreter on the command string.
	*/
	PyObject *pSysModuleName = PyUnicode_DecodeFSDefault("sys");
	if (pSysModuleName == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Unable to decode 'sys' to Python string" << endl;
		exit(1);
	}
	PyObject *pSysModule = PyImport_Import(pSysModuleName);
	Py_DECREF(pSysModuleName);
	if (pSysModule == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Unable to import 'sys' module" << endl;
		exit(1);
	}
	PyObject *pSysPathList = PyObject_GetAttrString(pSysModule, "path");
	Py_DECREF(pSysModule);
	if (pSysPathList == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Unable to get 'path' object from 'sys' module" << endl;
		exit(1);
	}
	PyObject *pSysPathInsertFunction = PyObject_GetAttrString(pSysPathList, "insert");
	Py_DECREF(pSysPathList);
	if (pSysPathInsertFunction == nullptr || !PyCallable_Check(pSysPathInsertFunction))
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Unable to get 'insert' function from 'sys.path' list" << endl;
		exit(1);
	}

	// Arguments to be passed to the sys.path.insert() function
	PyObject *pInsertArgs = Py_BuildValue("is", 0, module_path.parent_path().string().c_str());
	if (pInsertArgs == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Error building arguments tuple" << endl;
		exit(1);
	}

	PyObject *pInsertCallResult = PyObject_CallObject(pSysPathInsertFunction, pInsertArgs);
	Py_DECREF(pInsertArgs);
	if (pInsertCallResult == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Unable to call 'sys.path.insert()'" << endl;
		exit(1);
	}
	Py_DECREF(pSysPathInsertFunction);

	//stringstream command_string;
	//// Set the first path item to be the location of the runtime generator module so it can be imported
	//command_string << "import sys;sys.path.insert(0,'" << module_path.parent_path().string() << "')";
	//cout << command_string.str() << endl;
	//PyRun_SimpleString(command_string.str().c_str());

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
	try {
		pModule = PyImport_Import(pModuleName);
	}
	catch (exception &ex)
	{
		cerr << "Exception when loading runtime data generator module:" << endl << ex.what();
		exit(1);
	}
	if (pModule == nullptr)
	{
		if (PyErr_Occurred()) PyErr_Print();
		cerr << "Unable to load runtime data generator module" << endl;
		exit(1);
	}
	Py_DECREF(pModuleName);

	// Update the static storage with the module object 
	RuntimeDataGenerator::setGeneratorModule(pModule);
	// We're done with this object here so decref it
	Py_DECREF(pModule);

	// Initialize and run googletest
	::testing::InitGoogleTest(&argc, argv);
	int res = RUN_ALL_TESTS();

	// Reference counting for Python variables
	Py_DECREF(pModule);
	if (Py_FinalizeEx() < 0)
	{
		cerr << "Error finalizing Python runtime" << endl;
		exit(99);
	}

	return res;
}