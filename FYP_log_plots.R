# Make sure libraries and packages are loaded
########################################################

# install.packages("lme4", type= "binary")
library(lme4)
library(lmerTest)

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
mod1 <- glmer(formula= ffr ~ rt_centered+ op + lag + list+ (1|subject), data=my_data, family= "binomial")
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


ggplot()+ geom_jitter(aes(x= 1:length(residuals(mod1, type= "response")), residuals(mod1, type= "response")), alpha= 0.5, color= "hot pink")+ labs(title= "Mod 1: Lag, OP, RT, List", x= "Residuals", y= "Count")
ggsave("residuals_IFR_mod1_scatter.png", device= "png", dpi= 300)
is_it= residuals(mod1, type= "response")< 0.5 & residuals(mod1, type= "response")> -0.5
is_it[is_it== "FALSE"] <- paste ("Exceeds Threshold")
is_it[is_it== "FALSE"] <- paste ("Target Range")

ggplot()+ geom_histogram(aes(x= residuals(mod1, type= "response"), fill= is_it), alpha= 0.75, bins= 100, color= "hot pink")+ labs(title= "Model 1: Lag, OP, RT, List", x= "Residuals", y= "Count", fill= "Residuals Threshold")+theme(text = element_text(size=15))
ggsave("residuals_IFR_mod1_hist.png", device= "png", dpi= 300)

options(warn = defaultW)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f1vals), height= 0, width= 0.45 , color= "hot pink", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f1vals), draw_quantiles = 0.5, adjust= 2, alpha= 0.5)+ ylim(0,1)+ theme(text = element_text(size=15))+  labs(title= "Mod 1: Lag, OP, RT, List", x= "Was it FFR?", y= "Predicted Probability")
ggsave("fittedvalues_IFR_mod1.png", device= "png", dpi= 300, height= 3.36, width= 4.84, units= "in")

#Mod 2: OP+ RT + List
########################################################
mod2 <- glmer(formula= ffr ~ rt_centered+ op + list+ (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(mod2)

#Fitted Values
mod2fit <- fitted(mod2)
my_data$f2vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f2vals <- mod2fit[i]
}

#Plot Residuals for Mod2
ggplot()+ geom_point(aes(x= 1:length(residuals(mod2, type= "response")), residuals(mod2, type= "response")), alpha= 0.1, color= "dark green")+
labs(title= "Mod 2: OP, RT, List", x= "Residuals", y= "Count")
ggsave("residuals_IFR_mod2_scatter.png", device= "png", dpi= 300)

ggplot()+ geom_histogram(aes(x= residuals(mod2, type= "response")), alpha= 0.75, bins= 100, color= "dark green")+ labs(title= "Mod 2: OP, RT, List", x= "Residuals", y= "Count")+theme(text = element_text(size=15))
ggsave("residuals_IFR_mod2_hist.png", device= "png", dpi= 300, height= 3.36, width= 4.84)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f2vals), height= 0.1, width= 0.45 , color= "dark green", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f2vals), draw_quantiles = 0.5, adjust= 2, alpha= 0.5)+ labs(title= "Mod 2: OP, RT, List", x= "FFR", y= "Predicted Probability of FFR") + ylim(0,1)+ theme(text = element_text(size=15))
ggsave("fittedvalues_IFR_mod2.png", device= "png", dpi= 300, , height= 3.36, width= 4.84)

#Mod 3: Lag + RT + List
########################################################
mod3 <- glmer(formula= ffr ~ rt_centered+ lag + list+ (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(mod3)

#Fitted Values
mod3fit <- fitted(mod3)
my_data$f3vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f3vals <- mod3fit[i]
}

#Plot Residuals for Mod3
ggplot()+ geom_point(aes(x= 1:length(residuals(mod3, type= "response")), y= residuals(mod3, type= "response")), color= "purple", alpha= 0.1)+ labs(title= "Mod 3: Lag, RT, List", x= "Residuals", y= "Count")
ggsave("residuals_IFR_mod3_scatter.png", device= "png", dpi= 300)


ggplot()+ geom_histogram(aes(x= residuals(mod3, type= "response")), alpha= 0.75, bins= 100, color= "purple")+ labs(title= "Mod 3: Lag, RT, List", x= "Residuals", y= "Count")+theme(text = element_text(size=15))
ggsave("residuals_IFR_mod3_hist.png", device= "png", dpi= 300, height= 3.36, width= 4.84)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f3vals), height= 0.1, width= 0.45 , color= "purple", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f3vals), alpha= 0.5, draw_quantiles = c(0.5), adjust= 2) +labs(title= "Mod 3: Lag, RT, List", x= "Was it FFR?", y= "Predicted Probability of FFR")+ ylim(0,1)+ theme(text = element_text(size=15))
ggsave("fittedvalues_IFR_mod3.png", device= "png", dpi= 300, height= 3.36, width= 4.84)

ggplot()+ geom_histogram(aes(x= residuals(mod4, type= "response")), alpha= 0.75, bins= 100, color= "purple")+ labs(title= "Mod 4: Lag, RT, List", x= "Residuals", y= "Count")+theme(text = element_text(size=15))
ggsave("residuals_IFR_mod3_hist.png", device= "png", dpi= 300, height= 3.36, width= 4.84)

# install.packages("MuMIn")
library(MuMIn)
r.squaredGLMM(mod4)

# Marginal and Conditional R2.  Marginal R2 only considers Fixed Effects, while Conditional R2 takes into account the Random Effects. 

# Model 1: Lag, OP, RT, List
r.squaredGLMM(mod1)

# Model 2: OP, RT, List
r.squaredGLMM(mod2)

# Model 3: Lag, RT, List
r.squaredGLMM(mod3)




factor(summary(mod1)$coefficients[,4])


factor(summary(mod2)$coefficients[,2])



mod4 <- glmer(formula= ffr ~ rt_centered+ sp + op+ list+ (1|subject), data=my_data[dist_cond==2,], family= "binomial")
summary(mod4)

mod4fit <- fitted(mod4)
my_data$f4vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f4vals <- mod4fit[i]
}

ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f4vals), height= 0.1, width= 0.45 , color= "violetred2", alpha= 0.4)+ geom_violin(aes(x= recalled, y= f4vals), alpha= 0.5, draw_quantiles = c(0.5), adjust= 2) +labs(title= "Mod 4: SP, RT, List, OP", x= "Was it FFR?", y= "Predicted Probability of FFR")+ ylim(0,1)+ theme(text = element_text(size=15))
ggsave("fittedvalues_IFR_mod4.png", device= "png", dpi= 300)

  r.squaredGLMM(mod4)
  
  
r.squaredGLMM(mod1)
r.squaredGLMM(mod2)
r.squaredGLMM(mod3)

sreg <- data.table()

mod4 <- glmer(formula= ffr ~ sp + op+ list+ (1|subject), data=my_data[dist_cond==2,], family= "binomial")
summary(mod4)
  r.squaredGLMM(mod4)



sreg$pred_fit <- 1
sreg$pred_fit[mod1fit<0.5 & mod1fit> -0.5] <- 0


r.squaredGLMM(glm(formula= ffr ~ sp+op+lag+rt, data= my_data, family= "binomial"))




mod5 <- glmer(formula= ffr ~ rt + list +(1|subject), data=my_data[dist_cond==2,], family= "binomial")
summary(mod5)
  r.squaredGLMM(mod5)

p1 <- (ggplot(data= my_data)+ geom_histogram(aes(x= rt), bins= 50, color = "blue"))

p2 <- (ggplot(data= my_data)+ geom_histogram(aes(x= op), bins= 26, color = "violetred1"))

library(cowplot)

cowplot::plot_grid(p1, p2)

lm(formula= ffr ~ lag+op, data= my_data)

# install.packages("NoiseFiltersR")
library(NoiseFiltersR)

is_it= residuals(mod1, type= "response")< 0.5 & residuals(mod1, type= "response")> -0.5
is_it[is_it== "FALSE"] <- paste ("Exceeds Threshold")
is_it[is_it== "TRUE"] <- paste ("Target Range")




# ggplot(data= my_data)+ geom_histogram(aes(x= ))
# count of predicted values
# Mean counts across person and dots regular counts per person
# geom_hline with all of the dots

