from project.sdss.SDSSImporter import SDSSImporter

if __name__ == "__main__":
    galaxy_file = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy.csv'
    groups_file = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
    destiny = 'C:/users/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7-valid.csv'
    sdss_real = SDSSImporter(destiny, destiny)
    sdss_real.transform_final_dss(galaxy_file, groups_file)