sessionInfo()
#readr_2.1.5    dbscan_1.2.2   jsonlite_2.0.0

if (!require('jsonlite')) install.packages('jsonlite')
library(jsonlite)
if (!require('dbscan')) install.packages('dbscan')
library(dbscan)
if (!require('readr')) install.packages('readr')
library(readr)
if (!require('rjson')) install.packages('rjson')
library(rjson)

if (!require('dplyr')) install.packages('dplyr')
library(dplyr)

if (!require('akima')) install.packages('akima')
library(akima)

if (!require('astrolibR')) install.packages("astrolibR")
library(astrolibR)

if (!require('scatterplot3d')) install.packages("scatterplot3d")
library(scatterplot3d)

if (!require('gMOIP')) install.packages("gMOIP")
library(gMOIP)

if (!require('ggplot2')) install.packages("ggplot2")
library(ggplot2)

if (!require('rgl')) install.packages("rgl")
library(rgl)

if (!require('pracma')) install.packages("pracma")
library(pracma)

if (!require('plotly')) install.packages("plotly")

library(plotly)

get_distance <- function(z){
  url <- paste ("http://www.mathstools.com:8080/math/servlet/CosmologyServlet?z=",z,"&q=distance", sep="")
  tryCatch(
    expr = {
    datad <- rjson::fromJSON(file=url)
    print(datad$PD)
    return (datad$PD)
    },
    error = function(e){
      print(paste('Error!!', errors, sep =" "))
      print(e)
      print(z)
      return (0)
    }
  )
}

parseRANumeric <- function (hour, min=0, sec=0)
{
  number = hour * 360 /24
  number = number + (360 /24) * (min/60)
  number = number + (360 /24) * (sec/3600)
  return (number)
}

parseDECNumeric <- function (degree, min=0, sec=0)
{
  suma = 1
  
  if (any(degree < 0)) {
    suma = -1
  }
  return ((suma)*sec/3600 + (suma)*min/60 + degree);
}

changeCoordsSperical <- function (r, zeta_ra, psi_dec)
{
  return (c(changeCoordsSpericalX(r, zeta_ra, psi_dec),
            changeCoordsSpericalY(r, zeta_ra, psi_dec),
            changeCoordsSpericalZ(r, zeta_ra, psi_dec)
            ))
}

changeCoordsGalactic <- function (dech, decm, decs, rah, ram, ras)
{
  #a<-glactc(ten(19,50,47), ten(8,52,6), 2000, gl, gb, 1)
  a<-glactc(ten(dech, decm, decs), ten(rah, ram, ras), 2000, gl, gb, 1)
  #return (a[1]$gl, a[2]$gb)
  return (a)
}

changeCoordsGalacticGB <- function (ra, dec)
{
  #a<-glactc(ten(19,50,47), ten(8,52,6), 2000, gl, gb, 1)
  a<-glactc(ra, dec, 2000, gl, gb, 1)
  #return (a[1]$gl, a[2]$gb)
  return (a$gb)
}

changeCoordsGalacticGL <- function (ra, dec)
{
  #a<-glactc(ten(19,50,47), ten(8,52,6), 2000, gl, gb, 1)
  a<-glactc(ra, dec, 2000, gl, gb, 1)
  #return (a[1]$gl, a[2]$gb)
  return (a$gl)
}

parseToGalactic <- function (dt_sample)
{
  a<- mapply (changeCoordsGalactic, dt_sample$Ded, dt_sample$Dem, 
              dt_sample$des, dt_sample$RAh, dt_sample$Ram, dt_sample$Ras)[,1]
  dt_sample$gl=a[1]$gl
  dt_sample$gb=a[2]$gb
  return (dt_sample)
}

parseCoords2Numeric <- function (hour, min=0, sec=0, degree, m=0, s=0)
{
  return (c(parseRANumeric(hour, min, sec),
            parseDECNumeric(degree, m, s)
  ))
}

to_radians <- function(angle)
{
  return (angle * pi / 180)
}

changeCoordsSpericalX <- function (r, ra_longitude, dec_latitude)
{
  x = r * cos(to_radians(ra_longitude)) * cos(to_radians(dec_latitude))
  return (x)
}

changeCoordsSpericalY <- function (r, ra_longitude, dec_latitude)
{
  y = r * sin(to_radians(ra_longitude)) * cos(to_radians(dec_latitude))
  return (y)
}
changeCoordsSpericalZ <- function (r, ra_longitude, dec_latitude)
{
  z = r * sin(to_radians(dec_latitude))
  return (z)
}

#Work aready done
------------------------------------------------------------
dt <- read.csv('2dfgrs-title.csv')
dt$dec <- parseDECNumeric(dt$Ded, dt$Dem, dt$Des)
dt$ra <- parseRANumeric(dt$RAh, dt$Ram, dt$Ras)

# Galactic coords
dt$gl <- mapply(changeCoordsGalacticGL, dt$ra, dt$dec)
dt$gb <- mapply(changeCoordsGalacticGB, dt$ra, dt$dec)


# Distance
dt$dist <- sapply (X=dt$Z, FUN = get_distance)

setwd('C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data')

#Rectangulars
dt$x <- mapply(changeCoordsSpericalX, dt$dist , dt$ra, dt$dec)
dt$y <- mapply(changeCoordsSpericalY, dt$dist , dt$ra, dt$dec)
dt$z <- mapply(changeCoordsSpericalZ, dt$dist , dt$ra, dt$dec)

#save file
write.csv(dt, '2dfgrs-title-dist.csv')

#Rectangulars - Galactic
dt$x <- mapply(changeCoordsSpericalX, dt$dist , dt$gl, dt$gb)
dt$y <- mapply(changeCoordsSpericalY, dt$dist , dt$gl, dt$gb)
dt$z <- mapply(changeCoordsSpericalZ, dt$dist , dt$gl, dt$gb)

write.csv(dt, '2dfgrs-title-dist.csv')

dt <- read.csv('2dfgrs-title-dist.csv')

the_values <- c('RAh', 'Ram', 'Ras', 'Ded', 'Dem', 'Des', 'dist', 'Z', 'Q_Z', 'ra', 'dec', 'x', 'y', 'z')
dt <- dt[,the_values]

dt_sample3 <- dt[dt$RAh<=1 & dt$RAh>=0 & dt$Ded>=-29 & dt$Ded<=-27 & dt$Z < 0.3,]
a<- dt_sample3[,c('x', 'y', 'z')]
scatterplot3d(dt_sample3[,12:14])
ggplot(dt_sample3, aes(x=Z, y=Z))+geom_violin()

res <- optics(a, minPts = 20)
blo_scan <- extractDBSCAN(res, eps_cl = 0.001401)
hullplot(a, blo_scan)
plot(res)

db <- dbscan(a, eps = 0.0014, minPts = 20)
plot3d(a$x, a$y, a$z, col = db$cluster + 1, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")

------------------------------------------------------------


setwd('C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data')
dt <- read.csv('2dfgrs-title-dist.csv')
podemos tomar una muestra:
dt_sample <-sample_n(dt, 10)
orig_dt <- dt

"""
plot(df$ra, df$dec)
df[ df$ra<20,'ra']
"""
dt$dec <- parseDECNumeric(dt$Ded, dt$Dem, dt$Des)
dt$ra <- parseRANumeric(dt$RAh, dt$Ram, dt$Ras)
setwd('C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data')
datad2 <- read.csv('2dfgrs-title.csv')
datad2$dist <- get_distance(datad2$Z)

datad2$dist <- sapply (X=datad2$Z, FUN = get_distance)

x<-datad2$ra
y<-datad2$dec
z <- datad2$dist
im <- with(data,interp(x,y,z))
with(im,image(x,y,z))

a<- datad2[,c('ra', 'dec')]
res <- optics(a, minPts = 1000)
res <- extractDBSCAN(res, eps_cl = 5)

# Galactic coords
dt$gl <- mapply(changeCoordsGalacticGL, dt$ra, dt$dec)
dt$gb <- mapply(changeCoordsGalacticGB, dt$ra, dt$dec)

# Distance
dt_sample$dist <- sapply (X=dt_sample$Z, FUN = get_distance)

# Rectangulars
dt_sample$x <- mapply(changeCoordsSpericalX, dt_sample$dist , dt_sample$gl, dt_sample$gb)
dt_sample$y <- mapply(changeCoordsSpericalY, dt_sample$dist , dt_sample$gl, dt_sample$gb)
dt_sample$z <- mapply(changeCoordsSpericalZ, dt_sample$dist , dt_sample$gl, dt_sample$gb)

scatterplot3d(dt_sample[,42:44])

'''
Si se toman 
a<- datad2[,c('x', 'y', 'z')]
res <- optics(a, minPts = 10)
res <- extractDBSCAN(res, eps_cl = 0.0151)
Se obtienen 4 grupos y 862 elementos de ruido


dt_sample3 <- dt[dt$RAh<=1 & dt$RAh>=0 & dt$Ded>=-29 & dt$Ded<=-27,]
dt_sample3$gl <- mapply(changeCoordsGalacticGL, dt_sample3$ra, dt_sample3$dec)
dt_sample3$gb <- mapply(changeCoordsGalacticGB, dt_sample3$ra, dt_sample3$dec)

dt_sample3$x <- mapply(changeCoordsSpericalX, dt_sample3$dist , dt_sample3$gl, dt_sample3$gb)
dt_sample3$y <- mapply(changeCoordsSpericalY, dt_sample3$dist , dt_sample3$gl, dt_sample3$gb)
dt_sample3$z <- mapply(changeCoordsSpericalZ, dt_sample3$dist , dt_sample3$gl, dt_sample3$gb)

dt_sample3$x <- mapply(changeCoordsSpericalX, dt_sample3$dist , dt_sample3$ra, dt_sample3$dec)
dt_sample3$y <- mapply(changeCoordsSpericalY, dt_sample3$dist , dt_sample3$ra, dt_sample3$dec)
dt_sample3$z <- mapply(changeCoordsSpericalZ, dt_sample3$dist , dt_sample3$ra, dt_sample3$dec)

dt_sample3$xx <- mapply(changeCoordsSpericalX, dt_sample3$Z , dt_sample3$gl, dt_sample3$gb)
dt_sample3$yy <- mapply(changeCoordsSpericalY, dt_sample3$Z , dt_sample3$gl, dt_sample3$gb)
dt_sample3$zz <- mapply(changeCoordsSpericalZ, dt_sample3$Z , dt_sample3$gl, dt_sample3$gb)

#dt_sample3 <- dt_sample3[dt_sample3$Z< 0.3,]

a<- dt_sample3[,c('x', 'y', 'z')]
scatterplot3d(dt_sample3[,42:44])
ggplot(dt_sample3, aes(x=Z, y=Z))+geom_violin()

dt_sample3 <- dt_sample[dt_sample$Z< 0.1,]

res <- optics(a, minPts = 20)
blo_scan <- extractDBSCAN(res, eps_cl = 0.01401)
 hullplot(a, blo_scan)
 
 db <- dbscan(a, eps = 0.0014, minPts = 20)
 plot3d(a$x, a$y, a$z, col = db$cluster + 1, size = 5, xlab = "X", 
       ylab = "Y", zlab = "Z")
       
       
cl <- hdbscan(a, minPts = 20, cluster_selection_epsilon = 0.0020)
plot3d(a$x, a$y, a$z, col = cl$cluster + 1, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")