import csv
import math
from scipy.integrate import quad
import pandas as pd

from project.load_dss_galaxy_group import to_radians, lambda_cdm, calculate_distance, changeCoordsSpericalX, \
    changeCoordsSpericalY, changeCoordsSpericalZ


class dFGRSImporter:

    def __init__(self, sdss_file, destiny_file):
        self.destiny_file = destiny_file
        self.sdss_File = sdss_file

    def parseRANumeric(hour, min=0, sec=0):
        number = hour * 360 /24
        number = number + (360 /24) * (min/60)
        number = number + (360 /24) * (sec/3600)
        return (number)

    def parseDECNumeric(degree, min=0, sec=0):
        suma = 1
        if degree < 0:
            suma = -1
        return (suma)*sec/3600 + (suma)*min/60 + degree

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
            df = pd.DataFrame(columns=['GAL_ID', 'ra', 'dec', 'z'])
            for i, line in enumerate(reader):
                adict = line[0].split()
                if adict[26] >= 3: # If quality greater than 3
                    df.loc[i] = [adict[0],
                                 self.parseRANumeric(adict[10], adict[11], adict[12]),
                                 self.parseDECNumeric(adict[13], adict[14], adict[15]),
                                 adict[23]]
                print(i)
            df.to_csv(self.destiny_file)
        print("End")


    def import_group_file(self):
        '''
        transform a group file in a CSV file
        '''
        with open(self.sdss_File, "r") as f:
            reader = csv.reader(f, delimiter="\t")
            df = pd.DataFrame(columns=['GAL_ID', 'GROUP_ID'])
            for i, line in enumerate(reader):
                adict = line[0].split()
                df.loc[i] = [adict[2], adict[0]]
                print(i)
            df.to_csv(self.destiny_file)
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
