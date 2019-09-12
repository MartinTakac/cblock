#!/bin/bash

# Just so we only need to pass one thing to the docker run command

set -e

chmod +x ./build.sh
./build.sh

python /usr/src/BL_MODEL_TESTS/run_tests.py