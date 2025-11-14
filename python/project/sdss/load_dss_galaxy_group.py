from project.sdss.SDSSImporter import SDSSImporter

if __name__ == "__main__":
    real = 1
    if real == 0:
        galaxy_file = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy.csv'
        groups_file = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
        destiny = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7-valid.csv'
    if real == 1:
        galaxy_file = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_real_galaxy.csv'
        groups_file = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
        destiny = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7-valid.csv'
    sdss_real = SDSSImporter(destiny, destiny)
    sdss_real.transform_final_dss(galaxy_file, groups_file)