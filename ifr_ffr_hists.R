dir <- getwd()
target_dir <- "/Users/rebeccawilder/First-Year-Project"
setwd(target_dir)

my_data <- read.csv(file= "newdata.csv")
my_data <- data.frame(my_data)




my_data
data_names <- c("subject", "session", "list", "rec_itemnos", "rt", "sp", "op", "lag", "ffr", "ffr_lag")
colnames(my_data) <- data_names


rt= my_data$rt #Response times, elapsed over IFR period
op= my_data$op #Output Position for IFR
ffr= my_data$ffr #Logical matrix for items that were both IFR and FFR, used primarily for lag
sp= my_data$sp #Serial Position for IFR
nlist= my_data$list #Matrix for indexing which list any given item belongs to (IFR)
lag= my_data$lag #Matrix calculated N intervening items between study and IFR



#IFR items that were also FFR
rtc= rt[ffr== 1]
spc= sp[ffr== 1]
opc= op[ffr== 1]
nlistc= nlist[ffr==1]
lagc= lag[ffr== 1]



library("ggplot2")

#add list histogram
#latex check into for making PDFs
#Histograms take a look at each histograms and make sure that data makes sense

# y=..count../sum(..count..)


ggplot()+
geom_histogram(aes(x= sp, color= "IFR"), color= "blue", bins= 40)


#Histogram of Lists IFR
(ifr_list <- ggplot()+
  geom_histogram(aes(x= nlist), color= "aquamarine", fill= "grey", bins= 16)+
  labs(title= "IFR Items by List", x= "List", y= "Count"))

#Histogram of Lists IFR that was FFR
(ffr_list <- ggplot()+
  geom_histogram(aes(x= nlistc), color= "aquamarine", fill= "grey", bins= 16)+
  labs(title= "IFR Items by List", subtitle= "Reflecting items that were FFR", x= "List", y= "Count"))


#Histogram of SPC IFR 
(ifr_sp <- ggplot()+
  geom_histogram(aes(x= sp, color= "FFR"), color= "navy", fill= "grey", bins= 16)+
  labs(title= "Serial Position", subtitle= "Reflecting IFR data points only", x= "Serial Positions"))

#Histogram of SPC IFR that was FFR
(ffr_sp <- ggplot()+
  geom_histogram(aes(x= spc), color= "navy", fill= "grey", bins= 16)+
  labs(title= "Serial Position", subtitle= "Reflecting IFR data points that were FFR", x= "Serial Positions"))


(ifr_op <- ggplot()+
geom_histogram(aes(x= op), color= "purple", fill= "grey", bins= 27)+
  labs(title= "Output Position", subtitle= "Reflecting IFR Items Only", x= "Output Position"))

(ffr_op <- ggplot()+
geom_histogram(aes(x= opc), color= "purple", fill= "grey", bins= 24)+
  labs(title= "Output Position", subtitle= "Reflecting Items that were FFR" , x= "Output Positions"))

((ifr_lag <- ggplot()+
geom_histogram(aes(x= lag), color="gold", fill= "grey", bins= 35)+
  labs(title= "Number of Intervening Items", subtitle= "IFR Items Only", x= "Lag")))
  
  
 (ffr_lag <- ggplot()+
    geom_histogram(aes(x= lagc), color= "gold", fill= "grey", bins= 33)+
    labs(title= "Number of Intervening Items", subtitle= "Reflecting Items That were FFR", x= "Lag"))

((ifr_rt <- ggplot()+
geom_histogram(aes(x= rt), color="magenta", fill= "grey", bins= 40)+
  labs(title= "Response Time", subtitle= "IFR Items Only", x= "Response Time")))
  
  
 (ffr_rt <- ggplot()+
    geom_histogram(aes(x= rtc), color= "magenta", fill= "grey", bins= 40)+
    labs(title= "Response Time", subtitle= "Reflecting Items That were FFR", x= "Response Time"))

library("cowplot")

cowplot::plot_grid(ifr_list, ffr_list, ifr_sp, ffr_sp, ifr_op, ffr_op)

cowplot:: plot_grid(ifr_lag, ffr_lag, ifr_rt, ffr_rt)

             

#logistic regression

# install.packages("lme4")
# library(lme4)

#glmer(formula =ffr ~ (1|subject), data=dat, family= "binomial")

#go to chapter on mixed models 
# formula = ffr ~(1|subjects) means that intercept can vary by subject

#Start looking into lag and lag^2 --> allowing for quadratic effects; If you want to account for effects that are u-shaped and scaling variables.  

#m1 <- glmer(formula= ffr ~ lag + (lag|subject), data= dat, family= binomial)
#Reach out to Jeff Zemla about gfortran problem


# ggplot(data= my_data)+
#   geom_smooth(aes(x= 1:length(lag), y= my_data$lag), method= 'lm')+
#   geom_point(aes(x= 1:length(unique(lag)), y = my_data$lag, alpha= 0.5))

install.packages("lme4", type= "binary")

library(lme4)
practice <- glmer(formula= ffr ~ (1|subject), data=my_data, family= "binomial")

