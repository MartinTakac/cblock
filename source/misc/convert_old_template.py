import json
import warnings
import os
import shutil
import numpy as np
from argparse import ArgumentParser
import importlib
import importlib.util
import sys
from pathlib import Path
import logging

"""
This is just the exact same thing as francisco's old one, except instead of replacing tags with values,
it replaces tags with new tags, i.e. jinja statements.

All we need is name and tag to do the conversion I think
"""


class RuntimeGenerator:

    TAG = 'tag'
    VALUE = 'value'
    SCRIPTS = 'scripts'
    VAR_NAME = 'name'
    INDEPENDENT_VARIABLES = 'variables'
    DEPENDENT_VARIABLES = 'dependent_variables'
    DEPENDS_ON = 'depends_on'
    OPERATION = 'operation'
    CUSTOM_OPERATIONS_LIB = 'custom_operations_lib'
    EXCLUDED_FOLDERS = 'excluded_folders_to_copy'

    # NOTE: Including type hints in places to make IDEs work nicer
    def generate_runtime(self, input_runtime_path: Path, output_folder_path: Path, config_file_path: Path):
        """Generate BL runtime data using input template and config file

        Arguments:
            input_runtime_path {Path} -- Path to template runtime data
            output_folder_path {Path} -- Path to destination (will be deleted if exists)
            config_file_path {Path} -- Path to json configuration file
        """
        with config_file_path.open() as f:
            full_config = json.load(f)

        # Check for excluded folders
        excluded_folders = []
        if self.EXCLUDED_FOLDERS in full_config:
            excluded_folders = [input_runtime_path / f for f in full_config[self.EXCLUDED_FOLDERS]]

        # Write the new runtime
        self._copy_runtime_to_output_folder(input_runtime_path, output_folder_path, excluded_folders)

        # Get variables with their final values and replace the tags
        variables = self._get_variables_to_change(full_config)
        self._replace_value_in_files(output_folder_path, variables)

        logging.info("COMPLETED")

    def get_custom_operations_lib(self, full_config: dict, input_runtime_path: Path):
        """Load custom operations module if it exists

        Arguments:
            full_config {dict} -- Parsed json configuration file
            input_runtime_path {Path} -- Path to template directory

        Raises:
            FileNotFoundError: If a custom op module is in the config file but does not exist on disk

        Returns:
            ModuleType -- The loaded module if provided, `None` otherwise.
        """
        if self.CUSTOM_OPERATIONS_LIB in full_config:
            custom_op_lib_path = Path(full_config[self.CUSTOM_OPERATIONS_LIB])
            # If the supplied script path is not fully qualified, it is assumed to be
            # in the template directory
            if not custom_op_lib_path.is_absolute():
                custom_op_lib_path = input_runtime_path / custom_op_lib_path

            if not custom_op_lib_path.exists():
                raise FileNotFoundError("Unable to find custom operations lib: {}. Expected in\n{}".format(
                    custom_op_lib_path.name, str(custom_op_lib_path)))

            # Spec loader handles the paths and stuff for us
            # Module name is just the file name
            spec = importlib.util.spec_from_file_location(custom_op_lib_path.stem, custom_op_lib_path)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            return module
        else:
            return None

    def _get_variables_to_change(self, full_config):
        """Gets a list of all the changes (tag and value)

        Arguments:
            full_config {dict} -- Parsed json configuration file

        Returns:
            list -- List of (variables, values) to change
        """
        independent_variables = full_config[self.INDEPENDENT_VARIABLES]
        dependent_variables = full_config[self.DEPENDENT_VARIABLES]
        self._ensure_names_in_variables(independent_variables)
        self._ensure_names_in_variables(dependent_variables)
        new_dep_vars = list()
        for var in dependent_variables:
            tmp = dict()
            tmp["value"] = 0
            tmp["name"] = var["name"]
            tmp["tag"] = var["tag"]
            new_dep_vars.append(tmp)

        all_variables = independent_variables + new_dep_vars

        self._check_for_repeated_variable_names(all_variables)
        self._check_tags_in_variables(all_variables)

        variables_to_change = [v for v in all_variables if self.TAG in list(v.keys())]
        return variables_to_change

    def _ensure_names_in_variables(self, variables):
        """TODO: document this

        Arguments:
            variables {[type]} -- [description]

        Raises:
            ValueError: [description]
        """
        no_name_variables = [v for v in variables if self.VAR_NAME not in list(v.keys())]
        if len(no_name_variables) > 0:
            raise ValueError("There are variables without a name")

    def _check_for_repeated_variable_names(self, variables):
        """TODO: Document this

        Arguments:
            variables {[type]} -- [description]

        Raises:
            ValueError: [description]
        """
        seen = set()
        variables_names = [var[self.VAR_NAME] for var in variables]
        duplicated_names = [x for x in variables_names if x in seen or seen.add(x)]
        if len(duplicated_names) > 0:
            if len(duplicated_names) > 1:
                duplicated_names = ', '.join(duplicated_names)
            else:
                duplicated_names = duplicated_names[0]
            raise ValueError("There are variables with duplicated names: " + duplicated_names)

    def _check_tags_in_variables(self, variables):
        """TODO: document this

        Arguments:
            variables {[type]} -- [description]
        """
        no_tag_variables = [v for v in variables if self.TAG not in list(v.keys())]
        for v in no_tag_variables:
            logging.warn("'{}' does not exist in {}".format(self.TAG, v[self.VAR_NAME]))

    def _copy_runtime_to_output_folder(self, input_runtime_path: Path, output_folder_path: Path, excluded_folders):
        """Copy the template runtime data to the output directory

        Arguments:
            input_runtime_path {Path} -- Template runtime data
            output_folder_path {Path} -- Output directory
            excluded_folders {list} -- Folders to be excluded in the copy operation
        """
        if output_folder_path.exists():
            shutil.rmtree(str(output_folder_path))
        output_folder_path.mkdir(parents=True)

        # Perform the copy operation
        for item in input_runtime_path.iterdir():
            # d is the fully qualified output path
            d = output_folder_path / item.name
            if item.is_dir():
                if item not in excluded_folders:
                    shutil.copytree(str(item), str(d), ignore=shutil.ignore_patterns(*excluded_folders))
            else:
                shutil.copy2(str(item), str(d))

    def _replace_value_in_files(self, runtime_path: Path, variables_to_change):
        """Replaces the variable values in the files with those from the config

        Arguments:
            runtime_path {Path} -- Path to the modified runtime data
            variables_to_change {list} -- List of variables that will be modified
        """
        for root, dirs, files in os.walk(runtime_path):
            for filename in files:
                file_path = Path(root) / filename
                if self.check_if_file_is_text(file_path):
                    with file_path.open('r') as f_read:
                        file_data = f_read.read()
                        for var in variables_to_change:
                            # Here's where the meat happens
                            # Replace every instance of tag with {{name}}
                            # Escape curly braces with two of them. Since we need two, we gotta use four.
                            file_data = file_data.replace(var[self.TAG], "{{{{ {0} }}}}".format(var[self.VAR_NAME]))
                        with file_path.open('w') as f_write:
                            f_write.write(file_data)
                else:
                    logging.warning("File: {}\n\tcan't be read as text file. No changes applied to it.".format(
                        str(file_path)))

    def check_if_file_is_text(self, file_path: Path):
        """Checks if the provided file is text or binary. Text files can be modified, binaries can't

        Arguments:
            file_path {Path} -- Path to file

        Returns:
            bool -- `True` if file is text, `False` otherwise
        """
        bytes_text = file_path.open('rb').read(1024)
        text_chars = bytearray({7, 8, 9, 10, 12, 13, 27} | set(range(0x20, 0x100)) - {0x7f})
        return not bool(bytes_text.translate(None, text_chars))


if __name__ == "__main__":
    rg = RuntimeGenerator()
    rg.generate_runtime(Path("source/model_template"), Path("source/model_template_new"),
                        Path("source/cblock_tests/letters/cblock_config_old.json"))
