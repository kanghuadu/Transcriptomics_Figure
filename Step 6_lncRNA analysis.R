##'@Step 6: lncRNA analysis
library(ggVennDiagram)
library(ggplot2)

df01 <- read.table("02_lncRNA_sfotware_out/01.CPC.out.txt",header = F,sep = "\t")$V1
df02 <- read.table("02_lncRNA_sfotware_out/02.CNCI.out.txt",header = F,sep = "\t")$V1
df03 <- read.table("02_lncRNA_sfotware_out/03.LGC.out.txt",header = F,sep = "\t")$V1
df04 <- read.table("02_lncRNA_sfotware_out/04.pfam.txt",header = F,sep = "\t")$V1
df05 <- read.table("02_lncRNA_sfotware_out/05.orfpredictor.out.txt",header = F,sep = "\t")$V1
df06 <- read.table("02_lncRNA_sfotware_out/06.Swissprot.out.txt",header = F,sep = "\t")$V1
# 合并到一个list中，用于绘制Venn图
gene_all <- list("CPC2" = df01, 
                 "CNCI" = df02, 
                 "LGC" = df03, 
                 "Pfam" = df04, 
                 "OrfPredictor" = df05, 
                 "Swissprot" = df06)

ggVennDiagram(gene_all, edge_size = 0.5, 
              label = "count",
              label_alpha = 0)+
  scale_fill_distiller(palette = "Paired",direction = 1)+
  #scale_fill_distiller(palette = "RdBu")+
  theme(legend.position = "none")

##'@保存
ggsave("./08.lncRNA VennPlot.pdf", width = 6, height = 6, dpi = 300)

##'
library(writexl)

## Calculate the intersection
gene_common <- Reduce(intersect, gene_all)

## Calculation of genes specific to each group
# unique_gene <- lapply(gene_all, function(x) setdiff(x, gene_common))

unique_genes <- lapply(names(gene_all), function(name) {
  setdiff(gene_all[[name]], unlist(gene_all[names(gene_all) != name]))
})
# Create a data frame for saving the results
output_list <- c(list("Common_Genes" = data.frame(Gene = gene_common)), 
                 setNames(unique_genes, names(gene_all)))
# 
output_list <- lapply(output_list, as.data.frame)
##'@Save results
write_xlsx(output_list, "./02.lncRNA_VennPlot.xlsx")

##------------------------------------------------------------------------------

## the lncRNA PCA analysis, correlation analysis, KEGG and GO enrichment histograms were 
## performed using the same code
