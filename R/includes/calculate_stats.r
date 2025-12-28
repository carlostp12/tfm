get_initial_stats_frame <- function(){
  stats <- data.frame(
		'purity_list'=integer(),
		'completeness_list'=integer(),
		'cluster_list'=integer(),
		'group_list'=integer(),
		'pures'=integer(),
		'completes'=integer(),
		'pure_complet'=integer(),
		'fp_list'=numeric(),
		'fr_list'=numeric(),
		'und_gr'=numeric(),
		'spurious'=numeric(),
		'bad_class'=numeric(),
		'recovery'=numeric(),
		'fc_list'=numeric(),
		'real_list'=numeric()
		)
  stats
}
calculate_output <- function(mm){
  predicted_groups <- length(unique(mm$cluster_id))
  all <- execute_stats(mm, blo_scan)
  number_pure_groups <- nrow(all[all$purity >= 0.666,])
  number_complete_groups <- nrow(all[all$completn>=0.5,])
  number_pure_complete_groups <- nrow(all[all$purity >= 0.666 & all$completn >= 0.5,])
  fp <- number_pure_groups/predicted_groups
  fr <- number_pure_complete_groups / true_groups
  s <- undetected_groups(all)
  fc <- number_complete_groups / predicted_groups
  c(mean(all$purity), 
    mean(all$completn), 
    length(unique(all$cluster_id)), 
    length(unique(all$group_id)), 
    number_pure_groups, 
    number_complete_groups, 
    number_pure_complete_groups, 
    fp, fr, 
    length(s$GROUP_ID), 
    mean(all$spurious), 
    mean(all$bad_class),
    sum(all$recovery),fc,sum(all$is_real)
  )
}

get_elements_in_m5_groups <- function(mm){
	groups_in_mm5<-sqldf(sprintf("
	      select
	          mm.GAL_ID,
	          mm.x, 
	          mm.y, 
	          mm.z, 
	          mm.GROUP_ID, 
	          mm.redshift, 
	          mm.dist,  
	          mm.cluster_id 
	      from 
	          mm as mm, h 
        where 
            mm.GROUP_ID=h.GROUP_ID and 
	          h.members >= %s", min_members))
	groups_in_mm5
}

#Function to get clusters-stats from DBSCAN clustering
extract_stats_dbscan <- function (eps_sequence_values, local_res) {
	stats <- get_initial_stats_frame()
	for (eps_test in eps_sequence_values) {
	  print(sprintf("Extracting DBSCAN stats for epsI=%s", eps_test))
	  blo_scan <- extractDBSCAN(local_res, eps_test)
    mm$cluster_id <- blo_scan$cluster
    mm5 <- get_elements_in_m5_groups(mm)
    alli <- calculate_output(mm)
    
    stats[nrow(stats) +1,] <- 
		  c(alli[1], alli[2], alli[3], 
		    alli[4], alli[5], alli[6], 
		    alli[7],  alli[8], alli[9], 
		    alli[10], alli[11], alli[12], 
		    alli[13], alli[14], alli[15])
	}
	stats
}

#Function to get clusters-stats from OPTICS clustering
extract_stats_XI <- function (eps_sequence_values, local_res) {
  stats <- get_initial_stats_frame()
		
	for (eps_test in eps_sequence_values) {
	  print(sprintf("Extracting XI stats for XI=%s", eps_test))
	  blo_scan <- extractXi(local_res, eps_test)
    mm$cluster_id <- blo_scan$cluster
    #mm5 <- get_elements_in_m5_groups(mm)
    alli <- calculate_output(mm)
    
		stats[nrow(stats) +1,] <- 
		  c(alli[1], alli[2], alli[3], 
		    alli[4], alli[5], alli[6], 
		    alli[7],  alli[8],alli[9], 
		    alli[10], alli[11], alli[12], 
		    alli[13], alli[14], alli[15])
	}
	stats
}

#Function to get clusters-stats from HDBSCAN clustering
extract_stats_hdbscan <- function (eps_sequence_values, points) {
  stats <- get_initial_stats_frame()
		
	for (eps_test in eps_sequence_values) {
	  print(sprintf("Extracting HDBSCAN stats for EPS= %s", eps_test))
	  blo_scan <- hdbscan(points, 
	                      minPts = min_members, 
	                      cluster_selection_epsilon  = eps_test)
    mm$cluster_id <- blo_scan$cluster
    #mm5 <- get_elements_in_m5_groups(mm)
    alli <- calculate_output(mm)
    
		stats[nrow(stats) +1,] <- 
		  c(alli[1], alli[2], alli[3], 
		    alli[4], alli[5], alli[6], 
		    alli[7],  alli[8],alli[9], 
		    alli[10], alli[11], alli[12], 
		    alli[13], alli[14], alli[15])
	}
	stats
}

#Function to get clusters-stats from DPC clustering
# rho can go fixed to 0.992
extract_stats_hdbscan <- function (delta_sequence_values, galaxyDens,
                                   rho=0.992, delta=0.0012) {
  
  stats <- get_initial_stats_frame()
		
	for (delta_test in delta_sequence_values) {
	  print(sprintf("Extracting DPC stats for EPS= %s", delta_test))
	  galaxyClusters <- findClusters(galaxyClusters, rho, delta_test)
	  
	  mm$cluster_id <- galaxyClusters$cluster
    #mm5 <- get_elements_in_m5_groups(mm)
    alli <- calculate_output(mm)
    
		stats[nrow(stats) +1,] <- 
		  c(alli[1], alli[2], alli[3], 
		    alli[4], alli[5], alli[6], 
		    alli[7],  alli[8],alli[9], 
		    alli[10], alli[11], alli[12], 
		    alli[13], alli[14], alli[15])
	}
	stats
}

get_elements_not_in_groups <- function(mm5, dataset_all){
  groups_results <- sqldf("select 
	  	  mm5.GAL_ID,
	      mm5.x, 
	      mm5.y, 
	      mm5.z, 
	      mm5.GROUP_ID, 
	      mm5.redshift, 
	      mm5.dist,  
	      0 as cluster_id
	  from 
		    mm5, dataset_all
	  where 
		  mm5.GROUP_ID 
		not in (select 
		  			group_id 
			    from dataset_all) 
			      group by mm5.GAL_ID,
	          mm5.x, 
	          mm5.y, 
	          mm5.z, 
	          mm5.GROUP_ID, 
	          mm5.redshift, 
	          mm5.dist")
  groups_results
}

get_elements_in_groups <- function(dataset_mm, dataset_all){
	tt<-sqldf(sprintf("
	      select
	          d.GAL_ID,
	          d.x, 
	          d.y, 
	          d.z, 
	          d.GROUP_ID, 
	          d.redshift, 
	          d.dist,  
	          d.cluster_id 
	      from 
	          dataset_mm as d, dataset_all a 
        where 
            d.GROUP_ID=a.GROUP_ID and 
	          d.cluster_id>0"))
	tt
}

custom_heatmap <- function(data, rowN, colN, xTitle = "", yTitle = "", numColors)
{
    # transpose and rotate matrix clockswise 90 degrees 
    dataAdjusted <- t(apply(data,2,rev))

    image(1:ncol(data), 1:nrow(data), xlab = xTitle, ylab = yTitle, dataAdjusted, col = rev(brewer.pal(numColors,"RdYlBu")), axes = FALSE)
    axis(1, 1:ncol(data), colN)
    axis(2, 1:nrow(data), rowN)

    for (x in 1:ncol(data))
        for (y in 1:nrow(data))
            # add text values into matrix based on transposed/rotated indices + round values to two digits
            text(x, y, round(dataAdjusted[x,y],2))
}

update_mm5 <- function() {
	mm5<-sqldf(sprintf("
    SELECT 
        mm.GAL_ID,
        mm.x, 
        mm.y, 
        mm.z, 
        mm.GROUP_ID, 
        mm.redshift, 
        mm.dist, mm.cluster_id
      FROM 
        mm as mm, h 
      where 
          mm.GROUP_ID=h.GROUP_ID and 
          h.members >= %s"
                   , min_members))
  return (mm5)
}

assessDPC <- function (dd, rr){
	g = findClusters(galaxyDens, rho=rr, delta=dd)
	#plot(galaxyClusters)
	#abline(h = delta, lty = 3) 
	#abline(v = rho, lty = 3) 
	mm$cluster_id <- g$cluster
	tt5 <- update_mm5()
	length(unique(tt5$GROUP_ID))
	length(unique(tt5$cluster_id))
	print(sprintf("Groups %s whereas clusters %s -> %s %s" , 
		length(unique(tt5$GROUP_ID)), length(unique(tt5$cluster_id)), rr, dd))
	return (length(unique(tt5$cluster_id))/length(unique(tt5$GROUP_ID)))
	#(min(length(unique(mm5$GROUP_ID))/length(unique(mm5$cluster_id)) , length(unique(mm5$cluster_id))/length(unique(mm5$GROUP_ID))))
}