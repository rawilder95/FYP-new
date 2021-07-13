defaultW <- getOption("warn")
options(warn = -1)
library(lme4)
library("ggplot2")
library("data.table")
# install.packages("lmerTest")
library(lmerTest)
dir <- getwd()
target_dir <- "/Users/rebeccawilder/First-Year-Project"
setwd(target_dir)
my_data <- read.csv(file= "newdata.csv")
my_data <- data.table(my_data)
data_names <- c("subject", "session", "list", "rec_itemnos", "rt", "sp", "op", "lag", "ffr")
colnames(my_data) <- data_names
nsubj <- unique(my_data$subject)
nses <- unique(my_data$session)
my_data[,rt_centered:= scale(rt, scale=TRUE)]
my_data[,recalled:= ffr==1]
my_data$recalled[my_data$recalled== "TRUE"] <- paste("YES")
my_data$recalled[my_data$recalled== "FALSE"] <- paste("NO")

# Models
mod1 <- glmer(formula= ffr ~ rt_centered+ op + lag + list+ (1|subject), data=my_data, family= "binomial")
mod2 <- glmer(formula= ffr ~ rt_centered+ op + list+ (1|subject), data=my_data, family= "binomial")
mod3 <- glmer(formula= ffr ~ rt_centered+ lag + list+ (1|subject), data=my_data, family= "binomial")


this_idx <- data.table()
this_idx[, ypred:= seq(0, length.out= length(nsubj))]
this_idx[, npred:= seq(0, length.out= length(nsubj))]
this_idx[, youtcome:= seq(0, length.out= length(nsubj))]
this_idx[, noutcome := seq(0, length.out= length(nsubj))]

for (i in 1:length(nsubj)){
  this_idx$youtcome[i] <- length(my_data[subject== nsubj[i] & recalled == "YES"]$subject)
  this_idx$ypred[i] <- length(my_data[subject == nsubj[i] & f1vals> 0.5]$subject)
  this_idx$noutcome[i] <- length(my_data[subject== nsubj[i] & recalled == "NO"]$subject)
  this_idx$npred[i] <- length(my_data[subject == nsubj[i] & f1vals> 0.5]$subject)
}
