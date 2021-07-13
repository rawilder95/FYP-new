dir <- getwd()
target_dir <- "/Users/rebeccawilder/First-Year-Project"
setwd(target_dir)

my_data <- read.csv(file= "R_data_02072021.csv")
my_data <- data.frame(my_data)

my_data
data_names <- c("subject", "session", "list", "rec_itemnos", "rt", "sp", "op", "lag", "ffr")
colnames(my_data) <- data_names


rt= my_data$rt
op= my_data$op
ffr= my_data$ffr
sp= my_data$sp

library(data.table)
unique(lag)

sp <- sp[1:length(rt)]

op<- op[1:length(rt)]
rtc <- rt[ffr==TRUE]
spc <- sp[ffr==TRUE]
opc <- op[ffr==TRUE]

lag= my_data$lag
lagc= lag= lag[ffr== TRUE]
ffr_output= op[ffr==TRUE]
#plot hist for rt
hist(rt,breaks = 100,probability = TRUE, main= "Histogram of Response Times")

hist(rtc, breaks= 100, probability= TRUE, main= "IFR Response Times that were FFR",)


hist(sp, breaks= 100, probability= TRUE, density= 40, main= "IFR Serial Positions for Items that were FFR")

hist(op, breaks= 100, probability= TRUE, density= 45, main = "Out Positions of IFR items that Were FFR", xlab= "IFR Output Position")

hist(lag, breaks= 100, probability = TRUE, density= 1, main= "N Intervening Items Between Initial" )


library("ggplot2")
ggplot()+
geom_histogram(aes(x= rtc, y=..count../sum(..count..)), bins= 100)+
labs(title= "Response Times", subtitle= "Reflecting IFR data points that were FFR", x= "Response Times", y= "Density")



ggplot()+
geom_histogram(aes(x= spc, y=..count../sum(..count..)), binwidth= 1, color= blue)+
labs(title= "Serial Position", subtitle= "Reflecting IFR data points that were FFR", x= "Serial Positions", y= "Density")


ggplot()+
geom_histogram(aes(x= opc, y=..count../sum(..count..)), binwidth= 1)+
labs(title= "Output Positions", subtitle= "Reflecting IFR data points that were FFR", x= "Output Position", y= "Density")


ggplot()+
geom_histogram(aes(x= opc, y=..count../sum(..count..)), bins= 40)+
labs(title= "Response Times", subtitle= "Reflecting IFR data points that were FFR", x= "Response Times", y= "Density")

ggplot()+
geom_histogram(aes(x= lag), color= "blue", binwidth= 1)

             
