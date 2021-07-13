# install.packages("lme4", type= "binary")
library(lme4)
library(lmerTest)

# devtools::install_github("strengejacke/strengejacke")
# install.packages("data.table")
# install.packages("jtools")
library("jtools")
library("ggplot2")
library(lme4)
library("data.table")

dir <- getwd()
target_dir <- "/Users/rebeccawilder/First-Year-Project"
setwd(target_dir)

my_data <- read.csv(file= "govtrack-stats-2020-senate-ideology.csv")

senate <- data.table(my_data)

senate[, party_idx:= 0]
senate[ideology<0.57]$party_idx= 1
senate[ideology>0.57]$party_idx= 0
senate[name== "b'Manchin'"]$party_idx= 1
senate[name== "b'Murkowski'"]$party_idx= 0
senate[name== "b'Jones'"]$party_idx= 1
senate[st_homg := 0]
for (i in 1:length(unique(senate$state))){
  idx= unique(senate$state[i])
    print(senate[state== idx, 10])
}






mod1 <- lm(data= senate, formula= party_idx~ideology)
senate[,sen_fit:= fitted(mod1)]




summary(mod1)





ggplot(data= senate) + geom_smooth(aes(x= party_idx, ideology), method= "lm")+ geom_point(aes(x= ideology, y= sen_fit))

