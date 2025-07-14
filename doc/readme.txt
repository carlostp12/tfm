Galaxy Distribution Analysis through Unsupervised Methods
Bytes 
 1-  6  I06   ---     SeqNum   2dFGRS serial number (SEQNUM)
       8  I1    ---   o_SeqNum   [1,6] Number of spectra obtained
  10- 19  A10   ---     Name     2dFGRS name (NAME)
  21- 23  I03   ---     UKST     UKST plate number (IFIELD)
  25- 26  I2    h       RA1950.h Right ascension (B1950, hours)
  28- 29  I2    min     RA1950.m Right ascension (B1950, minutes)
  31- 35  F5.2  s       RA1950.s [0,60.] Right ascension (B1950, seconds)
      37  A1    ---     DE1950.- Declination sign (B1950)
  38- 39  I2    deg     DE1950.d Declination (B1950, degrees)
  41- 42  I2    arcmin  DE1950.m Declination (B1950, minutes)
  44- 47  F4.1  arcsec  DE1950.s [0,60.] Declination (B1950, seconds)
  49- 50  I2    h       RAh      Right ascension (J2000, hours)
  52- 53  I2    min     RAm      Right ascension (J2000, minutes)
  55- 59  F5.2  s       RAs      [0,60.] Right ascension (J2000)
      61  A1    ---     DE-      Declination sign (J2000, seconds)
  62- 63  I2    deg     DEd      Declination (J2000, degrees)
  65- 66  I2    arcmin  DEm      Declination (J2000, minutes)
  68- 71  F4.1  arcsec  DEs      [0,60.] Declination (J2000, seconds)
  73- 78  F6.3  mag     Bjmag    Final bj magnitude (BJG) (1)
  80- 85  F6.3  mag     Bjsel    Final bj magnitude corrected from
                                       extinction (BJSEL) (G2)
  87- 92  F6.3  mag     Bjmag.o  Original bj magnitude (BJG_OLD) (1)
  94- 99  F6.3  mag     Bjsel.o  Original bj magnitude corrected from
                                       extinction (BJSELOLD)
 102-106  F5.3  mag     Gext     Galactic extinction value (GALEXT)
 108-113  F6.3  mag     Bjmag.S  ?=0 SuperCosmos bj magnitude (SB_BJ) (1)
 115-120  F6.3  mag     Rmag.S   ?=0 SuperCosmos R magnitude  (SR_R) (1)
 122-128  F7.4  ---     z.obs    ?=-9 Best redshift (observed) (Z) (2)
 130-136  F7.4  ---     z        ?=-9 Best redshift (heliocentric) (Z_HELIO) (2)
 138-142  A5    ---     ObsRun   Observation run of best spectrum (OBSRUN)
     144  I1    ---   q_z        [1,5] Redshift quality for best spectrum
                                      (reliable redshifts have quality>=3) (2)
     146  I1    ---   n_z        Redshift type (abs=1, emi=2, man=3) (ABEMMA)
 148-154  F7.4  ---     z.abs    ?=-9.999 Cross-correlation redshift (Z_ABS) (2)
     156  I1    ---     T        Cross-correlation template (KBESTR) (2)
 158-162  F5.2  ---     Rx       ?=-9.99 Cross-correlation R value (R_CRCOR) (2)
 164-170  F7.4  ---     z.em     ?=-9.999 Emission redshift (Z_EMI) (2)
     172  I1    ---   o_z.em     Number of emission lines for Z_EMI (NMBEST) (2)
 175-179  F5.1  ---     SNR      Median signal to noise ratio per pixel (2)
 181-188  F8.4  ---     eta      ?=-99.9 Eta spectral type parameter
 
 2 TGS436Z001 349  0 11 55.72 -32 32 55.2 00 14 27.05 -32 16 14.6 
 19.424 19.362 19.430 19.390  0.062 19.368	18.286  -> Magnitudes
 0.2981  0.2981 									-> Redshift
 01SEP 												-> Observation Run of best spectrum
 4													-> Redshift Quality, Q in [1, 5] Reliable are Q>= 3
 1  												-> RedShift type (abs=1, emi=2, man=3) (ABEMMA)
 0.2981 											-> ?=-9.999 Cross-correlation redshift (Z_ABS) (2)
 5													-> Cross correlation template  
 4.57  												-> ?=-9.99 Cross-correlation R value
 0.2984 											-> RedShift emission (Z_EMI)
 1    												-> Number of emission lines for Z_EMI
 3.8 												-> Signal to noise mena ratio per pixel
 -99.9000											-> Eta spectral type parameter.
 
 Questiones de Laura:
1.  has mirado qué datos hay disponibles? (fuentes, cantidad, campos, etc)
	Sí, el catálogo 2dFGRS Glaxy survey 245591 objetos principalmente galaxias.
2. has mirado artículos relacionados con esta propuesta? qué analizan y cómo?
	Aún no, solo he visto cartografiados (cosmocartografiados)
qué tipo de modelos o técnicas, así sin entrar en detalle, planteas o crees que de podrían aplicar? en qué se distinguiría de lo que ya hay en la literatura?
cuál sería la aportación principal buscada con el proyecto?	


SOBRE SDSS: Se puede obtener de aquí https://skyserver.sdss.org/dr9/en/tools/search/sql.asp
 - Solo hay 3 tipos de objetos: STAR, QSO y GALAXY.
 - Los objetos se guardan en una tabla llamada PhotoObjAll. Esta tabla contiene TODA la información y no debe usarse a menos que que quiera buscar sobre un objeto en concreto.
 - La vista que se debe usar es PhotoObj.
 - Hay otra vista de observaciones llamada SpecObj, su tabla correspondiente es la SpecObjAll. Igual que anterior, esta tabla no se puede usar porque contiene información redundante e incorrecta, hay que usar la vista. (IMPORTANTE).
 - En cuanto a las magnitudes: hay varios datos: psfMagnitude, fiberMagnitude. El llamado modelMag no debe usarse.
 - La clasificación STAR/GALAXY se hace aquí https://skyserver.sdss.org/dr1/en/help/docs/algorithm.asp?search=expMag&submit1=Search
 Ahí dice que para galaxias se recomienda petrosianMagnitudes, para estrellas psfMag y para Quasares también psfMag.
 
 
 
Catalogo 2dFGRS bajado de 
https://cdsarc.cds.unistra.fr/ftp/VII/250/
Catálogo de QSO es un ascii, contiene 47768 lineas
https://www.kandrsmith.org/RJS/QSO_Survey/Spec_Cat/catalogue.html
El mismo de:
Otro catálogo:
2QZ/6QZ, catalogue obtenido de:
https://www.2dfquasar.org/Spec_Cat/catalogue.html
25341 líneas,

SDSS
Hay un catálogo de Supernovas en
https://classic.sdss.org/supernova/snlist_confirmed.php
También una herramienta de SQL:
https://skyserver.sdss.org/dr9/en/tools/search/sql.asp
Aquí hay tutoriales para los distintos conjuntos de datos, p.e. BOSS
https://www.sdss.org/dr18/tutorials/
En particular es interesante este: https://www.sdss4.org/surveys/boss#WorkingwithBOSSdata

Aquí https://www.sdss4.org/dr17/spectro/tutorials 
hay un enlace a https://gitlab.com/shadaba/lss-handson
Que es un proyecto de Python con datasets, es un proyecto que tiene dos ejemplos:
	1. Introduce la idea de la función de correlación a dos puntos con unas partículas en una red regular.
	2. Explica la función de correlación a dos puntosy nos guia por un catálogo simulado. Finalmente se discuten
	aspectos de la observación y te guía por la medidad para una muestra del SDSS-DR7.

Compton drag epoch: época posterior a la recombinación en la que los  bariones caen en pozos gravitarorios por la materia oscura:. Epoca del arrastre.

Hay que evaluar la función de correlación, la más habitual es la correlación a dos puntos (2PCF) que mide la pobabilidad de encontrar dos objetos a una distancia r. Se cuenta cuantos pares de objetos hay a una distancia cierta y se compara con los que hay en una distribución aleatoria.



Idea de las estrellas variables
Cartalogo HIPPARCOS: 119626 estrellas. La idea sería predecir mediante métodos de ML la variabilidad de una estrella.
si las ordenamos por varianza, vemos que las que presentan una mayor varianza son las de tipo M que también son S, como se dice en wikipedia en
https://es.wikipedia.org/wiki/Clasificaci%C3%B3n_estelar. 

Por tanto hay dos ideas:
- Clasificación estelar con métodos de ML para estrellas variables usando catálogos estelares, uno de ellos HIPPARCOS.
- Estructura galáctica: Como los diferentes valores de h, pueden afectar a las BAOs. Cartograficado galáctico:
			- 2dFGRS: Muy claro, cada campo es lo que és.
			- BOSS de SDSS, o bien DR9. Mucho más complejo y numeroso: Los campos son difíciles de averguar, pero hay vistas de tablas
	Objetivos:
			- Representación en un mapa del cielo los objetos del catálogo y la muestra que vaya a usar.
			- Calcular las ditancias con diversos modelos de universo (variar las distintas densidades). Aquí habrá que emplear métodos numéricos. 
				m - M = 5 log d - 5 => Módulo distancia => Calcular magnitudes absolutas (distancia de luz)
			- Analizar la densidad de galaxias y como ésta decrece con el tiempo (=z =con la distancia)
			- Verificar si hay picos en ese decrecimiento (debería haberlos por las osclaciones acústicas)
			- Como las distintas cosmologías afectan al pico observado?.
			- ¿Cuales modelos se pueden descartar?
			- ¿¿¿Aplicar métodos de ML para saber si se trata de STAR, QSO o GALAXY???
			- Para evitar el sesgo de Malmquist hay que limitar la muestra por distancia, no por magnitud.
			
		double OMr = 0.0000;
    	double OMm = 0.286; 0.3
		double OMv = 0.714; 0.7
		double H0 = 69.3;

Questiones de Laura:
1.  has mirado qué datos hay disponibles? (fuentes, cantidad, campos, etc)
	Sí, el catálogo 2dFGRS Glaxy survey 245591 objetos principalmente galaxias.
	También el catálog SDSS, mucho más numeroso y complejo, la muestra es de millones, puede ser el objetivo.
2. has mirado artículos relacionados con esta propuesta? qué analizan y cómo?
	Aún no, solo he visto cartografiados (cosmocartografiados)
	He visto como se obtienen la curva de decrecimiento de densidades por estimadores de correlación:
	Los estimadores y comparaciones pueden verse aquí: https://arxiv.org/pdf/astro-ph/9912088 (https://arxiv.org/abs/astro-ph/9912088)
	En la página 31 de este https://helda.helsinki.fi/server/api/core/bitstreams/2da17a6f-4179-4b99-8119-e6fb84a109dc/content
		Se dice que el mejor estimador no viesado es el de Landy y Salazy(1993)
3. qué tipo de modelos o técnicas, así sin entrar en detalle, planteas o crees que de podrían aplicar? en qué se distinguiría de lo que ya hay en la literatura?
	- Tecnicas de integración numérica y métodos estadísticos de los vistos en clase. Podría aprovechar para aplicar el módulo-distancia y comparar resultados.	
cuál sería la aportación principal buscada con el proyecto?
	- La prinpal aportación seria: 
		1) Se pueden descartar valores de H que no expliquen los picos observados?.
		2) Como son esas distancias en otros models diferentes del L-CDM? Aparecen también Picos?
	
IDEA: Si tuviera el tipo de objeto, tal vez con el SDSS lo tenga, podría aplicar métodos de ML para destingir el tipo de objeto de los datos.
Lo tengo!!! Star, QSO, Galaxy.

La idea es un estudio de la distribución de las galaxias mediante el SDSS y el 2dFGRS. Obtener algún pico de densidad, ver si se obtiene lo mismo en ambos catálogos.
Lo dificil será preparar una muestra o las muestras.
Estimador para la función de correlación a dos puntos. ->Seleccionar el óptimo.


Pasos para el estudio:
0 ) Preparar el IDE: Ubuntu.
1 ) Investigar sobre la función de correlación a dos puntos: instalar
		https://gitlab.com/shadaba/lss-handson 
		https://gitlab.com/shadaba/CorrelationFunction.git
2) Seleccionar y capturar los datos: 2dFGRS 
			2dFGRS Glaxy survey 245591
				The total number of unique objects with spectra is 245591, of which...
				12311 are stars (z < 0.002),
				125 are QSOs (z > 0.5), and
				232155 are galaxies, of which...
				3720 have Q=1,
				8021 have Q=2,
				25082 have Q=3,
				140391 have Q=4,
				55941 have Q=5,
				so there are a total of 221414 unique galaxies with good-quality (Q>=3) spectra.
		y SDSS BOSS que es el DR9.
			https://www.sdss3.org/dr9/ donde tenemos:
			Sky coverage	14,555 square degrees
				Catalog objects	932,891,133
				Galaxy spectra	1,457,002
				Quasar spectra	228,468
				Star spectra	668,054
3) una vez que tengamos los datos:
	     - Almacenamiento.
		 - Selección de campos (aunque es posible que los datos descargados ya contengan los campos que necesitemos)
		 - Selección de datos (desde donde hasta donde, distancia, magnitud?)
		 - Conversión, creacion de campos necesarios: Distancia propia en función de z, otros tipos de distancias?.
		 - Preprocesamiento: como son los datos? grupos? Tendencias? Clases ...). Histogramas.
4) Análisis: Contiene los puntos marcados como objetivos más arriba.
	
