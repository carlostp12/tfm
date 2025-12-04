import os
from project.sdss.SDSSImporter import SDSSImporter


def execute(real=0):
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")

    real_importer = real > 0
    if real == 0:
        galaxy_file = '{}\\data\\sdss\\SDSS7_galaxy.csv'.format(base_folder)
        groups_file = '{}\\data\\sdss\\SDSS7_galaxy_group.csv'.format(base_folder)
        destiny = '{}\\data\\sdss\\SDSS7-valid.csv'.format(base_folder)
    if real == 1:
        galaxy_file = '{}\\data\\sdss\\SDSS7_real_galaxy.csv'.format(base_folder)
        groups_file = '{}\\data\\sdss\\SDSS7_galaxy_group.csv'.format(base_folder)
        destiny = '{}\\data\\sdss\\SDSS7-valid.csv'.format(base_folder)
    sdss_real = SDSSImporter(destiny, destiny, real_importer)
    sdss_real.transform_final_dss(galaxy_file, groups_file)


if __name__ == "__main__":
    execute()