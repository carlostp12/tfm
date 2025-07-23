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

setwd('C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data')
dt <- read.csv('2dfgrs-title-dist.csv')
# podemos tomar una muestra:
dt_sample <-sample_n(dt, 10)


"""
plot(df$ra, df$dec)
df[ df$ra<20,'ra']
"""
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

a<- datad2[,c('ra', 'dec')]
res <- optics(a, minPts = 1000)
res <- extractDBSCAN(res, eps_cl = 5)

dt_sample$gl <- mapply(changeCoordsGalacticGL, dt_sample$ra, dt_sample$dec)
dt_sample$gb <- mapply(changeCoordsGalacticGB, dt_sample$ra, dt_sample$dec)

