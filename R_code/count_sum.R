### input: output of dual_crispr that includes construction and sample names
    #### attention: the input of total_reads comes from fastqc report
### output: summary table including sample names and corresponding zerocounts, zerocounts%, mapped reads, mapping ratio, GiniIndex, counts_above, counts_above%

count_sum<-function(raw_ct, total_reads, count_threshold, ...){
  library(ineq)
  library(tibble)
  sample_name<-colnames(raw_ct)[-1]
  
  out_sum<-data.frame(matrix(ncol = 1, nrow = length(sample_name),dimnames=list(NULL, c("sample"))))
  #colnames(out_ct)<-c("sample", "zerocounts", "zerocounts%", "GiniIndex", paste0("counts_above", count_threshold), paste0("counts_above", count_threshold,"%"))
  
  out_sum$sample<-sample_name
  out_sum <- out_sum %>% 
    mutate(
      reads = total_reads,
      mapped= as.numeric(sapply(raw_ct[,-1], sum)),
      `mapped%` = as.numeric(sapply(raw_ct[,-1], sum))/total_reads *100, 
      zero_counts = as.numeric(colSums(raw_ct[,-1]==0)),
      `zero_counts%` = as.numeric(colSums(raw_ct[,-1]==0))/nrow(raw_ct) * 100,
      Gini_Index = as.numeric(sapply(raw_ct[,-1], Gini)),
      above_threshold = as.numeric(colSums(raw_ct[,-1]>=count_threshold)),
      `above_threshold%` = as.numeric(colSums(raw_ct[,-1]>=count_threshold)) / nrow(raw_ct) * 100
    )

}