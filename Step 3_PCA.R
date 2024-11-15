##'@Step three: analysis of PCA
dir.create("02_Analysis/02_PCA")

sampleFile <- "./Results_Figuire/sampleFile"

exprData <- "01_mRNA_expression/02_mRNA_expression.24529.csv"
data <- read.csv(exprData,header = T)
data[1:5,1:6]

# data processing
rownames_data <- make.names(data[,1],unique=T)
data <- data[,-1,drop=F]
rownames(data) <- rownames_data
data <- data[rowSums(data)>0,]
# 
data <- data[apply(data, 1, var)!=0,]

data$mad <- apply(data, 1, mad) 

data <- data[data$mad>0, ]

data <- data[order(data$mad, decreasing=T), 1:(dim(data)[2]-1)]

dim(data)
##
mads <- apply(data, 1, mad)
data <- data[rev(order(mads)),]
dim(data)
data[1:5,1:5]
# Rows are samples and columns are variables
data_t <- t(data)
variableL <- ncol(data_t)
if(sampleFile != "") {
  sample <- read.table(sampleFile,header = T, row.names=1,sep="\t")
  data_t_m <- merge(data_t, sample, by=0)
  rownames(data_t_m) <- data_t_m$Row.names
  data_t <- data_t_m[,-1]
}

## PCA analysis, scale standardised data
pca <- prcomp(data_t[,1:variableL], scale=TRUE)
head(pca)

rotation = pca$rotation
head(rotation)

# PCA
library(factoextra)
## 1. Fragmentation charts show the contribution of each component
fviz_eig(pca, addlabels = TRUE)

#  2. PAC sample clustering information display
fviz_pca_ind(pca, repel=F)   
fviz_pca_ind(pca, col.ind=data_t$conditions, mean.point=F, 
             addEllipses = T, legend.title="Groups")
#'@PCA1 and PCA2
pca1 <- round(summary(pca)$importance[2, 1] * 100, 1)
pca1
pca2 <- round(summary(pca)$importance[2, 2] * 100, 1)
pca2
# Colouring and plotting 95% confidence intervals based on subgroups
p2 <- fviz_pca_ind(pca, col.ind=data_t$conditions, 
                   mean.point=F, addEllipses = T, 
                   legend.title= "", ellipse.type="confidence", ellipse.level=0.95,
                   title= NULL, label = "none")+## label="none"
  xlab(paste0("PC1 (", pca1, "%)"))+
  ylab(paste0("PC2 (", pca2, "%)"))+
  theme_bw()+
  theme(
    axis.text.x = element_text(size = 8),
    axis.text.y = element_text(size = 8),
    axis.title.x = element_text(size = 10),
    axis.title.y = element_text(size = 10),
    legend.text = element_text(size = 8),
    legend.position = "right"
  )

p2
ggsave("./02.PCA of mRNA.pdf", plot = p2,
       width = 4, height = 3, dpi = 300)
