sessionInfo()
#readr_2.1.5    dbscan_1.2.2   jsonlite_2.0.0

if (!require('jsonlite')) install.packages('jsonlite')
if (!require('dbscan')) install.packages('dbscan')
library(dbscan)
if (!require('readr')) install.packages('readr')
library(readr)
get_distance <- function(z){
  url <- paste ("http://www.mathstools.com:8080/math/servlet/CosmologyServlet?z=",z,"&q=distance", sep="")
  data <- fromJSON(url)
  return (data$PD)
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
  if (degree< -0){
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