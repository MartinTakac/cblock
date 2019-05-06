/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/
#if !defined (TEST_EXPECT_VARIABLE_VALUE_H)
#define TEST_EXPECT_VARIABLE_VALUE_H

#include "bl.h"

void ExpectVariableValue(struct BL_model_variable *variable, unsigned expectedValue, const char *failure_output_string = NULL);

void ExpectVariableValue(struct BL_model_variable *variable, int expectedValue, const char *failure_output_string = NULL);

void ExpectVariableValue(struct BL_model_variable *variable, BL_real expectedValue, const char *failure_output_string = NULL);

void ExpectVariableValue(struct BL_model_variable *variable, char expectedValue, const char *failure_output_string = NULL);

void ExpectVariableValue(struct BL_model_variable *variable, std::vector<unsigned> expectedValues, const char *failure_output_string = NULL);

void ExpectVariableValue(struct BL_model_variable *variable, std::vector<int> expectedValues, const char *failure_output_string = NULL);

void ExpectVariableValue(struct BL_model_variable *variable, std::vector<BL_real> expectedValues, const char *failure_output_string = NULL);

void ExpectVariableValue(struct BL_model_variable *variable, std::vector<char> expectedValues, const char *failure_output_string = NULL);

void ExpectVariableValueNear(struct BL_model_variable *variable, BL_real expectedValue, BL_real tolerance, const char *failure_output_string = NULL);

void ExpectVariableValueNear(struct BL_model_variable *variable, std::vector<BL_real> expectedValues, BL_real tolerance, const char *failureOutputString = NULL);

BL_real get_variable_value(BL_model* model_ptr, const char *variable_name);

std::vector<BL_real> get_variable_array(BL_model* model_ptr, const char *variable_name);

int set_variable_float(BL_model* model_ptr, const char *variable_name, BL_real value);

int set_variable_array(BL_model* model_ptr, const char *variable_name, std::vector<BL_real> data);

// N.B. Checks resulting transformation matrices.
// This means that transformations which are mathematically equivalent should
// compare as matching, even if they're generated from different Euler angles.
void ExpectTransformationVariableValue(struct BL_model_variable *variable,
	BL_real rx, BL_real ry, BL_real rz, BL_real ox, BL_real oy, BL_real oz,
	BL_real tx, BL_real ty, BL_real tz, BL_real scale, BL_real tolerance);


#if defined (__cplusplus)
class TestVariableWrapper
{
	BL_real real_value;
	int int_value;
	unsigned int unsigned_value;
	std::vector<char> char_vector;
	std::vector<BL_real> real_vector;

	BL_model_value_type type;
	bool isVector;

public:
	TestVariableWrapper(BL_real value) :
		real_value(value), type(BL_MODEL_VALUE_REAL), isVector(false)
	{
	}

	TestVariableWrapper(int value) :
		int_value(value), type(BL_MODEL_VALUE_INTEGER), isVector(false)
	{
	}

	TestVariableWrapper(unsigned value) :
		unsigned_value(value), type(BL_MODEL_VALUE_UNSIGNED), isVector(false)
	{
	}

	TestVariableWrapper(const char* value) :
		type(BL_MODEL_VALUE_CHARACTER), isVector(true)
	{
		const std::string valueAsStdString(value);
		char_vector = std::vector<char>(valueAsStdString.begin(), valueAsStdString.end());
	}

	TestVariableWrapper(std::vector<BL_real> value) :
		real_vector(value), type(BL_MODEL_VALUE_REAL), isVector(true)
	{
	}

	TestVariableWrapper(std::vector<char> value) :
		char_vector(value), type(BL_MODEL_VALUE_CHARACTER), isVector(true)
	{
	}

	int SetVariableWithValue(BL_model_variable *blVariable) const;

	int SetVariableWithValue(BL_model *blModel, const char *variableName) const;

	void ExpectBLVariableMatchesValue(BL_model_variable *blVariable, const char *variableName) const;

};
#endif /* defined (__cplusplus) */

#endif /* TEST_EXPECT_VARIABLE_VALUE_H */
