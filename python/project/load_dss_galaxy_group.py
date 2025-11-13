import csv
import math
import re
from scipy.integrate import quad

import pandas as pd

from project.SDSSImporter import SDSSImporter


def lambda_cdm(x, OMr, OMm, OMv):
    return 1 / (math.sqrt(OMr * (1 + x) ** 4 + OMm * (1 + x) ** 3 + OMv))


def calculate_distance(z):
    OMr = 0.0001
    OMm = 0.3
    OMv = 0.7
    I = quad(lambda_cdm, 0, z, args=(OMr, OMm, OMv))
    return I


def to_radians (angle):
    return angle * math.pi / 180


def changeCoordsSpericalX(r, ra_longitude, dec_latitude):
    return r * math.cos(to_radians(ra_longitude)) * math.cos(to_radians(dec_latitude))


def changeCoordsSpericalY(r, ra_longitude, dec_latitude):
    return r * math.sin(to_radians(ra_longitude)) * math.cos(to_radians(dec_latitude))


def changeCoordsSpericalZ(r, ra_longitude, dec_latitude):
    return r * math.sin(to_radians(dec_latitude))


if __name__ == "__main__":
    galaxy_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_galaxy.csv'
    groups_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
    sdss_real = SDSSImporter()
    sdss_real.transform_final_dss(galaxy_file, groups_file)