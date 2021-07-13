# install.packages("lme4", type= "binary")
library(lme4)

# devtools::install_github("strengejacke/strengejacke")
# install.packages("data.table")
# install.packages("jtools")
library("jtools")
library("ggplot2")

library("data.table")
# install.packages("lmerTest")
# library(lmerTest)
# install.packages("devtools", type= "binary")

library("devtools")


# devtools::install_github("strengejacke/sjPlot")
# install.packages("sjmisc")
library(sjmisc)


dir <- getwd()
target_dir <- "/Users/rebeccawilder/First-Year-Project"
setwd(target_dir)

my_data <- read.csv(file= "newdata.csv")

my_data <- data.table(my_data)





data_names <- c("subject", "session", "list", "rec_itemnos", "rt", "sp", "op", "lag", "ffr", "dist_cond")
colnames(my_data) <- data_names

# Center rts
my_data[,rt_center:= scale(rt, scale=TRUE)]


practice <- glmer(formula= ffr ~ rt_center+ op + lag + list+ (1|subject) + (1|session), data=my_data[dist_cond==1,], family= "binomial")
summary(practice)



nsubj <- unique(my_data$subject)
# install.packages("schoolmath")
library(schoolmath)
my_data[,yint := 0]
my_data[,rtb := 0]
my_data[,opb := 0]
my_data[,lagb := 0]

nsubj= unique(my_data$subject)
sum_practice <- summary(practice)
my_data[,rtb:= coef(practice)$subject$`rt_center`[1]]
my_data[,lagb:= coef(practice)$subject$`lag`[1]]
my_data[,opb:= coef(practice)$subject$`op`[1]]
(my_data)

my_data[, yint:= 0]
getcoefs<- coef(practice)$subject[1]$`(Intercept)`
k <- vector()
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$yint <- getcoefs[i]
}

my_data[, recalled:= NA]
my_data$recalled[my_data$ffr==1]<- paste("Yes")
my_data$recalled[my_data$ffr==0]<- paste("No")

rt_data <- data.table()
rt_data$ypred <- my_data$rtb*my_data$rt_center + my_data$yint
rt_data$recalled <- my_data$recalled

op_data <- data.table()
op_data$ypred <- my_data$opb*my_data$op + my_data$yint
op_data$recalled <- my_data$recalled

lag_data <- data.table()
lag_data$ypred <- my_data$lagb*my_data$lag + my_data$yint
lag_data$recalled <- my_data$recalled






n<- length(rt_data$ypred)
setattr(rt_data, "row.names", seq.int(n))
setattr(op_data, "row.names", seq.int(n))
setattr(lag_data, "row.names", seq.int(n))



reg_scatter_op <- ggplot(data= op_data, aes(x= recalled, y= ypred)) + geom_jitter(color= "dark green", alpha= 0.2, size= 0.6)+ geom_point(alpha= 0.4, size= 0.4)+
  ylim(-4,2)+
  labs(title= "Probability of Final Free Recall (ƒ) Output Position", x= "FFR", y= "p(FFR)")
ggsave("reg_scatter_op.png", dpi= 300, units= "in")


ggplot(data= lag_data, aes(x= recalled, y= ypred)) + geom_jitter(color= "magenta", alpha= 0.2, size= 0.4)+ geom_point(alpha= 0.2, size= 0.6)+
  ylim(-4,2)+
  labs(title= "Probability of Final Free Recall (ƒ) Lag", x= "FFR", y= "p(FFR)")
ggsave("reg_scatter_lag.png", dpi= 300, units= "in")

ggplot(data= rt_data, aes(x= recalled, y= ypred)) + geom_jitter(color= "purple", alpha= 0.3, size= 0.4)+ geom_point(alpha= 0.2, size= 0.6)+
  ylim(-4,2)+
  labs(title= "Probability of Final Free Recall (ƒ) Response Time", x= "FFR", y= "p(FFR)")
ggsave("reg_scatter_rt.png", dpi= 300, units= "in")

getbetas= c(unique(my_data$opb), unique(my_data$lagb),  unique(my_data$rtb))
disc_stats <- c(mean(scale(my_data$op, scale=FALSE)),sd(scale(my_data$op, scale=FALSE)),mean(scale(my_data$lag, scale=FALSE)),sd(scale(my_data$lag, scale=FALSE)), mean(scale(my_data$rt_center, scale=TRUE)), sd(scale(my_data$rt, scale=FALSE)))


ggplot() + geom_bar(aes(x= c("opb", "lagb", "rtb"), y= c(unique(my_data$opb), unique(my_data$lagb), unique(my_data$rtb))), stat= "identity")+
 geom_errorbar(inherit.aes= FALSE, aes(ymin=mean(my_data$op)-sd(my_data$op), ymax= mean(my_data$op)+sd(my_data$op)))

lag_op_rt_list1 <- glmer(data= my_data[dist_cond==1], formula= ffr ~ op+ rt_center+ lag+list+ (1|subject)+ (1|session), family= "binomial", na.action= na.exclude)

length(fitted(lag_op_rt_list1))








m1<- predict(lag_op_rt_list1, type= "response")
plot(m1)

# install.packages("plm")
library(plm)


data("Produc", package = "plm")

# ASSIGN RANDOM NAs ACROSS NON-PANEL COLUMNS
set.seed(41120)
for(col in names(Produc)[!names(Produc) %in% c("state", "year")]) {
  Produc[sample(nrow(Produc), 50), col] <- NA
}

results <- plm(log(gsp) ~ log(pcap) + log(pc) + log(emp) + unemp,
               data = Produc, index = c("state","year"))

fitted_values_vec <- fitted(results)
str(fitted_values_vec)
# 'pseries' Named num [1:588] -0.2459 -0.2274 -0.0927 -0.0981 -0.0184 ...
# - attr(*, "names")= chr [1:588] "ALABAMA" "ALABAMA" "ALABAMA" "ALABAMA" ...
# - attr(*, "index")=Classes ‘pindex’ and 'data.frame': 588 obs. of  2 variables:
#   ..$ state: Factor w/ 48 levels "ALABAMA","ARIZONA",..: 1 1 1 1 1 1 1 1 1 1 ...
#   ..$ year : Factor w/ 17 levels "1970","1971",..: 1 2 5 6 7 8 9 10 12 13 ...


fitted_values_df <- cbind(attr(fitted_values_vec, "index"), 
                          fitted_values = fitted_values_vec)

Produc <- merge(Produc, fitted_values_df, by= c("state","year"), all.x=TRUE)




my_data[ffr==1,]$lag_op_rt_list<- fitted(lag_op_rt)
yint <- -2.009464
lagbeta <- 0.072733 
rtbeta <- 0.001779
opbeta <- -0.026154

ggplot()+ geom()


mod1data <- data.table()

yweight <- predict(model_weight, list(wt = xweight),type="response")


mod1data <- (lagbeta*my_data[ffr==1,]$lag + rtbeta*my_data[ffr==1,]$rt + opbeta*my_data[ffr==1,]$op)

mod2data <- (lagbeta*my_data[ffr==0,]$lag + rtbeta*my_data[ffr==0,]$rt + opbeta*my_data[ffr==0,]$op)

my_data[ffr==1, betas:= mod1data]
my_data[ffr==0, betas:= mod2data]
my_data[ffr==1, recalled:= "YES"]
my_data[ffr==0, recalled:= "NO"]





mod1 <- glmer(formula= ffr ~ rt_center+ op + lag + list+ (1|subject) + (1|session), data=my_data[dist_cond==1,], family= "binomial")



 modfit<- fitted(mod1)
 my_data$betas <- 0

for (i in 1:length(nsubj)){
   my_data[subject==nsubj[i]]$betas<- modfit[i]
}

 yesno<- vector()
 
 for (i in 1:length(nsubj)){
   yesno[i]<- my_data[subject== nsubj[i]]$recalled[i]
 }
 

 
 
 betas<- my_data$betas


 
 
 for (i in length(nsubj)){
   betas[my_data$subject==nsubj[i]] <- modfit[i]
 }

# ggplot(data= my_data[unique(subject)])+ geom_point(aes(x= recalled, y=betas), size= 0.2, alpha= 0.1)+
# ylim(min(betas), max(betas))
# yesno <- data.table(yesno)
# yesno$yesno <- yesno
# yesno$betas <- unique(my_data$betas)



#Plot Predicting Lag+ List + OP + RT
ggplot(my_data)+ geom_point(aes(x= recalled, y=betas), color= "blue", alpha= 0.2, size= 0.4)+
labs(title= "Mixed Effects Multiple Logistic Regression Model", subtitle=  "FFR~ Lag+ Output+ Response Time+ List",x= "Was it FFR?", y= "p(FFR)")+ ylim(0,1)
ggsave("op_lag_rt_list", device= "png", dpi= 300)


#RT+OP+LIST
mod2<- glmer(formula= ffr ~ rt_center+ op + list+ (1|subject) + (1|session), data=my_data[dist_cond==1,], family= "binomial")

modfit2<- fitted(mod2)


 my_data$betas2 <- 0

for (i in 1:length(nsubj)){
   my_data[subject==nsubj[i]]$betas2<- modfit2[i]
}

 ggplot(my_data)+ geom_point(aes(x= recalled, y = betas2), size= 0.4,alpha= 0.2, color= "violet")+ labs(title= "Mixed Effects Multiple Logistic Regression Model", subtitle= "FFR~ Output+ Response Time+ List", x= "Was it FFR?", y= "p(FFR)")
 ggsave("op_rt_list", device= "png", dpi= 300)
 
 mod3<- glmer(formula= ffr ~ rt_center+ lag + list+ (1|subject), data=my_data[dist_cond==1,], family= "binomial")

modfit3<- fitted(mod3)


 my_data$betas3 <- 0

for (i in 1:length(nsubj)){
   my_data[subject==nsubj[i]]$betas3<- modfit3[i]
}
 
 
# yes <- data.table()
# yes<- my_data[recalled== "YES"]$betas3
# no <- my_data[recalled== "NO"]$betas3
# 
# 
# 
# 
# 
# yes <- c(yes, rep(NaN, length(no)- length(yes)))
# 
# my_data$betas3[yes==no]=NaN
#  

 
 
 # install.packages("cowplot")
 library(cowplot)
 
 
 
 (p3 <- ggplot(my_data)+ geom_point(aes(x= recalled, y = betas3), color= "dark green", size= 0.4,alpha= 0.2)+ labs(title= "FFR~ Lag+ Response Time+ List", x= "Was it FFR?", y= "p(FFR)"))
 ggsave("lag_rt_list", device= "png", dpi= 300)
 
 
ggplot()+ geom_point(aes(x= my_data$recalled[1:164], y= unique(my_data$betas3)), color= "dark green", size= 2, alpha= 0.5)+
labs(title= "FFR~ Lag+ Response Time+ List", x= "Was it FFR?", y= "p(FFR)")+ theme(text = element_text(size=20))
  ggsave("betas3.png", device= "png", dpi= 300, height= 10, width= 15, unit= "in")
 
ggplot()+ geom_point(aes(x= my_data$recalled[1:164], y= unique(my_data$betas2)), color= "purple", size= 2, alpha= 0.5)+ labs(title= "FFR~ Output+ Response Time+ List", x= "Was it FFR?", y= "p(FFR)") + theme(text = element_text(size=20))
  ggsave("betas2.png", device= "png", dpi= 300, height= 10, width= 15, unit= "in")

 ggplot()+ geom_point(aes(x= my_data$recalled[1:164], y= unique(my_data$betas)), color= "hot pink", size= 2, alpha= 0.5)+ labs(title="FFR~ Output+ Response Time+ Lag+ List", x= "Was it FFR?", y= "p(FFR)")+ theme(text = element_text(size=20))
  ggsave("betas1.png", device= "png", dpi= 300, height= 10, width= 15, unit= "in")

  
ggplot()+ geom_point(aes(x= c(1:length(residuals(mod2))), y= residuals(mod3)), color= "red", alpha= 0.5)+ labs(x= "count", y= "residuals")
  

residuals(mod1)[1]
my_data[1,recalled]



ggplot()+ geom_histogram(aes(x= op), color= "navy", binwidth= 1)+ labs(x= "Output Position", y= "Density")+ theme(text = element_text(size = 15))+ theme(axis.text = element_text(size = 15)) 
ggsave("op_hist.png", device= "png", dpi= 300)

ggplot()+ geom_histogram(aes(x= lag), color= "navy", binwidth= 1)+ labs(x= "Lag", y= "Density")+ theme(text = element_text(size = 15))+ theme(axis.text = element_text(size = 15)) 
ggsave("lag_hist.png", device= "png", dpi= 300)

ggplot()+ geom_histogram(aes(x= sp), color= "navy", binwidth= 1)+ labs(x= "Output Position", y= "Density")+ theme(text = element_text(size = 15)) + theme(axis.text = element_text(size = 15))
ggsave("list_hist.png", device= "png", dpi= 300)
 

