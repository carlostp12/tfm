# Abstract
This work primary focuses on apply density-based algorithms to datasets from major surveys, including the Two-degree Field Galaxy Redshift Survey (2dFGRS) and the Sloan Digital Sky Survey (SDSS). The application will be followed by hyperparameter tuning and a performance assessment to identify the algorithms’ strengths and weaknesses in actual galactic group detection.
In the future, these methods may be applied to new surveys and other celestial regions.

# How the project is Divided
The project utilizes both Python and R due to their role as the primary programming languages throughout the Master's program. The overall structure of the project is systematically divided as follows:
1. Python
This segment encompasses all scripts related to data preprocessing and data acquisition.
Furthermore, the Python environment includes a Jupyter notebook (notebook-2df.ipynb) dedicated to the calculation and analysis of the correlation function estimators for 2dFGRS catalog, this part is still optional and today (14-12-2025) still working on it.
3. R
This component is dedicated to the evaluation of all density-based algorithms under consideration. It includes the execution of these algorithms and the subsequent derivation of the final conclusions across the following datasets:

 * Galaxy Redshift Survey (2dFGRS).

 * Sloan Digital Sky Survey Data Release 7 (SDSS-DR7).

  # How execute
  Once project is downloaded, you have to set an environment variable:
  $PROJECT_TFM
  This variable must to point to the tfm folder.
  1. Execute a notebook: There are several python notebook, the ones:
     * $PROJECT_TFM/python/notebook/notebook-2df.ipynb : contains the execution for the 2PCF application and estimators application.
     * $PROJECT_TFM/python/notebook/ImportXXXX.ipynb are dedicated to transform the raw dataset to final dataset, are not neccesary to execute given that all final dataset are already created and imported.
  2. Execute R-notebook: if you set the $PROJECT_TFM variable properly, R-Studio must be able to execute any of the:
    * "CARLOS_TORO_TFM - XXX.Rmd" files.
  Anyway there exists an HTML for each one if you prefer not running them (each execution takes a long time).


