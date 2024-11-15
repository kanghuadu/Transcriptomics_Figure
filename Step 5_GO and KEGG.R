##'@GO and KEGG enrichment analysis

data <- read_excel("02_GO_reults.xlsx",sheet = 1)

data[1:5,1:6]
category_colors <- c("Biological Process" = "#66c2a5", "Molecular Function" = "#fc8d62", 
                     "Cellular Component" = "#8da0cb")

ggplot(data, aes(x = Count, y = reorder(Term, Count), fill = Category)) +
  geom_bar(stat = "identity", color = "black",width = 0.8, size = 0.1) +
  scale_fill_manual(values = category_colors) +
  facet_grid(Category ~ ., scales = "free_y", 
             space = "free_y", switch = "y") +  # switch 'y' to move category labels to left
  theme_classic2()+
  labs(x = "Number of Genes", y = "", title = "") +
  theme(
    strip.text.y.left = element_text(angle = 90, hjust = 0, face = "bold"),  # Move labels to the left without borders
    strip.placement = "outside",   # Place strip labels outside the plot area
    strip.background = element_blank(),  # Remove the strip background
    panel.spacing.y = unit(0.0, "lines"), ## 修改每个图之间的间距
    legend.position = "none",
    axis.text.x = element_text(angle = 0, hjust = 1,  colour = "black", size = 10),
    axis.text.y = element_text(colour = "black", size = 10)
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  geom_text(aes(label = Count), hjust = -0.2, size = 3.5) # Display count on bars

ggsave("06.GO bar plot.pdf", width = 8, height = 8)

##'@绘制KEGG气泡图
data2 <- read_excel("02_KEGG_reults.xlsx",sheet = 2)
head(data2)
data2$Pathway <- factor(data2$Pathway, levels = rev(data2$Pathway))

data2$Pvalue <- as.numeric(as.character(data2$Pvalue))
data2$logP <- -log10(data2$Pvalue)
#绘图
ggplot(data2, aes(x = Ridio, y = Pathway, 
                  size = Count, fill = logP)) +
  geom_point(alpha = 0.8, shape = 21,color = "black") +
  scale_fill_gradient(low = "#3793DE", high = "#D15047") + 
  scale_size_continuous(range = c(3, 9)) +
  theme_bw() +
  labs(x = "Rich Factor", y = "", fill = "-log10(Pvalue)") +
  theme(
    axis.text.x = element_text(colour = "black", size = 10),
    axis.text.y = element_text(colour = "black", size = 10)
  ) 

ggsave("07.KEGG Bubble plot.pdf", width = 8, height = 6)

