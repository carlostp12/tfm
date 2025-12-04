import os

from dFGRSImporter import dFGRSImporter

'''
Load and transform original 2dfGRS data file on to a CSV file
'''
if __name__ == "__main__":
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")
    orig = "https://www.guidetothesky.com/uoc/data/2dfgrs/2dfgrs.dat"
    destiny = '{}\\data\\2dfgrs\\2dfgrs.csv'.format(base_folder)
    sdss_real = dFGRSImporter(orig, destiny)
    sdss_real.import_file()