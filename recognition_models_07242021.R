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

####### Final Recognition #############
# Model OP and List
list_op <- glmer(data= my_data, formula= recognized ~ op + op2+ list+ list2+ (1|subject)+ (1|session), family= "binomial")

summary(list_op)
r.squaredGLMM(list_op)
my_data[, flist_op:= fitted(list_op)]






# Plot OP and List
ggplot(data= my_data, aes(x= recog, y= flist_op))+ geom_jitter(height= 0, width= 0.4, alpha= 0.2, color= "hot pink")+ ylim(0.5, 1)+ labs(title= "List, OP, & Quadratic Terms", x=("Was it Recognized?"), y= "Fitted Values")+ geom_violin(alpha= 0.5, draw_quantiles = mean(my_data$flist_op), trim= TRUE)
 ggsave("recog_list_op", device= "png", dpi= 300)


# Model List, OP, Lag 
list_op_lag <- glmer(data= my_data, formula= recognized ~ op + op2+ list+ list2+ lag+lag2+ (1|subject), family= "binomial")

my_data[, flist_op_lag:= fitted(list_op_lag)]



summary(list_op_lag)
r.squaredGLMM(list_op_lag)

# Plot List, OP, Lag
ggplot(data= my_data, aes(x= recog, y=flist_op_lag))+ geom_jitter(height= 0, width= 0.4, alpha= 0.2, color= "pink")+ labs(title= "List, OP, Lag & Quadratic Terms", x=("Was it Recognized?"), y= "Fitted Values")+ geom_violin(alpha= 0.5, draw_quantiles = mean(my_data$flist_op_lag), trim= TRUE)
 ggsave("recog_list_op_lag", device= "png", dpi= 300)



#Model List and Lag
list_lag <- glmer(data= my_data, recognized~ list+ list2+ lag+lag2 + (1|subject), family= "binomial")


summary(list_lag)
r.squaredGLMM(list_lag)

my_data[, flist_lag:= fitted(list_lag)]

#Plot List and Lag
ggplot(data= my_data, aes(x= recog, y= flist_lag))+ geom_jitter(alpha= 0.2, height= 0, width= 0.4, color= "sky blue")+ geom_violin(alpha= 0.5, draw_quantiles = mean(my_data$flist_lag), trim= TRUE)+ labs(title= "List, Lag, & Quadratic Terms", x= "Was it Recognized?", y= "Fitted Values")
 ggsave("recog_list_lag", device= "png", dpi= 300)

#Model List, OP, and SP
list_sp_op <- glmer(data= my_data, recognized~ list+list2+ sp+sp2+ op+ op2+ (1|subject), family= "binomial")

summary(list_sp_op)
r.squaredGLMM(list_sp_op)

my_data[, flist_sp_op:= fitted(list_sp_op)]



#Plot List, OP, and SP 
ggplot(data= my_data, aes(x= recog, y= flist_sp_op))+ geom_jitter(alpha= 0.2, height= 0, width= 0.4, color= "navy")+ geom_violin(alpha= 0.5, draw_quantiles = mean(my_data$flist_sp_op), trim= TRUE) + labs(title= "List, SP, OP, and Quadratic Terms", x= "What it Recognized?", y= "Fitted Values")
 ggsave("recog_list_op_sp", device= "png", dpi= 300)

# Model List, SP, and Lag
list_sp_lag <- glmer(data= my_data, recognized~ list+ list2+ sp+ sp2+ lag+ lag2+ (1|subject), family= "binomial")

summary(list_sp_lag)
r.squaredGLMM(list_sp_lag)

my_data[, flist_sp_lag:= fitted(list_sp_lag)]

# Plot List, SP, and Lag
ggplot(data=my_data, aes(x= recog, y= flist_sp_lag))+ geom_jitter(height= 0, width= 0.4, color= "dark green", alpha= 0.2)+ geom_violin(alpha= 0.5, trim= TRUE, draw_quantiles = mean(my_data$flist_sp_lag))+ labs(title= "List, SP, and Lag", x= "Was it Recognized?", y= "Fitted Values")
 ggsave("recog_list_sp_lag", device= "png", dpi= 300)
 
 my_data[, res_list_sp_lag:= residuals(list_sp_lag, type= "response")]
 
my_data[, yy_list_sp_lag:= 0]




# ggplot()+ geom_jitter(aes(x= 1:length(is_it_listop), y= is_it_listop))



 my_data[, res_list_op:= residuals(list_op, type= "response")]
  my_data[, res_list_lag:= residuals(list_lag, type= "response")]
  my_data[, res_list_op_lag:= residuals(list_op_lag, type= "response")]
  
 my_data[, res_list_sp_op:= residuals(list_sp_lag, type= "response")]

is_it_listop<- residuals(list_op, type= "response")>0.5 & residuals(list_op, type= "response")< -0.5

# Histogram List SP Lag
is_it_listsplag= residuals(list_lag, type= "response")< 0.5 & residuals(list_op, type= "response")> -0.5
is_it_listsplag[is_it_listsplag== FALSE] <- print(paste("Exceeds Range"))
is_it_listsplag[is_it_listsplag== TRUE] <- print(paste("Target Range"))
ggplot(data= my_data)+ geom_histogram(aes(x= res_list_sp_lag, fill= is_it_listsplag), bins= 100)+ labs(fill= "Range of Values", x= "List SP Lag")
ggsave("hist_residuals_list_sp_lag", device= "png", dpi= 300)

# Histogram List SP OP
is_it_listspop= residuals(list_lag, type= "response")< 0.5 & residuals(list_op, type= "response")> -0.5
is_it_listspop[is_it_listspop== FALSE] <- print(paste("Exceeds Range"))
is_it_listspop[is_it_listspop== TRUE] <- print(paste("Target Range"))
ggplot(data= my_data)+ geom_histogram(aes(x= res_list_sp_lag, fill= is_it_listspop), bins= 100)+ labs(fill= "Range of Values", x= "List SP OP")
ggsave("hist_residuals_list_sp_op", device= "png", dpi= 300)



is_it = abs(residuals(list_op))>0.5

ggplot()+ geom_histogram(aes(x= my_data$residuals(list_op)), fill= is_it)




# Histogram List OP
is_it_listop= residuals(list_lag, type= "response")< 0.5 & residuals(list_op, type= "response")> -0.5
is_it_listop[is_it_listop== FALSE] <- print(paste("Exceeds Range"))
is_it_listop[is_it_listop== TRUE] <- print(paste("Target Range"))
ggplot(data= my_data)+ geom_histogram(aes(x= res_list_op, fill= is_it_listop), bins= 100)+ labs(fill= "Range of values", x= "List OP")
# + xlim(min(my_data$res_list_op), max(my_data$res_list_op))
ggsave("hist_residuals_list_op", device= "png", dpi= 300)


# Histogram List Lag
is_it_listlag= residuals(list_lag, type= "response")< 0.5 & residuals(list_lag, type= "response")> -0.5
is_it_listlag[is_it_listlag== FALSE] <- print(paste("Exceeds Range"))
is_it_listlag[is_it_listlag== TRUE] <- print(paste("Target Range"))
ggplot(data= my_data)+ geom_histogram(aes(x= res_list_lag, fill= is_it_listlag), bins= 75)+ labs(fill= "Range of values", x= "List Lag")
ggsave("hist_residuals_list_lag", device= "png", dpi= 300)


# Histogram List OP Lag
is_it_listoplag= residuals(list_op_lag, type= "response")< 0.5 & residuals(list_op_lag, type= "response")> -0.5
is_it_listoplag[is_it_listoplag== FALSE] <- print(paste("Exceeds Range"))
is_it_listoplag[is_it_listoplag== TRUE] <- print(paste("Target Range"))
ggplot(data= my_data)+ geom_histogram(aes(x= res_list_op_lag, fill= is_it_listoplag), bins= 75)+ labs(fill= "Range of values", x= "List Op Lag")
ggsave("hist_residuals_list_op_lag", device= "png", dpi= 300)


res_listop <- fitted(list_op)- my_data$recognized
res_listoplag <- fitted(list_op_lag)- my_data$recognized
is_it= residuals(list_op, type= "response")<0.5 & residuals(list_op, type= "response")> -0.5
is_it[is_it== FALSE] <- print(paste("Within Range"))
is_it[is_it== TRUE] <- print(paste("Exceeds Range"))



ggplot(data= my_data)+ geom_histogram(aes(x= res_listop, fill= is_it), bins= 1000)+ labs(fill= "Deviation from Prediction", x= "Residuals", y= "Count")

 
ggplot(data= my_data)+ geom_histogram(aes(x= residuals(list_op, type= "response"), fill= is_it), bins= 1000)+ labs(fill= "Deviation from Prediction", x= "Residuals", y= "Count")


list_op_avg <- mean(fitted(list_op))
my_data$recognized- list_op_avg

ggplot(data= my_data, aes(x= my_data$sp, y= fitted(list_op)), height= 0) + geom_jitter(aes(x= my_data$sp, y= fitted(list_op)), alpha= 0.1)+geom_smooth(method= "lm")

