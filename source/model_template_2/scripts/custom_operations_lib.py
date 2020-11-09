import numpy as np
from os import path


def calculate_som_weights(som_x, som_y):
    list_of_values = []
    for y in range(0,som_y,1):
        for x in range(0,som_x,1):
            x_output = (x+0.5)/som_x
            y_output = 1-(y+0.5)/som_y
            list_of_values.append([x_output, y_output])
    return list_of_values

# def calculate_som_weights(som_x, som_y):
    # dimGranularityX = som_x
    # dimGranularityY = som_y
    # minX = -0.03
    # minY = -0.03
    # maxX = 1.03
    # maxY = 1.03
    # stepX = (maxX-minX)/(dimGranularityX-1)
    # stepY = (maxY-minY)/(dimGranularityY-1)

    # list_of_values = []
    # for y in range(0,dimGranularityY,1):
        # y_output = maxY - stepY*y
        # for x in range(0,dimGranularityX,1):
            # x_output = minX + stepX*x
            # list_of_values.append([x_output, y_output])
    # return list_of_values

def calculate_som_weights_np(som_x, som_y):
    return np.array(calculate_som_weights(som_x, som_y))

def calculate_som_weights_str(som_x, som_y):
    values_list = calculate_som_weights(som_x, som_y)

    string_value = " "
    for xy in values_list:
            string_value = string_value + "{:.3f}".format(xy[0])+" "+"{:.3f}".format(xy[1])+" "
    return string_value
