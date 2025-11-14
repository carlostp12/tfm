import csv
import re

from SDSSImporter import SDSSImporter
import pandas as pd


'''
if step == 1
    Load and transform the original SDDS group file imodelC_1 on to a galaxy-group CSV file.
'''
if __name__ == "__main__":
    sdss_orig = "C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/imodelC_1"
    sdss_destiny = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
    sdss_real = SDSSImporter(sdss_orig, sdss_destiny)
    sdss_real.import_group_file()
