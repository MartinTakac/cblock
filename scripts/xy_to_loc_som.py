
from os import path

som_x = #P_SOM_SIZE_X#
som_y = #P_SOM_SIZE_Y#

file_path="scene/cblock/planning/xy_to_loc_som.blm"


full_file_path = path.join(base_path, file_path)

blm_content = """BL_associative_self_organizing_map_module
# this som transforms x,y coordinates to a sparse vector
map_size_x=#P_SOM_SIZE_X#
map_size_y=#P_SOM_SIZE_Y#
number_of_inputs=2
number_of_layers=1
input_sizes=2
input_values=0.
plastic=0.
alphas=1.
best_match_threshold=1000.
best_match_learning_multiplier=1.
compare_noise=0.
use_soft_output=0.
use_activation_probability=1.
#specifies s in the activation_function 
normalize_activation=0.
activation_sensitivity=500
exploration_method_type=NO_EXPLORATION_METHOD
associative_self_organizing_map={som_weights}"""




def calculate_som_weights(som_x, som_y):
    dimGranularityX = som_x
    dimGranularityY = som_y
    minX = -0.03
    minY = -0.03
    maxX = 1.03
    maxY = 1.03



    stepX = (maxX-minX)/(dimGranularityX-1)
    stepY = (maxY-minY)/(dimGranularityY-1)

    string_value = " "
    for y in range(0,dimGranularityY,1):
        #x_output = minX
        y_output = maxY - stepY*y
        for x in range(0,dimGranularityX,1):
            x_output = minX + stepX*x
            string_value = string_value + "{:.2f}".format(x_output)+" "+"{:.2f}".format(y_output)+" "
    return string_value

som_weights = calculate_som_weights(som_x, som_y)

blm_content = blm_content.format(som_weights=som_weights)

with open(full_file_path, "w") as text_file:
    text_file.write(blm_content)