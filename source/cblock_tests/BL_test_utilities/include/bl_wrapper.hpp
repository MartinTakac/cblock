/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/
#pragma once

/*
includes
--------
*/
#include "bl.h"
#include <string>
#include <boost/filesystem.hpp>

namespace{
using namespace std;
namespace bfs = boost::filesystem;
}

namespace util
{

// Convenience function to time step the model n times
void time_step(BL_model *model, unsigned int n = 1);

/*******
	Wrapper class for BL_model_variable
	I tried writing one for BL_model too but it kept crashing when it tried to close BL so
	I gave up.
*******/
template <typename T>
class BLVariable
{
public:
	BLVariable(BL_model *model, const string &path)
		: path(path), model(model)
	{
		ptr = get_BL_model_variable(model, path.c_str());
		if (!(ptr))
		{
			throw runtime_error("Unable to get variable: " + path);
		}
		const int return_code = get_BL_model_variable_value_information(ptr, &(this->value_type), &(this->size));
		if (return_code != 1)
		{
			throw runtime_error("Unable to get variable information for " + path);
		}
	}
	// I think I need to do this because gtest complains if  I don't
	// Something something default constructor I dunno
	BLVariable() : ptr(nullptr), model(nullptr), path("") {}

	T get_value()
	{
		T value;
		const int return_code = copy_BL_model_variable_to_value(this->ptr, this->value_type, &value, 1);

		if (return_code != 1)
		{
			throw runtime_error("Unable to read variable: " + this->path);
		}

		return value;
	}

	vector<T> get_vector_value()
	{
		vector<T> values(this->size);
		const int return_code = copy_BL_model_variable_to_value(this->ptr, this->value_type, values.data(), this->size);

		if (return_code != 1)
		{
			throw runtime_error("Unable to read vector variable: " + this->path);
		}
		return values;
	}

	void set_value(const T new_value)
	{
		const int return_code = copy_value_to_BL_model_variable(this->value_type, &new_value, 1, this->ptr);

		if (return_code != 1)
		{
			throw runtime_error("Error setting variable: " + this->path);
		}
	}

	void set_vector_value(const vector<T> &values)
	{
		if (values.size() != static_cast<size_t>(this->size))
		{
			throw runtime_error("Unable to set variable: " + this->path + "\nSize mismatch");
		}
		const int return_code = copy_value_to_BL_model_variable(this->value_type, values.data(), this->size, this->ptr);

		if (return_code != 1)
		{
			throw runtime_error("Error setting vector variable " + this->path);
		}
	}

	BL_model *get_model()
	{
		return this->model;
	}

	BL_model_variable *get_ptr()
	{
		return this->ptr;
	}

	const string get_name() const
	{
		return this->name;
	}

	const BL_model_value_type get_value_type() const
	{
		return this->value_type;
	}

private:
	// Name of variable (i.e. without path info)
	string name;
	string path;
	unsigned int size;
	BL_model_value_type value_type;
	BL_model_variable *ptr;
	BL_model *model;
};
} // namespace util
