rm(list=ls())

# load libraries:
library(R.matlab)
library(nlme)
library(ggplot2)

# Set working directory, where the EEG data are:
fout = 'D:/Data/R/fieldtripWrapper/Data/'
setwd(fout)

#Dataframe-formated data: 
d2t <- 'Data4R.mat'

# Load .mat data and keep the relevant information:
matdata <- readMat(paste(fout, d2t, sep=""))
matdata = matdata$d4R
matdata = matdata[, ,1]

# parse all fields of our structure, using "$":
ERF <- matdata$data
Channels <- unlist(matdata$channels)
Time <- matdata$time
Condition <- matdata$condition
Condition[Condition == 1] <- "FIC"
Condition[Condition == 2] <- "FC"
Condition <- factor(Condition)

# combine everything in a time-frame:
EEG <- data.frame(ERF, Channels, Time, Condition) 

# prepare to plot:
ts <- 18
p <- ggplot(EEG, aes(Time, ERF,color = Condition), size = 2) +facet_wrap(~Channels)
p <- p+theme(axis.text= element_text(size=ts-2), axis.title = element_text(size = ts, face = "bold"), axis.line  = element_line(colour = "#636363", size = 1))
p <- p + stat_summary(fun.y = 'mean', geom = 'line', size = 0.75)+theme_minimal()
p <- p + theme(strip.text = element_text(size=ts), legend.text=element_text(size=14), legend.title=element_text(size=14))
p

ggsave(paste(fout,d2t,".png", sep=""), width = 14, height =13, dpi = 350)

