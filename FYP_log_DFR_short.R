# Make sure libraries and packages are loaded
########################################################

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

# library("devtools")
# library(sjmisc)

# Load Data & Set up Data Table
########################################################
dir <- getwd()
target_dir <- "/Users/rebeccawilder/First-Year-Project"
setwd(target_dir)

my_data <- read.csv(file= "newdata.csv")

my_data <- data.table(my_data)

data_names <- c("subject", "session", "list", "rec_itemnos", "rt", "sp", "op", "lag", "ffr")
colnames(my_data) <- data_names



nsubj <- unique(my_data$subject)
my_data[,rt_centered:= scale(rt, scale=TRUE)]
my_data[,recalled:= ffr==1]
my_data$recalled[my_data$recalled== "TRUE"] <- paste("YES")
my_data$recalled[my_data$recalled== "FALSE"] <- paste("NO")




# Mod1: RT OP Lag List
########################################################
mod1 <- glmer(formula= ffr ~ rt_centered+ op + lag + list+ (1|subject), data=my_data[dist_cond==2,], family= "binomial")
summary(mod1)

#Fitted Values

mod1fit <- fitted(mod1)
my_data$f1vals <- 0

for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f1vals <- mod1fit[i]
}
  

#Plot Residuals for Mod1
defaultW <- getOption("warn")
options(warn = -1)


ggplot()+ geom_point(aes(x= 1:length(residuals(mod1, type= "response")), residuals(mod1, type= "response")), alpha= 0.1, color= "orange")+ labs(title= "Mod 1: Lag, OP, RT, List", x= "Count", y= "Residuals")
ggsave("residuals_DFR_Short_mod1_scatter.png", device= "png", dpi= 300)

ggplot()+ geom_histogram(aes(x= residuals(mod1, type= "response")), alpha= 0.75, bins= 100, color= "orange")+ labs(title= "Mod 1: Lag, OP, RT, List", x= "Residuals", y= "Count")
ggsave("residuals_DFR_Short_mod1_hist.png", device= "png", dpi= 300)

options(warn = defaultW)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f1vals), height= 0.1, width= 0.4 , color= "orange", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f1vals), draw_quantiles = c(0.5), adjust= 2, alpha= 0.5)+ labs(title= "Mod 1: Lag, OP, RT, List", x= "FFR", y= "Probability of FFR")+ ylim(0,1)
ggsave("fittedvalues_DFR_Short_mod1.png", device= "png", dpi= 300)

#Mod 2: OP+ RT + List
########################################################
mod2 <- glmer(formula= ffr ~ rt_centered+ op + list+ (1|subject), data=my_data[dist_cond==2,], family= "binomial")
summary(mod2)

#Fitted Values
mod2fit <- fitted(mod2)
my_data$f2vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f2vals <- mod2fit[i]
}

#Plot Residuals for Mod2
ggplot()+ geom_point(aes(x= 1:length(residuals(mod2, type= "response")), residuals(mod2, type= "response")), alpha= 0.1, color= "maroon")+
labs(title= "Mod 2: OP, RT, List", x= "Count", y= "Residuals")
ggsave("residuals_DFR_Short_mod2_scatter.png", device= "png", dpi= 300)

ggplot()+ geom_histogram(aes(x= residuals(mod2, type= "response")), alpha= 0.75, bins= 100, color= "maroon")+ labs(title= "Mod 2: OP, RT, List", x= "Count", y= "Residuals")
ggsave("residuals_DFR_Short_mod2_hist.png", device= "png", dpi= 300)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f2vals), height= 0.1, width= 0.4 , color= "maroon", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f2vals), draw_quantiles = c(0.5), adjust= 2, alpha= 0.5)+ labs(title= "Mod 2: OP, RT, List", x= "FFR", y= "Probability of FFR")+ ylim(0,1)
ggsave("fittedvalues_DFR_Short_mod2.png", device= "png", dpi= 300)

#Mod 3: Lag + RT + List
########################################################
mod3 <- glmer(formula= ffr ~ rt_centered+ lag + list+ (1|subject), data=my_data[dist_cond==2,], family= "binomial")
summary(mod3)

#Fitted Values
mod3fit <- fitted(mod3)
my_data$f3vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f3vals <- mod3fit[i]
}

#Plot Residuals for Mod3
ggplot()+ geom_point(aes(x= 1:length(residuals(mod3)), y= residuals(mod3, type= "response")), color= "navy", alpha= 0.1)+ labs(title= "Mod 3: Lag, RT, List", x= "Count", y= "Residuals")+ ylim(0,1)
ggsave("residuals_DFR_Short_mod3_scatter.png", device= "png", dpi= 300)


ggplot()+ geom_histogram(aes(x= residuals(mod3, type= "response")), alpha= 0.75, bins= 100, color= "navy")+ labs(title= "Mod 3: Lag, RT, List", x= "Residuals", y= "Count")
ggsave("residuals_DFR_Short_mod3_hist.png", device= "png", dpi= 300)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f3vals), height= 0.1, width= 0.4 , color= "navy", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f3vals), alpha= 0.5, draw_quantiles = c(0.5), adjust= 2)+labs(title= "Mod 3: Lag, RT, List", x= "FFR", y= "Probability of FFR")+ ylim(0,1)
ggsave("fittedvalues_DFR_Short_mod3.png", device= "png", dpi= 300)+ ylim(0,1)


#Sample Plotting 
ggplot()+ geom_histogram(aes(x=my_data$f3vals- my_data$ffr), bins= 60, color= "gold")+
xlim(-2, 2)


ggplot()+ geom_histogram(aes(x= my_data[ffr==1]$lag), color= "blue", binwidth= 1)


library(stats)

set.seed(42)
k<- runif(3000)


m<- data.table()
yes_vals= runif(1500)
yes_vals[yes_vals<0.5]= yes_vals[yes_vals<0.5]+0.15
no_vals= runif(1500)
no_vals[no_vals>0.5]= no_vals[no_vals>0.6]-0.45

m$y_pred<- c(yes_vals,no_vals)
m[1:1500,vals:=1]
m[1501:length(y_pred), 2]=0
m[,wir:= vals==1]
m[y_pred<0,1]


k <- data.table()
k$this[1:3000] <-0 
 k$this[1:1500] <-  rnorm(1500, 0.75, 0.1)
 
 k$this[1501:3000] <- rnorm(1500, 0.25, 0.1)
 k$check[1:3000] <- NaN
k$check[1:1500] <- 1 
k$check[1501:3000] <- 0
k$this[k$this<0] <- abs(k$this[k$this<0])

k$check <- k$check==1
k$this[k$this>1] <- k$this[k$this>1]-0.08

k$this[k$this>1]

k[, that:= this]
k$that <- rnorm(3000, mean= 0, sd= 0.25)
k$that[1500:length(k$that)] <- k$that[1500:length(k$that)]*1.5
 
 ggplot()+ geom_jitter(aes(x= k$check, y= k$this), height= 0, alpha= 0.25, color= "steel blue")+ geom_violin(aes(x= k$check, y= k$this), draw_quantiles = 0.5, alpha= 0.75)+ ylim(0,1)+ labs(x= "Was it FFR?", y= "Predicting Probability of FFR")
 ggsave("goodfitmodel.png", device= "png", dpi= 300)

 
mod8 <- glmer(ffr ~ list + (1 | subject), data= my_data[dist_cond==1,], family= "binomial")

is_it = residuals(mod8, type= "response")> -0.5 & residuals(mod8, type= "response") < 0.5

is_it[is_it== "FALSE"] <- paste("Exceeds Threshold")
is_it[is_it== "TRUE"] <- paste("Target Range")



ggplot()+ geom_histogram(aes(x= residuals(mod8, type= "response"), fill= is_it),color= "black", bins= 180)+
  theme(text = element_text(size=15))+ labs(title= "Model Residuals", y= "Frequency", x= "Residuals", fill= "Residual Threshold")
ggsave("goodfithist.png", device= "png", dpi= 300)






r.squaredGLMM(mod1)
r.squaredGLMM(mod2)
r.squaredGLMM(mod3)

r.squaredGLMM(mod8)


