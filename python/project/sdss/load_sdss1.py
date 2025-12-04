import os

from SDSSImporter import SDSSImporter


def execute():
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")

    sdss_orig = "https://www.guidetothesky.com/uoc/data/sdss/SDSS7"
    sdss_destiny = '{}\\data\\sdss\\SDSS7_galaxy.csv'.format(base_folder)
    sdss_real = SDSSImporter(sdss_orig, sdss_destiny, False)
    sdss_real.import_file()


if __name__ == "__main__":
    execute()
