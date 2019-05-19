/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

/*
includes
--------
*/
#include <iostream>
#include <cstdlib>
#include <sstream>

#include "gtest/gtest.h"
#include "gmock/gmock.h"
#include "gmock/gmock-matchers.h"
#include "gtest/gtest-param-test.h"
#include "bl.h"
#include "bl_message.h"
#include "bl_io.h"

#include "BL_test_utilities/test_expect_variable_value.h"
#include "BL_test_utilities/dialog_helper_functions.h"
#include "BL_test_utilities/run_in_BL.hpp"
#include "BL_test_utilities/runtime_data_generation.hpp"

#include "boost/filesystem.hpp"

namespace {
	using testing::Eq;
	namespace bfs = boost::filesystem;
	using namespace std;
}
/// Message system
static struct BL_message_system *test_message_system = nullptr;

static bfs::path current_dir = bfs::path(CMAKE_CURRENT_SOURCE_DIR);

static int bl_debug_message(enum BL_message_type type,
	const char *locale,const char *output_string)
{
	int return_code;

	return_code=0;
	if (output_string&&(BL_DEBUG_MESSAGE==type))
	{
		printf("%s",output_string);
		return_code=1;
	}

	return (return_code);
} /* bl_debug_message */

class CBlock_Autotrain_TestData {
public:
	CBlock_Autotrain_TestData(const char *testRunName, TestVariableWrapper goalIndex, const char *expectedName) :
		testRunName(testRunName), goalIndex(goalIndex), expectedName(expectedName)
	{}

	const char *testRunName;
	TestVariableWrapper goalIndex;
	const char *expectedName;
};

class cblock_letters : public ::testing::TestWithParam<CBlock_Autotrain_TestData> {
public:
	static void SetUpTestCase() {
		test_message_system=create_BL_message_system(bl_debug_message);
		set_BL_message_system(test_message_system);
		RuntimeDataGenerator::generate_runtime_data(current_dir / "cblock_letters" / "cblock_letters_config.json", current_dir / "cblock_letters" / "runtime_data");
	}

	virtual void SetUp() {
		change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);
		change_BL_directory("cblock_letters");
		srand(1);
	}

	static void TearDownTestCase() {
		release_BL_message_system(test_message_system);
	}
};


TEST_P(cblock_letters, AutoTrain) {
	CBlock_Autotrain_TestData testParameters = GetParam();

	RunInBL runner;
	runner.setMessageSystem(test_message_system);
	if (HasFatalFailure()) return;

runner.Run([testParameters](BL_model *model) {
    
    TestVariableWrapper one_two_five(125.0f);

	for (int i = 0; i < 2; i++)
	{
        one_two_five.SetVariableWithValue(model, "training_control/do_autotrain_steps");
        time_step_BL_model(model);
	}
		
	TestVariableWrapper one(1.0f);
	one.SetVariableWithValue(model, "training_control/trigger_automatic_training_qml");

	for (int i = 0; i < 6000; i++)
	{
		time_step_BL_model(model);
	}

	TestVariableWrapper zero(0.0f);
	zero.SetVariableWithValue(model, "training_control/trigger_automatic_training_qml");

	//Set the goal to the index for the word Pauline
	testParameters.goalIndex.SetVariableWithValue(model, "control/manual_goal_index");

	one.SetVariableWithValue(model, "cblock/cblockInputs/goal_driven");
	one.SetVariableWithValue(model, "control/allow_playback");

	const unsigned loop_limit = 1000000;
	const unsigned output_count_wanted = 30;
	char output[output_count_wanted + 1];
	bool sequenceRead = false;
	unsigned loop_count = 0, output_count = 0;
	auto expectedSequenceLength = strlen(testParameters.expectedName);
	while (loop_count < loop_limit && output_count < output_count_wanted && !sequenceRead)
	{
		time_step_BL_model(model);

		BL_real outputReady = get_variable_value(model, "cblock/cblockOutputs/ready");
		if (outputReady > 0.0)
		{
			auto current_output = get_variable_array(model, "cblock/cblockOutputs/predicted_bitmap");
			BL_real eosPredicted = get_variable_value(model, "cblock/cblockOutputs/eos_predicted");

			if (eosPredicted && (output_count >= expectedSequenceLength))
			{
				sequenceRead = true;
				printf(" %8d %f %f %f %f EOS\n", loop_count, outputReady, current_output[42], current_output[0],
					eosPredicted);
			}
			else
			{
				char predictedCharacter = char(current_output[0] * 100.0 + 64.5);
				printf(" %8d %f %f %f %c %f\n", loop_count, outputReady, current_output[42], current_output[0], predictedCharacter,
					eosPredicted);

				output[output_count] = predictedCharacter;
				output_count++;
			}

			one.SetVariableWithValue(model, "cblock/cblockOutputs/reset");
		}
		loop_count++;
	}
	output[output_count] = 0;

	EXPECT_THAT(output, testing::StrEq(testParameters.expectedName));

	});

}

INSTANTIATE_TEST_CASE_P(cblock_tests_autotrain,
	cblock_letters,
	::testing::Values(
		CBlock_Autotrain_TestData("JASON", 1.0f, "JASON"),
		CBlock_Autotrain_TestData("ANDREW", 2.0f, "ANDREW"),
		CBlock_Autotrain_TestData("LIAM", 3.0f, "LIAM"),
		CBlock_Autotrain_TestData("CAROLINE", 4.0f, "CAROLINE"),
		CBlock_Autotrain_TestData("KHURRAM", 5.0f, "KHURRAM"),
		CBlock_Autotrain_TestData("MARTIN", 6.0f, "MARTIN"),
		CBlock_Autotrain_TestData("ALI", 7.0f, "ALI"),
		CBlock_Autotrain_TestData("MARK", 8.0f, "MARK"),
		CBlock_Autotrain_TestData("DAVID", 9.0f, "DAVID"),
		CBlock_Autotrain_TestData("NICOLAS", 10.0f, "NICOLAS"),
		CBlock_Autotrain_TestData("TIM", 11.0f, "TIM"),
		CBlock_Autotrain_TestData("PAULA", 12.0f, "PAULA"),
		CBlock_Autotrain_TestData("PAULINE", 13.0f, "PAULINE"),
		CBlock_Autotrain_TestData("ROB", 14.0f, "ROB"),
		CBlock_Autotrain_TestData("SIMON", 15.0f, "SIMON"),
		CBlock_Autotrain_TestData("OLEG", 16.0f, "OLEG"),
		CBlock_Autotrain_TestData("XUEYUAN", 17.0f, "XUEYUAN"),
		CBlock_Autotrain_TestData("RACHEL", 18.0f, "RACHEL"),
		CBlock_Autotrain_TestData("GREG", 19.0f, "GREG"),
		CBlock_Autotrain_TestData("KIERAN", 20.0f, "KIERAN")
	),
	[](const ::testing::TestParamInfo<CBlock_Autotrain_TestData>& info)
	-> std::string { return std::string(info.param.testRunName); }
);

class cblock_letters_input : public ::testing::TestWithParam<CBlock_Autotrain_TestData> {
public:
	static void SetUpTestCase() {
		test_message_system = create_BL_message_system(bl_debug_message);
		set_BL_message_system(test_message_system);		
		RuntimeDataGenerator::generate_runtime_data(current_dir / "cblock_letters" / "cblock_letters_config.json", current_dir / "cblock_letters" / "runtime_data");
	}

	virtual void SetUp() {
		change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);
		change_BL_directory("cblock_letters");
		srand(1);
	}

	static void TearDownTestCase() {
		release_BL_message_system(test_message_system);
	}
};

TEST_P(cblock_letters_input, InputTest) {
	CBlock_Autotrain_TestData testParameters = GetParam();

	RunInBL runner;
	runner.setMessageSystem(test_message_system);
	if (HasFatalFailure()) return;

	runner.Run([testParameters](BL_model *model) {
	const unsigned input_size = 100;
	std::vector<float> input(input_size);

		TestVariableWrapper one(1.0f);

		const int time_steps_to_wait = 2;

		const int total_limit = 10;
		for (int i = 0; i < total_limit; i++)
		{
			for (int i = 0; i < time_steps_to_wait; i++)
				time_step_BL_model(model);

			auto data = (float)(i % 5);

			std::cout << " Input << ";
			for (int j = 0; j < input_size; j++)
			{
				input[j] = data + j % 2;
				std::cout << input[j] << ' ';
			}
			std::cout << '\n';

			float S0 = get_variable_value(model, "cblock/IO/input_control/S0");
			float S1_bitmap = get_variable_value(model, "cblock/IO/input_control/S1_bitmap");
			float init_bitmap = get_variable_value(model, "cblock/IO/indiv_type/bitmap");
			printf(" S0 %f S1_bitmap %f init_bitmap %f\n", S0, S1_bitmap, init_bitmap);

			set_variable_array(model, "cblock/cblockInputs/input_bitmap", input);

			one.SetVariableWithValue(model, "cblock/cblockInputs/ready");

			float inputReset = 0.0;
			while (inputReset == 0.0 && i < total_limit)
			{
				time_step_BL_model(model);

				float S0 = get_variable_value(model, "cblock/IO/input_control/S0");
				float S1_bitmap = get_variable_value(model, "cblock/IO/input_control/S1_bitmap");
				float init_bitmap = get_variable_value(model, "cblock/IO/indiv_type/bitmap");
				printf(" S0 %f S1_bitmap %f init_bitmap %f\n", S0, S1_bitmap, init_bitmap);

				inputReset = get_variable_value(model, "cblock/cblockInputs/reset");
				if (inputReset != 0.0)
				{
					std::cout << " inputReset set \n";
				}
				i++;
			}

			for (int i = 0; i < time_steps_to_wait; i++)
				time_step_BL_model(model);

			BL_real outputReady = get_variable_value(model, "cblock/cblockOutputs/ready");
			if (outputReady > 0.0 && i < total_limit)
			{
				time_step_BL_model(model);

				outputReady = get_variable_value(model, "cblock/cblockOutputs/ready");
				i++;
			}


			auto predicted_bitmap = get_variable_array(model, "cblock/cblockOutputs/predicted_bitmap");
			std::cout << " Output <<";
			for (int j = 0; j < predicted_bitmap.size(); j++)
				std::cout << predicted_bitmap[j] << ' ';
			std::cout << '\n';

			one.SetVariableWithValue(model, "cblock/cblockOutputs/reset");
		}
	});
}

INSTANTIATE_TEST_CASE_P(cblock_tests,
	cblock_letters_input,
	::testing::Values(
		CBlock_Autotrain_TestData("JASON", 1.0f, "JASON"),
		CBlock_Autotrain_TestData("ANDREW", 2.0f, "ANDREW"),
		CBlock_Autotrain_TestData("LIAM", 3.0f, "LIAM"),
		CBlock_Autotrain_TestData("CAROLINE", 4.0f, "CAROLINE"),
		CBlock_Autotrain_TestData("KHURRAM", 5.0f, "KHURRAM"),
		CBlock_Autotrain_TestData("MARTIN", 6.0f, "MARTIN"),
		CBlock_Autotrain_TestData("ALI", 7.0f, "ALI"),
		CBlock_Autotrain_TestData("MARK", 8.0f, "MARK"),
		CBlock_Autotrain_TestData("DAVID", 9.0f, "DAVID"),
		CBlock_Autotrain_TestData("NICOLAS", 10.0f, "NICOLAS"),
		CBlock_Autotrain_TestData("TIM", 11.0f, "TIM"),
		CBlock_Autotrain_TestData("PAULA", 12.0f, "PAULA"),
		CBlock_Autotrain_TestData("PAULINE", 13.0f, "PAULINE"),
		CBlock_Autotrain_TestData("ROB", 14.0f, "ROB"),
		CBlock_Autotrain_TestData("SIMON", 15.0f, "SIMON"),
		CBlock_Autotrain_TestData("OLEG", 16.0f, "OLEG"),
		CBlock_Autotrain_TestData("XUEYUAN", 17.0f, "XUEYUAN"),
		CBlock_Autotrain_TestData("RACHEL", 18.0f, "RACHEL"),
		CBlock_Autotrain_TestData("GREG", 19.0f, "GREG"),
		CBlock_Autotrain_TestData("KIERAN", 20.0f, "KIERAN")
	),
	[](const ::testing::TestParamInfo<CBlock_Autotrain_TestData>& info)
	-> std::string { return std::string(info.param.testRunName); }
);
