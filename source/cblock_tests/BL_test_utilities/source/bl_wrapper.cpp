/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

/*
includes
--------
*/
#include "bl_wrapper.hpp"
#include "bl.h"
#include "bl_message.h"
#include "bl_io.h"

#include <string>

#include <boost/filesystem.hpp>

using namespace std;
namespace bfs = boost::filesystem;
namespace util
{

void time_step(BL_model *model, unsigned int n)
{
	int return_code = 0;
	for (unsigned int i = 0; i < n; i++)
	{
		return_code = time_step_BL_model(model);
		if (return_code != 1)
		{
			throw runtime_error("Error time stepping BL model");
		}
	}
}

} // namespace util