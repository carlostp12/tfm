import csv
import re

import pandas as pd

if __name__ == "__main__":
    with open("C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/imodelC_1", "r") as f:
        reader = csv.reader(f, delimiter="\t")
        df = pd.DataFrame(columns=['GAL_ID', 'GROUP_ID'])
        whiteSpaceRegex = "\\s";
        for i, line in enumerate(reader):
            j = 0
            print(i)
            attr = line[0].split()
            df.loc[i] = [attr[2], attr[3]]
        df.to_csv('C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv')