####'@two step:correlation analysis of sample
library(reshape2)
library(corrplot)
library(plyr)
library(igraph)
library(autoReg)
library(tidyverse)
library(ggsci)

df_fpkm <- read.csv("./01_mRNA_expression/02_mRNA_expression.24529.csv",
                    row.names = 1, check.names = F)
# Extract Value Column
numeric_df <- df_fpkm[sapply(df_fpkm, is.numeric)]
numeric_df[1:5,1:6]
#
corr <- cor(numeric_df, method = "pearson",use = "pairwise.complete.obs")

##'@heat map of correlation

pdf("./Results_Figuire/01.heatmap of correlation.pdf", width = 4, height = 3)
p <- pheatmap(corr, 
              cluster_cols = T,
              cluster_rows = T,
              ##'@聚类树高度
              clustering_distance_rows = "euclidean",
              clustering_distance_cols = "euclidean",
              #color = mycol,
              legend_breaks = seq(-1,1,by = 0.1),
              border_color = "white",
              color = colorRampPalette(colors = c("#1f78b4", "white", "#e31a1c"))(100),
              angle_col = 45,
              display_numbers = TRUE,         # 显示数值
              number_color = "black",         # 数值颜色
              fontsize_number = 8             # 数值字体大小
)

p
dev.off()