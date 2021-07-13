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

data_names <- c("subject", "session", "list", "rec_itemnos", "rt", "sp", "op", "lag", "ffr", "dist_cond")
colnames(my_data) <- data_names



nsubj <- unique(my_data$subject)
my_data[,rt_centered:= scale(rt, scale=TRUE)]
my_data[,recalled:= ffr==1]
my_data$recalled[my_data$recalled== "TRUE"] <- paste("YES")
my_data$recalled[my_data$recalled== "FALSE"] <- paste("NO")

ggplot(data= my_data)+ geom_histogram(aes(x= op), bins= max(unique(my_data$op)))

ggplot(data= my_data)+ geom_histogram(aes(x= rt), bins= 26)


# Mod1: RT OP Lag List
########################################################
mod1 <- glmer(formula= ffr ~ rt_centered+ op + lag +  list+ (1|subject), data=my_data[dist_cond==4,], family= "binomial")
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


ggplot()+ geom_point(aes(x= 1:length(residuals(mod1)), residuals(mod1, type= "response")), alpha= 0.1, color= "orchid")+ labs(title= "Mod 1: Lag, OP, RT, List", x= "Count", y= "Residuals")
ggsave("residuals_CDFR_Short_mod1_scatter.png", device= "png", dpi= 300)

ggplot()+ geom_histogram(aes(x= residuals(mod2, type= "response")), alpha= 0.75, bins= 100, color= "orchid")+ labs(title= "Mod 1: Lag, OP, RT, List", x= "Residuals", y= "Count")
ggsave("residuals_CDFR_Short_mod1_hist.png", device= "png", dpi= 300)

options(warn = defaultW)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f1vals), height= 0.1, width= 0.4 , color= "orchid", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f1vals), draw_quantiles = c(0.5), adjust= 2, alpha= 0.5)+ labs(title= "Mod 1: Lag, OP, RT, List", x= "FFR", y= "Probability of FFR")+ ylim(0,1)
ggsave("fittedvalues_CDFR_Short_mod1.png", device= "png", dpi= 300)

#Mod 2: OP+ RT + List
########################################################
mod2 <- glmer(formula= ffr ~ rt_centered+ op + list+ (1|subject), data=my_data[dist_cond==4,], family= "binomial")
summary(mod2)

#Fitted Values
mod2fit <- fitted(mod2)
my_data$f2vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f2vals <- mod2fit[i]
}

#Plot Residuals for Mod2
ggplot()+ geom_point(aes(x= 1:length(residuals(mod2)), residuals(mod2, type= "response")), alpha= 0.25, color= "thistle3")+
labs(title= "Mod 2: OP, RT, List", x= "Count", y= "Residuals")
ggsave("residuals_CDFR_Short_mod2_scatter.png", device= "png", dpi= 300)

ggplot()+ geom_histogram(aes(x= residuals(mod2, type= "response")), alpha= 0.75, bins= 100, color= "thistle3")+ labs(title= "Mod 2: OP, RT, List", x= "Count", y= "Residuals")
ggsave("residuals_CDFR_Short_mod2_hist.png", device= "png", dpi= 300)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f2vals), height= 0.1, width= 0.4 , color= "thistle3", alpha= 0.25)+ geom_violin(aes(x= recalled, y= f2vals), draw_quantiles = c(0.5), adjust= 2, alpha= 0.5)+ labs(title= "Mod 2: OP, RT, List", x= "FFR", y= "Probability of FFR")+ ylim(0,1)
ggsave("fittedvalues_CDFR_Short_mod2.png", device= "png", dpi= 300)

#Mod 3: Lag + RT + List
########################################################
mod3 <- glmer(formula= ffr ~ rt_centered+ lag + list+ (1|subject)+ (1|session), data=my_data[dist_cond==4,], family= "binomial")
summary(mod3)

#Fitted Values
mod3fit <- fitted(mod3)
my_data$res3 <- 0
my_data$f3vals <- 0
resmod3 <- residuals(mod3)

for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f3vals <- mod3fit[i]
  my_data[subject== nsubj[i]]$res3 <- 
resmod3[i]}

#Plot Residuals for Mod3
ggplot()+ geom_point(aes(x= 1:length(residuals(mod3)), y= residuals(mod3, type= "response")), color= "rosybrown2", alpha= 0.1)+ labs(title= "Mod 3: Lag, RT, List", x= "Count", y= "Residuals")
ggsave("residuals_CDFR_Short_mod3_scatter.png", device= "png", dpi= 300)


ggplot()+ geom_histogram(aes(x= residuals(mod3, type= "response")), alpha= 0.75, bins= 205, color= "rosybrown2")+ labs(title= "Mod 3: Lag, RT, List", x= "Residuals", y= "Count")
ggsave("residuals_CDFR_Short_mod3_hist.png", device= "png", dpi= 300)

#Plot Fitted Values
ggplot(data= my_data)+ geom_jitter(aes(x= recalled, y= f3vals), height= 0.1, width= 0.4 , color= "rosybrown2", alpha= 0.1)+ geom_violin(aes(x= recalled, y= f3vals), alpha= 0.5, draw_quantiles = c(0.5), adjust= 2)+labs(title= "Mod 3: Lag, RT, List", x= "FFR", y= "Probability of FFR")+ ylim(0,1)
ggsave("fittedvalues_CDFR_Short_mod3.png", device= "png", dpi= 300)




r.squaredGLMM(mod1)
r.squaredGLMM(mod2)
r.squaredGLMM(mod3)


