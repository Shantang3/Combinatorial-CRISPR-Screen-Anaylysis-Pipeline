# Combinatorial CRISPR Screen Anaylysis Pipeline
This pipeline is desinged for data analysis and visulization for the STAR Protocols of "Fast and Efficient Generation of Paired-gRNA Library Facilitates Combinatorial CRISPR Screen for Discovering Synthetic Lethal Gene Pairs".

Note that the sampler data set is relatively small, containing only 10 genes (4 gRNAs/gene) and 10 safe-gRNAs, which yields to a dual-gRNA library with 2,500 different gRNA-gRNA constructs. 

## 1. Dual-crispr: Mapping and counting for gRNA-gRNA construction
A detailed demonstration of how to install and run Dual-cripsr can be found at: 
https://github.com/ucsd-ccbb/mali-dual-crispr-pipeline 

Note: the configure and library reference files for mapping (part of dual-crispr input) are provided under ./data folder

## 2.Quality control:
Mainly focus on the statistics of sequecing, count distribution and sample correlation.
Please refer to QC folder.

## 3. LogFC and Genetic Interaction (GI) calculation 
The LFC of specified gene-gene pair is calculated by MAGeCK RRA (https://sourceforge.net/p/mageck/wiki/Home/).

The GI value is calulated as the LFC deviation between observed and expected gene-gene pairs divided by the standard deviation of the individual genes’ LFCs.

## 4. Visualization
