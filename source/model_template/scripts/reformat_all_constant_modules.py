import re

from tempfile import mkstemp
import filecmp
from shutil import move
from os import close, path
import os

# Based on https://svn.soulmachines.com:8443/!/#repo/view/head/research/Shane/VSCodeBL/scripts/reformatConstantModule.py


class LastReadState:
    NothingRead, ValueReadFirst, ValueNameReadFirst, ValueReadSecond, ValueNameReadSecond = range(5)


BLConstantModulePattern = re.compile(r"^BL_constant_module\s*$")

valuesPattern = re.compile(r"values\[(\d+)\]")
valueNamesPattern = re.compile(r"value_names\[(\d+)\]")
numberOfValuesPattern = re.compile(r"^number_of_values\s*=\s*\d+")

numberOfAudioOutsPattern = re.compile(r"number_of_audio_outs")

audioOutPattern = re.compile(r"audio_out_\d+_(\w+)")
audioOutNamePattern = re.compile(r"audio_out_\d+_name")

characterConstantPattern = re.compile(r"character\s+(\d+)\s+(.+)$")


class ReformatConstantModule:

    def variable_count(self, fname):

        filename, file_extension = os.path.splitext(fname)
        if (file_extension != '.blm') or not self.check_if_file_is_text(fname):
            return 0, 0, 0
        variable_count = 0
        constant_module_count = 0
        audio_out_count = 0
        lastRead = LastReadState.NothingRead
        with open(fname) as f:
            for j, line in enumerate(f):
                constantMatch = BLConstantModulePattern.match(line)
                if constantMatch:
                    constant_module_count = constant_module_count + 1
                if valueNamesPattern.match(line):
                    if lastRead == LastReadState.ValueReadFirst:
                        lastRead = LastReadState.ValueNameReadSecond
                    else:
                        variable_count = variable_count + 1
                        lastRead = LastReadState.ValueNameReadFirst
                if valuesPattern.match(line):
                    if lastRead == LastReadState.ValueNameReadFirst:
                        lastRead = LastReadState.ValueReadSecond
                    else:
                        variable_count = variable_count + 1
                        lastRead = LastReadState.ValueReadFirst
                audio_out = audioOutNamePattern.search(line)
                if audio_out:
                    audio_out_count = audio_out_count + 1
        return constant_module_count, variable_count, audio_out_count

    @staticmethod
    def character_replace_function(matchObject):
        currentLength = int(matchObject.group(1))
        stringLength = len(matchObject.group(2))
        if stringLength > currentLength:
            currentLength = stringLength
        return "character " + str(currentLength) + " " + matchObject.group(2)

    def update_variables(self, file_path, variable_count, audio_out_count, create_backup):
        variable_index = -1  # variables start at 0
        lastRead = LastReadState.NothingRead
        audio_out_index = 0  # audio_out start at 1
        LineIsAudioOuts = False

        filename, file_extension = os.path.splitext(file_path)
        if (file_extension != '.blm') or not self.check_if_file_is_text(file_path):
            return

        fh, abs_path = mkstemp()
        with open(abs_path, 'w') as new_file:
            with open(file_path) as old_file:
                for line in old_file:
                    # Substitute anywhere in line to pick up comments
                    # but only increment on lines that start with pattern
                    if valueNamesPattern.match(line):
                        if lastRead == LastReadState.ValueReadFirst:
                            lastRead = LastReadState.ValueNameReadSecond
                        else:
                            variable_index = variable_index + 1
                            lastRead = LastReadState.ValueNameReadFirst
                    if valuesPattern.match(line):
                        if lastRead == LastReadState.ValueNameReadFirst:
                            lastRead = LastReadState.ValueReadSecond
                        else:
                            variable_index = variable_index + 1
                            lastRead = LastReadState.ValueReadFirst
                    line = valueNamesPattern.sub("value_names[{}]".format(variable_index), line)
                    line = numberOfValuesPattern.sub("number_of_values={}".format(variable_count), line)
                    line = valuesPattern.sub("values[{}]".format(variable_index), line)
                    line = characterConstantPattern.sub(self.character_replace_function, line)
                    if audioOutNamePattern.search(line):
                        audio_out_index = audio_out_index + 1
                    line = audioOutPattern.sub(r"audio_out_{}_\1".format(audio_out_index), line)
                    if LineIsAudioOuts:
                        LineIsAudioOuts = False
                        line = re.sub(r"integer\s+\d+.*$", "integer 1 {}".format(audio_out_count), line)
                    if numberOfAudioOutsPattern.search(line):
                        LineIsAudioOuts = True

                    new_file.write(line)

        close(fh)
        if filecmp.cmp(abs_path, file_path):
            # print ("File is up to date, no changes made")
            return (0)
        else:
            backup_filename = file_path + ".bak"
            if create_backup:
                move(file_path, backup_filename)
                print("Updated constant_module counts, old file saved as {}", backup_filename)
            move(abs_path, file_path)
            print("Updated constant_module counts, {}", file_path)

            return (1)

    def format_file(self, filename, create_backup=False):
        (constant_module_count, variable_count, audio_out_count) = self.variable_count(filename)
        if constant_module_count != 1:
            return
        return self.update_variables(filename, variable_count, audio_out_count, create_backup)

    @staticmethod
    def check_if_file_is_text(file_path):
        """
        Checks if the provided file is text or binary. Text files can be modified, binaries can't

        Arguments:
            file_path {Path} -- Path to file

        Returns:
            bool -- `True` if file is text, `False` otherwise
        """
        with open(file_path, 'rb') as new_file:
            bytes_text = new_file.read(1024)
            text_chars = bytearray({7, 8, 9, 10, 12, 13, 27} | set(range(0x20, 0x100)) - {0x7f})
            return not bool(bytes_text.translate(None, text_chars))


reformatConstantModule_instance = ReformatConstantModule()


def reformat_constant_modules_in_path(directory_to_check):
    for root, dirs, files in os.walk(directory_to_check):
        for filename in files:
            file_path = path.join(root, filename)
            reformatConstantModule_instance.format_file(file_path)


reformat_constant_modules_in_path(base_path)  # noqa
