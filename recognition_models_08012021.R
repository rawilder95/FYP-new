# Make sure libraries and packages are loaded
########################################################

# install.packages("lme4", type= "binary")
# defaultW <- getOption("warn")
# options(warn = -1)
library(lme4)
library(MuMIn)
# install.packages("data.table")
library("ggplot2")
library("data.table")
# install.packages("lmerTest")
library(lmerTest)


# Load Data & Set up Data Table
########################################################
dir <- getwd()
target_dir <- "/Users/rebeccawilder/FYP-new"
setwd(target_dir)
my_data <- read.csv(file= "recognition_mat_7212021.csv")
my_data <- data.table(my_data)
data_names <- c("subject", "session", "sp", "op", "list", "lag", "recognized")
colnames(my_data) <- data_names
my_data[,sp2:= sp^2]
my_data[, list2:= list^2]
my_data[, op2:= op^2]
my_data[, lag2:= lag^2]
my_data[, recog:= recognized==1]
my_data$recog[my_data$recog== "TRUE"] <- paste("YES")
my_data$recog[my_data$recog== "FALSE"] <- paste("NO")