########################################################################
# 3D function plotting
########################################################################
plot3D_cluster <- function(objectClustering, setPoints){
  plot3d(setPoints$x, setPoints$y, setPoints$z, 
       col = objectClustering$cluster + 1, size = 2, 
       xlab = "X", ylab = "Y", zlab = "Z")
}

plot_purity_completeness <- function(
    eps_sequence, 
    purity_l, 
    completeness_l, 
    pures_com, 
    titles, 
    title = "",
    x=0,
    labelx = 'X', labely = 'Y'
    ){
    test_data <- data.frame('d1' = eps_sequence)	
    g<- ggplot(test_data, aes(eps_sequence)) +
        geom_line(aes(y = purity_l, colour = titles[1])) + 
        geom_line(aes(y = completeness_l, colour = titles[2]))+  
        geom_line(aes(y = pures_com, colour = titles[3]))+
    ggtitle(title) +
      labs(x = labelx, y = labely)
    
    if (x>0){  
     g+ geom_vline(xintercept = x, linetype="dotted",)
    }else{
      g
    }
}

plot_purity_completeness_trend <- function(
    eps_sequence, 
    purity_l, 
    completeness_l, 
    titles, 
    title = "",
    x = 0,
    labelx = 'X', labely = 'Y')
  {
    test_data <- data.frame('d1' = eps_sequence)	
    g <- ggplot(test_data, aes(eps_sequence)) +
        geom_line(aes(y = purity_l, colour = titles[1])) + 
        geom_line(aes(y = completeness_l, colour = titles[2]))+
    ggtitle(title) +
    labs(x = labelx, y = labely)
    if (x>0){  
      g + geom_vline(xintercept = x, linetype="dotted",)
    }else{
      g
    }
}

pplot_purity_completeness <- function(
    eps_sequence, 
    mi_lista, 
    titles, 
    title = "",
    x=0,
    labelx = 'X', labely = 'Y'
    ){
	limit <- length(mi_lista)
    test_data <- data.frame('d1' = eps_sequence)	
	col = c("red", "blue", "green", "gray")
    i <- 1
  cols <- list()
	plot(eps_sequence, mi_lista[1]$uno, type="l", xlab = labelx, ylab = labely, main=title, col=col[1])
	cols[1] <- "red"
	for(i in 2:limit) {
      lines (eps_sequence, as.numeric(mi_lista[i]$uno), type="l", 'col' = col[i])
	    cols[i] <- col[i]
		  i <- i+1
	}
	if(x != 0){
		abline(v=x, col="yellow")
	}
	legend("topright", legend = titles, lty = 1, col=as.character(cols))
}


ppplot_purity_completeness <- function(
    df,
    names, 
    title = "",
    x=0,
    labelx = 'X', labely = 'Y'
    ){
	limit <- length(names)
	df[, names]
	df$cat <- rep(names, each=2)
	col = list("red", "blue", "green", "gray", "orange")
  i <- 1
  g <- ggplot(df, aes(x=eps))
	
	for(i in 1:limit) {
      g <- g +geom_line(aes(y=!!sym(names(df)[i])), colour= col[[i]])
      #print(names(x_stats)[i])
		  i <- i+1
	}
  g <- g + scale_color_identity(name = '',
                       breaks = c('red', 'blue'),
                       labels = c("TempMax", "TempMin"),
                       guide = 'legend')
  
  g <- g+ ggtitle(title) + labs(x = labelx, y = labely)
  
	if(x != 0){
		 g <- g + geom_vline(xintercept = x, linetype="dotted",)
	}
	g
}