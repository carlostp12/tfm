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

    sdss_orig = "{}\\data\\groups\\sdss\\imodelC_1".format(base_folder)
    sdss_destiny = '{}\\data\\groups\\sdss\\SDSS7_galaxy_group.csv'.format(base_folder)
    sdss = SDSSImporter(sdss_orig, sdss_destiny)
    sdss.import_group_file()

