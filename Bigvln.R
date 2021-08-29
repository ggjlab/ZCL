library(reshape2)
library(ggplot2)
varnames<-c("gene1","gene2","gene3")
seuratobject$Cluster<-seuratobject@active.ident
data.use <- data.frame(FetchData(object = seuratobject, vars = c(varnames,"Cluster")))
colnames(data.use)[length(varnames)+1]<-"Cluster"
x<-data.frame(data.use,cell_id=rownames(data.use))
x<-melt(x,id=c("cell_id","Cluster"),variable.name = "gene",value.name = "expression")
mytheme<-theme_bw()+theme(
  plot.title = element_text(size = 15, face = "bold"),axis.text.y=element_blank(), 
  axis.ticks.y=element_blank(),
  strip.text.y = element_text(angle =180,size = 10,face = "bold"),strip.background = element_blank(),
  panel.spacing = unit(0, "lines"),
  plot.margin=unit(rep(0.5,4), 'lines'),
  panel.border=element_rect(fill='transparent', color='black'),
  axis.title=element_blank()
)

plot<- ggplot( data = x, mapping = aes( x = Cluster,y = expression)) +
  geom_violin(position = position_dodge(0.2), scale = "width", adjust = 1,trim = T,mapping = aes(fill = Cluster)) +
  mytheme+guides(fill=FALSE)
plot<-plot+facet_grid(gene~.,switch = "y",scales ="free_y",as.table=F)
plot

# Bar Plot----> Mean expression
Dev<-c("Tissue1","Tissue2","Tissue3")
mean_expression<-c(1:7)
Sample_sum<-data.frame(Dev,mean_expression)
rownames(Sample_sum)<-Sample_sum$Dev
for (j in varnames) {
  for (i in c(1:7)) {
    Sample_sum[i,j]<-sum(x$expression[x$Sample==Dev[i]&x$gene==j])/length(x$expression[x$Sample==Dev[i]&x$gene==j])
  }
}

Sample_sum<-Sample_sum[,-2]

Sample_sum<-melt(Sample_sum,id=c("Dev"),variable.name = "Gene",value.name = "Mean_exp")
Sample_sum$Dev<-factor(Sample_sum$Dev,levels = Dev)

ggplot(data = Sample_sum,aes(x=Dev,y=Mean_exp,fill=Dev))+
  geom_bar(stat = "identity")+mytheme+guides(fill=FALSE)+facet_grid(Gene~.,switch = "y",scales ="free_x",as.table=F)


