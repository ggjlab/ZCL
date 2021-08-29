library(circlize)
library(dplyr)
library(gdata)
library(RColorBrewer)

color_species = structure(c("#2E8B57", "#FF4500"), names = c("Specie1","Specie2"))
DF<-read.table("top_hits_SRS_75.out",sep="\t",head=T)
all_regions = unique(c(as.character(DF$Cluster1), as.character(DF$Cluster2)))
color.list<-read.table("color.list",head=T,sep="=")
rownames(color.list)<-color.list$name
color.list<-color.list[as.character(all_regions),]
color_regions = structure(as.character(color.list$color), names = as.character(all_regions))
df2 = data.frame(from=paste(DF$Species1,DF$Cluster1,sep="|"),to=paste(DF$Species2,DF$Cluster2,sep="|"),value=DF$Mean_AUROC)
combined = unique(data.frame(regions = c(as.character(DF$Cluster1), as.character(DF$Cluster2)), 
    species = c(as.character(DF$Species1), as.character(DF$Species2)), stringsAsFactors = FALSE))
combined = combined[order(combined$species, combined$regions), ]
order = paste(combined$species, combined$regions, sep = "|")
grid.col = structure(color_regions[combined$regions], names = order)
gap = rep(1, length(order))
gap[which(!duplicated(combined$species, fromLast = TRUE))] = 5

pdf("HM-circos-new_Cluster.pdf")
circos.par(gap.degree = gap,start.degree=270)
chordDiagram(df2, order = order, 
	annotationTrack = c("grid"),
    grid.col = grid.col, directional = FALSE,
    preAllocateTracks = list(
        track.height = 0.04,
        track.margin = c(0.05, 0)
    )
)
for(species in unique(combined$species)) {
    l = combined$species == species
    sn = paste(combined$species[l], combined$regions[l], sep = "|")
    highlight.sector(sn, track.index = 1, col = color_species[species], 
        niceFacing = TRUE)
}
circos.clear()

legend("bottomleft", pch = 15, col = color_regions, 
    legend = names(color_regions), cex = 0.3)
legend("bottomright", pch = 15, col = color_species, 
    legend = names(color_species), cex = 0.6)


dev.off()
