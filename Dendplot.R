library(gdata)
library(reshape2)
library(Matrix)
library(readr)
library(tidyr)
library(dplyr)
library(magrittr)
library(ggplot2)
library(ggdendro)
library(grid)
library(dendextend)
library(tidyverse)
library(RColorBrewer)

ave<-read.csv("mean.csv",row.names = 1)
ave<-as.data.frame(t(ave))
ZCA<-ave
wilcox<-read.csv("ZCA_marker.csv",row.names = 1)
wilcox<-wilcox[1:100,]
gene<-as.character(wilcox$X1_n)
for(i in 1:55){
  name<-paste("X",i,sep = "")
  name<-paste(name,"n",sep = "_")
  gene1<-as.character(wilcox[,name])
  gene<-union(gene,gene1)
}
gene<-gsub(gene,replacement = "\\.",pattern = "\\-")
usegene<-gene
ZCA<-ZCA[usegene,]
ZCA<-na.omit(ZCA)
corZCA<-cor(ZCA,method = "spearman")

total_dup1<-corZCA
total.dist<-as.dist(1-total_dup1)
total.tree<-hclust(total.dist,method="ward.D")
plot(total.tree)
total.tree<-as.dendrogram(total.tree)

dend<-total.tree %>%
  set("leaves_pch",15)%>% 
  set("branches_lwd",1)%>%
  set("labels_cex",0.5)

dend1<- color_branches(dend,k=8)
use<-order.dendrogram(total.tree)


