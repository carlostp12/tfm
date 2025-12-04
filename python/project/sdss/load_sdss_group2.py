import os

from SDSSImporter import SDSSImporter


'''
if step == 1
    Load and transform the original SDDS group file imodelC_1 on to a galaxy-group CSV file.
'''
if __name__ == "__main__":

    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")

    sdss_orig = "https://www.guidetothesky.com/uoc/data/sdss/imodelC_1"
    sdss_destiny = '{}\\data\\sdss\\SDSS7_galaxy_group.csv'.format(base_folder)
    sdss = SDSSImporter(sdss_orig, sdss_destiny, False)
    sdss.import_group_file()

