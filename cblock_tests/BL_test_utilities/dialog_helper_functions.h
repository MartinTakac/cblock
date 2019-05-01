#if !defined (DIALOG_HELPER_FUNCTIONS_H)
#define DIALOG_HELPER_FUNCTIONS_H

#include <string>
#include <vector>
#include "bl.h"

void TagToVector(std::string tag, std::vector<BL_real> &data);
std::string VectorToTag(const std::vector<BL_real> data);

std::string GetStateForId(std::string tag);
int UpdateCurrentState(std::string state_type, std::vector<BL_real> &state);
void UpdateCurrentStateInitiated(std::string tag, std::vector<BL_real> &state);

struct PredictionOutput {
    std::string output_event;
    BL_real eos_predicted;
    BL_real surprise;
    BL_real contains_prediction;
    BL_real goal_reached;
    BL_real goal_reached_degree;
    std::vector<BL_real> output_bitmap;
};

#endif /* DIALOG_HELPER_FUNCTIONS_H */
