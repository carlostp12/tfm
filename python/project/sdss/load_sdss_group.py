import csv
import re

from SDSSImporter import SDSSImporter
import pandas as pd


def merge_galaxy_group():
    galaxy_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_galaxy.csv'
    groups_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
    sdss_new = SDSSImporter.SDSSImporter()
    sdss_new.transform_final_dss(galaxy_file, groups_file)

'''
if step == 1
    Load and transform the original SDDS group file imodelC_1 on to a galaxy-group CSV file.
if step == 2
    Take the csv group and galaxy files and merge them into a single file relating groups and galaxy 
'''
if __name__ == "__main__":
    step = 1
    if step == 1:
        sdss_orig = "C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/imodelC_1"
        sdss_destiny = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
        sdss_real = SDSSImporter(sdss_orig, sdss_destiny)
        sdss_real.import_group_file()
    if step == 2:
        merge_galaxy_group()