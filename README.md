# TFM
Trabajo fin de Master DataScience UOC
# Objetivos Iniciales

- Visualización : lo cual permitirá ver los datos que se están tratando. La parte de web, puede ser un extra, si sobra tiempo, incluir este extra.
- Análisis de Densidad de Galaxias: en el que la aplicación de algoritmos de densidad tipo DBSCAN, HDBSCAN,... o estimadores de la función de correlación será importante
- Verificación de los picos acústicos: este no es un objetivo directamente de Data Science, pero es la consecuencia del punto anterior, por lo que una aplicación directa de un método de DS a cosmología.
- Aplicación de algoritmos de Clustering -> bastante ligado al punto anterior. La aplicación de los algoritmos de densidad para clusterización entiendo que serían la previa a analizar el decrecimiento de la densidad con la distancia. O bien juntaría objetivos, o los invertiría (?)

# Objetivos
- PEC1: es la definición de contexto, objetivos, motivación, etc.
- PEC2: se centra en el Estado del Arte.
- PEC3 es la implementación. 
- PEC4 la entrega final de la memoria. 
- PEC5 la presentación y video de la defensa. 

 El análisis de los datos, tratamiento previo, etc también suele requerir bastante tiempo. Es aconsejable centrarse en los aspectos más directamente relacionados con Data Science, y menos relevancia a objetivos que son más puramente de cosmología matemática, siempre que sea posible.


# Note of SDSS galaxy and group catalog

For our purposes, it doesn't matter whether you use Model or Petro; what's important is the SDSS galaxy and iMODELC_1. With both, you can join a galaxy cluster.


# How the project is Divided
The project utilizes both Python and R due to their role as the primary programming languages throughout the Master's program. The overall structure of the project is systematically divided as follows:
- PYTHON: This segment encompasses all scripts related to data preprocessing and data acquisition. Furthermore, the Python environment includes several Jupyter notebooks dedicated to the calculation and analysis of the correlation function estimators
- R: This component is dedicated to the evaluation of all density-based algorithms under consideration. It includes the execution of these algorithms and the subsequent derivation of the final conclusions across the following datasets:

2dF Galaxy Redshift Survey (2dFGRS)

Sloan Digital Sky Survey Data Release 7 (SDSS-DR7)

Re-Real Space SDSS-DR7
- 
