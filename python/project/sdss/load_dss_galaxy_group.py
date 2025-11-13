from project.sdss.SDSSImporter import SDSSImporter

if __name__ == "__main__":
    galaxy_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss_real/SDSS7_galaxy.csv'
    groups_file = 'C:/carlos/oneDrive/data-science/TFM/tfm/data/groups/sdss/SDSS7_galaxy_group.csv'
    sdss_real = SDSSImporter.SDSSImporter()
    sdss_real.transform_final_dss(galaxy_file, groups_file)