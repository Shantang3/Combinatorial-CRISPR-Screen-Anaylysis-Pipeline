library(ggplot2)
library(ggrepel)
library(devtools)
library(gridExtra)

GI_gene<-read.table("https://raw.githubusercontent.com/Shantang3/Combinatorial-CRISPR-Screen-Anaylysis-Pipeline/main/data/Demo_MAGeCK_GI.txt", header = T) %>% 
  mutate(diff=obs_lfc-exp_lfc)
## The gene-gene pair highlited in the figure
gene_label<-c("EZH2__IGF1R","ETF1__ULK1","CDK2__IGF1R","CDK2__ULK1","ETF1__WNT5A")

p1<-ggplot(GI_gene, aes(x=exp_lfc, y=obs_lfc,colour=GI)) +
  geom_point(aes(colour=GI),alpha=.7)+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed")+
  labs(x = "Expected paired-gene LFC", y= "Observed paired-gene LFC") +
  xlim(-1.4, 0.5)+ylim(-1.4, 0.5)+
  scale_color_gradient2(midpoint=0, low="cyan", mid="black", high="yellow", space ="Lab", name="GI score")+
  geom_point(data = subset(GI_gene, id %in% gene_label), color = "brown1")+
  geom_text_repel(
    data = subset(GI_gene, id %in% gene_label),
    aes(label = id),
    size = 3.9,fontface = 'bold', color = 'brown1',
    box.padding = unit(0.35, "lines"),point.padding = unit(1.5, "lines"), segment.color = 'grey50') + 
  theme_bw()+ theme(aspect.ratio=1) + #_linedraw+
  theme(legend.key.size = unit(1, 'cm'), #change legend key size
        legend.key.height = unit(1, 'cm'), #change legend key height
        legend.key.width = unit(1, 'cm'), #change legend key width
        legend.title = element_text(size=15), #change legend title font size
        legend.text = element_text(size=15))
p1

p2<-ggplot(GI_gene, aes(x=exp_lfc, y=diff, colour=GI)) +
  geom_point(aes(colour=GI),alpha=.7)+
  geom_abline(intercept = 0, slope = 0, linetype = "dashed")+
  labs(x = "Expected paired-gene LFC", y= "LFC difference (observed - expected)") +#y= "Observed paired-gRNA phenotype")+
  xlim(-1.1, 0.2)+ylim(-0.7, 0.5)+
  scale_color_gradient2(midpoint=0, low="cyan", mid="black", high="yellow", space ="Lab", name="GI score")+
  geom_point(data = subset(GI_gene, id %in% gene_label), color = "firebrick1")+
  geom_text_repel(
    data = subset(GI_gene, id %in% gene_label),
    aes(label = id),
    size = 3.9,fontface = 'bold', color = 'firebrick1',
    box.padding = unit(0.35, "lines"),point.padding = unit(1.5, "lines"), segment.color = 'grey50') + 
  theme_bw()+ theme(aspect.ratio=1)+
  theme(legend.key.size = unit(1, 'cm'), #change legend key size
        legend.key.height = unit(1, 'cm'), #change legend key height
        legend.key.width = unit(1, 'cm'), #change legend key width
        legend.title = element_text(size=15), #change legend title font size
        legend.text = element_text(size=15))
p2

jpeg("./GI_visulization.jpeg",width=800,height=500)
grid.arrange(p1, p2, nrow = 1)
dev.off()  
