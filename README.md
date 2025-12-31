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

# Access the R markdown export as HTML
 * You can access the R markdown proccess of 2dFGRS redshitft space sample by click on this <a href="https://www.guidetothesky.com/uoc/data/html/CARLOS_TORO_TFM---2dFGRS.html">link</a>.
 * You can access the R markdown proccess of SDSS-DR7 redshitft space sample by click on this <a href="https://www.guidetothesky.com/uoc/data/html/CARLOS_TORO_TFM---SDSS.html">link</a>.
 * You can access the R markdown proccess of SDSS-DR7 Re-Real space sample by click on this <a href="https://www.guidetothesky.com/uoc/data/html/CARLOS_TORO_TFM---SDSS-REAL.html">link</a>.

# Access the Python notebook as HTML
You can access the HTML export of Python notebook of the processed 2PCF estimators on the 2dFGRS sample by use this link <a href="https://www.guidetothesky.com/uoc/data/html/notebook-2df.html">link</a>.

 # How execute
  If you are interested in execute this project you have to download all and set the environment variable: $PROJECT_TFM pointing to the tfm downloaded folder.
  1. Execute a Python notebook: There are several python notebook, the ones:
     * $PROJECT_TFM/python/notebook/notebook-2df.ipynb : contains the execution for the 2PCF application and estimators application.
     * $PROJECT_TFM/python/notebook/ImportXXXX.ipynb are dedicated to transform the raw dataset to final dataset, are not neccesary to execute given that all final dataset are already created and imported. But it should be possible to execute them.
  2. Execute R-markdown: set the $PROJECT_TFM variable properly, and use R-Studio to execute any of the:
    * "CARLOS_TORO_TFM - XXX.Rmd" files.
Anyway, there exists an HTML for each one if you prefer not running them (each execution takes a while depending on your processor, but most likely more than one hour).


