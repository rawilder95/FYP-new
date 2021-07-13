library(Stat2Data)
data("NFLStandings2016")
nfl <- data.table(NFLStandings2016)

lm(formula= WinPct ~ PointsFor + PointsAgainst, data= nfl)


library(car)
# install.packages("car", type= "binary")

# install.packages("car",dependencies=TRUE)
mod <- lm(WinPct ~PointsFor + PointsAgainst + TDs, data= nfl)
vif(mod)

