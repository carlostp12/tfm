import csv
import math

import numpy as np
from scipy.integrate import quad
import pandas as pd

from project.utils.utils import parseRANumeric, parseDECNumeric, calculate_distance, changeCoordsSpericalX, \
    changeCoordsSpericalY, changeCoordsSpericalZ


class dFGRSImporter:

    def __init__(self, sdss_file, destiny_file):
        self.destiny_file = destiny_file
        self.sdss_File = sdss_file

    def import_file(self):
        '''
        transform a dss original galaxy file in a CSV file

        SEQNUM, OSEQNUM, NAME, UKST, RA1950.h, RA1950.m, RA1950.s, DE1950.d, DE1950.m, DE1950.s, \
        RAh, Ram, Ras, Ded, Dem, Des, \
        Bjmag, Bjsel, Bjmag.o, Bjsel.o, Gext, Bjmag.S, Rmag.S, \
        Z, Z_HELIO, OBSRUN, \
        Q_Z, \
        N_Z, Z_ABS, KBESTR, R_CRCOR, Z_EMI, NMBEST, SNR, ETA
        0, \
        10,11, 12
        13, 14, 15
        23
        26
        '''
        with open(self.sdss_File, "r") as f:
            reader = csv.reader(f, delimiter="\t")
            with open(self.destiny_file, "w") as fw:
                fw.write('GAL_ID,ra,dec,z\n')
                for i, line in enumerate(reader):
                    adict = line[0].split()
                    if int(adict[26]) > 2:  # If quality greater than 2
                        fw.write(
                            '{},{},{},{}\n'.format(int(adict[0]),
                            parseRANumeric(float(adict[10]), float(adict[11]), float(adict[12])),
                            parseDECNumeric(float(adict[13]), float(adict[14]), float(adict[15])),
                            float(adict[23])))

                    if i % 10000 == 1:
                        print(i)
            fw.close()
        f.close()
        print("End")

    def import_group_file(self):
        '''
        transform a group file in a CSV file
        '''
        with open(self.sdss_File, "r") as f:
            reader = csv.reader(f, delimiter="\t")
            with open(self.destiny_file, "w") as fw:
                fw.write('GAL_ID,GROUP_ID\n')
                for i, line in enumerate(reader):
                    adict = line[0].split()
                    fw.write('{},{}\n'.format(adict[2], adict[0]))
                    if i % 10000 == 1:
                        print(i)
            fw.close()
        f.close()
        print("End")

    def transform_final_dss(self, galaxy_file, groups_file):
        '''
        Transform two galaxies and groups files on a simple csv galaxy file
        with a field for groups.
        :param galaxy_file: Galaxy dataset
        :param groups_file: Groups dataset
        :return:
        '''
        # galaxy_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_galaxy.csv'
        # groups_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
        galaxy_df = pd.read_csv(galaxy_file)
        galaxy_df['GAL_ID'] = galaxy_df['GAL_ID'].astype(int)
        groups_df = pd.read_csv(groups_file)
        groups_df['GAL_ID'] = groups_df['GAL_ID'].astype(int)
        galaxy_df_merge = galaxy_df.merge(groups_df, on='GAL_ID')

        with open(self.destiny_file, "w") as f:
            f.write('GAL_ID,ra,dec,x,y,z,redshift,dist,GROUP_ID\n')

            for index, row in galaxy_df_merge.iterrows():
                dist = calculate_distance(row['z'])

                x = changeCoordsSpericalX(dist, row['ra'], row['dec'])
                y = changeCoordsSpericalY(dist, row['ra'], row['dec'])
                z = changeCoordsSpericalZ(dist, row['ra'], row['dec'])
                if index % 10000 == 1:
                    print(index)
                f.write('{},{},{},{},{},{},{},{},{}\n'.format(
                    int(row['GAL_ID']), float(row['ra']), float(row['dec']),
                    x, y, z, float(row['z']), dist, int(row['GROUP_ID'])))

        f.close()


