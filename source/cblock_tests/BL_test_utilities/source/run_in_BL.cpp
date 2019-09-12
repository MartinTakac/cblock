/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

#include <functional>

/*
includes
--------
*/

#include "gtest/gtest.h"
#include "gmock/gmock.h"
#include "gmock/gmock-matchers.h"
#include "gtest/gtest-param-test.h"
#include "bl.h"
#include "bl_message.h"
#include "bl_io.h"

#if defined (USE_BL_INTERFACE)
#include "bl_thread.h"

#include "bl_viewer.h"
#include "bl_application.hpp"
#endif /* defined (USE_BL_INTERFACE) */

#include "run_in_BL.hpp"

using ::testing::Eq;

#if defined (USE_BL_INTERFACE)
struct BL_idle_function_data
{
	int neuron_model_settling_time;
	BL_real model_time_step_s;
	struct BL_viewer *viewer;
	struct BL_model *time_step_model;
}; /* struct BL_idle_function_data */

static int bl_idle_function(void *idle_function_data_void)
{
	int return_code;
	struct BL_idle_function_data *idle_function_data;

	return_code = 0;
	idle_function_data = (struct BL_idle_function_data *)idle_function_data_void;
	if (idle_function_data)
	{
		display_BL_viewer(idle_function_data->viewer);
		return_code = 1;
	}

	return (return_code);
} /* bl_idle_function */
#endif /* defined (USE_BL_INTERFACE) */

class RunInBLImpl {

public:
	BL_message_system* message_system = (BL_message_system*)NULL;
	bool useBLInterface = false;
	BL_model* model = (BL_model *)NULL;
	TestFunction testFunctionPointer;

	void runTestFunction()
	{
		testFunctionPointer(model);
	}
};

void RunInBL::setMessageSystem(BL_message_system *message_system_parameter)
{
	impl->message_system = message_system_parameter;
}

RunInBL::RunInBL()
{
	impl = new RunInBLImpl;
	impl->message_system = (BL_message_system*)NULL;
#if defined (USE_BL_INTERFACE)
	impl->useBLInterface = true;
#else /* defined (USE_BL_INTERFACE) */
	impl->useBLInterface = false;
#endif /* defined (USE_BL_INTERFACE) */
}

#if defined (USE_BL_INTERFACE)
static void time_step_bl_sample_thread_function(void *runInBL_void)
{
	RunInBL *runInBL;

	if ((runInBL = (RunInBL *)runInBL_void))
	{
		runInBL->impl->runTestFunction();
		quit_BL_application();
	}

} /* time_step_bl_sample_thread_function */
#endif /* defined (USE_BL_INTERFACE) */

void RunInBL::Run(TestFunction testFunction)
{
	/// Create model
	char* argv = {};
	const int argc = sizeof(argv) / sizeof(char *);

#if defined (BEFORE_THREAD_POOLING)
	auto open_return_code = open_BL(nullptr, 0, (char **)&argv, NULL);
#else /* defined (BEFORE_THREAD_POOLING) */
	auto open_return_code = open_BL(nullptr, argc, &argv, NULL, 1);
#endif /* defined (BEFORE_THREAD_POOLING) */
	ASSERT_THAT(open_return_code, Eq(1)) << "open_BL must succeed";

	impl->model = create_BL_model((BL_model *)NULL, (BL_model_descriptor *)NULL);

	if (impl->useBLInterface)
	{
#if defined (USE_BL_INTERFACE)
		const BL_real field_of_view_up = 18.;
		const int neuron_model_settling_time = 10;
		const BL_real model_time_step_s = (BL_real)0.001;

		impl->testFunctionPointer = testFunction;

		int return_code = setup_BL_application(argc, &argv);

		struct BL_idle_function_data *bl_idle_function_data;

		auto scene_viewer = create_BL_viewer(impl->message_system, (char *)"scene",
			(struct BL_viewer *)NULL, 0, 0, get_screen_width_pixels_BL_application(),
			get_screen_height_pixels_BL_application(), field_of_view_up);

		set_BL_viewer_BL_model(scene_viewer, impl->model);
		preset_BL_viewer(scene_viewer);

		bl_idle_function_data = new BL_idle_function_data();
		if (bl_idle_function_data)
		{
			bl_idle_function_data->neuron_model_settling_time =
				neuron_model_settling_time;
			bl_idle_function_data->model_time_step_s = model_time_step_s;
			bl_idle_function_data->viewer = scene_viewer;
			bl_idle_function_data->time_step_model = (struct BL_model *)NULL;
		}
		set_BL_viewer_idle_function(scene_viewer, bl_idle_function,
			bl_idle_function_data);

		create_BL_thread(time_step_bl_sample_thread_function, (void *)this,
			BL_THREAD_CREATE_DETACHED);

		return_code = main_loop_BL_application();

		destroy_BL_viewer(&bl_idle_function_data->viewer);

		delete bl_idle_function_data;

		impl->testFunctionPointer = (TestFunction)NULL;
#else /* defined (USE_BL_INTERFACE) */
		ASSERT_FALSE("Support for BL_interface was not compiled into this test build.");
#endif /* defined (USE_BL_INTERFACE) */
	}
	else
	{
		testFunction(impl->model);
	}

	destroy_BL_model(&impl->model);
	close_BL();

}
