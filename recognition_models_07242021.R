# Make sure libraries and packages are loaded
########################################################

# install.packages("lme4", type= "binary")
defaultW <- getOption("warn")
options(warn = -1)
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
data_names <- c("subject", "session", "sp", "op", "lag", "list", "recognized")
colnames(my_data) <- data_names
my_data[,sp2:= sp^2]
my_data[, list2:= list^2]
my_data[, op2:= op^2]
my_data[, lag2:= lag^2]
my_data[, recog:= recognized==1]
my_data$recog[my_data$recog== "TRUE"] <- paste("YES")
my_data$recog[my_data$recog== "FALSE"] <- paste("NO")

####### Final Recognition #############
# Model OP and List
f0list_op <- glmer(data= my_data, formula= recognized ~ op + op2+ list+ list2+ (1|subject), family= "binomial")
summary(f0list_op)
r.squaredGLMM(f0list_op)

# Plot OP and List
ggplot(data= my_data, aes(x= recog, y= fitted(f0list_op)))+ geom_jitter(height= 0, width= 0.4, alpha= 0.2, color= "hot pink")+ ylim(0,1)+ labs(title= "List, OP, & Quadratic Terms", subtitle= "Recognition==0", x=("Was it Recognized?"), y= "Fitted Values")

# Model Lag, OP, and List
f0list_op_lag <- glmer(data= my_data[recognized==0,], formula= recognized ~ op + op2+ list+ list2+ lag+lag2+ (1|subject), family= "binomial")

mod1 <- glmer(data= my_data, recognized~ list+ list2 + op+ op2+ lag+ lag2+ (1|subject), family= "binomial")

summary(f0list_op_lag)
r.squaredGLMM(f0list_op_lag)

# Plot OP and List
ggplot(data= my_data, aes(x= recog, y= fitted(mod1)))+ geom_jitter(height= 0, width= 0.4, alpha= 0.2, color= "pink")+ ylim(0,1)+ labs(title= "List, OP, Lag & Quadratic Terms", subtitle= "Recognition==0", x=("Was it Recognized?"), y= "Fitted Values")

