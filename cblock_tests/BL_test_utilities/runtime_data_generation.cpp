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

namespace {
	namespace bfs = boost::filesystem;
	using namespace std;
}

void delete_runtime_data(const bfs::path& path)
{
	try
	{
		for (bfs::directory_entry &x : bfs::directory_iterator(path))
		{
			// remove_all is recursive, but we don't just call it on path because we want to keep the parent directory
			bfs::remove_all(x.path());
		}
	}
	catch (const bfs::filesystem_error &ex)
	{
		cerr << "Unable to delete runtime data file, message: " << endl << "\t" << ex.what() << endl;
		exit(1);
	}
}

void generate_runtime_data(bfs::path config_file_path, bfs::path output_path, bfs::path current_dir)
{
	auto script_path = current_dir / ".." / "runtime_data_generator" / "runtime_generator.py";
	auto template_path = current_dir / ".." / "cblock_template";

	// Convert to canonical/absolute/fully-qualified paths and make directory separators agree
	// Note that these functions require the paths to exist, so we don't need to manually check that ourselves
	script_path = bfs::canonical(script_path).make_preferred();
	template_path = bfs::canonical(template_path).make_preferred();

	// Arguments for the python script
	vector<string> arguments = { script_path.string(), "-r", template_path.string(), "-c", config_file_path.make_preferred().string(), "-o", output_path.make_preferred().string() };

	// Convert the arguments into wide char arrays for Python to consume
	vector<wchar_t*> argv;
	for (const auto& arg : arguments)
	{
		argv.push_back(Py_DecodeLocale(arg.c_str(), nullptr));
	}
	argv.push_back(nullptr);

	unique_ptr<wchar_t> home(Py_DecodeLocale("C:\\Users\\chris.gorman\\AppData\\Local\\Continuum\\anaconda3\\envs\\cblock_tests", nullptr));
	if (!home)
	{
		throw std::runtime_error("Unable to decode PYTHONHOME");
	}
	Py_SetPythonHome(home.get());

	Py_Initialize();
	
	PySys_SetArgvEx(argv.size() - 1, argv.data(), 0);
	

	// Windows needs to read python script as binary otherwise CRLF breaks the interpreter
	unique_ptr<FILE> script(fopen(script_path.string().c_str(), 
#if defined (BL_WINDOWS)
		"rb"
#else
		"r"
#endif
	));

	if (!script)
	{
		throw std::runtime_error("Unable to open file");
	}

	// TODO: Crashing
	PyRun_SimpleFile(script.get(), script_path.filename().string().c_str());
	fclose(script.get());

	if (Py_FinalizeEx() < 0)
	{
		exit(120);
	}

	//stringstream command_string;
	//command_string << python_path << " " << script_path.string() << " -r " << template_path.string() << " -c " << config_file_path.string() << " -o " << output_path.string();
	//system(command_string.str().c_str());
}