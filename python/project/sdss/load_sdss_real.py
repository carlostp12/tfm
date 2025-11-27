import os

from SDSSImporter import SDSSImporter


if __name__ == "__main__":
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")
    sdss_orig = "{}\\data\\groups\\sdss_real\\SDSS7_real".format(base_folder)
    sdss_destiny = '{}\\data\\groups\\sdss_real\\SDSS7_real_galaxy.csv'.format(base_folder)
    sdss_real = SDSSImporter(sdss_orig, sdss_destiny, True)
    sdss_real.import_file()