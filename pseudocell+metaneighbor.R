source("pseudocell_pipeline.R")
Pseudocell_analysis_pipeline(data,pheno,pseudocell_size = 20)
data1<-readRDS("OUT_pseudocell_20_.Rds")
data1<-as.data.frame(data1)
human<-data1
human_copy<-human
colnames(human_copy)<-gsub("Pseudocell","Copy",colnames(human_copy))
data1<-cbind(human,human_copy)
P1<-read.csv("OUT_pseudocell_20_.pheno.csv")
P1copy<-P1
P1copy$Study_ID<-"Copy"
P1copy$Sample_ID<-gsub("Pseudocell","Copy",P1copy$Sample_ID)
P1copy$Celltype<-gsub("Pseudocell","Copy",P1copy$Celltype)
P1<-rbind(P1,P1copy)
source("runMN.R")
library(gplots)
library(RColorBrewer)
library(pheatmap)
celltypes1 <-unique(as.character(P1$Celltype))
var.genes1=get_variable_genes(data1,P1)
length(var.genes1)
celltype.NV=run_MetaNeighbor_US(var.genes1,data1,celltypes1,P1)
write.table(celltype.NV,file="celltype.NV_SRS_75.out",sep="\t",quote=F)
pheatmap(celltype.NV)











