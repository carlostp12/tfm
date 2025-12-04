import load_sdss1, load_sdss_real1, load_sdss_group2, load_sdss_group_galaxy3


def import_files():
    load_sdss1.execute()


def import_files_real():
    load_sdss_real1.execute()


def import_groups():
    load_sdss_group2.execute()


def import_groups_galaxy():
    load_sdss_group_galaxy3.execute(0)


def import_groups_real_galaxy():
    load_sdss_group_galaxy3.execute(1)