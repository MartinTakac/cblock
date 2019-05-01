/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

#include <functional>

/*
includes
--------
*/
#include "gtest/gtest.h"
#include "bl_message.h"

#include "test_expect_variable_value.h"

template<typename T> void CompareFunction(T expected, T result)
{
	EXPECT_EQ(expected, result) << "Variable is expected to be " << expected;
}

template<> void CompareFunction(BL_real expected, BL_real result)
{
	EXPECT_FLOAT_EQ(expected, result) << "Variable is expected to be " << expected;
}

template<> void CompareFunction(const char *expected, const char *result)
{
	EXPECT_STREQ(expected, result) << "Variable is expected to be " << expected;
}

template<typename T> void CompareFunction(T expected, T result, T tolerance)
{
	EXPECT_NEAR(expected, result, tolerance) << "Variable is expected to be near " << expected;
}

// Internal expect value functions
template<typename T> void ExpectVariableValueSinglePrivate(
	struct BL_model_variable *variable,
	T expectedValue,
	BL_model_value_type expectedValueType)
{
	BL_model_value_type output_value_type;
	unsigned output_number=0;
	get_BL_model_variable_value_information(variable,
		&output_value_type,&output_number);
	if ((BL_MODEL_VALUE_UNSIGNED==expectedValueType)&&
		(BL_MODEL_VALUE_INTEGER==output_value_type))
	{
		output_value_type=BL_MODEL_VALUE_UNSIGNED;
	}
	else if ((BL_MODEL_VALUE_INTEGER==expectedValueType)&&
		(BL_MODEL_VALUE_UNSIGNED==output_value_type))
	{
		output_value_type=BL_MODEL_VALUE_INTEGER;
	}
	EXPECT_EQ(expectedValueType,output_value_type);
	EXPECT_EQ(1,output_number);

	T output;
	copy_BL_model_variable_to_value(variable,
		expectedValueType,&output,1);
	CompareFunction(expectedValue,output);
}

template<typename T> void CompareFunction(std::vector<T> expected, std::vector<T> result)
{
	for (int i = 0; ((i < result.size()) && (i < expected.size())); ++i) {
		EXPECT_EQ(expected[i], result[i]) << "Array[" << i <<
			"] is expected to be " << expected[i];
	}
}

template<> void CompareFunction(std::vector<BL_real> expected, std::vector<BL_real> result)
{
	for (int i = 0; ((i < result.size()) && (i < expected.size())); ++i) {
		EXPECT_FLOAT_EQ(expected[i], result[i]) << "Array[" << i <<
			"] is expected to be " << expected[i];
	}
}

template<typename T> void CompareFunction(std::vector<T> expected, std::vector<T> result, const char *failureOutputString)
{
	for (int i = 0; ((i < result.size()) && (i < expected.size())); ++i) {
		EXPECT_EQ(expected[i], result[i]) << failureOutputString;
	}
}

template<> void CompareFunction(std::vector<BL_real> expected, std::vector<BL_real> result, const char *failureOutputString)
{
	for (int i = 0; ((i < result.size()) && (i < expected.size())); ++i) {
		EXPECT_FLOAT_EQ(expected[i], result[i]) << failureOutputString;
	}
}

template<typename T> void CompareFunctionNear(std::vector<T> expected, std::vector<T> result, T tolerance)
{
	for (int i = 0; ((i < result.size()) && (i < expected.size())); ++i) {
		EXPECT_NEAR(expected[i], result[i], tolerance) << "Array[" << i <<
			"] is expected to be near " << expected[i];
	}
}

template<typename T> void CompareFunctionNear(std::vector<T> expected, std::vector<T> result, T tolerance, const char *failureOutputString)
{
	for (int i = 0; ((i < result.size()) && (i < expected.size())); ++i) {
		EXPECT_NEAR(expected[i], result[i], tolerance) << failureOutputString;
	}
}

template<typename T> void ExpectVariableValueArrayPrivate(
	struct BL_model_variable *variable,
	std::vector<T> expectedValues,
	BL_model_value_type expectedValueType, 
	const char *failureOutputString)
{
	BL_model_value_type output_value_type;
	unsigned output_number=0;
	unsigned expected_output_number=static_cast<unsigned>(expectedValues.size());
	get_BL_model_variable_value_information(variable,
	&output_value_type,&output_number);
	EXPECT_EQ(expectedValueType,output_value_type);
	EXPECT_EQ(expected_output_number,output_number);
	
	if (output_number==expected_output_number) {
		std::vector<T> output_array;
	
		output_array.resize(output_number);
	
		copy_BL_model_variable_to_value(variable,
			expectedValueType,(output_array.data()),output_number);
	
		if (failureOutputString == (const char *)NULL)
			CompareFunction(expectedValues, output_array);
		else
			CompareFunction(expectedValues, output_array, failureOutputString);
	}
}

void ExpectVariableValueTypePrivate(struct BL_model_variable *variable, BL_model_value_type expectedValueType)
{
	BL_model_value_type output_value_type;
	unsigned output_number = 0;
	get_BL_model_variable_value_information(variable,
		&output_value_type, &output_number);
	EXPECT_EQ(expectedValueType, output_value_type);
	EXPECT_EQ(1, output_number);
}

// Single value overloads
void ExpectVariableValue(struct BL_model_variable *variable,unsigned expectedValue, const char *failure_output_string)
{
	ExpectVariableValueSinglePrivate<unsigned>(variable,expectedValue,BL_MODEL_VALUE_UNSIGNED);
}

void ExpectVariableValue(struct BL_model_variable *variable,int expectedValue, const char *failure_output_string)
{
	ExpectVariableValueSinglePrivate<int>(variable,expectedValue,BL_MODEL_VALUE_INTEGER);
}

void ExpectVariableValue(struct BL_model_variable *variable,BL_real expectedValue, const char *failure_output_string)
{
	ExpectVariableValueSinglePrivate(variable,expectedValue,BL_MODEL_VALUE_REAL);
}

void ExpectVariableValue(struct BL_model_variable *variable,char expectedValue, const char *failure_output_string)
{
	ExpectVariableValueSinglePrivate<char>(variable,expectedValue,BL_MODEL_VALUE_CHARACTER);
}

// Array value overloads
void ExpectVariableValue(struct BL_model_variable *variable,std::vector<unsigned> expectedValues, const char *failure_output_string)
{
	ExpectVariableValueArrayPrivate<unsigned>(variable,expectedValues,BL_MODEL_VALUE_UNSIGNED, failure_output_string);
}

void ExpectVariableValue(struct BL_model_variable *variable,std::vector<int> expectedValues, const char *failure_output_string)
{
	ExpectVariableValueArrayPrivate<int>(variable,expectedValues,BL_MODEL_VALUE_INTEGER, failure_output_string);
}

void ExpectVariableValue(struct BL_model_variable *variable,std::vector<BL_real> expectedValues, const char *failure_output_string)
{
	ExpectVariableValueArrayPrivate<BL_real>(variable,expectedValues,BL_MODEL_VALUE_REAL, failure_output_string);
}

void ExpectVariableValue(struct BL_model_variable *variable,std::vector<char> expectedValues, const char *failure_output_string)
{
	ExpectVariableValueArrayPrivate<char>(variable,expectedValues,BL_MODEL_VALUE_CHARACTER, failure_output_string);
}

void ExpectVariableValueType(struct BL_model_variable *variable, BL_model_value_type expectedValueType, const char *failure_output_string)
{
	ExpectVariableValueTypePrivate(variable, expectedValueType);
}

BL_real get_variable_value(BL_model* model_ptr, const char *variable_name)
{
	BL_real value;
	auto variable = get_BL_model_variable(model_ptr, variable_name);

	BL_model_value_type output_value_type;
	unsigned output_number = 0;
	get_BL_model_variable_value_information(variable,
		&output_value_type, &output_number);
	EXPECT_EQ(BL_MODEL_VALUE_REAL, output_value_type);
	EXPECT_EQ(1, output_number);

	const int return_code = copy_BL_model_variable_to_value(variable, BL_MODEL_VALUE_REAL, &value, 1);
	EXPECT_EQ(return_code, 1) << "Failed to read value from variable " << variable_name;
	return value;

}

std::vector<BL_real> get_variable_array(BL_model* model_ptr, const char *variable_name)
{
	BL_model_value_type output_value_type;
	unsigned output_number = 0;
	auto variable = get_BL_model_variable(model_ptr, variable_name);

	get_BL_model_variable_value_information(variable,
		&output_value_type, &output_number);
	EXPECT_EQ(BL_MODEL_VALUE_REAL, output_value_type);

	std::vector<BL_real> result(output_number);

	const int return_code = copy_BL_model_variable_to_value(variable, BL_MODEL_VALUE_REAL, result.data(), result.capacity());
	EXPECT_EQ(return_code, 1) << "Failed to read value from variable " << variable_name;
	return result;

}

int set_variable_array(BL_model* model_ptr, const char *variable_name, std::vector<BL_real> data)
{
	BL_model_value_type output_value_type;
	unsigned output_number = 0;
	auto variable = get_BL_model_variable(model_ptr, variable_name);

	get_BL_model_variable_value_information(variable,
		&output_value_type, &output_number);
	EXPECT_EQ(BL_MODEL_VALUE_REAL, output_value_type);

	const int return_code = copy_value_to_BL_model_variable(BL_MODEL_VALUE_REAL, data.data(), data.size(), variable);
	EXPECT_EQ(return_code, 1) << "Failed to set array value to variable " << variable_name;
	return return_code;

}

int set_variable_float(BL_model* model_ptr, const char *variable_name, BL_real value)
{
    BL_model_value_type output_value_type;
    unsigned output_number = 0;
    auto variable = get_BL_model_variable(model_ptr, variable_name);

    get_BL_model_variable_value_information(variable,
        &output_value_type, &output_number);
    EXPECT_EQ(BL_MODEL_VALUE_REAL, output_value_type);

    const int return_code = copy_value_to_BL_model_variable(BL_MODEL_VALUE_REAL, &value, 1, variable);
    EXPECT_EQ(return_code, 1) << "Failed to set real value to variable " << variable_name;
    return return_code;

}

// Internal expect value functions
template<typename T> void ExpectVariableValueNear(
	struct BL_model_variable *variable,
	T expectedValue,
	BL_model_value_type expectedValueType, T tolerance,
	const char *failureOutputString)
{
	BL_model_value_type output_value_type;
	unsigned output_number = 0;
	get_BL_model_variable_value_information(variable,
		&output_value_type, &output_number);
	EXPECT_EQ(expectedValueType, output_value_type);
	EXPECT_EQ(1, output_number);

	T output;
	copy_BL_model_variable_to_value(variable,
		expectedValueType, &output, 1);
	if (failureOutputString == (const char *)NULL)
		EXPECT_NEAR(expectedValue , output, tolerance) << "Variable is expected to be near " << expectedValue;
	else
		EXPECT_NEAR(expectedValue, output, tolerance) << failureOutputString;
}

template<typename T> void ExpectVariableValueNearArrayPrivate(
	struct BL_model_variable *variable,
	std::vector<T> expectedValues,
	BL_model_value_type expectedValueType, T tolerance,
	const char *failureOutputString)
{
	BL_model_value_type output_value_type;
	unsigned output_number=0;
	unsigned expected_output_number=static_cast<unsigned>(expectedValues.size());
	get_BL_model_variable_value_information(variable,
	&output_value_type,&output_number);
	EXPECT_EQ(expectedValueType,output_value_type);
	EXPECT_EQ(expected_output_number,output_number);
	
	if (output_number==expected_output_number) {
		std::vector<T> output_array;
	
		output_array.resize(output_number);
	
		copy_BL_model_variable_to_value(variable,
			expectedValueType,(output_array.data()),output_number);
	
		if (failureOutputString == (const char *)NULL)
			CompareFunctionNear<T>(expectedValues, output_array, tolerance);
		else
			CompareFunctionNear<T>(expectedValues, output_array, tolerance, failureOutputString);
	}
}

void ExpectVariableValueNear(struct BL_model_variable *variable, BL_real expectedValue, BL_real tolerance, const char *failureOutputString)
{
	ExpectVariableValueNear(variable, expectedValue, BL_MODEL_VALUE_REAL, tolerance, failureOutputString);
}

void ExpectVariableValueNear(struct BL_model_variable *variable, std::vector<BL_real> expectedValues, BL_real tolerance, const char *failureOutputString)
{
	ExpectVariableValueNearArrayPrivate<BL_real>(variable, expectedValues, BL_MODEL_VALUE_REAL, tolerance, failureOutputString);
}



int TestVariableWrapper::SetVariableWithValue(BL_model_variable *blVariable) const
{
	if (isVector)
	{
		switch (type)
		{
		case BL_MODEL_VALUE_REAL:
			return copy_value_to_BL_model_variable(BL_MODEL_VALUE_REAL, real_vector.data(),
				(unsigned int)real_vector.size(), blVariable);
			break;
		case BL_MODEL_VALUE_CHARACTER:
			return copy_value_to_BL_model_variable(BL_MODEL_VALUE_CHARACTER, char_vector.data(),
				(unsigned int)char_vector.size(), blVariable);
			break;
        default:
            ADD_FAILURE() << "Setting value for an unexpected TestVariableWrapper value type";
            break;
		}
	}
	else
	{
		switch (type)
		{
		case BL_MODEL_VALUE_REAL:
			return copy_value_to_BL_model_variable(BL_MODEL_VALUE_REAL, &real_value,
				1, blVariable);
			break;
		case BL_MODEL_VALUE_UNSIGNED:
			return copy_value_to_BL_model_variable(BL_MODEL_VALUE_UNSIGNED, &unsigned_value,
				1, blVariable);
			break;
		case BL_MODEL_VALUE_INTEGER:
			return copy_value_to_BL_model_variable(BL_MODEL_VALUE_INTEGER, &int_value,
				1, blVariable);
			break;
        default:
            ADD_FAILURE() << "Setting value for an unexpected TestVariableWrapper value type";
            break;
		}
	}
	return (0);
}

int TestVariableWrapper::SetVariableWithValue(BL_model *blModel, const char *variableName) const
{
	auto variable = get_BL_model_variable(blModel, variableName);

	return SetVariableWithValue(variable);
}


void TestVariableWrapper::ExpectBLVariableMatchesValue(BL_model_variable *blVariable, const char *variableName) const
{
	if (isVector)
	{
		switch (type)
		{
		case BL_MODEL_VALUE_REAL:
			return ExpectVariableValue(blVariable, real_vector, variableName);
			break;
		case BL_MODEL_VALUE_CHARACTER:
			return ExpectVariableValue(blVariable, char_vector, variableName);
			break;
        default:
            FAIL() << "Unexpected TestVariableWrapper check comparison";
		}
	}
	else
	{
		switch (type)
		{
		case BL_MODEL_VALUE_REAL:
			return ExpectVariableValue(blVariable, real_value, variableName);
			break;
		case BL_MODEL_VALUE_UNSIGNED:
			return ExpectVariableValue(blVariable, unsigned_value, variableName);
			break;
		case BL_MODEL_VALUE_INTEGER:
			return ExpectVariableValue(blVariable, int_value, variableName);
			break;
        default:
            FAIL() << "Unexpected TestVariableWrapper check comparison";
		}
	}
}
