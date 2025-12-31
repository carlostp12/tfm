# Abstract
This work primary focuses on applying density-based algorithms to datasets from major surveys, including the Two-degree Field Galaxy Redshift Survey (2dFGRS) and the Sloan Digital Sky Survey (SDSS. The application will be followed by hyperparameter tuning and a performance assessment to identify the algorithms' strengths and weaknesses in actual galactic group detection. Furthermore, the study integrates a statistical perspective through the Two-Point Correlation Function (2PCF), providing a global measure of galaxy clustering to complement the discrete group detections. These methods establish a robust framework intended for application to next-generation surveys and diverse celestial regions.

# How the project is Divided
The project utilizes both Python and R due to their role as the primary programming languages throughout the Master's program. The overall structure of the project is systematically divided as follows:
1. Python
This segment encompasses all scripts related to data preprocessing and data acquisition.
Furthermore, the Python environment includes a Jupyter notebook (notebook-2df.ipynb) dedicated to the calculation and analysis of the correlation function estimators for 2dFGRS catalog, this is the statistic study of galaxy density.
3. R
This component is dedicated to the evaluation of all density-based algorithms under consideration. It includes the execution of these algorithms and the subsequent derivation of the final conclusions across the following datasets:

 * Galaxy Redshift Survey (2dFGRS).

 * Sloan Digital Sky Survey Data Release 7 (SDSS-DR7).

You can access the R markdown by click on this <a href="R/CARLOS_TORO_TFM---2dFGRS.html">link</a>

  # How execute
  Once project is downloaded, you have to set an environment variable:
  $PROJECT_TFM.
  This variable must to point to the tfm downloaded folder.
  1. Execute a Python notebook: There are several python notebook, the ones:
     * $PROJECT_TFM/python/notebook/notebook-2df.ipynb : contains the execution for the 2PCF application and estimators application.
     * $PROJECT_TFM/python/notebook/ImportXXXX.ipynb are dedicated to transform the raw dataset to final dataset, are not neccesary to execute given that all final dataset are already created and imported. But it should be possible to execute them.
  2. Execute R-notebook: if you set the $PROJECT_TFM variable properly, R-Studio must be able to execute any of the:
    * "CARLOS_TORO_TFM - XXX.Rmd" files.
  Anyway, there exists an HTML for each one if you prefer not running them (each execution takes a long time, most likely more than one hour).


