# install.packages("lme4", type= "binary")
library(lme4)
# library("ggplot2")
# library("data.table")

dir <- getwd()
target_dir <- "/Users/rebeccawilder/First-Year-Project"
setwd(target_dir)

my_data <- read.csv(file= "newdata.csv")

my_data <- data.table(my_data)





data_names <- c("subject", "session", "list", "rec_itemnos", "rt", "sp", "op", "lag", "ffr", "dist_cond")
colnames(my_data) <- data_names






rt= my_data$rt #Response times, elapsed over IFR period
op= my_data$op #Output Position for IFR
ffr= my_data$ffr #Logical matrix for items that were both IFR and FFR, used primarily for lag
sp= my_data$sp #Serial Position for IFR
nlist= my_data$list #Matrix for indexing which list any given item belongs to (IFR)
lag= my_data$lag #Matrix calculated N intervening items between study and IFR


# my_data[is.nan(rt),ffr]<- NaN
# for (i in length colnames(my_data))
#   my_data$col_names[my_data]

#IFR items that were also FFR
rtc= rt[ffr== 1]
spc= sp[ffr== 1]
opc= op[ffr== 1]
nlistc= nlist[ffr==1]
lagc= lag[ffr== 1]

ifr <- my_data[dist_cond==1,]

# Subj each have data points (groups within groups= grouping effect)
# Consider running these as three different regressions first** + compare effects
# Specify condition subsets in my data
# Recenter variables also consider rescaling (play around with it) scale(predictor var)***
# scale(op, scale= FALSE)
# High correlation between sp and lag= -0.8203558 (potential go through transforms MAYBE-- transform is completely nonlinar, so maybe not)

my_data[,op_centered := scale(op, scale= FALSE)]
my_data[, lag_centered := scale(lag, scale= FALSE)]
my_data[, sp_centered := scale(sp, scale= FALSE)]
my_data[, rt_centered := scale(rt, scale= TRUE)]
my_data[, sp1 := sp*-1]


ggplot(data= my_data)
# Add session as a grouping variable and list (greater for later lists)** as a predictor
# Exclude items that have a lag greater than [nevermind]
# If it's about op interference we should expect that to be the only significant regressor and vice versa
# Serial position and lag being same z value is normal because we're doing a combination of lag with having sp and op ().  Lag has more of op.  Just lag + list + rt, just op + list + rt, lag + op + list + rt
# Plot with actual y values on x-axis and predicted y values on y-axies (we talked about boxplot/bar graph with 2 x axis points)


# coef function on data


practice <- glmer(formula= ffr ~ rt_centered+ op + lag + list+ (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(practice)

ypred <- ffr*


p2 <- glmer(formula= ffr ~ rt_centered+ op + lag * list+ (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(p2)

p3 <- glmer(formula= ffr ~ rt_centered + op + lag + list+ (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(p3)


ggplot()+ geom_point(aes(x= , y= unlist(ypred)))

simple_mod <- glmer(formula= ffr ~ (1|subject), data= my_data)
summary(simple_mod)



mod1 <- glmer(formula= ffr ~ lag+ rt_centered + (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(mod1)

mod2 <- glmer(formula= ffr ~ sp_centered + lag_centered + op_centered + (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(mod2)

mod3 <- glmer(formula= ffr ~ rt_centered+op+lag + (1|subject), data=my_data[dist_cond==1,], family= "binomial")
summary(mod3)

mod4 <- glmer(formula= ffr ~ lag+ rt_centered + list + (1|subject) + (1|subject), data= my_data[dist_cond==1,], family= "binomial")
summary(mod4)

getints <- coef(mod4)$subject$`(Intercept)`
getlag <- 


my_data$ffr*coef$subject


ggplot(data= my_data)+ geom_histogram(aes(x= sp_centered), color= "blue", binwidth= 0.25)





