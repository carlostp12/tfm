
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

setwd('C:/Users/Carlos/OneDrive/data-science/TFM/tfm/data')
dt <- read.csv('2dfgrs-title-dist.csv')
str(dt)

# Take a sample
dt_sample3 <- dt[dt$RAh<=1 & dt$RAh>=0 & dt$Ded>=-29 & dt$Ded<=-27,]
dt_sample3 <- dt_sample3[dt_sample3$Z< 0.3,]

names(dt_sample3)[names(dt_sample3) == 'Z'] <- 'redshift'

dt_sample3<- dt_sample3[,c('SEQNUM','x', 'y', 'z', 'redshift',  "dist")]
ggplot(dt_sample3, aes(x=redshift, y=redshift))+geom_violin()


######################
#     GROUPS loading #    
######################       
dt_groups <- read.csv('groups/group_members.csv', sep = ',')       
mm<-merge(dt_sample3, dt_groups, by.x = 'SEQNUM', by.y = 'ID_2DF')
#mm<- mm[,c('SEQNUM','x', 'y', 'z', "dist", 'GROUP_ID', 'redshift)]

a<- mm[,c('x', 'y', 'z')]

#clustering
res <- optics(a, minPts = 5)
plot(res)
blo_scan <- extractDBSCAN(res, eps_cl = 0.00075)
plot(blo_scan)

plot3d(a$x, a$y, a$z, col = blo_scan$cluster + 1, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")

# mm ----------------------------------------------------------------------


#Groups >=5 selection actual groups
h<-sqldf("SELECT count(SEQNUM) as members, GROUP_ID FROM mm GROUP BY GROUP_ID order by members DESC")  
h2<-sqldf("SELECT mm.x, mm.y, mm.z, mm.GROUP_ID FROM mm as mm, h 
    where mm.GROUP_ID=h.GROUP_ID and h.members >= 5")
plot3d(h2$x, h2$y, h2$z, col = h2$GROUP_ID, size = 2, xlab = "X", 
       ylab = "Y", zlab = "Z")

mm$cluster_id <- blo_scan$cluster

#Groups >=8 groups obtained with model
hh<-sqldf("SELECT count(SEQNUM) as members, cluster_id FROM mm GROUP BY cluster_id order by members DESC")
hh2<-sqldf("SELECT mm.x, mm.y, mm.z, mm.GROUP_ID FROM mm as mm, hh 
    where mm.cluster_id=hh.cluster_id and hh.cluster_id >0 and hh.members >= 8")

'''
sfactor <- 3
nulos <- 0
debuggingState(on=FALSE)
mm$cluster <- blo_scan$cluster
34Htj25,Guara97.
ctorop@uoc.edu
'''
