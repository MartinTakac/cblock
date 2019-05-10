# Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
# Creates a Conda environment in the given directory 
# There's no difference between the Mac Windows and Linux commands, so we can just run
# them directly from cmake
# Also we need to install numpy from pip because doing so from conda installs MKL which is Bad

if (NOT DEFINED USE_MINICONDA_VERSION)
    message(FATAL_ERROR "USE_MINICONDA_VERSION not defined")
endif()

function(create_conda_env env_name output_path requirements_file)

    get_filename_component(OUTPUT_PATH_ABS "${output_path}" ABSOLUTE)
    # If you want to pass a full path to conda create, it will not accept the -n parameter
    set(CONDA_ENV_PATH "${OUTPUT_PATH_ABS}/${env_name}")
    if (EXISTS ${CONDA_ENV_PATH})
        message("Cannot create conda environment at ${CONDA_ENV_PATH}, path already exists.")
        return()
    endif()

    get_filename_component(REQUIREMENTS_TXT "${requirements_file}" ABSOLUTE)

    set(CONDA_EXE "${THIRD_PARTY}/miniconda/${USE_MINICONDA_VERSION}/builds/${OS_STATIC_LIB_DIR}/Scripts/conda")
    if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
        set(CONDA_EXE "${CONDA_EXE}.exe")
    endif()

    set(ENV_COMMAND_STRING "${CONDA_EXE} create -y --copy -p ${CONDA_ENV_PATH} python=3.7")

    set(PYTHON_EXE "${CONDA_ENV_PATH}/python")

    # Make sure we're installing the packages to the correct environment
    set(PIP_STRING "${PYTHON_EXE} -m pip install -q -r ${REQUIREMENTS_TXT}")

    message("Creating conda environment in ${CONDA_ENV_PATH}")
    message("Command string: ${ENV_COMMAND_STRING}")
    execute_process(COMMAND ${ENV_COMMAND_STRING} RESULT_VARIABLE ENV_RES)
    if (NOT ${ENV_RES} EQUAL 0)
        message(FATAL_ERROR "Error creating Conda environment")
    endif()

    message("Installing Python packages: ${PIP_STRING}")
    execute_process(COMMAND ${PIP_STRING} RESULT_VARIABLE PIP_RES)
    if (NOT ${PIP_RES} EQUAL 0)
        message(FATAL_ERROR "Error creating Conda environment")
    endif()
    message("Conda environment ready to use")

endfunction()