
###############################################################################
#	Number of elements in a given output-cluster
###############################################################################
calculate_count_of_cluster <- function(cluster_id, dataset){
	ttotal<-sqldf(sprintf("
	    select 
	      count(GAL_ID) as how_many
			from 
			  dataset
			where 
	       cluster_id =%s", cluster_id))
}


###############################################################################
#	Number of elements in a given true-group
###############################################################################
calculate_count_of_group <- function(group_id, dataset){
	ttotal<-sqldf(sprintf("
	  select 
	    count(GAL_ID) as how_many
		from 
		  dataset
		where 
		  group_id=%s
		group by 
	    group_id", group_id)) 
    list('how_many' = ttotal$how_many)
}


###############################################################################
#	The most common true-group of a given output-cluster and count elements in the
#	intersection group and cluster.
###############################################################################
calculate_majority_group <- function(cluster_id, dataset){
	ttotal<-sqldf(sprintf("
	  select 
	    count(GAL_ID) as how_many,
			group_id as group_id
		from 
		  dataset
		where 
		  cluster_id=%s
		  
		group by 
			group_id
		order by 
		  how_many desc 
	    limit 1", cluster_id)) 
    list('group_id' = ttotal$group_id,
         'how_many' = ttotal$how_many)
}

###############################################################################
#	Purity and Completeness: 
#		1- (P) how many in an output-cluster coming from a true-group.
#		2- (C) how many in the majority true-group are present in output-cluster.
#	An output-cluster is said to be pure if P- >= 0.666 
#	An output-cluster is said to be complete if C >= 0.5 
###############################################################################
calculate_stats <- function(cluster_id, dataset) {
  #print(sprintf('Calculating stats for  clusterID %s', cluster_id))
  total<-calculate_majority_group(cluster_id, dataset)
  #Number of elements in the cluster_id that also belong
  #to majority group
  total_in_cluster_group <- total$how_many
  group_id <- total$group_id
  
  #Total number of elements in a group
  total_in_group <- calculate_count_of_group(group_id, dataset)
  total_in_group <- total_in_group$how_many
  
  #Total number of elements in a cluster
  total_in_cluster<-calculate_count_of_cluster(cluster_id, dataset)
  total_in_cluster <- total_in_cluster$how_many
  
  #Purity: all of group in cluster/total un cluster
  purity <- ifelse(total_in_cluster > 0, total_in_cluster_group/total_in_cluster, 0)
  #completeness: all of group in cluster/total un group
  completeness <- ifelse(total_in_group > 0, total_in_cluster_group/total_in_group, 0)	
  
  bad_classified <- total_in_group - total_in_cluster_group # belowing to group but classified outside
  spurious <- total_in_cluster - total_in_cluster_group # Outside of the group classified inside
  list('cluster_id' = cluster_id, 
		'group_id' = group_id , 
		'total_in_group' = total_in_group, 
		'total_in_cluster' = total_in_cluster, 
		'total_in_cluster_group' = total_in_cluster_group,
		'purity' = purity,
		'completeness' = completeness,
		'spurious' = spurious,
		'bad_classified' = bad_classified,
		'is_pure' = ifelse(purity>=0.666, 1, 0),
		'is_complete' = ifelse(completeness >= 0.5, 1, 0)
	   )
}


############################################################################
# Execute stats from a given mm dataset and a db_scan execution result
# delete column from dataframe: mm <- select(mm, -'cluster')
############################################################################
execute_stats <- function(mm, blo_scan){
  
	#mm0 <- mm[mm$cluster != 0, ]
	cluster_results <-sqldf("
    select 
	    distinct(cluster_id) AS cluster
		FROM 
	    mm")
	stats <- data.frame('cluster_id'=integer(),
		'group_id'=integer(),
		'total_in_group'=integer(),
		'total_in_cluster'=integer(),
		'total_in_cluster_group'=integer(),
		'purity'=numeric(),
		'completn'=numeric(),
		'spurious'=numeric(),
		'bad_class'=numeric(),
		'is_pur'=integer(),
		'is_comp'=integer(),
		'recovery'=numeric()
		)
	for(r in cluster_results$cluster){
	  if(r != 0) {
		bb <- calculate_stats(r, mm)
		stats[nrow(stats) +1,] <- 
			c(  bb$cluster_id, 
				bb$group_id, 
				bb$total_in_group, 
				bb$total_in_cluster, 
				bb$total_in_cluster_group, 
				bb$purity, 
				bb$completeness, 
				bb$spurious,
				bb$bad_classified,
				bb$is_pure,  
				bb$is_complete,
				ifelse(bb$is_pure & bb$is_complete,
				       bb$total_in_group/number_non_isolated_galaxies,
				       0 ))
		}
		#print(r)
	}
	return (stats)
}

undetected_groups <- function(dataset){
  groups_results <-sqldf("
    select 
        distinct(GROUP_ID)
    from 
        mm5
    where 
      group_id not in (
        select 
          distinct(group_id) as group_id
		    from
          dataset
        )")
   groups_results
}

print_stats <- function(all_data) {
  print(paste("Mean purity", mean(all_data$purity)))
  print(paste("Mean completness", mean(all_data$completn)))
  s<- undetected_groups(all_data)
  print(paste("Undetected groups", length(s$GROUP_ID), "out of", true_groups))
  print(paste("Detected real groups", (true_groups-length(s$GROUP_ID)), "out of", true_groups))
}
# Pretty print a vector preceded by a title
pretty_print <- function (title, avector= c()){
  paste(title, do.call(paste, c(as.list(avector), sep = " ")))
}

print_global_stats <- function(global_stats, sequence_values) {
  print ('############### DATA FOR eps values ############')
  pretty_print(pretty_print("EPS", eps_sequence_test))
  print ('#############################################')
  
  print ('')
  print ('')  
  print(pretty_print("Completeness", global_stats$completeness_list))
  print(pretty_print("Purity", global_stats$purity_list))
  print(pretty_print("Groups", global_stats$group_list))
  print(pretty_print("Clusters", global_stats$cluster_list))
  print(pretty_print("EPS", sequence_values))
  print(paste("True Groups", true_groups))
  print(pretty_print("Und. Groups", global_stats$und_gr))
  print(pretty_print("Complete gr.:", global_stats$completes))
  print(pretty_print("Pure gr.:", global_stats$pures))
  print(pretty_print("Fr:", global_stats$fr_list))
  print(pretty_print("Fp:", global_stats$fp_list))
  print(pretty_print("Spurious:", global_stats$spurious))
  print(pretty_print("Bad class:", global_stats$bad_class))
  print(pretty_print("Recovery:", global_stats$recovery))
}

get_groups_with_more_than <- function(mm, min_members){
	h<-sqldf("select 
            count(GAL_ID) as members, 
            GROUP_ID 
          from 
            mm 
          group by 
            GROUP_ID 
          order by  
            members desc")
	sqldf(sprintf("
    SELECT 
        mm.GAL_ID,
        mm.x, 
        mm.y, 
        mm.z, 
        mm.GROUP_ID, 
        mm.redshift, 
        mm.dist
      FROM 
        mm as mm, h 
      where 
          mm.GROUP_ID=h.GROUP_ID and 
          h.members >= %s"
      , min_members))
}

get_clusters_with_more_than<- function(mm, min_members){
	h<-sqldf("select 
            count(GAL_ID) as members, 
            cluster_id 
          from 
            mm 
          group by 
            cluster_id 
          order by  
            members desc")
	sqldf(sprintf("
    SELECT 
        mm.GAL_ID,
        mm.x, 
        mm.y, 
        mm.z, 
        mm.GROUP_ID, 
        mm.redshift, 
        mm.dist,
		mm.cluster_id
      FROM 
        mm as mm, h 
      where 
          mm.cluster_id=h.cluster_id and 
          h.members >= %s"
      , min_members))
}