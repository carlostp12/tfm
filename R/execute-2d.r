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

if (!require('sqldf')) install.packages("sqldf")
library(sqldf)


#Work aready done
'''
------------------------------------------------------------
dt <- read.csv("2dfgrs-title.csv")
dt$dec <- parseDECNumeric(dt$Ded, dt$Dem, dt$Des)
dt$ra <- parseRANumeric(dt$RAh, dt$Ram, dt$Ras)

# Galactic coords
dt$gl <- mapply(changeCoordsGalacticGL, dt$ra, dt$dec)
dt$gb <- mapply(changeCoordsGalacticGB, dt$ra, dt$dec)


# Distance
dt$dist <- sapply (X=dt$Z, FUN = get_distance)

setwd("C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data")

#Rectangulars
dt$x <- mapply(changeCoordsSpericalX, dt$dist , dt$ra, dt$dec)
dt$y <- mapply(changeCoordsSpericalY, dt$dist , dt$ra, dt$dec)
dt$z <- mapply(changeCoordsSpericalZ, dt$dist , dt$ra, dt$dec)
#sdss
dt_sdss$x <- mapply(changeCoordsSpericalX, dt_sdss$dist , dt_sdss$RA, dt_sdss$DEC)
dt_sdss$y <- mapply(changeCoordsSpericalY, dt_sdss$dist , dt_sdss$RA, dt_sdss$DEC)
dt_sdss$z <- mapply(changeCoordsSpericalZ, dt_sdss$dist , dt_sdss$RA, dt_sdss$DEC)
dt_sample3 <- dt[dt$RA<210 & dt$RA>180 & dt$DEC>27 & dt$DEC<30,] # ==> RA [12h,14h] dec in [27, 30]
dt_sample3 <- dt[dt$RA<210 & dt$RA>180 & dt$DEC>25 & dt$DEC<30,]

dt_sample3<- dt[,c("GAL_ID","x", "y", "z", "Z",  "dist", "GROUP_ID")]
names(dt_sample3)[names(dt_sample3) == "Z"] <- "redshift"
names(dt_sample3)[names(dt_sample3) == "GAL_ID"] <- "SEQNUM"
dt_sample3<- dt_sample3[,c("GAL_ID","x", "y", "z", "redshift",  "dist", "GROUP_ID")]

#save file
write.csv(dt, "2dfgrs-title-dist.csv")
write.csv(dt_sdss, "sdss-title-dist.csv")

#Rectangulars - Galactic
dt$x <- mapply(changeCoordsSpericalX, dt$dist , dt$gl, dt$gb)
dt$y <- mapply(changeCoordsSpericalY, dt$dist , dt$gl, dt$gb)
dt$z <- mapply(changeCoordsSpericalZ, dt$dist , dt$gl, dt$gb)

write.csv(dt, "2dfgrs-title-dist.csv")

'''
setwd("C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data")

dt <- read.csv('2dfgrs-title-dist.csv')

dt_sample3 <- dt[dt$RAh<=1 & dt$RAh>=0 & dt$Ded>=-29 & dt$Ded<=-27 & dt$Z < 0.3,]

a<- dt_sample3[,c('x', 'y', 'z')]
scatterplot3d(a)
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
#podemos tomar una muestra:
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
scatterplot3d(dt_sample3[,41:43])
ggplot(dt_sample3, aes(x=Z, y=Z))+geom_violin()

dt_sample3 <- dt_sample3[dt_sample3$Z< 0.2,]

######################
#     OPTICS         #    
###################### 
res <- optics(a, minPts = 20)
blo_scan <- extractDBSCAN(res, eps_cl = 0.01401)
 hullplot(a, blo_scan)
hullplot(a, mm$GROUP_ID) 

######################
#     DBSCAN         #    
###################### 
 db <- dbscan(a, eps = 0.0014, minPts = 20)
 plot3d(a$x, a$y, a$z, col = db$cluster + 1, size = 5, xlab = "X", 
       ylab = "Y", zlab = "Z")
######################
#     HDBSCAN         #    
######################
cl <- hdbscan(a, minPts = 20, cluster_selection_epsilon = 0.0020)
plot3d(a$x, a$y, a$z, col = cl$cluster + 1, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")

# table -------------------------------------------------------------------

res <- extractDBSCAN(res, eps_cl = 0.00049)

       
######################
#     GROUPS reading #    
######################       
dt_groups <- read.csv('groups/group_members.csv', sep = ',')       
mm<-merge(dt_sample3, dt_groups, by.x = 'SEQNUM', by.y = 'ID_2DF')
mm<- mm[,c('SEQNUM','x', 'y', 'z', "dist", 'GROUP_ID')]

a<- mm[,c('x', 'y', 'z')]
res <- optics(a, minPts = 10)
res <- extractDBSCAN(res, eps_cl = 0.00151)
plot3d(a$x, a$y, a$z, col = mm$GROUP_ID, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")
plot3d(a$x, a$y, a$z, col = res$cluster + 1, size = 2, xlab = "X", 
        ylab = "Y", zlab = "Z")     
        
f<- function(x_vector, y_vector){
suma <- 0
norma = sum(x_vector * x_vector)^0.5
  for(x in x_vector){
    for(y in y_vector){
      print(x)
      suma <- suma + (x-y)*x
    }
  }
return (suma/norma)
}

Rutina para tomar un objeto como distancia
aa <- head(a)
mi_matrix = matrix(0, ncol = nrow(aa), nrow = nrow(aa))

distancia <- function(vector1, vector2){
  sqrt((vector1$x-vector2$x)^2 + (vector1$y-vector2$y)^2 
  + (vector1$z-vector2$z)^2)
}

distancia <- function(vector1, vector2){
  sqrt(sum((vector1-vector2)^2))
}

projected_distance <- function(vector1, vector2){
  (sum(vector1-vector2)*vector1) / sqrt(sum(vector1^2))
}

distancia_s <- function(vector1, vector2){
    sqrt (sum((vector1-vector2)^2) + 
              (sfactor * sum((vector1-vector2)*vector1) / sqrt(sum(vector1^2)))^2
    )
}

for(i in 1:n){
  ai<- a[i,]
    for(j in 1:n){
        aj <- a[j,]
        if (i<j) {
            mi_matrix[i,j] = distancia(ai,aj)
        }else if (i>j)
        {
            mi_matrix[i,j] = mi_matrix[j,i]
        }else{
            mi_matrix[i,j] =0
        }
    }
    print(paste("J es ", i ))
}

# R es ineficiente para iterar por índices, es mejor vectorizar o como en este
# caso usar la función outer y mapply

FN <- function(i, j) {
    if (i<j) {
            mi_matrix[i,j] = distancia(a[i,],a[j,])
            print(mi_matrix[i,j])
        }else if (i>j)
        {
            mi_matrix[i,j] = mi_matrix[j,i]
        }else{
            mi_matrix[i,j] =0
           # print(0)
        }
         #print(paste("i J es ", i, " " , j, "\n"))
}
FN <- function(j,i) {
    if(i %% 10 == 1 & j %% 100 == 1){
      print(paste("i J es ", i, " " , j, "\n"))
    }
    if (i<j) {
        distancia(a[i,],a[j,])
    }
}
aaa <- outer(1:n, 1:n, FUN=function(x, y) mapply(FN, x, y))
n<-nrow(a)
as.dist(mi_matrix)

# Mejor todavía, vectorizar y aplicar por fila
sfactor <- 0.2
lista_filas <- as.list(data.frame(t(a)))
matriz_distancias <- outer(lista_filas, lista_filas, FUN = Vectorize(distancia_s))
matriz_distancias<- sqrt(matriz_distancias)
aaa <- as.dist(matriz_distancias)
res <- optics(aaa, minPts = 5)
blo_scan <- extractDBSCAN(res, eps_cl = 0.00049)
 hullplot(a, blo_scan)
hullplot(a, mm$GROUP_ID) 

plot3d(a$x, a$y, a$z, col = mm$GROUP_ID, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")
plot3d(a$x, a$y, a$z, col = blo_scan$cluster + 1, size = 2, xlab = "X", 
        ylab = "Y", zlab = "Z")
        
mm<- mm[,c('SEQNUM','x', 'y', 'z', "dist", 'GROUP_ID')]        
h<-sqldf("SELECT count(SEQNUM) as members, GROUP_ID FROM mm GROUP BY GROUP_ID order by members DESC")        
h2<-sqldf("SELECT mm.x, mm.y, mm.z, mm.GROUP_ID FROM mm as mm, h 
    where mm.GROUP_ID=h.GROUP_ID and h.members>5")

h<-sqldf("SELECT count(SEQNUM) as members, GROUP_ID FROM mm GROUP BY GROUP_ID order by members DESC")  
h2<-sqldf("SELECT mm.x, mm.y, mm.z, mm.GROUP_ID FROM mm as mm, h 
    where mm.GROUP_ID=h.GROUP_ID and h.members >= 5")
plot3d(h2$x, h2$y, h2$z, col = h2$GROUP_ID, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")
       
plot3d(a$x, a$y, a$z, col = h2$GROUP_ID, size = 2, xlab = "X", 
        ylab = "Y", zlab = "Z")

aa<- mm[,c('x', 'y', 'z')]

#Una de las mejores opciones:
blo_scan <- extractDBSCAN(res, eps_cl = 0.00069)
'''




###############################################################################
#	Executions
###############################################################################
mm$cluster <- blo_scan$cluster
mm0 <- mm[mm$cluster != 0, ]
cluster_results <-sqldf("SELECT distinct(cluster) AS cluster
    FROM mm0")
completeness <- data.frame('group'=integer(),'cluster'=integer(),'count_in_group'=integer(),'count_in_group_cluster'=integer(), 'completeness'=numeric())
purity <- data.frame('group'=integer(),'cluster'=integer(),'total_in_group'=integer(),'total_in_cluster'=integer(), 'purity'=numeric())
for(r in cluster_results$cluster){
  if(r != 0) {
    bb <- calculate_completeness(r, mm0)
 #   completeness <- append(completeness, bb$completeness) 
	completeness[nrow(completeness) +1,] <- c(bb$group_id, bb$cluster_id, bb$count_in_group, bb$count_in_group_cluster,  bb$completeness)
    bb <- calculate_purity(r, mm0)
  #  purity <- append(purity, bb$purity)
  purity[nrow(purity) +1,] <- c(bb$group_id, bb$cluster_id, bb$total_in_group, bb$total_in_cluster,  bb$purity)

  }else{
    completeness <- append(completeness, 0)
    purity <- append(purity, 0)
  }
      print(r)
}

print("**************************************************")
print("Completeness analysys")
ccc <- completeness[completeness$count_in_group > threshold,]
print(sprintf(' Total groups with more than %s members: %s', threshold, nrow(ccc)))
print(sprintf(' Completeness avg: %s', 	mean(ccc$completeness)))
print(sprintf(' Total clusters complete: %s out of %s', 	nrow(ccc[ccc$completeness>0.5,]), nrow(ccc)))
print("**************************************************")

print("**************************************************")
print("Purity analysys")
ccc <- purity[purity$total_in_group > threshold,]
print(sprintf(' Total groups with more than %s members: %s', threshold, nrow(ccc)))
print(sprintf(' Purity avg: %s', 	mean(ccc$purity)))
print(sprintf(' Total clusters pure: %s out of %s', nrow(ccc[ccc$purity>0.666,]), nrow(ccc)))
print("**************************************************")