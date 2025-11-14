from dFGRSImporter import dFGRSImporter

'''
Load and transform original 2dfGRS data file on to a CSV file
'''
if __name__ == "__main__":
    orig = "C:/carlos/oneDrive/data-science/TFM/tfm/data/2dfgrs/2dfgrs.dat"
    destiny = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/2dfgrs/2dfgrs.csv'
    sdss_real = dFGRSImporter(orig, destiny)
    sdss_real.import_file()