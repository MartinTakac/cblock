/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

/*
includes
--------
*/
#include <chrono>
#include <thread>
#include <iostream>

#include "gtest/gtest.h"
#include "gmock/gmock.h"
#include "gmock/gmock-matchers.h"
#include "gtest/gtest-param-test.h"
#include "boost/filesystem.hpp"
#include "bl.h"
#include "bl_message.h"
#include "bl_io.h"

#include "BL_test_utilities/test_expect_variable_value.h"
#include "BL_test_utilities/dialog_helper_functions.h"
#include "BL_test_utilities/run_in_BL.hpp"
#include "BL_test_utilities/runtime_data_generation.hpp"

using testing::Eq;
namespace bfs = boost::filesystem;

/// Message system
static struct BL_message_system *test_message_system=
	(struct BL_message_system *)NULL;

static bfs::path current_dir = bfs::path(CMAKE_CURRENT_SOURCE_DIR);

static int bl_debug_message(enum BL_message_type type,
	const char *locale,const char *output_string)
{
	int return_code;

	return_code = 0;
	if (output_string && (BL_DEBUG_MESSAGE == type))
	{
		printf("%s", output_string);
		return_code = 1;
	}

	return (return_code);
} /* bl_debug_message */

/// Functions for sending events and receiving predictions from Cblock
static void send_event(BL_model* model, std::string event, std::vector<BL_real> &current_state, bool reset_initiated = false, bool log = true) {

    // Generate three-hot encoding of input event
    std::vector<BL_real> input_bitmap;
    TagToVector(event, input_bitmap);

    // Set state vector based on input event (last two elements determine type of event selected in goal-driven mode)
    std::string state_type = GetStateForId(event);
    ASSERT_EQ(UpdateCurrentState(state_type, current_state), 0);
    UpdateCurrentStateInitiated(event, current_state);
    if (reset_initiated) { 
        current_state[98] = 0.0;
        current_state[99] = 0.0;
    }

    if ((event.size() == 3) && log) {
        printf("Sending input: %s | state[98] %.0f state[99] %.0f\n", event.c_str(), current_state[98], current_state[99]);
    }

    // Send input, state and input type to Cblock
    if (event.substr(0, 1) == "9" && event != "922") {
        set_variable_float(model, "cblock/cblockInputs/inputType_finalizeSeq", 1);
        set_variable_float(model, "cblock/cblockInputs/inputType_nextElem", 0);
        set_variable_float(model, "cblock/cblockInputs/inputType_resetSeq", 0);
    } else if (event == "922") {
        set_variable_float(model, "cblock/cblockInputs/inputType_finalizeSeq", 0);
        set_variable_float(model, "cblock/cblockInputs/inputType_nextElem", 0);
        set_variable_float(model, "cblock/cblockInputs/inputType_resetSeq", 1);
    } else {
        set_variable_float(model, "cblock/cblockInputs/inputType_finalizeSeq", 0);
        set_variable_float(model, "cblock/cblockInputs/inputType_nextElem", 1);
        set_variable_float(model, "cblock/cblockInputs/inputType_resetSeq", 0);
        set_variable_array(model, "cblock/cblockInputs/input_bitmap", input_bitmap);
    }
    set_variable_array(model, "cblock/cblockInputs/state", current_state);
    time_step_BL_model(model);

    // Tell Cblock to read inputs
    set_variable_float(model, "cblock/cblockInputs/ready", 1);
    time_step_BL_model(model);

    // Cblock should confirm that inputs have been read
    BL_real input_reset = get_variable_value(model, "cblock/cblockInputs/reset");
    ASSERT_FLOAT_EQ(input_reset, 1.0);

    // Reset input ready flag once inputs have been read
    set_variable_float(model, "cblock/cblockInputs/ready", 0);
}

static void get_prediction(BL_model *model, PredictionOutput &output_data, bool log = true) {

    // Wait for output ready flag
    float output_ready = get_variable_value(model, "cblock/cblockOutputs/ready");
    int counter = 0;
    while ((output_ready < 0.9) && (counter < 20)) {
        time_step_BL_model(model);
        output_ready = get_variable_value(model, "cblock/cblockOutputs/ready");
        counter++;
    }
    ASSERT_FLOAT_EQ(output_ready, 1.0) << "Output ready should have been received within 20 time-steps";
    if (log) {
        printf("Timesteps required for output ready: %d\n", counter);
    }

    // Extract outputs
    output_data.contains_prediction = get_variable_value(model, "cblock/cblockOutputs/contains_prediction");
    output_data.output_bitmap = get_variable_array(model, "cblock/cblockOutputs/predicted_bitmap");
    output_data.eos_predicted = get_variable_value(model, "cblock/cblockOutputs/eos_predicted");
    output_data.surprise = get_variable_value(model, "cblock/cblockOutputs/surprise");
    output_data.goal_reached = get_variable_value(model, "cblock/cblockOutputs/goal_reached");
    output_data.goal_reached_degree = get_variable_value(model, "cblock/cblockOutputs/goal_reached_degree");
    ASSERT_EQ(output_data.output_bitmap.size(), 100);

    // Convert 3-hot output_bitmap to tag
    output_data.output_event = VectorToTag(output_data.output_bitmap);

    // Reset output
    set_variable_float(model, "cblock/cblockOutputs/reset", 1);
    time_step_BL_model(model);
    set_variable_float(model, "cblock/cblockOutputs/reset", 0);
    time_step_BL_model(model);
}

class cblock_bootstrap : public ::testing::Test {
public:
	static void SetUpTestCase() {
		test_message_system=create_BL_message_system(bl_debug_message);
		set_BL_message_system(test_message_system);
	}

	virtual void SetUp() {
		change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);
		change_BL_directory("cblock_dialog");
		srand(1);
	}

	static void TearDownTestCase() {
		release_BL_message_system(test_message_system);
	}
};

// Autotraining test - trains Cblock on sequences
TEST_F(cblock_bootstrap, Bootstrap) {

    RunInBL runner;
    runner.setMessageSystem(test_message_system);
    if (HasFatalFailure()) return;

    runner.Run([](BL_model *model) {

        // Sequences for training - events are 3-hot, with events 919, 920, 921 indicating finalise sequence, while event 922 resets sequence and clears state so that the next sequence starts with a blank state
        std::vector<std::vector<std::string>> sequences;
        std::vector<std::string> sequence0 = { "504", "105", "921", "922" };
        std::vector<std::string> sequence1 = { "503", "103", "504", "105", "921", "922" };
        std::vector<std::string> sequence2 = { "502", "921", "922" };
        std::vector<std::string> sequence3 = { "502", "504", "105", "921", "922" };
        std::vector<std::string> sequence4 = { "506", "101", "516", "106", "507", "107", "512", "920", "922" };
        std::vector<std::string> sequence5 = { "517", "108", "509", "109", "510", "110", "508", "920", "922" };
        std::vector<std::string> sequence6 = { "108", "509", "118", "510", "116", "508", "920", "922" };
        std::vector<std::string> sequence7 = { "518", "101", "509", "114", "520", "115", "501", "920", "922" };
        std::vector<std::string> sequence8 = { "108", "509", "116", "510", "117", "520", "115", "505", "920", "922" };
        std::vector<std::string> sequence9 = { "511", "101", "513", "919", "922" };
        std::vector<std::string> sequence10 = { "511", "101", "514", "499", "515", "919", "922" };
        std::vector<std::string> sequence11 = { "113", "519", "112", "513", "919", "922" };
        sequences.push_back(sequence0);
        sequences.push_back(sequence1);
        sequences.push_back(sequence2);
        sequences.push_back(sequence3);
        sequences.push_back(sequence4);
        sequences.push_back(sequence5);
        sequences.push_back(sequence6);
        sequences.push_back(sequence7);
        sequences.push_back(sequence8);
        sequences.push_back(sequence9);
        sequences.push_back(sequence10);
        sequences.push_back(sequence11);

        // Initial time step
        time_step_BL_model(model);

        // BootstrapMode - Init
        set_variable_float(model, "cblock/cblockParams/surprise_avg_mult", 2);
        set_variable_float(model, "cblock/cblockInputs/goal_driven", 0);
        time_step_BL_model(model);

        // BootstrapMode - HandleTimeStep/BootstrapState - Init
        time_step_BL_model(model);
        
        // BootstrapState - HandleTimeStep
        const int BOOTSTRAP_ITERATIONS = 10;
        bool log = true;
        for (int i = 0; i < BOOTSTRAP_ITERATIONS; i++) {
            if (i > 0) {
                log = false;
            }
            printf("Epoch %d/%d\n", i + 1, BOOTSTRAP_ITERATIONS);

            for (int j = 0; j < sequences.size(); j++) {

                std::vector<std::string> current_sequence = sequences[j];
                std::vector<BL_real> current_state = std::vector<BL_real>(100, 0.0f);

                for (int k = 0; k < current_sequence.size(); k++) {

                    // Send event
                    std::string event = current_sequence[k];
                    send_event(model, event, current_state, false, log);

                    // Get prediction
                    PredictionOutput prediction_output;
                    get_prediction(model, prediction_output, log);

                    if (event.substr(0, 1) == "9") {
                        ASSERT_FLOAT_EQ(prediction_output.contains_prediction, 0.0);
                    } else {
                        ASSERT_FLOAT_EQ(prediction_output.contains_prediction, 1.0);
                    }
                       
                }

                if (log) {
                    printf("\n");
                }
            }
        }
        printf("Bootstrap complete\n");

        // Save weights for use in further tests
        set_variable_float(model, "cblock/cblockParams/save_all_weights", 1);
        time_step_BL_model(model);
        set_variable_float(model, "cblock/cblockParams/save_all_weights", 0);
        time_step_BL_model(model);
    });

}

class CBlock_Playback_TestData {
public:
    CBlock_Playback_TestData(std::vector<std::string> sequence) :
        sequence(sequence),
        prediction({})
    {}

    CBlock_Playback_TestData(std::vector<std::string> sequence, std::vector<std::string> prediction) :
        sequence(sequence),
        prediction(prediction)
    {}

    std::vector<std::string> sequence;
    std::vector<std::string> prediction;
};

class cblock_playback_ngd : public ::testing::TestWithParam<CBlock_Playback_TestData> {
public:
    static void SetUpTestCase() {
        test_message_system = create_BL_message_system(bl_debug_message);
        set_BL_message_system(test_message_system);
		delete_runtime_data(current_dir / "cblock_dialog" / "runtime_data");
		generate_runtime_data(current_dir / "cblock_dialog" / "cblock_dialog_config.json", current_dir / "cblock_dialog" / "runtime_data", current_dir);
    }

    virtual void SetUp() {
        change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);
        change_BL_directory("cblock_dialog");
        srand(1);
    }

    static void TearDownTestCase() {
        release_BL_message_system(test_message_system);
    }
};

// Goal-off playback - plays back sequences in non-goal-driven mode
TEST_P(cblock_playback_ngd, SequencePlaybackGoalOff) {
    CBlock_Playback_TestData test_data = GetParam();

    RunInBL runner;
    runner.setMessageSystem(test_message_system);
    if (HasFatalFailure()) return;

    runner.Run([test_data](BL_model *model) {

        // Initial time step
        time_step_BL_model(model);

        // Load weights (assumes previous bootstrap test ran successfully)
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 1);
        time_step_BL_model(model);
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 0);
        time_step_BL_model(model);

        // Set some default variables
        set_variable_float(model, "cblock/cblockParams/surprise_avg_mult", 2);
        set_variable_float(model, "cblock/cblockInputs/goal_driven", 0);
        time_step_BL_model(model);

        BL_real input_ready = get_variable_value(model, "cblock/cblockInputs/ready");
        BL_real input_reset = get_variable_value(model, "cblock/cblockInputs/reset");
        BL_real output_ready = get_variable_value(model, "cblock/cblockOutputs/ready");
        BL_real output_reset = get_variable_value(model, "cblock/cblockOutputs/reset");
        ASSERT_FLOAT_EQ(input_ready, 0.0);
        ASSERT_FLOAT_EQ(input_reset, 0.0);
        ASSERT_FLOAT_EQ(output_ready, 0.0);
        ASSERT_FLOAT_EQ(output_reset, 0.0);

        std::vector<BL_real> current_state = std::vector<BL_real>(100, 0.0f);

        // Send events in current sequence
        for (int i = 0; i < test_data.sequence.size() - 1; i++) {

            std::string event = test_data.sequence[i];
            send_event(model, event, current_state);

            PredictionOutput prediction_output;
            get_prediction(model, prediction_output);

            if (prediction_output.output_event.size() > 0) {
                printf("Prediction:    %s", prediction_output.output_event.c_str());
            } else if (prediction_output.eos_predicted > 0.9) {
                printf("Prediction:    EOS");
            }
            printf(" | EOS predicted: %.0f | Surprise: %.0f\n", prediction_output.eos_predicted, prediction_output.surprise);

            // Compare predictions with next event in sequence
            if (i < test_data.sequence.size() - 1) {
                std::string next_event = test_data.sequence[i + 1];
                if (next_event.substr(0, 1) != "9") {
                    ASSERT_EQ(prediction_output.output_event, next_event);
                } else if ((next_event.substr(0, 1) == "9") && (next_event != "922")) {
                    ASSERT_FLOAT_EQ(prediction_output.eos_predicted, 1.0);
                }
            }

            
        }
        std::cout << std::endl;
    });
}

// Only sequences with unique starting events as we cannot control which sequence Cblock will pick in non-goal-driven mode if there are duplicate starting events
INSTANTIATE_TEST_CASE_P(cblock_tests_playback_ngd,
    cblock_playback_ngd,
    ::testing::Values(
        CBlock_Playback_TestData({ "504", "105", "921" }),
        CBlock_Playback_TestData({ "503", "103", "504", "105", "921" }),
        CBlock_Playback_TestData({ "506", "101", "516", "106", "507", "107", "512", "920" }),
        CBlock_Playback_TestData({ "517", "108", "509", "109", "510", "110", "508", "920" }),
        CBlock_Playback_TestData({ "518", "101", "509", "114", "520", "115", "501", "920" }),
        CBlock_Playback_TestData({ "113", "519", "112", "513", "919" })
    ),
);

class cblock_playback_ngd_digression : public ::testing::TestWithParam<CBlock_Playback_TestData> {
public:
    static void SetUpTestCase() {
        test_message_system = create_BL_message_system(bl_debug_message);
        set_BL_message_system(test_message_system);
		delete_runtime_data(current_dir / "cblock_dialog" / "runtime_data");
		generate_runtime_data(current_dir / "cblock_dialog" / "cblock_dialog_config.json", current_dir / "cblock_dialog" / "runtime_data", current_dir);
    }

    virtual void SetUp() {
        change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);
        change_BL_directory("cblock_dialog");
        srand(1);
    }

    static void TearDownTestCase() {
        release_BL_message_system(test_message_system);
    }
};

// Goal-off playback with digression - plays back sequences in non-goal-driven mode and switches plans halfway through
TEST_P(cblock_playback_ngd_digression, SequencePlaybackGoalOffDigression) {
    CBlock_Playback_TestData test_data = GetParam();

    RunInBL runner;
    runner.setMessageSystem(test_message_system);
    if (HasFatalFailure()) return;

    runner.Run([test_data](BL_model *model) {

        // Initial time step
        time_step_BL_model(model);

        // Load weights (assumes previous bootstrap test ran successfully)
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 1);
        time_step_BL_model(model);
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 0);
        time_step_BL_model(model);

        // 
        set_variable_float(model, "cblock/cblockParams/surprise_avg_mult", 2);
        set_variable_float(model, "cblock/cblockInputs/goal_driven", 0);
        time_step_BL_model(model);

        std::vector<BL_real> current_state = std::vector<BL_real>(100, 0.0f);

        // Send events in current sequence
        for (int i = 0; i < test_data.sequence.size(); i++) {

            std::string event = test_data.sequence[i];
            send_event(model, event, current_state);

            PredictionOutput prediction_output;
            get_prediction(model, prediction_output);

            if (prediction_output.output_event.size() > 0) {
                printf("Prediction:    %s", prediction_output.output_event.c_str());
            } else if (prediction_output.eos_predicted > 0.9) {
                printf("Prediction:    EOS");
            }
            printf(" | EOS predicted: %.0f | Surprise: %.0f\n", prediction_output.eos_predicted, prediction_output.surprise);

            // Compare predictions from Cblock with expected events
            if (test_data.prediction[i] != "000") {
                if (test_data.prediction[i] == "SUP") {
                    ASSERT_FLOAT_EQ(prediction_output.surprise, 1.0);
                } else if (test_data.prediction[i] == "EOS") {
                    ASSERT_FLOAT_EQ(prediction_output.eos_predicted, 1.0);
                } else {
                    ASSERT_EQ(prediction_output.output_event, test_data.prediction[i]);
                }
            }
        }
        std::cout << std::endl;
    });

}

INSTANTIATE_TEST_CASE_P(cblock_tests_playback_ngd_digression,
    cblock_playback_ngd_digression,
    ::testing::Values(
        CBlock_Playback_TestData({ "108", "509", "106", "507", "107", "512" }, { "509", "000", "SUP", "107", "512", "EOS" }), // Ignore prediction after 509 as there are multiple paths
        CBlock_Playback_TestData({ "108", "509", "118", "519", "112", "513" }, { "509", "118", "510", "SUP", "513", "EOS" }),
        CBlock_Playback_TestData({ "108", "506", "101", "516", "106", "507", "107", "512" }, { "509", "SUP", "516", "106", "507", "107", "512", "EOS" })
    ),
);

class cblock_playback_gd : public ::testing::TestWithParam<CBlock_Playback_TestData> {
public:
    static void SetUpTestCase() {
        test_message_system = create_BL_message_system(bl_debug_message);
        set_BL_message_system(test_message_system);
		delete_runtime_data(current_dir / "cblock_dialog" / "runtime_data");
		generate_runtime_data(current_dir / "cblock_dialog" / "cblock_dialog_config.json", current_dir / "cblock_dialog" / "runtime_data", current_dir);
    }

    virtual void SetUp() {
        change_BL_directory(CMAKE_CURRENT_SOURCE_DIR);
        change_BL_directory("cblock_dialog");
        srand(1);
    }

    static void TearDownTestCase() {
        release_BL_message_system(test_message_system);
    }
};

// Playback - goal-driven - plays back sequences in goal-driven mode
TEST_F(cblock_playback_gd, SequencePlaybackGoalDriven) {

    RunInBL runner;
    runner.setMessageSystem(test_message_system);
    if (HasFatalFailure()) return;

    runner.Run([](BL_model *model) {

        // Initial time step
        time_step_BL_model(model);

        // Set lower goal reached threshold (required for this test as goal reached degree doesn't seem to exceed default threshold value of 0.9)
        set_variable_float(model, "cblock/cblockParams/goal_reached_thr", 0.7f);

        // Load weights (assumes previous bootstrap test ran successfully)
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 1.0f);
        time_step_BL_model(model);
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 0.0f);
        time_step_BL_model(model);

        // Send in random event initially before entering goal-driven mode (hack to allow proper GD functionality after loading weights)
        PredictionOutput prediction_output;
        std::vector<BL_real> current_state = std::vector<BL_real>(100, 0.0);

        printf("----- Need to send random input after loading weights otherwise goal-driven mode will not work -----\n");
        send_event(model, "103", current_state);
        get_prediction(model, prediction_output);
        prediction_output.eos_predicted = 0.0;
        prediction_output.surprise = 0.0;
        current_state = std::vector<BL_real>(100, 0.0);
        printf("----------------------------------------------------------------------------------------------------\n\n");

        // Set goal state vector
        std::vector<BL_real> goal_state = std::vector<BL_real>(100, 0.0f);
        goal_state[2] = 1.0f;
        goal_state[99] = 1.0f;

        // Activate goal driven mode
        set_variable_float(model, "cblock/planning/control/ior_surrounding", 1.0f);
        set_variable_float(model, "cblock/planning/control/ior_decay", 0.5f);
        set_variable_float(model, "cblock/planning/control/plan_timeout_speed", 0.1f);
        set_variable_float(model, "cblock/cblockParams/surprise_avg_mult", 2.0f);
        set_variable_array(model, "cblock/planning/goal/state", goal_state);
        set_variable_float(model, "cblock/cblockInputs/goal_driven", 1.0f);
        time_step_BL_model(model);

        std::vector<std::vector<std::string>> sequences;
        std::vector<std::string> sequence0 = { "506", "101", "516", "106", "507", "107", "512", "920" };
        std::vector<std::string> sequence1 = { "517", "108", "509", "109", "510", "110", "508", "920" };
        std::vector<std::string> sequence2 = { "108", "509", "118", "510", "116", "508", "920" };
        std::vector<std::string> sequence3 = { "518", "101", "509", "114", "520", "115", "501", "920" };
        std::vector<std::string> sequence4 = { "108", "509", "116", "510", "117", "520", "115", "505", "920" };
        sequences.push_back(sequence0);
        sequences.push_back(sequence1);
        sequences.push_back(sequence2);
        sequences.push_back(sequence3);
        sequences.push_back(sequence4);

        int i = 0;
        std::vector<std::string> selected_sequence;
        while (prediction_output.eos_predicted < 0.1) {
            get_prediction(model, prediction_output);

            // Make sure first event matches one of the possible sequences
            if (i == 0) {
                ASSERT_EQ(prediction_output.output_event.size(), 3);
                if (prediction_output.output_event == "506") {
                    selected_sequence = sequences[0];
                } else if (prediction_output.output_event == "517") {
                    selected_sequence = sequences[1];
                } else if (prediction_output.output_event == "108") {
                    selected_sequence = sequences[2];
                } else if (prediction_output.output_event == "518") {
                    selected_sequence = sequences[3];
                } else if (prediction_output.output_event == "108") {
                    selected_sequence = sequences[4];
                } else {
                    FAIL() << "Expect first predicted event to be the start of one of the possible sequences. Event: " << prediction_output.output_event;
                }
            }

            // Compare predicted event with existing event
            if (prediction_output.eos_predicted < 0.1) {
                ASSERT_EQ(prediction_output.output_event, selected_sequence[i]) << "Expected prediction to match sequence event";
            }

            // Ensure end-of-sequence is predicted at correct point in the sequence
            if (prediction_output.eos_predicted > 0.1) {
                ASSERT_EQ(i, selected_sequence.size() - 1) << "Expected end of sequence prediction to occur at second to last event";
            }

            if (prediction_output.output_event.size() == 3) {
                printf("Prediction:    %s", prediction_output.output_event.c_str());
            } else if (prediction_output.eos_predicted > 0.9) {
                printf("Prediction:    EOS");
            }
            printf(" | EOS predicted: %.0f | Surprise: %.0f | Contains prediction: %.0f\n", prediction_output.eos_predicted, prediction_output.surprise, prediction_output.contains_prediction);

            if (prediction_output.output_event.size() > 0) {
                send_event(model, prediction_output.output_event, current_state);
            }

            i++;
        }
       
    });

}

// Playback - goal-driven with digression - plays back sequence in goal-driven mode, tries to switch sequence halfway through and resume sequence after completion of digression sequence
TEST_F(cblock_playback_gd, SequencePlaybackGoalDrivenWithDigression) {

    RunInBL runner;
    runner.setMessageSystem(test_message_system);
    if (HasFatalFailure()) return;

    runner.Run([](BL_model *model) {

        // Initial time step
        time_step_BL_model(model);

        // Set lower goal reached threshold (required for this test as goal reached degree doesn't seem to exceed default threshold value of 0.9)
        set_variable_float(model, "cblock/cblockParams/goal_reached_thr", 0.7f);

        // Load weights (assumes previous bootstrap test ran successfully)
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 1.0f);
        time_step_BL_model(model);
        set_variable_float(model, "cblock/cblockParams/load_all_weights", 0.0f);
        time_step_BL_model(model);

        // Send in random event initially before entering goal-driven mode (hack to allow proper GD functionality after loading weights)
        PredictionOutput prediction_output;
        std::vector<BL_real> current_state = std::vector<BL_real>(100, 0.0);
        printf("----- Need to send random input after loading weights otherwise goal-driven mode will not work -----\n");
        send_event(model, "103", current_state);
        get_prediction(model, prediction_output);
        prediction_output.eos_predicted = 0.0;
        prediction_output.surprise = 0.0;
        current_state = std::vector<BL_real>(100, 0.0);
        printf("----------------------------------------------------------------------------------------------------\n\n");

        // Set goal state vector
        std::vector<BL_real> goal_state = std::vector<BL_real>(100, 0.0f);
        goal_state[2] = 1.0f;
        goal_state[99] = 1.0f;

        // Activate goal driven mode
        set_variable_float(model, "cblock/planning/control/ior_surrounding", 1.0f);
        set_variable_float(model, "cblock/planning/control/ior_decay", 0.5f);
        set_variable_float(model, "cblock/planning/control/plan_timeout_speed", 0.1f);
        set_variable_float(model, "cblock/cblockParams/surprise_avg_mult", 2.0f); // For surprise computation - Default 2.0
        set_variable_float(model, "cblock/cblockParams/prev_avg_err_mix", 0.9f); // For surprise computation - Default 0.9
        set_variable_array(model, "cblock/planning/goal/state", goal_state);
        set_variable_float(model, "cblock/cblockInputs/goal_driven", 1.0f);
        time_step_BL_model(model);

        std::vector<std::string> sequence =         { "517", "108", "509", "113", "519", "112", "513", "919", "509", "109", "510", "110", "508", "920" }; // Digression starts with event 113
        std::vector<std::string> expect_sequence =  { "517", "108", "509", "000", "SUP", "112", "513", "EOS", "000", "000", "510", "110", "508", "EOS" }; // Expected predictions (000 = ignore, SUP = surprise, EOS = end-of-sequence)

        // Initialise some variables used to control digression and restoration to previous plan
        std::vector<BL_real> save_state = std::vector<BL_real>(100, 0.0f);
        bool digress = false;
        bool restore_state = false;
        std::string last_event_before_digression;

        // Run through test sequence
        for (int i = 0; i < sequence.size(); i++) {
            get_prediction(model, prediction_output);

            // Compare predictions with expected events
            if (expect_sequence[i] != "000") {
                if (expect_sequence[i] == "SUP") {
                    ASSERT_FLOAT_EQ(prediction_output.surprise, 1.0);
                } else if (expect_sequence[i] == "EOS") {
                    ASSERT_FLOAT_EQ(prediction_output.eos_predicted, 1.0);
                } else {
                    ASSERT_EQ(sequence[i], expect_sequence[i]);
                }
            }

            // Expect digression to occur at this point and save state and last event before digression to restore later
            if (i == 4) {
                save_state = current_state;
                last_event_before_digression = sequence[i - 2];
                digress = true;
                printf("Digression started\n");
            }

            if (prediction_output.output_event.size() == 3) {
                printf("Prediction:    %s", prediction_output.output_event.c_str());
            } else if (prediction_output.eos_predicted > 0.9) {
                printf("Prediction:    EOS");
            }
            printf(" | EOS predicted: %.0f | Surprise: %.0f | Contains prediction: %.0f | Goal reached: %.0f | Goal reached degree: %.2f\n", 
                prediction_output.eos_predicted, prediction_output.surprise, prediction_output.contains_prediction, prediction_output.goal_reached, 
                prediction_output.goal_reached_degree);
            
            // Restore state at end of digression
            if (restore_state) {
                current_state = save_state;
                restore_state = false;
            }
            
            send_event(model, sequence[i], current_state, false);

            // Look for flag indicating end of digression sequence 
            if (sequence[i] == "919") {
                restore_state = true;
                printf("Digression complete\n");
            }
        }

        // Ensure goal is reached at plan completion
        get_prediction(model, prediction_output);
        ASSERT_GT(prediction_output.goal_reached_degree, 0.7);
        ASSERT_FLOAT_EQ(prediction_output.goal_reached, 1.0);

        if (prediction_output.output_event.size() == 3) {
            printf("Prediction:    %s", prediction_output.output_event.c_str());
        } else if (prediction_output.eos_predicted > 0.9) {
            printf("Prediction:    EOS");
        }
        printf(" | EOS predicted: %.0f | Surprise: %.0f | Contains prediction: %.0f | Goal reached: %.0f | Goal reached degree: %.2f\n", 
            prediction_output.eos_predicted, prediction_output.surprise, prediction_output.contains_prediction, prediction_output.goal_reached, 
            prediction_output.goal_reached_degree);

    });

}
