import json
from pathlib import Path

"""
Converts an old template system config file to the BLRG format
"""

if __name__ == "__main__":
    old_json_file = Path(".") / "cblock_config_old.json"
    new_json_file = Path(".") / "cblock_letters_config.json"

    with old_json_file.open() as fp:
        old_json_data = json.load(fp)

    new_json_data = dict()

    new_json_data["variables"] = dict()
    new_json_data["dependent_variables"] = dict()
    new_json_data["excluded_folders_to_copy"] = list()
    new_json_data["scripts"] = list()

    # Old variables was a list of dicts, new one is a dict of dicts
    for variables_dict in old_json_data["variables"]:
        new_json_data["variables"][variables_dict["name"]] = variables_dict["value"]

    # Same for dependent variables. Basically just maintains the structure, except the name is now the name of the dict
    # rather than a key in the dict
    for dep_var_dict in old_json_data["dependent_variables"]:
        tmp = dict()
        tmp["operation"] = dep_var_dict["operation"]
        tmp["depends_on"] = dep_var_dict["depends_on"]
        new_json_data["dependent_variables"][dep_var_dict["name"]] = tmp

    new_json_data["custom_operations_lib"] = old_json_data["custom_operations_lib"]
    new_json_data["excluded_folders_to_copy"] = old_json_data["excluded_folders_to_copy"]

    with new_json_file.open("w") as fp:
        json.dump(new_json_data, fp)
