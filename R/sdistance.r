#######################################
# Calculate angle between two points
#######################################
calculate_angle <- function(v1, v2) {
	dot_product <- sum(v1 * v2)
	mod_v1 <- sqrt(sum(v1^2))
	mod_v2 <- sqrt(sum(v2^2))
	acos_angle <- dot_product / (mod_v1 * mod_v2)
	acos(acos_angle)
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
d_LOS_scaled_symmetric <- function(v1, v2, sfactor) {
	(d_LOS(v1, v2) + d_LOS(v2, v1)) / 2
}

#######################################
# Calculate scaled distance between two given vectors
#######################################
d_LOS <- function(v1, v2, sfactor) {
	sfactor * sum((v1-v2)*v1) / sqrt(sum(v1^2))
}
#######################################
# Calculate elongated distance
# depends on s_factor (a factor, for example 0.2) and proper_distance
# v1 = c(x, y, x, distance, s_factor)
#######################################
s_distance <- function(v1, v2){
	vector1 <- v1[1:3]
	vector2 <- v2[1:3]
	proper_distance <- v1[4]
	sfactor <- v1[5]
    sqrt (traverse_distance(vector1, vector2, proper_distance)^2 + 
              d_LOS_scaled(vector1, vector2, sfactor)^2
		)
}

#######################################
# Get a dist object made up from s_distances
# use a coordintates matrix as follows:
#	a<- mm[,c('x', 'y', 'z', distance, s_factor)]
# The aim is to call optics with this object as fo
#   aaa <- as.dist(matriz_distancias)
#   res <- optics(aaa, minPts = 5)
#######################################

get_matrix_of_distances <- function(matrix_coordintates) {
	row_list <- as.list(data.frame(t(matrix_coordintates)))
	distances_matrix <- outer(row_list, row_list, FUN = Vectorize(s_distance))
	#matriz_distancias<- sqrt(distances_matrix)
	as.dist(distances_matrix)
}