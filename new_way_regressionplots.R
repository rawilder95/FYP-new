# Make sure libraries and packages are loaded
########################################################

# install.packages("lme4", type= "binary")
defaultW <- getOption("warn")
options(warn = -1)
library(lme4)
library(lmerTest)



library("ggplot2")

library("data.table")
# install.packages("lmerTest")
library(lmerTest)


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
nses <- unique(my_data$session)
my_data[,rt_centered:= scale(rt, scale=TRUE)]
my_data[,recalled:= ffr==1]
my_data$recalled[my_data$recalled== "TRUE"] <- paste("YES")
my_data$recalled[my_data$recalled== "FALSE"] <- paste("NO")
mod1 <- glmer(formula= ffr ~ rt_centered+ op + lag + list+ (1|subject), data=my_data, family= "binomial")
summary(mod1)

#Fitted Values

mod1fit <- fitted(mod1)
my_data$f1vals <- 0

for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f1vals <- mod1fit[i]
}


mod2 <- glmer(formula= ffr ~ rt_centered+ op + list+ (1|subject), data=my_data, family= "binomial")
summary(mod2)

#Fitted Values
mod2fit <- fitted(mod2)
my_data$f2vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f2vals <- mod2fit[i]
}


mod3 <- glmer(formula= ffr ~ rt_centered+ lag + list+ (1|subject), data=my_data, family= "binomial")
summary(mod3)

#Fitted Values
mod3fit <- fitted(mod3)
my_data$f3vals <- 0
for (i in 1:length(nsubj)){
  my_data[subject== nsubj[i]]$f3vals <- mod3fit[i]
}




  this_idx <- data.table()
  this_idx$nn <- nsubj
  this_idx$yy <- nsubj
  this_idx$ny <- nsubj
  this_idx$yn <- nsubj

  
  sum(mean(this_idx$nn),mean(this_idx$yy),mean(this_idx$yn),mean(this_idx$ny))
  sum(mean(this_idx2$nn),mean(this_idx2$yy),mean(this_idx2$yn),mean(this_idx2$ny))
  sum(mean(this_idx3$nn),mean(this_idx3$yy),mean(this_idx3$yn),mean(this_idx3$ny))
  
  test1 <- data.table()
  test1$f1 <- my_data$f1vals
  test1$f1 <- 0
  
  
# Model 1
for (i in 1:length(nsubj)){
  for (j in 1:length(nses)){
    test1$f1= length(my_data[subject== nsubj[i]]$recalled)
    this_idx[i]$nn <- length(my_data[subject== nsubj[i] & f1vals<0.5 & recalled == "NO"]$recalled)
    this_idx[i]$yy <- length(my_data[subject== nsubj[i] & f1vals>0.5 & recalled == "YES"]$recalled)
    this_idx[i]$ny <- length(my_data[subject== nsubj[i] & f1vals<0.5 & recalled == "YES"]$recalled)
    this_idx[i]$yn <- length(my_data[subject== nsubj[i] & f1vals>0.5 & recalled == "NO"]$recalled)
  }
}
  
  
  text1= c(mean(this_idx$nn), mean(this_idx$yy), mean(this_idx$ny), mean(this_idx$yn))
text1 = text1/unique(test1$f1)


text1= round(text1, digits= 2)


p1 <- (ggplot()+ 
  geom_bar(aes(x= "No/No", y= after_stat(mean(text1[1]))))+
  geom_bar(aes(x= "Yes/Yes", y= after_stat(mean(text1[2]))))+
  geom_bar(aes(x= "No/Yes", y= after_stat(mean(text1[3]))))+
  geom_bar(aes(x= "Yes/No", y= after_stat(mean(text1[4]))))+ 
  geom_text(aes(x= "No/No", y= text1[1]+0.17, label = text1[1]))+
  geom_text(aes(x= "Yes/Yes", y= text1[2]+0.17, label = text1[2]))+
  geom_text(aes(x= "No/Yes", y= text1[3]+0.17, label = text1[3]))+
  geom_text(aes(x= "Yes/No", y= text1[4]+0.17, label = text1[4]))+ theme(text = element_text(size=15))+ theme(panel.grid.major = element_line(colour= "black", size= 0.1))+ 
  labs(x= "Predictions Versus Outcomes", y= "Response Type Proportion", title= "Model 1: Lag, OP, RT, & List")+ylim(0,1))
ggsave("mod1_newway.png", device= "png", dpi= 300, height= 10, width= 7)
p1

# Model 2
this_idx2= data.table()
this_idx2 = this_idx
this_idx2$nn <- 0
this_idx2$yn <- 0
this_idx2$yy <- 0
this_idx2$ny <- 0


for (i in 1:length(nsubj)){
  for (j in 1:length(nses)){
    this_idx2[i]$nn <- length(my_data[subject== nsubj[i] & f2vals<0.5 & recalled == "NO"]$recalled)
    this_idx2[i]$yy <- length(my_data[subject== nsubj[i] & f2vals>0.5 & recalled == "YES"]$recalled)
    this_idx2[i]$ny <- length(my_data[subject== nsubj[i] & f2vals<0.5 & recalled == "YES"]$recalled)
    this_idx2[i]$yn <- length(my_data[subject== nsubj[i] & f2vals>0.5 & recalled == "NO"]$recalled)
  }
}




text2= c(mean(this_idx2$nn), mean(this_idx2$yy), mean(this_idx2$ny), mean(this_idx2$yn))
text2= text2/unique(test1$f1)

text2= round(text2, digits= 2)

p2 <- (ggplot()+ 
  geom_bar(aes(x= "No/No", y= after_stat(text2[1])))+
  geom_bar(aes(x= "Yes/Yes", y= after_stat(text2[2])))+
  geom_bar(aes(x= "No/Yes", y= after_stat(text2[3])))+
  geom_bar(aes(x= "Yes/No", y= after_stat(text2[4])))+
  geom_text(aes(x= "No/No", y= text2[1]+0.17, label = text2[1]))+
  geom_text(aes(x= "Yes/Yes", y= text2[2]+0.17, label = text2[2]))+
  geom_text(aes(x= "No/Yes", y= text2[3]+0.17, label = text2[3]))+
  geom_text(aes(x= "Yes/No", y= text2[4]+0.17, label = text2[4]))+
    theme(text = element_text(size=15))+  theme(panel.grid.major = element_line(colour= "black", size= 0.1))+ 
  labs(x= "Predictions Versus Outcomes", y= "Response Type Proportion", title= "Model 2: OP, RT, & List")+ ylim(0,1))
p2
ggsave("mod2_newway.png", device= "png", dpi= 300, height= 10, width= 7)

#Mod 3
this_idx3= data.table()
this_idx3 = this_idx
this_idx3$nn <- 0
this_idx3$yn <- 0
this_idx3$yy <- 0
this_idx3$ny <- 0

# Switch around the order of these
# Divide subjects by length of their respective data points (however many responses for that 'condition'/my_data[subject== nsubj[i]])
for (i in 1:length(nsubj)){
    this_idx3[i]$nn <- length(my_data[subject== nsubj[i] & f3vals<0.5 & recalled == "NO"]$recalled)
    this_idx3[i]$yy <- length(my_data[subject== nsubj[i] & f3vals>0.5 & recalled == "YES"]$recalled)
    this_idx3[i]$ny <- length(my_data[subject== nsubj[i] & f3vals<0.5 & recalled == "YES"]$recalled)
    this_idx3[i]$yn <- length(my_data[subject== nsubj[i] & f3vals>0.5 & recalled == "NO"]$recalled)
}

text3= c(mean(this_idx3$nn), mean(this_idx3$yy), mean(this_idx3$ny), mean(this_idx3$yn))
text3= round(text3, digits= 2)

p3 <- (ggplot()+ 
  geom_bar(aes(x= "No/No", y= after_stat(text3[1])))+
  geom_bar(aes(x= "Yes/Yes", y= after_stat(text3[2])))+
  geom_bar(aes(x= "No/Yes", y= after_stat(text3[3])))+
  geom_bar(aes(x= "Yes/No", y= after_stat(text3[4])))+
  geom_text(aes(x= "No/No", y= text3[1]+0.17, label = text3[1]))+
  geom_text(aes(x= "Yes/Yes", y= text3[2]+0.17, label = text3[2]))+
  geom_text(aes(x= "No/Yes", y= text3[3]+0.17, label = text3[3]))+
  geom_text(aes(x= "Yes/No", y= text3[4]+0.17, label = text3[4]))+ theme(text = element_text(size=15))+ theme(panel.grid.major = element_line(colour= "black", size= 0.1))+
  labs(x= "Predictions Versus Outcomes", y= "Response Type Proportion", title= "Model 3: Lag, RT, & List")+ ylim(0,1))
p3
ggsave("mod3_newway.png", device= "png", dpi= 300)



all_plots <- (cowplot::plot_grid(p1,p2, p3))
ggsave("all_mods_newway.png", device= "png", dpi= 300, height= 10, width= 10)
all_plots


my_data[subject== nsubj[1]]$f1vals


unique(this_idx$nn)
unique(this_idx$yy)
unique(this_idx$ny)
unique(this_idx$yn)

unique(this_idx2$nn)
unique(this_idx2$yy)
unique(this_idx2$ny)
unique(this_idx2$yn)

unique(this_idx3$nn)
unique(this_idx3$yy)
unique(this_idx3$ny)
unique(this_idx3$yn)


# Model 1 Counts
this_idx <- data.table()
this_idx$yy <- my_data$subject
this_idx$yy <- 0
this_idx$nn <- this_idx$yy
this_idx$yn <- this_idx$yy
this_idx$ny <- this_idx$yy
counter <- vector()
  counter <- nsubj
for (i in 1:length(nsubj)){
  # Actual YES & Predicted YES
  this_idx$yy[i] <- length(my_data[subject== nsubj[i] & recalled == "YES" & f1vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  if (length(my_data[subject== nsubj[i] & f1vals<0.5 & recalled== "NO"]$recalled)+ length(my_data[subject== nsubj[i] & f1vals<0.5 & recalled== "YES"]$recalled)+ length(my_data[subject== nsubj[i] & f1vals>0.5 & recalled== "NO"]$recalled)+ length(my_data[subject== nsubj[i] & f1vals>0.5 & recalled== "YES"]$recalled)== length(my_data[subject== nsubj[i]]$recalled)){
    counter[i] <- 1
  }
    else {
      counter[i] <- 0
    }
}
      
for (i in 1:length(nsubj)){  
  # Actual NO & Predicted NO
  this_idx$nn[i] <- length(my_data[subject== nsubj[i] & recalled == "NO" & f1vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual YES & Predicted NO
  this_idx$yn[i] <- length(my_data[subject== nsubj[i] & recalled == "YES" & f1vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted YES
  this_idx$ny[i] <- length(my_data[subject== nsubj[i] & recalled == "NO" & f1vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
}
  
f1_avg <- vector()
f1_avg <- c(mean(this_idx$yy[this_idx$yy>0]), mean(this_idx$nn[this_idx$yy>0]), mean(this_idx$yn[this_idx$yy>0]), mean(this_idx$ny[this_idx$yy>0]))

# Model 2 Counts
this_idx2 <- data.table()
this_idx2$yy <- my_data$subject
this_idx2$yy <- 0
this_idx2$nn <- this_idx2$yy
this_idx2$yn <- this_idx2$yy
this_idx2$ny <- this_idx2$yy

for (i in 1:length(nsubj)){
  # Actual YES & Predicted YES
  this_idx$yy[i] <- length(my_data[subject== nsubj[i] & recalled == "YES" & f1vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  if (length(my_data[subject== nsubj[i] & f1vals<0.5 & recalled== "NO"]$recalled)+ length(my_data[subject== nsubj[i] & f1vals<0.5 & recalled== "YES"]$recalled)+ length(my_data[subject== nsubj[i] & f1vals>0.5 & recalled== "NO"]$recalled)+ length(my_data[subject== nsubj[i] & f1vals>0.5 & recalled== "YES"]$recalled)== length(my_data[subject== nsubj[i]]$recalled)){
    counter[i] <- 1
  }
    else {
      counter[i] <- 0
    }
}


for (i in 1:length(nsubj)){
  # Actual YES & Predicted YES
  this_idx2$yy[i] <- length(my_data[subject== nsubj[i] & recalled == "YES" & f2vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted NO
  this_idx2$nn[i] <- length(my_data[subject== nsubj[i] & recalled == "NO" & f2vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual YES & Predicted NO
  this_idx2$yn[i] <- length(my_data[subject== nsubj[i] & recalled == "YES" & f2vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted YES
  this_idx2$ny[i] <- length(my_data[subject== nsubj[i] & recalled == "NO" & f2vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
}

f2_avg <- vector()
f2_avg <- c(mean(this_idx2[yy>0]$yy),mean(this_idx2[yy>0]$nn),mean(this_idx2[yy>0]$yn),mean(this_idx2[yy>0]$ny))


# Model 3 Counts 
this_idx3 <- data.table()
this_idx3$yy <- my_data$subject
this_idx3$yy <- 0
this_idx3$nn <- this_idx3$yy
this_idx3$yn <- this_idx3$yy
this_idx3$ny <- this_idx3$yy


for (i in 1:length(nsubj)){
  # Actual YES & Predicted YES
  this_idx3$yy[i] <- length(my_data[subject== nsubj[i] & recalled == "YES" & f3vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted NO
  this_idx3$nn[i] <- length(my_data[subject== nsubj[i] & recalled == "NO" & f3vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual YES & Predicted NO
  this_idx3$yn[i] <- length(my_data[subject== nsubj[i] & recalled == "YES" & f3vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted YES
  this_idx3$ny[i] <- length(my_data[subject== nsubj[i] & recalled == "NO" & f3vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
}

f3_avg <- vector()
f3_avg <- c(mean(this_idx3[yy>0]$yy),mean(this_idx3[yy>0]$nn),mean(this_idx3[yy>0]$yn),mean(this_idx3[yy>0]$ny))


ggplot()+ 
  geom_bar(aes(x= "Yes/Yes", y= after_stat(mean(f1_avg[1]))))+
  geom_bar(aes(x= "No/No", y= after_stat(mean(f1_avg[2]))))+
  geom_bar(aes(x= "Yes/No", y= after_stat(mean(f1_avg[3]))))+
  geom_bar(aes(x= "No/Yes", y= after_stat(mean(f1_avg[4]))))+ labs(x= "Outcomes versus Predictions", y= "Proportion")

############ Mod 3 splitting bar graphs ###################
this_idx3 <- data.table()
this_idx3$yy <- my_data$subject
this_idx3$yy <- 0
this_idx3$nn <- this_idx3$yy
this_idx3$yn <- this_idx3$yy
this_idx3$ny <- this_idx3$yy
for (i in 1:length(nsubj)){
  # Actual YES & Predicted YES
  this_idx3$y1[i] <- length(my_data[subject== nsubj[i] & recalled == "YES"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx3$y2[i] <- length(my_data[subject== nsubj[i] & f3vals<0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted NO
  this_idx3$n1[i] <- length(my_data[subject== nsubj[i] & recalled == "NO"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx3$n2[i] <- length(my_data[subject== nsubj[i] & f3vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual YES & Predicted NO
  this_idx3$yn1[i] <- length(my_data[subject== nsubj[i] & recalled == "YES"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx3$yn2[i] <- length(my_data[subject== nsubj[i] & f3vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted YES
  this_idx3$ny1[i] <- length(my_data[subject== nsubj[i] & recalled == "NO"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
 this_idx3$ny2[i] <- length(my_data[subject== nsubj[i] &  f3vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
}
f3_avg <- vector()
f3_avg <- c(mean(this_idx3$y1),mean(this_idx3$y2),mean(this_idx3$n1),mean(this_idx3$n2), mean(this_idx3$yn1),mean(this_idx3$yn2),mean(this_idx3$ny1),mean(this_idx3$ny2))
########### Mod 2 splitting bar graphs ################
this_idx2 <- data.table()
this_idx2$yy <- my_data$subject
this_idx2$yy <- 0
this_idx2$nn <- this_idx2$yy
this_idx2$yn <- this_idx2$yy
this_idx2$ny <- this_idx2$yy

for (i in 1:length(nsubj)){
  # Actual YES & Predicted YES
  this_idx2$y1[i] <- length(my_data[subject== nsubj[i] & recalled == "YES"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx2$y2[i] <- length(my_data[subject== nsubj[i] & f1vals<0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted NO
  this_idx2$n1[i] <- length(my_data[subject== nsubj[i] & recalled == "NO"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx2$n2[i] <- length(my_data[subject== nsubj[i] & f1vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual YES & Predicted NO
  this_idx2$yn1[i] <- length(my_data[subject== nsubj[i] & recalled == "YES"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx2$yn2[i] <- length(my_data[subject== nsubj[i] & f1vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted YES
  this_idx2$ny1[i] <- length(my_data[subject== nsubj[i] & recalled == "NO"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
 this_idx2$ny2[i] <- length(my_data[subject== nsubj[i] &  f1vals> 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
}


f2_avg <- vector()
f2_avg <- c(mean(this_idx2$y1),mean(this_idx2$y2),mean(this_idx2$n1),mean(this_idx2$n2), mean(this_idx2$yn1),mean(this_idx2$yn2),mean(this_idx2$ny1),mean(this_idx2$ny2))

########### Mod 1 splitting bar graphs ################
this_idx <- data.table()
this_idx$yy <- my_data$subject
this_idx$yy <- 0
this_idx$nn <- this_idx$yy
this_idx$yn <- this_idx$yy
this_idx$ny <- this_idx$yy

for (i in 1:length(nsubj)){
  # Actual YES & Predicted YES
  this_idx$y1[i] <- length(my_data[subject== nsubj[i] & recalled == "YES"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx$y2[i] <- length(my_data[subject== nsubj[i] & f1vals>0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  # Actual NO & Predicted NO
  this_idx$n1[i] <- length(my_data[subject== nsubj[i] & recalled == "NO"]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
  this_idx$n2[i] <- length(my_data[subject== nsubj[i] & f1vals< 0.5]$recalled)/length(my_data[subject == nsubj[i]]$recalled)
}
subj_idx <- data.table()
subj_idx$yes <- nsubj
subj_idx$no <- nsubj



for (i in 1:length(nsubj)){
  subj_idx$yes[i] <- length(my_data[subject== nsubj[i] & recalled== "YES"]$subject)/length(my_data[subject== nsubj[i]]$recalled)
  subj_idx$no[i] <- length(my_data[subject== nsubj[i] & recalled== "NO"]$subject)/length(my_data[subject== nsubj[i]]$recalled)
}







f1_avg <- vector()
f1_avg <- c(mean(this_idx$y1),mean(this_idx$y2),mean(this_idx$n1),mean(this_idx$n2))

################### PLOTS ############################
ggplot()+ 
  geom_bar(aes(x= "Outcome Yes", y= after_stat(mean(f1_avg[1]))))+
  geom_bar(aes(x= "Prediction Yes", y= after_stat(mean(f1_avg[2]))))+
  geom_bar(aes(x= "Outcome No", y= after_stat(mean(f1_avg[3]))))+
  geom_bar(aes(x= "Prediction No", y= after_stat(mean(f1_avg[4]))))







+ labs(x= "Outcomes versus Predictions", y= "Proportion")

###
m1 <- data.table()
m1$r <- c(0,0)
m1$p <- c(0,0)

m1$r[1] <- length(my_data[recalled== "YES"]$recalled)/length(my_data$recalled)
m1$r[2] <- length(my_data[recalled== "NO"]$recalled)/length(my_data$recalled)


m1$p[1]<- length(my_data[f1vals>0.5]$recalled)/length(my_data$recalled)
m1$p[2]<- length(my_data[f1vals<0.5]$recalled)/length(my_data$recalled)

###
m2 <- data.table()
m2$r <- c(0,0)
m2$p <- c(0,0)

m2$r[1] <- length(my_data[recalled== "YES"]$recalled)/length(my_data$recalled)
m2$r[2] <- length(my_data[recalled== "NO"]$recalled)/length(my_data$recalled)


m2$p[1]<- length(my_data[f2vals>0.5]$recalled)/length(my_data$recalled)
m2$p[2]<- length(my_data[f2vals<0.5]$recalled)/length(my_data$recalled)

###
m3 <- data.table()
m3$r <- c(0,0)
m3$p <- c(0,0)

m3$r[1] <- length(my_data[recalled== "YES"]$recalled)/length(my_data$recalled)
m3$r[2] <- length(my_data[recalled== "NO"]$recalled)/length(my_data$recalled)


m3$p[1]<- length(my_data[f3vals>0.5]$recalled)/length(my_data$recalled)
m3$p[2]<- length(my_data[f3vals<0.5]$recalled)/length(my_data$recalled)

p1<- ggplot() + geom_bar(aes(x= c("Yes P", "Yes R"), y= after_stat(c(mean(subj_idx$yes), m1$p[1])), fill= c("Predicted", "Recalled")))+
geom_bar(aes(x= c("No P", "No R"), y= after_stat(c(mean(subj_idx$no), m1$p[2])),fill= c("Predicted", "Recalled")))+ labs(fill= "Model Predictions vs. Responses", x= "Outcome Type", y= "Proportion of Outcomes", title= "Model 1")+ ylim(0,1)+
  geom_text(aes(x= "Yes P", y= m1$p[1]+0.1, label = round(m1$p[1], digits= 2)))+
  geom_text(aes(x= "No P", y= m1$p[2], label = round(m1$p[2], digits= 2)))+
  geom_text(aes(x= "No R", y= mean(subj_idx$no)+ 0.25, label = round(mean(subj_idx$no), digits= 2)))
p1

p2<- ggplot() + geom_bar(aes(x= c("Yes P", "Yes R"), y= after_stat(c(mean(subj_idx$yes), m2$p[1])), fill= c("Predicted", "Recalled")))+
geom_bar(aes(x= c("No P", "No R"), y= after_stat(c(mean(subj_idx$no), m2$p[2])),fill= c("Predicted", "Recalled")))+ labs(fill= "Model Predictions vs. Responses", x= "Outcome Type", y= "Proportion of Outcomes", title= "Model 2")+ ylim(0,1)+  
  geom_text(aes(x= "No R", y= mean(subj_idx$no)+0.17, label = text1[1]))+
  geom_text(aes(x= "Yes P", y= m1$p[1]+0.17, label = text1[2]))+
  geom_text(aes(x= "No P", y= m1$p[2]+0.17, label = text1[3]))+
  geom_text(aes(x= "Yes R", y=mean(subj_idx$yes)+0.17, label = text1[4]))
p2

p3<- ggplot() + geom_bar(aes(x= c("Yes P", "Yes R"), y= after_stat(c(mean(subj_idx$yes), m3$p[1])), fill= c("Predicted", "Recalled")))+
geom_bar(aes(x= c("No P", "No R"), y= after_stat(c(mean(subj_idx$no), m3$p[2])),fill= c("Predicted", "Recalled")))+ labs(fill= "Model Predictions vs. Responses", x= "Outcome Type", y= "Proportion of Outcomes", title= "Model 3")+ ylim(0,1)+  geom_text(aes(x= "No/No", y= text1[1]+0.17, label = text1[1]))+
  geom_text(aes(x= "Yes/Yes", y= text1[2]+0.17, label = text1[2]))+
  geom_text(aes(x= "No/Yes", y= text1[3]+0.17, label = text1[3]))+
  geom_text(aes(x= "Yes/No", y= text1[4]+0.17, label = text1[4]))

cowplot::plot_grid(p1,p2, p3)
ggsave("all_mods_method1.png", device= "png", dpi= 300, height= 10, width= 7)
