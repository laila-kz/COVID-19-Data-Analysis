#-----------------COVID-19 Data Analysis in R-------------------------------
#Goal : explore factores related to mortality 

#------0. Setup-------
rm(list=ls()) #remove all the variables stored previously
library(Hmisc) # for describe()
library(ggplot2) # for visualization
library(effsize) # for effect size (Cohen's d)

# --- 1. Load and Inspect Data ---
data <- read.csv("C:/Users/kheza/Downloads/COVID19_line_list_data.csv")
data <- subset(data, !is.na(age) & !is.na(gender))

# Quick overview of the dataset
describe(data)
colSums(is.na(data))

# --- 2. Data Cleaning ---
#create a new binary column (1 = death, 0 = survived)
data$death_dummy <- as.integer(data$death != 0)

# Remove rows with missing key variables (age, gender) if necessary
data <- subset(data, !is.na(age) & !is.na(gender))

# --- 3. Overall Mortality Rate ---
#calculate death rate
death_rate <- sum(data$death_dummy) / nrow(data)
death_rate


# --- 4. Age Analysis ---
# Claim: People who die are older than people who survive
dead = subset(data, death_dummy ==1)
alive = subset(data, death_dummy == 0)

mean(dead$age, na.rm = TRUE) # mean age of deceased
mean(alive$age, na.rm= TRUE) # mean age of survivors

# Statistical significance test:
#diff between dead and alive is around 20 yo ,is this statistacly significant
t.test(alive$age, dead$age, alternative="two.sided", conf.level=0.99)

#are age ditributions normal ? If not, use non-parametric test
#Wilcoxon rank-sum test
wilcox.test(alive$age, dead$age)

# Effect size: Cohen's d (strength of difference)
cohen.d(dead$age, alive$age, na.rm=TRUE)
#The age difference between patients who died and those who survived is large in practical terms (Cohen’s d ≈ 1.17, 95% CI [0.90, 1.44]). This indicates that age is a strong predictor of mortality in this dataset

# Age distribution by death status
ggplot(data, aes(x=age,fill = factor(death_dummy))) +
  geom_histogram(position = "dodge", binwidth =5 ) +
  labs(fill ="Death", title = "Age Distribution by Survival Status")

#normally if p-value <0.05 ,we reject null hypothesis
#here , p-value~ 0, so we reject the null hypothesis and 
#conclude that this is statistically significant


# --- 5. Gender Analysis ---
# Claim: Mortality differs between men and women
men  = subset(data, gender == "male")
women  =subset(data, gender == "female")


mean(men$death_dummy, na.rm = TRUE) ## male mortality rate 8.4%
mean(women$death_dummy, na.rm= TRUE)# #female mortality rate 3.7%

# Test difference in proportions (men vs women mortality rates)
t.test(men$death_dummy, women$death_dummy, alternative="two.sided", conf.level=0.99)

#99% confidence : men have from 0.8% to 8.8%higher chance of dying 
#p-value = 0.002< 0.05 so this is statisticlly signiifcant 


# Categorical vs binary outcome → Chi-squared test
table_gender <- table(data$gender,data$death_dummy)
chisq.test(table_gender)

# Confidence intervals for mortality rates
prop.test(sum(men$death_dummy, na.rm = TRUE), nrow(men))
prop.test(sum(women$death_dummy, na.rm = TRUE), nrow(women))

#Death rate by gender
ggplot(data,aes(x=gender, y=death_dummy)) +
  stat_summary(fun = mean , geom ="bar")+
  labs(title = "Death Rate by Gender", y = "Mortality Rate")

# --- 6. Multivariate Analysis ---
# Mortality might depend on age, gender, and other factors
#logistic regression model
model <- glm(death_dummy ~ age +gender, data=data,family=binomial)
summary(model)

#odds ratios with confidence intervals (easier interpretation)
exp(cbind(OddsRatio = coef(model), confint(model)))

#visualization of logistic regression fit: probability of death vs age by gender
ggplot(data, aes(x = age, y = death_dummy, color = gender)) +
  geom_jitter(alpha = 0.3) +
  stat_smooth(method = "glm", method.args = list(family = "binomial")) +
  labs(title = "Logistic Regression: Probability of Death by Age and Gender",
       y = "Probability of Death")

# --- 7. Conclusion (to include in report) ---
# - Age difference between deceased and survivors is large (Cohen’s d ~ 1.2, very large effect).
# - Mortality is significantly higher in men than women (Chi-square and CI confirm).
# - Logistic regression shows both age and gender are strong predictors of mortality.
# - Visualizations support the statistical findings.

