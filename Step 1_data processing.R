#'@one step: data processing

library(ggplot2)
library(dplyr)
library(tidyr)
library(readxl)
library(ggpubr)

###-----------------------------------------------------------------------------
##'@all annotated genes
df_raw <- read_excel("01_mRNA_expression/01.raw_mRNA_expression.xlsx",sheet = 1)
head(df_raw)
# Extracting data from columns 1,3,5,7,9,11,13
df_raw02 <- df_raw[,c(1,3,5,7,9,11,13)]
head(df_raw02)

# Rename columns
colnames(df_raw02) <- c("Gene","YL1","YL2","YL3","WL1","WL2","WL3")
head(df_raw02)

write.csv(df_raw02, "./01_mRNA_expression/00_all_mRNA_expression.csv", row.names = FALSE)

###'@Filtering values
df_raw03 <- read.csv("./01_mRNA_expression/00_all_mRNA_expression.csv",header = T, row.names = 1)
df_raw03[1:5,1:6]

threshold <- 0.5  
num_columns_per_treatment <- 3 
num_treatments <- ncol(df_raw03) / num_columns_per_treatment
treatment_indexes <- rep(1:num_treatments, each = num_columns_per_treatment)

# Check for genes with values greater than 0.5 in at least two replicates per treatment
filtered_genes <- apply(df_raw03[, -1], 1, function(row) {
  treatments <- split(row, treatment_indexes)

  any_above_threshold <- sapply(treatments, function(treatment) {
    num_above_threshold <- sum(treatment > threshold)
    num_above_threshold >= 2
  })

  return(any(any_above_threshold))
})

# 
# 
df_filtered <- df_raw03[filtered_genes, ]
dim(df_filtered)
df_filtered[1:5,1:6]

##'@Output results
write.csv(df_filtered, "./01_mRNA_expression/02_mRNA_expression.24529.csv")