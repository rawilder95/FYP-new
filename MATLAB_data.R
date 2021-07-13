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

op<- op[1:length(rt)]

lag= my_data$lag
ffr_output= op[ffr==TRUE]
#plot hist for rt
hist(rt,breaks = 100,probability = TRUE, main= "Histogram of Response Times")



#plot hist for lag
hist(lag, breaks= 100, probability= TRUE, xlab= "N Intervening Items", main= "Intervening Items Between Presentation and IFR")

#plot hist for 'was it ffr?'
ffr_hist= hist(ffr_output, density= 20, breaks= 100, probability= TRUE, main= "IFR Output Positions That Were FFR", xlab= "Output")




#I've been trying to figure out how to do a frequency dist line over the histogram, but I gave up after spending too much time on it. 
xfit= seq(min(ffr_output), max(ffr_output))
yfit= dnorm(xfit, mean= mean(ffr_output), sd= sd(ffr_output))

#yfit <- yfit *diff(ffr_hist$mids[1:2]*length(ffr_output))
lines(xfit, yfit, col= "blue")







             
