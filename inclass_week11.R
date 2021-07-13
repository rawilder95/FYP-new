library(data.table)
library(ggplot2)
# install.packages("lmerTest")
library(lmerTest)

data(sleepstudy)
sleep <-data.table(sleepstudy)

# 1a. Generate a scatter plot color coding for each subject.  Reaction time on y axis and days without sleep on x axis.

ggplot(data= sleep)+ geom_point(aes(x= Days, y= Reaction, color= Subject, alpha= 0.5)) #alpha set to 0.5 transparency makes it easier to see clustered data points

# It looks like, overall, there is a general trend between reaction time increasing as days without sleep increases.  However, it looks like there could be a few subjects whose reaction times peaked at around 5 days and slightly decreased afterwards.  

# 1b ) Fit a random intercept model to the data. What is the fixed effect? What is the random effect? From this model, would you say that sleep affects reaction time?

sleep_mod <- lmer(Reaction ~ Days + (1|Subject), data=sleep)
summary(sleep_mod)

# The fixed effect is the number of days a subject goes without sleeping, while the random effect variable is subjects.  Each subject has their own set of data points and, therefore, can introduce effects- unexplained by the predictor, into the model.  (Your explanation when we met was really helpful in understanding this!)

# This model certainly suggests that sleep, and implicitly lack thereof, affects reaction time.  Specifically, increasing the number of days that one goes without sleeping is linked to increased reaction times.  

# 1c What is the slope and y-intercept for subject 334? What is the mean y-intercept for all participants?

coef(sleep_mod)
mean(coef(sleep_mod)$Subject[,1])

#For subject 334, the slope is β= 10.467 and y-intercept is 248.408. The mean y-intercept for all subjects is 251.405

# 1d The study ends on day 9. What would you predict the reaction time of participant 370 to be on day 11?

y_int370 <- 245.0424
b <- 10.46729
day <- 11
coef(sleep_mod)

(p_react <- y_int370 + b*day)
# Our regression for subject 370 predicts that their reaction time should be roughly around 360ms on day 11


