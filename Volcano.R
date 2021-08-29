library(ggplot2)
maker$gene<-rownames(maker)

logFC <-maker$avg_logFC
adj <- maker$p_val_adj
gene<- aa$gene

data <- data.frame(logFC=logFC,padj=adj,gene=gene)
data$sig[(data$padj > 0.05|data$padj=="NA")|(data$logFC < 0.25)& data$logFC > -0.25] <- "no"
data$sig[data$padj <= 0.05 & data$logFC >= 0.25] <- "up"
data$sig[data$padj <= 0.05 & data$logFC <= -0.25] <- "down"
x_lim <- max(logFC,-logFC)
library(ggplot2)
library(ggrepel)
library(RColorBrewer)
theme_set(theme_bw())
data$gene<-as.character(data$gene)
data$label=ifelse(data$padj < 0.001 &(data$logFC >= 0.4 | data$logFC <= -0.4),data$gene,"")
p <- ggplot(data,aes(logFC,-1*log10(padj),
                     color = sig))+geom_point()+
  xlim(-1.5,1.5) +  labs(x="log2(FoldChange)",y="-log10(padj)")
p <- p + scale_color_manual(values =c("#0072B5","grey","#BC3C28"))
p <- p +theme(panel.grid =element_blank())+
  theme(axis.line = element_line(size=0))+ylim(0,400)
p <- p  +guides(colour = FALSE)
p<-p+geom_text_repel(data = data, aes(x = data$logFC, 
                                      y = -log10(data$padj), 
                                      label = label),
                     size = 3,box.padding = unit(0.5, "lines"),
                     point.padding = unit(0.8, "lines"), 
                     segment.color = "black", 
                     show.legend = FALSE)
p
