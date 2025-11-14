
from SDSSImporter import SDSSImporter


if __name__ == "__main__":
    sdss_orig = "C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_real"
    sdss_destiny = 'C:/Users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_real_galaxy.csv'
    sdss_real = SDSSImporter(sdss_orig, sdss_destiny)
    sdss_real.import_file()