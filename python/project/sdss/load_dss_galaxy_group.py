import os
from project.sdss.SDSSImporter import SDSSImporter

if __name__ == "__main__":
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")
    real = 1
    if real == 0:
        galaxy_file = '{}\\data\\groups\\sdss\\SDSS7_galaxy.csv'.format(base_folder)
        groups_file = '{}\\data\\groups\\sdss\\SDSS7_galaxy_group.csv'.format(base_folder)
        destiny = '{}\\data\\groups\\sdss\\SDSS7-valid.csv'.format(base_folder)
    if real == 1:
        galaxy_file = '{}\\data\\groups\\sdss_real\\SDSS7_real_galaxy.csv'.format(base_folder)
        groups_file = '{}\\data\\groups\\sdss\\SDSS7_galaxy_group.csv'.format(base_folder)
        destiny = '{}\\data\\groups\\sdss_real\\SDSS7-valid.csv'.format(base_folder)
    sdss_real = SDSSImporter(destiny, destiny)
    sdss_real.transform_final_dss(galaxy_file, groups_file)