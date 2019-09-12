/*******************************************************************************
Copyright 2017-2019 Soul Machines Ltd. All Rights Reserved.
==============================================================================*/

#include <iostream>
#include <sstream>

#include "dialog_helper_functions.h"

void TagToVector(std::string tag, std::vector<BL_real> &data) {
    data.resize(100, 0.0f);
    for (int i = 0; i < tag.size(); i++) {
        int index = std::stoi(tag.substr(i, 1));
        data[index + i * 10] = 1.0f;
    }
}

std::string VectorToTag(const std::vector<BL_real> data) {
    // Assumes 3-hot
    std::string tag;
    for (int i = 0; i < 10; i++) {
        if (data[i] > 0.9) {
            tag.append(std::to_string(i));
        }
    }
    for (int i = 10; i < 20; i++) {
        if (data[i] > 0.9) {
            tag.append(std::to_string(i - 10));
        }
    }
    for (int i = 20; i < 30; i++) {
        if (data[i] > 0.9) {
            tag.append(std::to_string(i - 20));
        }
    }

    return tag;
}

std::string GetStateForId(std::string tag) {
    std::string state;
    if (tag == "919") {
        state = "A";
    } else if (tag == "920") {
        state = "B";
    } else if (tag == "921") {
        state = "C";
    } else if (tag == "922") {
        state = "Clear";
    }
    return state;
}

int UpdateCurrentState(std::string state_type, std::vector<BL_real> &state) {
    if (state_type.size() == 0) {
        return 0;
    }

    if (state_type == "A") {
        state[1] = 1.0;
    } else if (state_type == "B") {
        state[2] = 1.0;
    } else if (state_type == "C") {
        state[0] = 1.0;
    } else if (state_type == "Clear") {
        state = std::vector<BL_real>(100, 0.0f);
    } else {
        return 1;
    }
    return 0;
}

// Updates the last two elements of the state-vector which are used to drive selection of the first event in goal-driven mode
void UpdateCurrentStateInitiated(std::string tag, std::vector<BL_real> &state) {
    if (tag.size() == 0) {
        return;
    }

    if (tag == "922") {
        state[98] = 0.0;
        state[99] = 0.0;
        return;
    }

    if ((state[98] < 0.1) && (state[99] < 0.1)) {
        if ((tag.substr(0, 1) == "1") || (tag.substr(0, 1) == "4")) {
            state[98] = 1.0;
        } else if (tag.substr(0, 1) == "5") {
            state[99] = 1.0;
        }
    }
}