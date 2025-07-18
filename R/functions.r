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

if (!require('akima')) install.packages('akima')
library(akima)


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
  number = number + min/60
  number = number + sec/3600
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

changeCoordsSpericalX <- function (r, zeta_ra, psi_dec)
{
  return (c(changeCoordsSpericalX(r, zeta_ra, psi_dec),
            changeCoordsSpericalY(r, zeta_ra, psi_dec),
            changeCoordsSpericalZ(r, zeta_ra, psi_dec)
            ))
}

parseCoords2Numeric <- function (hour, min=0, sec=0, degree, m=0, s=0)
{
  return (c(parseRANumeric(hour, min, sec),
            parseDECNumeric(degree, m, s)
  ))
}

changeCoordsSpericalX <- function (r, zeta_ra, psi_dec)
{
  x= r*cos(zeta_ra) * sin(psi_dec)
  return (x)
}

changeCoordsSpericalY <- function (r, zeta_ra, psi_dec)
{
  x= r * sin(zeta_ra) * sin(psi_dec)
  return (y)
}
changeCoordsSpericalZ <- function (r, zeta_ra, psi_dec)
{
  x= r*cos(psi_dec)
  return (z)
}


datad2$dec <- parseDECNumeric(datad2$Ded, datad2$Dem, datad2$Des)
datad2$ra <- parseRANumeric(datad2$RAh, datad2$Ram, datad2$Ras)
setwd('C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data')
datad2 <- read.csv('2dfgrs-title.csv')
datad2$dist <- get_distance(datad2$Z)

datad2$dist <- sapply (X=datad2$Z, FUN = get_distance)

x<-datad2$ra
y<-datad2$dec
z <- datad2$dist
im <- with(data,interp(x,y,z))
with(im,image(x,y,z))

#Objetivo mañana: Consultar el SDSS

a<- datad2[,c('ra', 'dec')]
res <- optics(a, minPts = 1000)
res <- extractDBSCAN(res, eps_cl = 5)