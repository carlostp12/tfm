import os

from SDSSImporter import SDSSImporter

if __name__ == "__main__":
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")

    sdss_orig = "C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7"
    sdss_destiny = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy.csv'
    sdss_real = SDSSImporter(sdss_orig, sdss_destiny, False)
    sdss_real.import_file()
