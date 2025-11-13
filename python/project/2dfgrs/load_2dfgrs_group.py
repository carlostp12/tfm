import csv
import re

from dFGRSImporter import dFGRSImporter
import pandas as pd

if __name__ == "__main__":
    sdss_orig = "C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/group_members"
    sdss_destiny = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/group_members.csv'
    sdss_real = dFGRSImporter(sdss_orig, sdss_destiny)
    sdss_real.import_group_file()
