library(dplyr)
library(Seurat)
#######loaddata#########
load("seurat_object_merged_Singlet_used.rdata")
seuratobject<-use_data
seuratobject <- ScaleData(object = seuratobject, verbose = FALSE)
seuratobject <- RunPCA(object = seuratobject, npcs = 50, verbose = FALSE)
ElbowPlot(object = seuratobject,ndims = 50)#1:20
#######tsneplot#########
seuratobject <- RunTSNE(object =seuratobject, reduction = "pca", dims= 1:25,
                nthreads = 4, reduction.name = "FItSNE", reduction.key = "FItSNE_", fast_tsne_path = "/home/ggj/Documents/tools/fit-tsne/FIt-SNE-master/bin/fast_tsne", 
                max_iter = 2000)
DimPlot(object = seuratobject, reduction = "FItSNE", no.legend = FALSE,label  = T ,
        do.return = TRUE,  pt.size = 0.5)
seuratobject <- RunUMAP(object = seuratobject, reduction = "pca", 
                               dims = 1:20)
DimPlot(object = seuratobject, reduction = "umap", label = T,pt.size = 0.5)
save(seuratobject,file = "combinedmerge.RData")
library(dplyr)
combined.markers <- FindAllMarkers(object =seuratobject, only.pos = TRUE, min.pct = 0.1, 
                               thresh.use = 0.1)
save(seuratobject,combined.markers,file = "epimerge.RData")
WriteXLS::WriteXLS(aa, "lib2-lib4diff.xlsx",row.names=T)
exp<-AverageExpression(seuratobject)
WriteXLS::WriteXLS(exp, "epi-avg.xlsx",row.names=T)
#######barplot#########
library(ggplot2)
barplotdata<-data.frame(Idents(seuratobject),seuratobject$Batch)
colnames(barplotdata)<-c("cluster","batch")
cluster1<-barplotdata[barplotdata$cluster==1,]
table(cluster1$batch)
clustername<-data.frame(table(cluster1$cluster))
batchname<-data.frame(table(cluster1$batch))
clusternum<-nrow(data.frame(table(barplotdata$cluster)))
batch<-data.frame(matrix(nrow = nrow(batchname),ncol = 0),row.names = batchname$Var1)
for (i in 1: clusternum ) 
{
  temp<-barplotdata[barplotdata$cluster==i,]
  batch0<-data.frame(table(temp$batch))
  batch<-cbind(batch,batch0[,2])
}
colnames(batch)<-paste0("cluster_",1:clusternum)
library(ggplot2)
ggplot(barplotdata,aes(x=cluster))+geom_bar(aes(fill=factor(batch)),position = "stack")+geom_text(vjust=0.5)
ggplot(barplotdata,aes(x=cluster))+geom_bar(aes(fill=factor(batch)),position = "dodge")
ggplot(barplotdata,aes(x=cluster))+geom_bar(aes(fill=factor(batch)),position = "fill")+theme_classic()