#Packages
install.packages("sqldf")
install.packages("lubridate")
install.packages("neuralnet")
install.packages("caret")
install.packages("ipred")
library(sqldf)
library(readxl)
library(lubridate)
library(caTools)
library(caret)
library(MASS)
library(neuralnet)
library(caret)
library(ipred)


#Load Data Sets
BudEarn <- read_excel("C:/Users/Jenny Esquibel/Dropbox/Jenny Folder/Data Science Masters/MSDS 696 - Practicum II/Budget-Earnings.xlsx")
str(BudEarn)
IMDB <- read_excel("C:/Users/Jenny Esquibel/Dropbox/Jenny Folder/Data Science Masters/MSDS 696 - Practicum II/IMDB.xlsx")
Academy<- read_excel("C:/Users/Jenny Esquibel/Dropbox/Jenny Folder/Data Science Masters/MSDS 696 - Practicum II/AcademyAwards.xlsx")


#Combine Data sets with SQl
data = sqldf("SELECT IMDB.*,BudEarn.* FROM IMDB
INNER JOIN BudEarn ON IMDB.Title = BudEarn.Movie")
data$Movie=NULL
data = sqldf("SELECT data.*,Academy.* FROM data
INNER JOIN Academy ON data.title = Academy.FilmName")
data$FilmName=NULL
data
str(data)
summary(data)
#Export dataset to excel to make sure it is what I want
write.csv(data, "/Users/Jenny Esquibel/Dropbox/Jenny Folder/Data Science Masters/MSDS 696 - Practicum II/CurrentMovieData.csv")

#Checking and adjusting variable types
str(data)
data$budget=as.numeric(data$budget)
data$mpaa=as.factor(data$mpaa)
data$Animation=as.factor(data$Animation)
data$Action=as.factor(data$Action)
data$Comedy=as.factor(data$Comedy)
data$Drama=as.factor(data$Drama)
data$Documentary=as.factor(data$Documentary)
data$Romance=as.factor(data$Romance)
data$Short=as.factor(data$Short)
data$AwardWinner=as.factor(data$AwardWinner)
data$Month=as.factor(data$Month)
data$AwardType=as.factor(data$AwardType)
data$releasedate <- with(data, ymd(sprintf('%04d%02d%02d', ReleaseYear, Month, Day)))
data$releasedate
summary(data)
dim(data)
str(data)

#######################################################################################################################
######################################################################################################################

#PHASE 1:


## Look at Correlations#Correlations Matrix (Function borrowed from https://gist.github.com/talegari/b514dbbc651c25e2075d88f31d48057b):
df=data[,c(35,4,5,6,7,18,19,20,21,22,24,26,28,30,33,34,31)]
str(df)
cor2 = function(df){
  
  stopifnot(inherits(df, "data.frame"))
  stopifnot(sapply(df, class) %in% c("integer"
                                     , "numeric"
                                     , "factor"
                                     , "character"))
  
  cor_fun <- function(pos_1, pos_2){
    
    # both are numeric
    if(class(df[[pos_1]]) %in% c("integer", "numeric") &&
       class(df[[pos_2]]) %in% c("integer", "numeric")){
      r <- stats::cor(df[[pos_1]]
                      , df[[pos_2]]
                      , use = "pairwise.complete.obs"
      )
    }
    
    # one is numeric and other is a factor/character
    if(class(df[[pos_1]]) %in% c("integer", "numeric") &&
       class(df[[pos_2]]) %in% c("factor", "character")){
      r <- sqrt(
        summary(
          stats::lm(df[[pos_1]] ~ as.factor(df[[pos_2]])))[["r.squared"]])
    }
    
    if(class(df[[pos_2]]) %in% c("integer", "numeric") &&
       class(df[[pos_1]]) %in% c("factor", "character")){
      r <- sqrt(
        summary(
          stats::lm(df[[pos_2]] ~ as.factor(df[[pos_1]])))[["r.squared"]])
    }
    
    # both are factor/character
    if(class(df[[pos_1]]) %in% c("factor", "character") &&
       class(df[[pos_2]]) %in% c("factor", "character")){
      r <- lsr::cramersV(df[[pos_1]], df[[pos_2]], simulate.p.value = TRUE)
    }
    
    return(r)
  } 
  
  cor_fun <- Vectorize(cor_fun)
  
  # now compute corr matrix
  corrmat <- outer(1:ncol(df)
                   , 1:ncol(df)
                   , function(x, y) cor_fun(x, y)
  )
  
  rownames(corrmat) <- colnames(df)
  colnames(corrmat) <- colnames(df)
  
  return(corrmat)
}
cor2(df)

#Step AIC
df$AwardWinner=as.numeric(df$AwardWinner)
AICMod <- glm(AwardWinner ~ ., data=df)
modelAward.AIC <- stepAIC(AICMod, direction=c("both"))
modelAward.AIC

#Used the AIC results to select variables for GLM
str(df)
df2=df[,c(1,2,3,4,7,11,12,13,16,17)]
str(df2)

#GLM Model For AwardWinner w/AIC
df2$AwardWinner[df2$AwardWinner == "1"] = "0"
df2$AwardWinner[df2$AwardWinner == "2"] = "1"
df2$AwardWinner=as.factor(df2$AwardWinner)
split = sample.split(df2$AwardWinner, SplitRatio = 0.7)
trainset = subset(df2, split == TRUE)
testset = subset(df2, split == FALSE)
modelAward <- glm(AwardWinner ~ ., data=trainset,family="binomial")
summary(modelAward)

predAward<-predict(modelAward,testset)
predAward2<- ifelse(c(predAward) > 0,1,0)
predictAward3=as.vector(predAward2)
table(testset$AwardWinner, predictAward3)
AccuracyAIC <-(250+54)/(250+54+87+38)
AccuracyAIC

#GLM Model For AwardWinner w/o AIC
df$AwardWinner[df$AwardWinner == "1"] = "0"
df$AwardWinner[df$AwardWinner == "2"] = "1"
df$AwardWinner=as.factor(df$AwardWinner)
split = sample.split(df$AwardWinner, SplitRatio = 0.8)
trainset = subset(df, split == TRUE)
testset = subset(df, split == FALSE)
modelAward <- glm(AwardWinner ~ ., data=trainset,family="binomial")
summary(modelAward)

predAward<-predict(modelAward,testset)
predAward2<- ifelse(c(predAward) > 0,1,0)
predictAward3=as.vector(predAward2)
table(testset$AwardWinner, predictAward3)
AccuracyAIC <-(166+37)/(166+37+65+26)
AccuracyAIC

#Random Forest Model Grid Search
df=data[,c(35,4,5,6,7,18,19,20,21,22,24,26,28,30,33,34,31)]
df=na.exclude(df)
df$Domestic=as.vector(df$`DomesticGross($M)`)
df$WorldWide=as.vector(df$`WorldwideGross($M)`)
df$`DomesticGross($M)`=NULL
df$`WorldwideGross($M)`=NULL
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid")
tunegrid <- expand.grid(.mtry=c(1:15))
rf_gridsearch <- train(as.factor(AwardWinner) ~., data=df, method="rf", tuneGrid=tunegrid, trControl=control)
print(rf_gridsearch)
plot(rf_gridsearch)


##########################################################################################################################
##########################################################################################################################

##PHASE 2##

#Subset for 1990 on:
dataModern <-subset(data, ReleaseYear >="1990")
str(dataModern)

## Look at Correlations -Modern Data
#Correlations Matrix (Function borrowed from https://gist.github.com/talegari/b514dbbc651c25e2075d88f31d48057b):
df=dataModern[,c(35,4,5,6,7,18,19,20,21,22,24,26,28,30,33,34,31)]
str(df)
cor2 = function(df){
  
  stopifnot(inherits(df, "data.frame"))
  stopifnot(sapply(df, class) %in% c("integer"
                                     , "numeric"
                                     , "factor"
                                     , "character"))
  
  cor_fun <- function(pos_1, pos_2){
    
    # both are numeric
    if(class(df[[pos_1]]) %in% c("integer", "numeric") &&
       class(df[[pos_2]]) %in% c("integer", "numeric")){
      r <- stats::cor(df[[pos_1]]
                      , df[[pos_2]]
                      , use = "pairwise.complete.obs"
      )
    }
    
    # one is numeric and other is a factor/character
    if(class(df[[pos_1]]) %in% c("integer", "numeric") &&
       class(df[[pos_2]]) %in% c("factor", "character")){
      r <- sqrt(
        summary(
          stats::lm(df[[pos_1]] ~ as.factor(df[[pos_2]])))[["r.squared"]])
    }
    
    if(class(df[[pos_2]]) %in% c("integer", "numeric") &&
       class(df[[pos_1]]) %in% c("factor", "character")){
      r <- sqrt(
        summary(
          stats::lm(df[[pos_2]] ~ as.factor(df[[pos_1]])))[["r.squared"]])
    }
    
    # both are factor/character
    if(class(df[[pos_1]]) %in% c("factor", "character") &&
       class(df[[pos_2]]) %in% c("factor", "character")){
      r <- lsr::cramersV(df[[pos_1]], df[[pos_2]], simulate.p.value = TRUE)
    }
    
    return(r)
  } 
  
  cor_fun <- Vectorize(cor_fun)
  
  # now compute corr matrix
  corrmat <- outer(1:ncol(df)
                   , 1:ncol(df)
                   , function(x, y) cor_fun(x, y)
  )
  
  rownames(corrmat) <- colnames(df)
  colnames(corrmat) <- colnames(df)
  
  return(corrmat)
}
cor2(df)

#Step AIC -Modern Data
df$AwardWinner=as.numeric(df$AwardWinner)
AICMod <- glm(AwardWinner ~ ., data=df)
modelAward.AIC <- stepAIC(AICMod, direction=c("both"))
modelAward.AIC

#Used the AIC results to select variables for glm - Modern Data
str(df)
df2=df[,c(1,2,3,4,7,8,11,13,17)]
str(df2)

#GLM Model For AwardWinner w/AIC -Modern Data
df2$AwardWinner[df2$AwardWinner == "1"] = "0"
df2$AwardWinner[df2$AwardWinner == "2"] = "1"
df2$AwardWinner=as.factor(df2$AwardWinner)
split = sample.split(df2$AwardWinner, SplitRatio = 0.7)
trainset = subset(df2, split == TRUE)
testset = subset(df2, split == FALSE)
modelAward <- glm(AwardWinner ~ ., data=trainset,family="binomial")
summary(modelAward)

predAward<-predict(modelAward,testset)
predAward2<- ifelse(c(predAward) > 0,1,0)
predictAward3=as.vector(predAward2)
table(testset$AwardWinner, predictAward3)
AccuracyAIC <-(156+12)/(156+12+49+6)
AccuracyAIC


#Random Forest Model-Modern data
df=dataModern[,c(35,4,5,6,7,18,19,20,21,22,24,26,28,30,33,34,31)]
df=na.exclude(df)
df$Domestic=as.vector(df$`DomesticGross($M)`)
df$WorldWide=as.vector(df$`WorldwideGross($M)`)
df$`DomesticGross($M)`=NULL
df$`WorldwideGross($M)`=NULL
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid")
tunegrid <- expand.grid(.mtry=c(1:15))
rf_gridsearch <- train(as.factor(AwardWinner) ~., data=df, method="rf", tuneGrid=tunegrid, trControl=control)
print(rf_gridsearch)
plot(rf_gridsearch)

#Neural Network Model-Modern data
df=dataModern[,c(35,4,5,6,7,18,19,20,21,22,24,26,28,30,33, 34,31)]
df=na.exclude(df)
df$Domestic=as.vector(df$`DomesticGross($M)`)
df$WorldWide=as.vector(df$`WorldwideGross($M)`)
df$`DomesticGross($M)`=NULL
df$`WorldwideGross($M)`=NULL
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid")
grid <- expand.grid(size=c(5,10,20,50), k=c(1,2,3,4,5))
rf_gridsearch <- train(as.factor(AwardWinner) ~., data=df, method="lvq", tuneGrid=grid, trControl=control,  tuneLength=5)
print(rf_gridsearch)
plot(rf_gridsearch)
