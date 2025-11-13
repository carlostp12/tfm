from dFGRSImporter import dFGRSImporter
'''
Load and transform original 2dfGRS-Group data-file on to a CSV file
'''

if __name__ == "__main__":
    orig = "C://carlos/oneDrive/data-science/TFM/tfm/data/groups/2dFGRS_member"
    destiny = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/2dfgrs/group_members.csv'
    sdss_real = dFGRSImporter(orig, destiny)
    sdss_real.import_group_file()
