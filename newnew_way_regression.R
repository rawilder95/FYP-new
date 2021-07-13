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
my_data$f1vals <- fitted(mod1)
my_data$f2vals <- fitted(mod2)
my_data$f3vals <- fitted(mod3)



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
this_idx

this_idx2 <- data.table()
this_idx2[, ypred:= seq(0, length.out= length(nsubj))]
this_idx2[, npred:= seq(0, length.out= length(nsubj))]
this_idx2[, youtcome:= seq(0, length.out= length(nsubj))]
this_idx2[, noutcome := seq(0, length.out= length(nsubj))]

for (i in 1:length(nsubj)){
  this_idx2$youtcome[i] <- length(my_data[subject== nsubj[i] & recalled == "YES"]$subject)/length(my_data[subject== nsubj[i]]$subject)
  this_idx2$ypred[i] <- length(my_data[subject == nsubj[i] & f2vals> 0.5]$subject)/length(my_data[subject== nsubj[i]]$subject)
  this_idx2$noutcome[i] <- length(my_data[subject== nsubj[i] & recalled == "NO"]$subject)/length(my_data[subject== nsubj[i]]$subject)
  this_idx2$npred[i] <- length(my_data[subject == nsubj[i] & f2vals> 0.5]$subject)/length(my_data[subject== nsubj[i]]$subject)
}
this_idx2

p1 <- (ggplot()+ 
  geom_bar(aes(x= c("yes_pred", "yes_outcome"), y= after_stat(c(mean(this_idx$ypred), mean(this_idx$youtcome)))))+
  geom_bar(aes(x= c("no_pred", "no_outcome"), y= after_stat(c(mean(this_idx$npred), mean(this_idx$noutcome))))))

    
    
    
this_idx= data.table()
this_idx$yy= 1:length(nsubj)
this_idx$nn= this_idx$yy
this_idx$yn= this_idx$yy
this_idx$ny= this_idx$yy

this_idx2= this_idx
this_idx3= this_idx

for (i in 1:length(nsubj)){
  this_idx$yy[i] <- round(length(my_data[subject== nsubj[i] & recalled== "YES" & fitted(mod1)>0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
  this_idx2$yy[i] <- round(length(my_data[subject== nsubj[i] & recalled== "YES" & fitted(mod2)>0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
  
  this_idx3$yy[i] <- round(length(my_data[subject== nsubj[i] & recalled== "YES" & fitted(mod3)>0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
}

for (i in 1:length(nsubj)){
  this_idx$nn[i] <- round(length(my_data[subject== nsubj[i] & recalled== "NO" & fitted(mod1)<0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
  
  this_idx2$nn[i] <- round(length(my_data[subject== nsubj[i] & recalled== "NO" & fitted(mod2)<0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
  this_idx3$nn[i] <- round(length(my_data[subject== nsubj[i] & recalled== "NO" & fitted(mod3)<0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
}


for (i in 1:length(nsubj)){
  this_idx$yn[i] <- round(length(my_data[subject== nsubj[i] & recalled== "YES" & fitted(mod1)<0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
  this_idx2$yn[i] <- round(length(my_data[subject== nsubj[i] & recalled== "YES" & fitted(mod2)<0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
  this_idx3$yn[i] <- round(length(my_data[subject== nsubj[i] & recalled== "YES" & fitted(mod3)<0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
}

for (i in 1:length(nsubj)){
  this_idx$ny[i] <- round(length(my_data[subject== nsubj[i] & recalled== "NO" & fitted(mod1)>0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
   this_idx2$ny[i] <- round(length(my_data[subject== nsubj[i] & recalled== "NO" & fitted(mod2)>0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
    this_idx3$ny[i] <- round(length(my_data[subject== nsubj[i] & recalled== "NO" & fitted(mod3)>0.5]$recalled)/length(my_data[subject==nsubj[i]]$recalled), digits = 2)
}


f1vals <- fitted(mod1)
f2vals <- fitted(mod2)
f3vals <- fitted(mod3)
res1 <- residuals(mod1)
res2 <- residuals (mod2)
res3 <- residuals (mod3)

p1 <- (ggplot()+ geom_bar(aes(x= c("1_Yes/Yes", "2_No/No", "3_Yes/No", "4_No/Yes"), y= after_stat(c(mean(this_idx$yy), mean(this_idx$nn), mean(this_idx$yn), mean(this_idx$ny))), fill= c("Correct", "Correct", "Incorrect", "Incorrect")), color= "navy")+ labs(title = "Model One", x= "Outcome/Prediction", y= "Response Proportion", fill= "Model Accuracy"))
#    geom_text(aes(x= "1_Yes/Yes", y= round(m1_avg[1], digits= 2))+ 0.1, label = round(m1_avg[1], digits= 2))+
#   geom_text(aes(x= "2_No/No", y= round(m1_avg[2], digits= 2))+ 0.1, label = round(m1_avg[2], digits= 2))+
#   geom_text(aes(x= "3_Yes/No", y= round(m1_avg[3], digits= 2))+ 0.1, label = round(m1_avg[3], digits= 2))+
#   geom_text(aes(x= "4_No/Yes", y= round(m1_avg[4], digits= 2)), label = round(m1_avg[4], digits= 2))
# p1   
   

p2 <- (ggplot()+ geom_bar(aes(x= c("1_Yes/Yes", "2_No/No", "3_Yes/No", "4_No/Yes"), y= after_stat(c(mean(this_idx2$yy), mean(this_idx2$nn), mean(this_idx2$yn), mean(this_idx$ny))), fill= c("Correct", "Correct", "Incorrect", "Incorrect")), color= "navy")+ labs(title= "Model Two", x= "Outcome/Prediction", y= "Response Proportion", fill= "Model Accuracy"))+
   geom_text(aes(x= "1_Yes/Yes", y= round(mean(this_idx2$yy))+ 0.1, label = round(mean(this_idx2$yy), digits= 2)))+
  geom_text(aes(x= "2_No/No", y= round(mean(this_idx2$nn))+ 0.1, label = round(mean(this_idx2$nn), digits= 2)))+
  geom_text(aes(x= "3_Yes/No", y= round(mean(this_idx2$yn))+ 0.1, label = round(mean(this_idx2$yn), digits= 2)))+
  geom_text(aes(x= "4_No/Yes", y= round(mean(this_idx2$ny))+ 0.1, label = round(mean(this_idx2$ny), digits= 2)))

p2


p3 <- (ggplot()+ geom_bar(aes(x= c("1_Yes/Yes", "2_No/No", "3_Yes/No", "4_No/Yes"), y= after_stat(c(mean(this_idx3$yy), mean(this_idx3$nn), mean(this_idx3$yn), mean(this_idx$ny))), fill= c("Correct", "Correct", "Incorrect", "Incorrect")), color= "navy")+ labs(title= "Model Three", x= "Outcome/Prediction", y= "Response Proportion", fill= "Model Accuracy"))

cowplot::plot_grid(p1, p2, p3)
ggsave("mod_all_newway.png", device= "png", dpi= 300, height= 10, width= 7)



p4 <- ggplot()+ geom_jitter(aes(y= f1vals, x= res1, color= c("Model 1", "Model 3")), color= "blue", alpha= 0.01)+ geom_jitter(aes(y= f3vals, x= res3), color= "red", alpha= 0.01) + labs(x= "Residuals", y= "Predicted", title= "Model 1 & Model 3 Comparison")

p5 <- ggplot()+ geom_jitter(aes(y= f1vals, x= res1, color= c("Model 1", "Model 2")), color= "blue", alpha= 0.1)+ geom_jitter(aes(y= f2vals, x= res2), color= "yellow", alpha= 0.01) + labs(x= "Residuals", y= "Predicted", title= "Model 1 & Model 2 Comparison")
cowplot:: plot_grid(p4, p5)
ggsave("mod_residuals_newway.png", device= "png", dpi= 300, height= 10, width= 7)



(m1_avg <- c(mean(this_idx$yy), mean(this_idx$nn), mean(this_idx$yn), mean(this_idx$ny)))

(m1_avg <- c(mean(this_idx2$yy), mean(this_idx2$nn), mean(this_idx2$yn), mean(this_idx2$ny)))

(m3_avg <- c(mean(this_idx3$yy), mean(this_idx3$nn), mean(this_idx3$yn), mean(this_idx3$ny)))


ggplot()+ geom_bar(aes(x= c(1,2,3,4), y= after_stat(m1_avg)))

 
ggplot()+ geom_bar(aes(x= c(1,2,3,4), y= after_stat(m3_avg)))



















