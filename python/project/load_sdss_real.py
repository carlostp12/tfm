import csv
import re

import pandas as pd

if __name__ == "__main__":
    with open("C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_real", "r") as f:
        reader = csv.reader(f, delimiter="\t")
        df = pd.DataFrame(columns=['GAL_ID', 'ra', 'dec', 'z'])
        whiteSpaceRegex = "\\s";
        for i, line in enumerate(reader):
            j = 0
            print(i)
            adict = dict();
            for j, attr in enumerate(line[0].split()):
                if j == 2:
                    adict['GAL_ID'] = attr
                if j == 3:
                    adict['ra'] = attr
                if j == 4:
                    adict['dec'] = attr
                if j == 5:
                    adict['z'] = attr
            print(adict)
            df.loc[i] = [adict['GAL_ID'], adict['ra'], adict['dec'], adict['z']]
        df.to_csv('C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_real_galaxy.csv')