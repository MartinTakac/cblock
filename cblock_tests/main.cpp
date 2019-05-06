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

#include "gtest/gtest.h"
#include "Python.h"

int main(int argc, char* argv[])
{
	// This tells the python runtime where the executable that is using it is
	// e.g. this would be /usr/bin/python if the python binary was calling it
	std::unique_ptr<wchar_t> program(Py_DecodeLocale(argv[0], nullptr));
	if (!program)
	{
		throw std::runtime_error("Unable to decode argv[0]");
	}
	Py_SetProgramName(program.get());

	//wchar_t *home = Py_DecodeLocale("C:\\Users\\chris.gorman\\AppData\\Local\\Continuum\\anaconda3\\envs\\BASE_IMAGE", nullptr);
	//if (home == NULL)
	//{
	//	throw std::runtime_error("Unable to decode PYTHONHOME");
	//}
	//Py_SetPythonHome(home);

	//Py_Initialize();
	::testing::InitGoogleTest(&argc, argv);

	int res = RUN_ALL_TESTS();

	//if (Py_FinalizeEx() < 0)
	//{
	//	exit(120);
	//}

	return res;
}