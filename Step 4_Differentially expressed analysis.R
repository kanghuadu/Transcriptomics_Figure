##'@Step four：Differrntially expressed analysis 
library(DESeq2)
library(ggplot2)
library(ggrepel)
library(pheatmap)


##'@read data
count_matrix <- read.csv("04_mRNA_count.24529.csv",header = T, 
                         row.names = 1)
count_matrix[1:5,1:6]

##'@Read sample classification information
sample_table <- read.csv("02.Sample_group.csv",header = T,row.names = 1)
sample_table
# Creating DESeq2 Objects
dds <- DESeqDataSetFromMatrix(countData = count_matrix,
                              colData = sample_table,
                              design = ~ Group)
dim(dds)
##'@Filter value
dds <- dds[rowSums(counts(dds)) > 1,]

res <- results(dds)
##'@results
res$type <- "not"
res$type[which((res$padj < 0.05) & (res$log2FoldChange > 1))] = "up"
res$type[which((res$padj < 0.05) & (res$log2FoldChange < -1))] = "down"
table(res$type)
##'filter NA
res <- na.omit(res)
res_diffsig <- res[(res$padj < 0.05) & abs(res$log2FoldChange) > 1,]
table(res_diffsig$type)
  
##'@添加差异基因数量统计
DEG_count <- nrow(res_diffsig)
up_count <- sum(res_diffsig$type == "up")
down_count <- sum(res_diffsig$type == "down")
result_df <- rbind(result_df, list(comparison, DEG_count, down_count,up_count))
  
##Calculate the number
count_summary <- table(res$type)
not_count <-count_summary["not"]
up_count <- count_summary["up"]
down_count <- count_summary["down"]
## 
legend_labels <- c(
    paste0("Dwon: ", down_count),
    paste0("Not: ", not_count),
    paste0("Up: ", up_count))
  
  ##'@Mapping of volcanoes
pdf(file.path("./Results_Figuire", paste0(comparison, '03. volcano.pdf')),
      width = 4, height = 3)
  ##赋值
diffsig <- res
  ##
Significant <-
    ifelse((diffsig$padj < 0.05 & abs(diffsig$log2FoldChange)> 1),
           ifelse(diffsig$log2FoldChange > 1,"Up","Down"), "Not")
  ##
p <- ggplot(diffsig, aes(log2FoldChange, -log10(padj))) +
    geom_point(aes(col = Significant)) +
    scale_color_manual(values = c("#0072B6", "grey", "#BC3C28"),
                       labels = legend_labels, # 使用自定义图例标签
                       name = NULL) +
    geom_vline(xintercept = c(-1, 1), colour = "black", linetype = "dashed") +
    geom_hline(yintercept = -log10(0.05), colour = "black", linetype = "dashed") +
    labs(x = expression(Log[2] ~ fold ~ change),
         y = expression(- ~ Log[10] ~ padj ~ value),
    theme_bw()+
    theme(plot.title = element_text(hjust = 0.5, size = 8.8))
  print(p)
  
dev.off()
  
  ##'@绘制差异基因热图
expr_data_normailzed <- counts(dds_subset, normalized = TRUE)
diffsig_genes <- rownames(res[res$type != "not",])
expr_data <- expr_data_normailzed[rownames(expr_data_normailzed) %in%
                                      diffsig_genes, ]
##'@绘制热图
pdf(file.path("./Results_Figuire", '04.heatmap.pdf',width = 4, height = 3)
p <- pheatmap(expr_data,
                color = colorRampPalette(c("#0072B6", "white", "#BC3C28"))(50),
                cluster_cols = T,
                show_rownames = F,
                show_colnames = T,
                scale = "row", ## none, row, column
                fontsize =10,
                fontsize_row = 6,
                fontsize_col = 6,
                border = FALSE,
                angle_col = 0)
dev.off()


vsd <- vst(dds_subset, blind=FALSE) # variance stabilization

quiescent = rownames(coldata)[coldata$phenotype=="WL"]
cycling = rownames(coldata)[coldata$phenotype=="YL"]
data_cts_mets_avg = data.frame("WL"=rowMeans(assay(vsd)[, quiescent],na.rm=T),
                               "YL"=rowMeans(assay(vsd)[, cycling],na.rm=T))


upCQ = res[!is.na(res$padj) & res$padj < 0.05 & res$log2FoldChange > 1,]
dwCQ = res[!is.na(res$padj) & res$padj < 0.05 & res$log2FoldChange < -1,]
dim(upCQ)
dim(dwCQ)

DESeq2::plotMA(resCQ,ylim=c(-3,3),main="Cycling vs Quiescent [liver metastasis]")

# 
pdf("./05.scatterplot.pdf", width=5, height=4)
plot(data_cts_mets_avg$WL, data_cts_mets_avg$YL, pch=20, 
     xlab="mRNA expression WL (Normalized counts)", 
     ylab="mRNA expression YL  (Normalized counts)",
     cex.lab=1.3,col=rgb(0.6,0.6,0.6,0.5));
abline(0,1,lty=2,col="black");
points(data_cts_mets_avg[rownames(upCQ),"WL"], 
       data_cts_mets_avg[rownames(upCQ),"YL"],pch=20,col=colors()[c(35)])

points(data_cts_mets_avg[rownames(dwCQ),"WL"], 
       data_cts_mets_avg[rownames(dwCQ),"YL"],pch=20,col=colors()[c(125)])
legend("topleft",legend=c("Up",
                          "Down"),
       col=colors()[c(35,125)],pch=20,inset=0.01,bty="n",cex=1.2)
dev.off()