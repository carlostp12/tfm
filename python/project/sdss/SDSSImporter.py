import csv
import math
from scipy.integrate import quad
import pandas as pd

from project.load_dss_galaxy_group import to_radians, lambda_cdm, calculate_distance, changeCoordsSpericalX, \
    changeCoordsSpericalY, changeCoordsSpericalZ


class SDSSImporter:

    def __init__(self, sdss_file, destiny_file):
        self.destiny_file = destiny_file
        self.sdss_File = sdss_file

    def import_file(self):
        '''
        transform a dss original galaxy file in a CSV file
        '''
        with open(self.sdss_File, "r") as f:
            reader = csv.reader(f, delimiter="\t")
            df = pd.DataFrame(columns=['GAL_ID', 'ra', 'dec', 'z'])
            for i, line in enumerate(reader):
                adict = line[0].split()
                df.loc[i] = [adict[2], adict[3], adict[4], adict[5]]
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
                df.loc[i] = [adict[2], adict[3]]
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
