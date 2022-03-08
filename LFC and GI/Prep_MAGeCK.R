## This file produces the count table that is used as input if MAGeCK RRA
##Input: raw_count from dual-crispr, library files

library(devtools)
raw_count <- read.table("https://raw.githubusercontent.com/Shantang3/Combinatorial-CRISPR-Screen-Anaylysis-Pipeline/main/data/Demo_raw_count.txt", header = T)
lib_file <- read.table("https://raw.githubusercontent.com/Shantang3/Combinatorial-CRISPR-Screen-Anaylysis-Pipeline/main/data/Demo_lib_file.txt", header = T)

raw_count<-merge(lib_file[c(1,2,3,5,6)], raw_count, by="construct_id")
nn_sample<-ncol(raw_count)-5
sample_name<-colnames(raw_count)[6:ncol(raw_count)]

mageck_count<-data.frame(raw_count)
## Add "Gene" attribute
mageck_count$Gene<-0
for (i in 1:nrow(mageck_count)) {
  tmp<- str_sort(c(mageck_count$target_a_id[i], mageck_count$target_b_id[i]), numeric = TRUE)
  mageck_count$Gene[i]<-paste0(tmp[1],"__",tmp[2])
}

colnames(mageck_count)[1]<-"sgRNA"
mageck_count<-mageck_count[,c("sgRNA","Gene",sample_name)] %>% 
  write.table("./Demo_MAGeCK_count_input.txt", 
            row.names = F, sep = "\t", quote = F)