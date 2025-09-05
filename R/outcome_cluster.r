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
	ttotal<-sqldf(sprintf("select count(seqnum) as how_many,
			group_id as group_id
		from dataset
			where cluster=%s
			group by group_id
			order by how_many desc
			limit 1", cluster_id)) 
    list('group_id' = ttotal$group_id, 'how_many' = ttotal$how_many)
}

###############################################################################
#	Purity: 
#		1- how many per cluster are present in a group.
#		2- how many in the majority group.
#	A cluster is said to be pure if 2-/1- >= 0.666 
###############################################################################
calculate_purity <- function(cluster_id, dataset) {
  print(sprintf('purity clusterID %s', cluster_id))
  total<-calculate_count_of_cluster(cluster_id, dataset)
  total_in_cluster <- total$how_many
  
  #print(sprintf('      total %s', total_in_cluster))
  total<-calculate_majority_group(cluster_id, dataset)
   
  # print(sprintf('      group %s', total$group_id))
  # print(sprintf('      total_in_group %s', total$how_many))   
  total_in_group <- total$how_many
  group <- total$group_id
  
   
  # a cluster is pure if tg/tc > 0.6666
  list('cluster_id' = cluster_id, 'total_in_group' = total_in_group, 
       'total_in_cluster' = total_in_cluster, 'group_id' = group, 
       'purity' = ifelse(total_in_cluster > 0, total_in_group/total_in_cluster, 0))
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
#	Completeness: 
#		1- how many in the majority group.
#		2- count in the group
#	A cluster is said to be complete if 1-/2- >= 0.5 
###############################################################################
calculate_completeness <- function(cluster_id, dataset){
	total <- calculate_majority_group(cluster_id, dataset)
	total_in_cluster <- total$how_many
	group_id <- total$group_id
    total <- calculate_count_of_group(group_id, dataset)
	total_in_group <- total$how_many
	
	list('cluster_id' = cluster_id, 'count_in_group_cluster' = total_in_cluster, 
		 'count_in_group' = total_in_group, 'group_id' = group_id, 
		 'completeness' = ifelse(total_in_group > 0, total_in_cluster/total_in_group, 0))
}

###############################################################################
#	Get the outcomes from a given dataset 
#			where dataset contains the fields:
#				"SEQNUM"       "x"            "y"            "z"           
#				"redshift"     "dist"        "GROUP_ID"     "GAL_ID"
#				"cluster" 
#		example:
#			cluster_outcomes <- update_all_cluster_outcomes(mm)
#		previously to this we have
#		added the cluster column to mm dataset by
#			blo_scan <- extractDBSCAN(res, eps_cl = 0.00079)
#			mm$cluster <- blo_scan$cluster
#		return: a new outcomes_dataset
###############################################################################
update_all_cluster_outcomes <- function(dataset)
{
	all_clusters<-sqldf("select distinct(cluster) as cluster from dataset")
	total_clusters <- dim(all_clusters)[1]
	majority_groups <- c()
	purities <- c()
	completenesss <- c()
	counts_of_group_cluster <- c()
	totals_in_group <- c()
	for(cluster in all_clusters$cluster)
	{
		completeness_results <- calculate_completeness(cluster, dataset)
		purity_results <- calculate_purity(cluster, dataset)
		#print(majority_groups)
		majority_groups <- append(majority_groups, completeness_results$group_id)
		purities <- append(purities, purity_results$purity)
		completenesss <- append(completenesss, completeness_results$completeness)
		counts_of_group_cluster <-  append(counts_of_group_cluster, completeness_results$count_in_group_cluster)
		totals_in_group <- append(totals_in_group, completeness_results$count_in_group)
	}
	
	all_clusters$majority_group <- majority_groups
	all_clusters$purity <- purities
	all_clusters$completeness <- completenesss
	all_clusters$group_in_cluster <- counts_of_group_cluster
	all_clusters$total_in_group <- totals_in_group
	all_clusters
}

