/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/
#if !defined (RUN_IN_BL_HPP)
#define RUN_IN_BL_HPP


#include <functional>

struct BL_model;

typedef std::function<void(BL_model *bl_model)> TestFunction;

class RunInBLImpl;

class RunInBL
{
public:
	RunInBLImpl *impl;
	RunInBL();

	void setMessageSystem(BL_message_system *message_system_parameter);
	void Run(TestFunction testFunction);
};

#endif /* RUN_IN_BL_HPP */
