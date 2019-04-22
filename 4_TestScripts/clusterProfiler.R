#*****************************
http://127.0.0.1:22399/library/clusterProfiler/doc/clusterProfiler.html#reactome-pathway-analysis

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

if (!require("clusterProfiler"))BiocManager::install("clusterProfiler", version = "3.8")
if (!require("DOSE"))BiocManager::install("DOSE")
library(clusterProfiler)
#install.packages("purrr")
#install.packages("ggforce")
#remove.packages("clusterProfiler")
data(geneList, package="DOSE")

#*****************************
library(clusterProfiler)
#Genome wide annotation for Human
library(org.Hs.eg.db)
keytypes(org.Hs.eg.db)
data(geneList, package="DOSE")
names1<-names(geneList)

write.csv(geneList,"I:/2_EDU/UOC/TFM/TestData/geneList.csv")

gene <- names(geneList)[abs(geneList) > 2]

genes<-geneList[abs(geneList) > 2]
write.csv(genes,"E:/2_EDU/UOC/TFM/TestData/selectedGenes.csv")
geneList<-read.csv("E:/2_EDU/UOC/TFM/TestData/geneList.csv")
names2<-geneList$X
setdiff(names2,names1)
head(geneList)
str(geneList)


str(geneListv)
ego3 <- gseGO(geneList     = geneList,
              OrgDb        = org.Hs.eg.db,
              ont          = "CC",
              nPerm        = 1000,
              minGSSize    = 100,
              maxGSSize    = 500,
              pvalueCutoff = 0.05,
              verbose      = FALSE)
head(ego3)

gene.df <- clusterProfiler::bitr(gene, fromType = "ENTREZID",
                toType = c("ENSEMBL", "SYMBOL"),
                OrgDb = org.Hs.eg.db)

library("pathview")
hsa04110 <- pathview(gene.data  = geneList,
                     pathway.id = "hsa04110",
                     species    = "hsa",
                     limit      = list(gene=max(abs(geneList)), cpd=1))


head(gene.df)
#GO classification
head(geneList)
ggo <- groupGO(gene     = gene,
               OrgDb    = org.Hs.eg.db,
               ont      = "CC",
               level    = 3,
               readable = TRUE)

head(ggo)

#GO over-representation test
names(geneList)<-c("ID","FoldChange")
geneList$ID<-as.character(geneList$ID)
head(geneList)
ego <- enrichGO(gene          = gene,
                universe      = names(geneList),
                OrgDb         = org.Hs.eg.db,
                ont           = "CC",
                pAdjustMethod = "BH",
                pvalueCutoff  = 0.01,
                qvalueCutoff  = 0.05,
                readable      = TRUE)
ego@result%>%
  filter(p.adjust<0.2)%>%
  mutate(
    p.adjust = color_tile("green", "red")(formatC(p.adjust,format = "e",digits = 2))
  )%>%
  dplyr::select(everything())

ego <- enrichGO(gene          = gene,
                universe      = names(geneList),
                OrgDb         = org.Hs.eg.db,
                ont           = "CC",
                pAdjustMethod = "holm",
                pvalueCutoff  = 0.1,
                qvalueCutoff  = 0.05,
                readable      = TRUE)
head(ego)

ego2 <- enrichGO(gene         = gene.df$ENSEMBL,
                 OrgDb         = org.Hs.eg.db,
                 keyType       = 'ENSEMBL',
                 ont           = "CC",
                 pAdjustMethod = "BH",
                 pvalueCutoff  = 0.01,
                 qvalueCutoff  = 0.05)
head(ego2)

ego2 <- setReadable(ego2, OrgDb = org.Hs.eg.db)


ego3 <- gseGO(geneList     = geneList,
              OrgDb        = org.Hs.eg.db,
              ont          = "CC",
              nPerm        = 1000,
              minGSSize    = 100,
              maxGSSize    = 500,
              pvalueCutoff = 0.05,
              verbose      = FALSE)

ego3@result$ID
print(gseaplot(ego3, geneSetID = "GO:0031012"))

hum <- search_kegg_organism('Homo sapiens', by='scientific_name')
dim(hum)
head(hum)

kk <- enrichKEGG(gene         = gene,
                 organism     = 'hsa',
                 pvalueCutoff = 0.05)

head(kk)
trace("gseKEGG", edit=TRUE)
kk2 <- gseKEGG(geneList     = geneList,
               organism     = 'hsa',
               nPerm        = 1000,
               minGSSize    = 120,
               pvalueCutoff = 0.05,
               verbose      = FALSE)
head(kk2)

library("pathview")
hsa04110 <- pathview(gene.data  = geneList,
                     pathway.id = "hsa04110",
                     species    = "hsa",
                     limit      = list(gene=max(abs(geneList)), cpd=1),
                     kegg.dir="I:/2_EDU/UOC/TFM/TestFolder/")
kk@result$Description[kk@result$p.adjust<=0.1]
img<-readPNG("I:/2_EDU/UOC/TFM/TestFolder/hsa04110.pathview.png")
image(img)
png("I:/2_EDU/UOC/TFM/TestFolder/test.png")
par(mar=c(0,0,0,0), xpd=NA, mgp=c(0,0,0), oma=c(0,0,0,0), ann=F)
plot.new()
plot.window(0:1, 0:1)

#fill plot with image
usr<-par("usr")    
rasterImage(img, usr[1], usr[3], usr[2], usr[4])
dev.off()

pathview(gene.data = geneList, pathway.id = "hsa04110",
         species = "hsa", out.suffix = "hsa04110", kegg.native = F,
         kegg.dir="I:/2_EDU/UOC/TFM/TestFolder/")

trace("keggview.native", edit=TRUE)

keggview.native(gene.data  = geneList,
                 pathway.name = "hsa04110",
                 species    = "hsa",
                 limit      = list(gene=max(abs(geneList)), cpd=1),
                 kegg.dir="I:/2_EDU/UOC/TFM/TestFolder")


enreac<-enrichPathway(gene=gene,pvalueCutoff=0.05, readable=T)
str(enreac)
enreac@result$Description[2]<-"BLA"

print(barplot(enreac))
print(viewPathway(enreac@result$Description[3],readable=TRUE, foldChange=geneList))

names(enreac@result[,c(1:7,9,8)])
source("D:/UOC/TFM/TEST/keggview_native.R")
dir()
barplot(ggo, drop=TRUE, showCategory=12)
head(ggo)

barplot(ego, showCategory=8)

dotplot(ego)

dotplot(ego3)

emapplot(ego)

cnetplot(ego, categorySize="pvalue", foldChange=geneList)

goplot(ego)


gseaplot(kk2, geneSetID = "hsa04145")
browseKEGG(kk, 'hsa04110')
dir()
