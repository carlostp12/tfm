calculate_count_of_cluster <- function(cluster_id, dataset){
	ttotal<-sqldf(sprintf("select count(seqnum) as how_many
			from dataset
				where cluster =%s", cluster_id))
	print(sprintf('      in cluster %s %s', cluster_id, ttotal$how_many))
    list('how_many' = ttotal$how_many)
}

calculate_count_of_group <- function(group_id, dataset){
	ttotal<-sqldf(sprintf("select count(seqnum) as how_many
		from dataset
			where group_id=%s
			group by group_id", group_id)) 
    list('how_many' = ttotal$how_many)
}

###############################################################################
#	The most common group of a given cluster and count elements in the
#	intersection group and cluster.
###############################################################################
calculate_majority_group <- function(cluster_id, dataset){
	ttotal<-sqldf(sprintf("
	select count(seqnum) as how_many,
			group_id as group_id
		from dataset
			where cluster=%s
			group by group_id
			order by how_many desc
			limit 1", cluster_id)) 
    list('group_id' = ttotal$group_id, 'how_many' = ttotal$how_many)
}

###############################################################################
#	Get the purity rate: a cluster is said to be pure if 2/3 of his
#	elements belong to a single cluster.
###############################################################################
get_global_purity_rate <- function(outcomes_dataset, min_members = 5) {
	current <- outcomes_dataset[outcomes_dataset$total_in_group >= min_members,]
	pures <- nrow(outcomes_dataset[outcomes_dataset$purity > 0.666,])
	pures / nrow(outcomes_dataset)
}

###############################################################################
#	Get the completeness rate: a cluster is said to be complete if 1/2 of his
#	elements belong to a single cluster.
###############################################################################
get_global_completeness_rate <- function(outcomes_dataset, min_members = 5) {
	current <- outcomes_dataset[outcomes_dataset$total_in_group >= min_members,]
	completes <- nrow(outcomes_dataset[outcomes_dataset$completeness > 0.5,])
	completes / nrow(outcomes_dataset)
}

###############################################################################
#	Get the recovery rate:  (pure+complete) / total_true_groups
###############################################################################
get_global_recovery_rate <- function(outcomes_dataset, original_data_set, min_members = 5) {

	total_true_groups <-sqldf("select how_many, group_id from (
							select count(group_id) as how_many, group_id 
						from original_data_set 
							group by group_id 
							order by how_many desc) 
						a where a.how_many>=5 order by how_many desc")

	current <- outcomes_dataset[outcomes_dataset$total_in_group >= min_members,]
	pures_and_complete <- nrow(outcomes_dataset[outcomes_dataset$purity>0.6 & outcomes_dataset$completeness>0.5,])
	pures_and_complete / nrow(total_true_groups)
}

###############################################################################
#	Purity and Completeness: 
#		1- how many per cluster are present in a group.
#		2- how many in the majority group.
#	A cluster is said to be pure if 2-/1- >= 0.666 
#	A cluster is said to be complete if 1-/2- >= 0.5 
###############################################################################
calculate_stats <- function(cluster_id, dataset) {
  print(sprintf('Calculating stats for  clusterID %s', cluster_id))
  total<-calculate_majority_group(cluster_id, dataset)
   
  total_in_cluster_group <- total$how_many
  group_id <- total$group_id
  print(group_id)
  total_in_group <- calculate_count_of_group(group_id, dataset)
  total_in_group <- total_in_group$how_many
  print(total_in_group)
  total_in_cluster<-calculate_count_of_cluster(cluster_id, dataset)
  total_in_cluster <- total_in_cluster$how_many
  
  
  purity <- ifelse(total_in_cluster > 0, total_in_cluster_group/total_in_cluster, 0)
  completeness <- ifelse(total_in_group > 0, total_in_cluster_group/total_in_group, 0)	
  bad_classified <- total_in_group - total_in_cluster_group
  spurious <- total_in_cluster - total_in_cluster_group
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
# delete column from dataframe: mm <- select(mm, -'cluster')
############################################################################

execute_stats <- function(mm, blo_scan){
	mm$cluster <- blo_scan$cluster
	#mm0 <- mm[mm$cluster != 0, ]
	cluster_results <-sqldf("SELECT distinct(cluster) AS cluster
		FROM mm")
	stats <- data.frame('cluster_id'=integer(),
		'group_id'=integer(),
		'total_in_group'=integer(),
		'total_in_cluster'=integer(),
		'total_in_cluster_group'=integer(),
		'purity'=numeric(),
		'completeness'=numeric(),
		'spurious'=numeric(),
		'bad_classified'=numeric(),
		'is_pure'=integer(),
		'is_complete'=integer()		
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
				bb$is_complete)
		}
		print(r)
	}
	return (stats)
}

###############################################################################
#	Execution 
#			obtaining results
###############################################################################
#all <- execute_stats(mm, blo_scan)
#nrow(all[all$is_complete>0 & all$is_pure>0 , ])
'''
sblo_scan <- extractDBSCAN(sres, eps_cl = 0.00008)
sstats <- execute_stats(mm, sblo_scan)

 cl <- hdbscan(a, minPts = 5, cluster_selection_epsilon = 0.00075)
'''
