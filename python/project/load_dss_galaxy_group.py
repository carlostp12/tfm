import csv
import math
import re
from scipy.integrate import quad

import pandas as pd


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
    galaxy_df = pd.read_csv(galaxy_file)
    groups_df = pd.read_csv(groups_file)
    galaxy_df.merge(groups_df[['GROUP_ID']], on = 'GAL_ID')
    final_df = pd.DataFrame(columns=['GAL_ID', 'x', 'y', 'z', 'redshift', 'dist', 'GROUP_ID'])

    for index, row in galaxy_df.iterrows():
        dist = calculate_distance(row[z])
        x = changeCoordsSpericalX(dist, row['ra'], row['dec'])
        y = changeCoordsSpericalY(dist, row['ra'], row['dec'])
        z = changeCoordsSpericalZ(dist, row['ra'], row['dec'])

        final_df.loc[index] = [row['GAL_ID'], x, y, z, row['z'], dist, row['GROUP_ID']]

    final_df.to_csv('C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv')