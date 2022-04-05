library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

## Input
target<-c(...)  ## TODO: input the list of gene target

vbc<-read_excel(".../VBC_hg38_top6_sgRNAs.xlsx",sheet = "Sheet1")

tkov3<-read_excel(".../TKOV3_guide_sequence.xlsx",sheet = "TKOv3-Human-Library")

geckov2a<-read.table(".../hGECKOV2_library_A_09mar2015.csv",header = T,sep = ',')
geckov2b<-read.table(".../hGECKOV2_library_B_09mar2015.csv",header = T,sep = ',')
geckov2<-data.frame(rbind(geckov2a[,-4],geckov2b[,-4]))
geckov2<-geckov2[order(geckov2$gene_id),]

kinomea<-read_excel(".../KinomeKO.xlsx",sheet = "A")
kinomeb<-read_excel(".../KinomeKO.xlsx",sheet = "B")
kinome<-data.frame(rbind(kinomea,kinomeb))
kinome<-kinome[order(kinome$Target.Gene.ID),]


## Integration
gRNA<-data.frame(matrix(ncol = 8))
colnames(gRNA)<-c("Gene","gRNA_seq","Kinome","TKOv3","hGECKOv2","vbc_top6","intersect","vbc_scores")

for (i in 1:length(target)) {
  geckov2_1<-data.frame(geckov2[geckov2$gene_id==as.character(target[i]),])
  tkov3_1<-data.frame(tkov3[tkov3$GENE==as.character(target[i]),])
  kinome_1<-data.frame(kinome[kinome$Target.Gene.Symbol==as.character(target[i]),])
  vbc_1<-data.frame(vbc[vbc$gene==as.character(target[i]),])
  vbc_1$sequence<-str_sub(vbc_1$sgRNA, end=-4) ##remove PAM from vbc$sgRNA
  
  temp<-Reduce(union, list(kinome_1$sgRNA.Target.Sequence,tkov3_1$SEQUENCE,geckov2_1$seq,vbc_1$sequence))
  
  gRNA_temp<-data.frame(matrix(ncol = 8,nrow = length(temp))) ##gRNA infor for specific genes
  colnames(gRNA_temp)<-c("Gene","gRNA_seq","Kinome","TKOv3","hGECKOv2","vbc_top6","intersect","vbc_scores")
  gRNA_temp[,3:7]<-0
  
  gRNA_temp$Gene<-rep(as.character(target$Target[i]),length(temp))
  gRNA_temp$gRNA_seq<-temp
  
  for (j in 1:length(temp)) { ##j for each specific seq
    gRNA_temp$Kinome[j]<-sum(as.character(kinome_1$sgRNA.Target.Sequence)==temp[j])
    gRNA_temp$TKOv3[j]<-sum(as.character(tkov3_1$SEQUENCE)==temp[j])
    gRNA_temp$hGECKOv2[j]<-sum(as.character(geckov2_1$seq)==temp[j])
    gRNA_temp$vbc_top6[j]<-sum(as.character(vbc_1$sequence)==temp[j])
    
    if (sum(vbc_1$sequence==temp[j])){ ##seq is in the vbc
      #gRNA_temp$vbc_scores[j]= vbc_1$`VBC score`[min(which(vbc_1$sequence==temp[j]))]
      vbc_temp<-vbc_1[vbc_1$sequence==temp[j],]
      gRNA_temp$vbc_scores[j]=vbc_temp$VBC.score
    }  else   {next}
    
  }
  gRNA_temp$intersect=gRNA_temp$Kinome+gRNA_temp$TKOv3+gRNA_temp$hGECKOv2+gRNA_temp$vbc_top6
  
  gRNA<-rbind(gRNA,gRNA_temp)
}

gRNA<-gRNA[-1,]
gRNA$length<-nchar(gRNA$gRNA_seq)

#write.xlsx(gRNA, "C:/Users/tang53/Box Sync/1Lab/1LabProject/CDKO/prep/TargetSum.xlsx", sheetName="gRNA_seq_V2",  append=TRUE)