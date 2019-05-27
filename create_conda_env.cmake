# Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
# -----------------------------------------------------------
# Creates a Conda environment in the given directory 
# There's no difference between the Mac Windows and Linux commands, so we can just run
# them directly from cmake
# Also we need to install numpy from pip because doing so from conda installs MKL which is Bad

function(create_conda_env retvar env_name output_path requirements_file)

    IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        set(TARGET_OSX 1)
    ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
        set(TARGET_WINDOWS 1)
    ELSEIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
        set(TARGET_LINUX 1)
    ENDIF()

    get_filename_component(OUTPUT_PATH_ABS "${output_path}" ABSOLUTE)
    # If you want to pass a full path to conda create, it will not accept the -n parameter
    set(CONDA_ENV_PATH "${OUTPUT_PATH_ABS}/${env_name}")
    set(${retvar} ${CONDA_ENV_PATH} PARENT_SCOPE)
    if (EXISTS ${CONDA_ENV_PATH})
        # See if Python is installed at this path
        find_program(TMP_PYBIN "python" PATHS ${CONDA_ENV_PATH} NO_DEFAULT_PATH)
        if (NOT TMP_PYBIN)
            # If there's no Python then this isn't an environment folder, i.e. somebody gave a non-empty non-conda path
            message(FATAL_ERROR "Unable to create conda environment at ${CONDA_ENV_PATH}. Path exists but does not contain a Python executable.")
        else()
            message("Unable to create conda environment at ${CONDA_ENV_PATH}. A Python executable was found, so we will assume it is an existing Conda environment.")    
        endif()
        
        return()
    endif()

    find_program(CONDA_EXE "conda")
    if (NOT CONDA_EXE)
        message(FATAL_ERROR "Unable to find conda executable. Please check your PATH")
    endif()
    set(ENV_ARGS "create" "-y" "--copy" "-p" "${CONDA_ENV_PATH}" "python=3.7")

    message("Creating conda environment in ${CONDA_ENV_PATH}")
    message("Command string: ${CONDA_EXE} ${ENV_ARGS}")
    execute_process(COMMAND ${CONDA_EXE} ${ENV_ARGS} RESULT_VARIABLE ENV_RES)
    if (NOT ${ENV_RES} EQUAL 0)
        message(FATAL_ERROR "Error creating Conda environment")
    endif()
    
    if(TARGET_WINDOWS)
        set(PYTHON_EXE "${CONDA_ENV_PATH}/python")
    else()
        set(PYTHON_EXE "${CONDA_ENV_PATH}/bin/python")
    endif()
    # Set environment variables so Python can find the modules it needs
    set(ENV{PYTHONHOME} ${CONDA_ENV_PATH})
    
    if(TARGET_WINDOWS)
        set(ENV{PATH} "${CONDA_ENV_PATH};${CONDA_ENV_PATH}/Scripts;${CONDA_ENV_PATH}/Library/bin;$ENV{PATH}")
    else()
        set(ENV{PATH} "${CONDA_ENV_PATH}:${CONDA_ENV_PATH}/bin:${CONDA_ENV_PATH}/lib:$ENV{PATH}")
    endif()

    get_filename_component(REQUIREMENTS_TXT "${requirements_file}" ABSOLUTE)
    # Make sure we're installing the packages to the correct environment
    set(PIP_STRING "-m" "pip" "install" "-q" "-r" "${REQUIREMENTS_TXT}")

    message("Installing Python packages: ${PYTHON_EXE} ${PIP_STRING}")
    execute_process(COMMAND ${PYTHON_EXE} ${PIP_STRING} RESULT_VARIABLE PIP_RES)
    if (NOT ${PIP_RES} EQUAL 0)
        message(FATAL_ERROR "Error creating Conda environment")
    endif()
    message("Conda environment ready to use")

endfunction()