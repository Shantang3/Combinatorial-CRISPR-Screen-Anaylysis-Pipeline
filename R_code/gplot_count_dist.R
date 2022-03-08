##Input:count table (with )
##Output: ggplot of 

gplot_count_dist<-function(ct, ...){
  
  require(ggplot2)
  require(RColorBrewer)
  
  nsample = ncol(ct)
  col <- brewer.pal(nsample, "Set1")
  
  dd <- log10(ct)
  dd1 <- reshape2::melt(dd, id=NULL)
  colnames(dd1)<-c("construct_id","variable","value")
  dd1$variable <- factor(dd1$variable, 
                         levels = colnames(ct))
  
  pp<-ggplot(dd1, aes(x=value, color=variable, group=variable))+
    geom_density(size=1)+
    scale_color_manual(values = col)+
    theme(text = element_text(color = "black", size = 14),
          plot.title = element_text(hjust = 0.5, size=18),
          axis.text = element_text(colour = "gray10"))+
    theme(axis.line = element_line(size = 0.5, colour = "black"),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank())+
    theme(legend.key = element_rect(fill="transparent"),
          legend.key.size = unit(0.6, "cm"),
          legend.text = element_text(size = 12),
          legend.title = element_blank(),
          legend.justification = c(0, 1), 
          legend.position = c(0.01, 0.99))
}