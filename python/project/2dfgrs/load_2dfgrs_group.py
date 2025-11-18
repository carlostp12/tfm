from dFGRSImporter import dFGRSImporter
import os
'''
Load and transform original 2dfGRS-Group data-file on to a CSV file
'''

if __name__ == "__main__":
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")

    orig = "{}\\data\\2dfgrs\\2dFGRS_member".format(base_folder)
    destiny = '{}\\data\\2dfgrs\\group_members.csv'.format(base_folder)
    sdss_real = dFGRSImporter(orig, destiny)
    sdss_real.import_group_file()
