# R Code for introduction-to-logistic-regression.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Logistic Regression in R
        data <- read.csv("health_data.csv")
        model <- glm(Diabetes ~ Age + BMI, data = data, family = "binomial")
        summary(model)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Logistic Regression in R
        data <- read.csv("heart_data.csv")
        model <- glm(HeartDisease ~ Age + Cholesterol + Smoking, data = data, family = "binomial")
        summary(model)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

df<-read.csv("https://github.com/datasciencedojo/datasets/raw/refs/heads/master/titanic.csv")
colnames(df)
View(df)


#set reference groups
df$Survived <- relevel(as.factor(df$Survived), ref = "0") #survied/died
df$Pclass <- relevel(as.factor(df$Pclass), ref = "1") #reference will be 1st class
df$Sex <- relevel(as.factor(df$Sex), ref = "female") #female is the reference group

#continous
df$Age
table(is.na(df$Age), df$Survived)

#check levels
levels(df$Survived)
levels(df$Pclass)
levels(df$Sex)

#fit logistic regression
fit<-glm(Survived~Pclass+Sex+Age,family = "binomial",data=df)
summary(fit)

#get ORs
coef(fit) #logit coef
exp(coef(fit)) #Odds Ratios

#Pclass2 coef
#Estimate=0.27 odds of survival of 2nd class passengers divided by odds of survival for 1st class
#Being in 2nd Class (as compared to 1st Class), lowered your odds of Survival by (1-0.27), 0.73
# or 73%, adjusting for 3rd class, Sex and Age.

#Pclass3 coef
#Estimate=0.08 odds of survival of 3rd class passengers divided by odds of survival for 1st class
#Being in 3rd Class (as compared to 1st Class), lowered your odds of Survival by (1-0.08), 0.92
# or 92%, adjusting for 2nd class, Sex and Age.

#Sex=Male coef
#Estimate=0.08 odds of survival of Male passengers divided by odds of survival for Females
#Being a Male (as compared to Female), lowered your odds of Survival by (1-0.08), 0.92
# or 92%, adjusting for Class and Age.

#Age coef
#Estimate=0.96 odds of survival of 1 year increase in age
#For every 1 year increase in age a person was, their odds of survival decreased by (1-0.96) 0.04 or 4%
# while adjusting for Sex, and Class.

#For a passenger who was 10 years older, thier odds of survival decreased by 10*0.04=0.4 or 40%
#while adjusing for Sex and Class.