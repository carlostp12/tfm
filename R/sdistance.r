incremente <- function (dot){
	dot + 1
}
#######################################
# Calculate angle between two points
#######################################
#nulos <- 0
calculate_angle <- function(v1, v2) {
	dot_product <- sum(v1 * v2)
	mod_v1 <- sqrt(sum(v1^2))
	mod_v2 <- sqrt(sum(v2^2))
	acos_angle <- dot_product / (mod_v1 * mod_v2)
	bool <- abs(acos_angle)  >1 | is.na(acos_angle)
	if(bool == TRUE) {
		0
	}else{
		acos(acos_angle)
	}
	
}

#######################################
# Calculate traverse distance from proper distance
#######################################
traverse_distance <- function(v1, v2, distance) {
	calculate_angle(v1, v2) * distance
}

#######################################
# Calculate scaled distance symmetric way
#######################################
d_LOS_scaled_symmetric <- function(v1, v2, redshift1, redshift2) {
	(d_LOS(v1, v2, redshift1) + d_LOS(v2, v1, redshift2)) / 2
}

#######################################
# Calculate scaled distance between two given vectors
# sfactor is global constant, f.e sfactor=0.2
#######################################
d_LOS <- function(v1, v2, redshift) {
	if(redshift< 0.01){
		sfactor <- 0.6
	} else if(redshift< 0.04){
		sfactor <- 0.5
	} else if(redshift< 0.06){
		sfactor <- 0.4
	} else if(redshift< 0.08){
		sfactor <- 0.35
	}else if(redshift< 0.1){
		sfactor <- 0.3
	}else if(redshift< 0.12){
		sfactor <- 0.19
	}else if(redshift< 0.15){
		sfactor <- 0.08
	}else if(redshift< 0.2){
		sfactor <- 0.01
	}else {
		sfactor <- 0.2
	}
	
	sfactor * sum((v1-v2)*v1) / sqrt(sum(v1^2))
}
#######################################
# Calculate elongated distance
# depends on sfactor (a factor, for example sfactor=0.2) and proper_distance
# v1 = c(x, y, x, distance)
# sfactor must be a global variable
#######################################
s_distance <- function(v1, v2){
	vector1 <- v1[1:3]
	vector2 <- v2[1:3]
	proper_distance <- v1[4]
	redshift1 <- v1[5]
	redshift2 <- v2[5]
	
    sqrt (traverse_distance(vector1, vector2, proper_distance)^2 + 
              d_LOS_scaled_symmetric(vector1, vector2, redshift1, redshift2)^2
		)
}

#######################################
# Get a dist object made up from s_distances
# use a coordintates matrix as follows:
#	a<- mm[,c('x', 'y', 'z', 'dist', 'redshift')]
#   matriz_distancias <- get_matrix_of_distances(a)
# The aim is to call optics with this object as follows
#   aaa <- as.dist(matriz_distancias)
#   res <- optics(aaa, minPts = 5)
#######################################

get_matrix_of_distances <- function(matrix_coordintates) {
	row_list <- as.list(data.frame(t(matrix_coordintates)))
	distances_matrix <- outer(row_list, row_list, FUN = Vectorize(s_distance))
	#matriz_distancias<- sqrt(distances_matrix)
	as.dist(distances_matrix)
}