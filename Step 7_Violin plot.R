##'@Violin plot base ggplot2
##'
##'@Load R package
library(ggplot2)
library(reshape2)

# Input teh data 
data1<-read.table("violin.xls",header=T)
head(data1)

df <- melt(data1,id.vars = "ID",
           variable.name = "Sample",
           value.name = "Expressions")
#
head(df,10)

#Draw basic plots
p1<-ggplot(df,aes(x=Sample,y=Expressions,fill=Sample))+
  geom_violin(aes(colour=Sample),
              width= 0.8,
              alpha=0.7,show.legend =F)
p1

#Add a box plot
p2<-p1+geom_boxplot(width= 0.1,
                    outlier.alpha=0,
                    show.legend =F)
p2
#Customize color scheme
mycolor <- c("#FF9999","#99CC00","#FF9900","#FF99CC","#99CC00","#c77cff")
p3 <- p2+scale_fill_manual(values=alpha(mycolor,0.9))+
  scale_color_manual(values=alpha(mycolor,0.9))
p3

#Customize plot theme
mytheme<-theme_classic()+
  theme(panel.grid.major= element_line(color = "white"),
        panel.grid.minor =element_line(color= "white"),
        legend.title = element_blank())

#
p3+mytheme
