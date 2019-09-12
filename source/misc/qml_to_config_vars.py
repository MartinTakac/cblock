import json
from pathlib import Path

"""
Parses the qml variables text file to generate variables for the model template.
This script needs to both generate a file with the new variable names (doesn't have to be
a complete config file) and it needs to rewrite the template files with the new variable names.
Hopefully none of these are dependent variables, I think they might not be just because they are
entered manually by the user at runtime (i.e. through the QML interface).

This won't be a drop-in thing. You need to clean the qml_vars file to remove the header parts and,
more importantly, to remove all of the things that actually aren't operating parameters.
e.g. buttons for manual training and display things.

Also some of the parameters are passed into dummy variables (like consts/sensitivityQML or whatever)
so these need to be further parsed to find out what they are actually controlling.
"""

if __name__ == "__main__":
    cwd = Path(".").absolute()
    vars_file = cwd / "qml_vars.txt"

    with open(vars_file) as fp:
        vars_data = fp.readlines()

    variable_paths = dict()
    variable_paths["variables"] = dict()
    for line in vars_data:
        if line.startswith("#") or line.startswith("\n"):
            continue
        line = line.split(",")
        # Get the path and the friendly name
        # We'll probably need to change them anyway but whatever
        path_parts = line[1].split("/")
        module = path_parts[-2]

        variable_name = "{}_{}".format(module, line[2].replace(" ", "_"))
        variable_paths["variables"][variable_name] = line[1]

    output_file = cwd / "vars.json"
    with open(output_file, "w") as fp:
        json.dump(variable_paths, fp)
