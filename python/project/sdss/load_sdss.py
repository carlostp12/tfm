import csv
import re

from SDSSImporter import SDSSImporter
import pandas as pd

if __name__ == "__main__":
    sdss_orig = "C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7"
    sdss_destiny = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy.csv'
    sdss_real = SDSSImporter(sdss_orig, sdss_destiny)
    sdss_real.import_file()
