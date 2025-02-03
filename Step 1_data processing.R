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
#
# The genes retained to be expressed in at least 2 replicate samples, and the detailed parameters, please refer to “Materials and Methods”.
#
##'@Output results
write.csv(df_filtered, "./01_mRNA_expression/02_mRNA_expression.24529.csv")
