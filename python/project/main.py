import pandas as pd
import numpy as np
import random


def generate_random_color():
    min = 0
    # The maximum intensity of the color space
    max = 255
    # Calculating 3 random values for each channel between min & max
    red = random.randint(min, max)/255
    green = random.randint(min, max)/255
    blue = random.randint(min, max)/255
    return (red, green, blue)


if __name__ == "__main__":
    l1 = range(87)
    dic_colors = dict()
    for i in l1:
        dic_colors[i] = generate_random_color()

    print(dic_colors[0])