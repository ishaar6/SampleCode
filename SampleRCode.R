install.packages("tidyverse")
library("tidyverse")
install.packages("readxl")
library("readxl")
install.packages("dplyr")
library("dplyr")

#sample code to determine the frequency of various X chromosome regions in CN-LOH 
data_1 <- read_xlsx("cn_wgd_all_code4.xlsx")

# filter for CN-LOH and X chromosomes only
data_LOH <-filter(data_1, segment_cn == "Copy_neutral_LOH", chromosome == "X")

#select only relevant chromosme data for the x chromosome 
data_LOH2 <- select(data_LOH, chromosome, start, end)

#group by the start location of chromosome and end location of chromosome to find significant regions. 
#This step is flawed though because other regions exhibit overlap as well.
data_LOHsum <- data_LOH2 %>% group_by (start, end) %>% summarize(Freq = n())

#I just picked 10 as a random value for significance here just as an example. 
data_LOHfinal <- data_LOHsum %>% filter(Freq > 10)

#I add here another row to make the table I can use to create a bargraph to accurately depict findings. 
data_barplot <- data_LOHfinal %>% mutate( x_axis= str_c(start, end, sep="-"))

#Add relevant title and x and y axis labels.
final_plot <- ggplot(data = data_barplot, aes(x_axis, Freq)) + geom_bar(stat= "identity", fill="lightblue")+
labs(title= "Frequency of CNLOH regions in X Chromosome From TCGA Data") + xlab("Base Pair Range in X Chromosome") + ylab("Frequency of Significant Region")

final_plot

##I tried to provide here most of the things that would probably be done with surveys with data manipulation
##as most of my previous work was using R in the preliminary stages for data cleaning 
##and using other software like bedtools, gistic, etc. to actually perform genomic analysis (since the overlaying of data gets complicated). 

