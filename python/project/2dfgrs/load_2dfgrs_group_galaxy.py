from dFGRSImporter import dFGRSImporter
'''
    Take the group and the galaxy files and merge them into a single file
'''

if __name__ == "__main__":
    galaxy = "C:/carlos/oneDrive/data-science/TFM/tfm/data/2dfgrs/2dfgrs.csv"
    groups = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/2dfgrs/group_members.csv'
    destiny = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/2dfgrs/2dfgrs-valid.csv'
    sdss_real = dFGRSImporter(destiny, destiny)
    sdss_real.transform_final_dss(galaxy, groups)
