#sacado de https://www.rdocumentation.org/packages/dbscan/versions/0.9-8/topics/optics
if (!require('dbscan')) install.packages('dbscan')
library(dbscan)

set.seed(2)
 n <- 400
 
 x <- cbind(
   x = runif(4, 0, 1) + rnorm(n, sd=0.1),
   y = runif(4, 0, 1) + rnorm(n, sd=0.1)
 )

plot(x, col=rep(1:4, time = 100))

### run OPTICS
res <- optics(x, eps = 10,  minPts = 10)
res

### get order
res$order

### plot produces a reachability plot
plot(res)

### identify clusters by cutting the reachability plot (black is noise)
# res <- optics_cut(res, eps_cl = .065) --> Do not work

opt <- extractDBSCAN(opt, eps_cl = .065)
res

plot(res)
plot(x, col = res$cluster+1L)

### re-cutting at a higher eps threshold
res <- optics_cut(res, eps_cl = .1)
res
plot(res)
plot(x, col = res$cluster+1L)

### identify clusters of varying density hierarchically using the Xi method
res <- opticsXi(res, xi = 0.05)
res

plot(res)
plot(x, col = res$cluster+1L)
# better visualization of the nested structure using convex hulls
hullplot(x, res)

# Xi cluster structure
res$clusters_xi

### use OPTICS on a precomputed distance matrix
d <- dist(x)
res <- optics(x, eps = 1, minPts = 10)
plot(res)


for(i in seq(0.00,0.2,0.01)){

 res <- extractDBSCAN(res, eps_cl = i)
 
 print(paste("Iteración ", i,";Puntos de ruido: ",sum(res$cluster==0),"Num.cluster: ",length(unique(res$cluster))))
}

for(i in seq(2,20,1)){
  res <- optics(x, eps = 0.07,  minPts = i)
  resScan <- extractDBSCAN(res, eps_cl = 0.07)
  print(paste("Iteración ", i,";Puntos de ruido: ",sum(resScan$cluster==0),"Num.cluster: ",length(unique(resScan$cluster))))
}

#Interesante: esta función consiste en fijar un valor min_samples y, a partir de ahí, graficar todas los radios eps de los
#puntos ordenados por distancia, de forma que, cuando los radios comienzan a aumentar de forma exponencial (el codo de la curva) 
# significa que nos alejamos de la zona de alta densidad (valores normales) y entramos en la zona de baja densidad (valores atípicos). 
#Esta es la denominada curva elbow. Como podemos ver donde la curva crece de forma exponencial es entre valores cercanos a 0.06 o 0.07.
kNNdistplot(x, k = 4)

res <- optics(x, eps = 1, minPts = 11)
#extract the clusters from optics
resScan <- extractDBSCAN(res, eps_cl = 0.07)
par(mfrow = c(1, 1))
plot(resScan)

par(mfrow = c(1, 2))
plot(x, col=rep(1:4, time = 100))
hullplot(x, resScan)