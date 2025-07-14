sessionInfo()
#readr_2.1.5    dbscan_1.2.2   jsonlite_2.0.0

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
  return (sec/3600 + min/60 + degree);
}