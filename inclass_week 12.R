library(Stat2Data)

library(data.table)

data(AccordPrice)
accord <- data.table(AccordPrice)

# 1a
mod1 <- lm(Price ~ Age, data=accord)
summary(mod1)

# Check to see if IV predicts mediator
mod2 <- lm(Mileage ~ Age, data=accord)
summary(mod2)

# Age does predict mileage

# Step 3: Does the mediator (mileage) predict the DV (price) after controlling for the IV (age)?
mod3 <- lm(Price ~ Age + Mileage, data=accord)
summary(mod3)
# Mileage is significant


# Step 4: Is the total effect larger than the direct effect?


# Step 1 Beta Value for IV
effect_magnitude_all <- abs(summary(m1)$coefficients[2,1]) 

# Step 3 Beta Value for IV
direct_effect_magnitude <- abs(summary(m3)$coefficients[2,1]) 

effect_magnitude_all > direct_effect_magnitude
# This indicates mediation


# We may infer that mileage is  mediates the relationship between age and price.  However, this is also likely a causal model because the age of the car inherently affects the possible max mileage on a car (the longer you have it the potential it has for more miles to have been driven), but the same is not true of mileage for price.

# 1b 

summary(mod3)
# This isn't a clear cut mediation (i.e. Age is significant in step 3).  The decrease in resale price isn't sourced entirely by mileage, only partially.  So our initial hypothesis is partially correct, in that the age of a car does, to an extent, affect resale price.  

# 1c
a <- summary(m2)$coefficients[2, 1]
b <- summary(m3)$coefficients[3, 1]
ab <- a*b

a_se <- summary(m2)$coefficients[2, 2]
b_se <- summary(m3)$coefficients[3, 2]
ab_se <- sqrt(a^2 * b_se^2 + b^2 * a_se^2)
z <- ab / ab_se

p <- pnorm(z) * 2
# p= 0.00415546, p is a significant mediator (very significant!)

# 1d
num_cars <- nrow(accord) # how many cars in in the dataset
loops <- 5000 # how many bootstrap samples do we want
car_dist <- c() # this will be our distribution

for (i in 1:loops) {
  # sample cars with replacement
  samp_cars <- sample(1:num_cars, num_cars, replace=TRUE)
  samp <- accord[samp_cars]
  # calculate a*b with your new sample
  bootstrap_m2 <- lm(Mileage ~ Age, data=samp)
  bootstrap_m3 <- lm(Price ~ Age + Mileage, data=samp)
  a <- summary(bootstrap_m2)$coefficients[2, 1]
  b <- summary(bootstrap_m3)$coefficients[3, 1]
  ab <- a*b
  # add this as a data point to the distribution
car_dist <- c(car_dist, ab)
}

car_dist <- sort(car_dist)
# Find middle 95% of data points 
lower <- 5000*.025 # 2.5% below idx
upper <- 5000*.975 # 2.5% above idx

# Confidence Interval CI[-0.7883642, -0.3929064]
# Although these will change with each time the simulation is run, it almost certain that our CI will not return 0, so we may glean that this is a significant mediation.  
car_dist[lower]
car_dist[upper]

