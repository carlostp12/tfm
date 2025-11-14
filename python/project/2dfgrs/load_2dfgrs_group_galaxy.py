import os

from dFGRSImporter import dFGRSImporter
'''
    Take the group and the galaxy files and merge them into a single file
'''

if __name__ == "__main__":
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")

    galaxy = "{}/tfm/data/2dfgrs/2dfgrs.csv".format(base_folder)
    groups = '{}/tfm/data/2dfgrs/group_members.csv'.format(base_folder)
    destiny = '{}/tfm/data/2dfgrs/2dfgrs-valid.csv'.format(base_folder)
    sdss_real = dFGRSImporter(destiny, destiny)
    sdss_real.transform_final_dss(galaxy, groups)
