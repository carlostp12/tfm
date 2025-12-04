from dFGRSImporter import dFGRSImporter
import os
'''
Load and transform original 2dfGRS-Group data-file on to a CSV file
'''

def execute():
    base_folder = os.getenv('PROJECT_TFM')
    if base_folder is None:
        print("You have to set up your $PROJECT_TFM env variable")

    orig = "https://www.guidetothesky.com/uoc/data/2dfgrs/2dFGRS_member"
    destiny = '{}\\data\\2dfgrs\\group_members.csv'.format(base_folder)
    sdss_real = dFGRSImporter(orig, destiny)
    sdss_real.import_group_file()


if __name__ == "__main__":
    execute()
