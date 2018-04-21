#Packages
install.packages("sqldf")
install.packages("lubridate")
library(sqldf)
library(readxl)
library(lubridate)
library(caTools)
library(caret)
library(MASS)


#Load Data Sets
library(readxl)
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
write.csv(data, "/Users/Jenny Esquibel\Dropbox\Jenny Folder\Data Science Masters\MSDS 696 - Practicum II/CurrentMovieData.csv")

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

#Step AIC - to remove any unecessary variables
df$AwardWinner=as.numeric(df$AwardWinner)
AICMod <- glm(AwardWinner ~ ., data=df)
modelAward.AIC <- stepAIC(AICMod, direction=c("both"))
modelAward.AIC

#Used the AIC results to select variables for glm
str(df)
df2=df[,c(1,2,3,4,7,11,12,13,16,17)]
str(df2)

#GLM Model For AwardWinner w/AIC
df2$AwardWinner=as.numeric(df2$AwardWinner)
df2 <- df2[sample(1:nrow(df2)), ]
split = sample.split(df2$AwardWinner, SplitRatio = 0.7)
trainset = subset(df2, split == TRUE)
testset = subset(df2, split == FALSE)
modelAward <- glm(AwardWinner ~ ., data=trainset)
summary(modelAward)

predAward<-predict(modelAward,testset)
predAward2<- ifelse(c(predAward) > 1.40,1,0)
predictAward3=as.vector(predAward2)
testset$AwardWinner[testset$AwardWinner == "1"] = "0"
testset$AwardWinner[testset$AwardWinner == "2"] = "1"
table(testset$AwardWinner, predictAward3)
AccuracyAIC <-(201+84)/(201+84+33+277)
AccuracyAIC

#GLM Model For AwardWinner w/o AIC
df$AwardWinner=as.numeric(df$AwardWinner)
split = sample.split(df$AwardWinner, SplitRatio = 0.8)
trainset = subset(df, split == TRUE)
testset = subset(df, split == FALSE)
modelAward <- glm(AwardWinner ~ ., data=trainset)
summary(modelAward)

predAward<-predict.glm(modelAward,testset)
predAward2<- ifelse(c(predAward) > 1.40,1,0)
predictAward3=as.vector(predAward2)
testset$AwardWinner[testset$AwardWinner == "1"] = "0"
testset$AwardWinner[testset$AwardWinner == "2"] = "1"
table(testset$AwardWinner, predictAward3)
AccuracyLM <-(134+51)/(134+51+48+40)
AccuracyLM


#Random Forest Model
df=data[,c(35,4,5,6,7,18,19,20,21,22,24,26,28,30,33,31)]
df$Domestic=as.vector(df$`DomesticGross($M)`)
df$WorldWide=as.vector(df$`WorldwideGross($M)`)
df$`DomesticGross($M)`=NULL
df$`WorldwideGross($M)`=NULL
df=na.exclude(df)
split = sample.split(df$AwardWinner, SplitRatio = 0.7)
trainset = subset(df, split == TRUE)
testset = subset(df, split == FALSE)
RFMod <- randomForest(as.factor(AwardWinner) ~.,
                      data=trainset, 
                      ntree=5000)
RFPred <- predict(RFMod, testset)
table(testset$AwardWinner, RFPred)
AccuracyRF=(226+71)/(226+71+72+51)
AccuracyRF

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
AwardWinner ~ length + budget + rating + Action + Animation + 
  Romance + ReleaseYear + `WorldwideGross($M)`
df2=df[,c(1,2,3,4,7,8,11,13,17)]
str(df2)

#GLM Model For AwardWinner w/AIC -Modern Data
df2$AwardWinner=as.numeric(df2$AwardWinner)
df2 <- df2[sample(1:nrow(df2)), ]
split = sample.split(df2$AwardWinner, SplitRatio = 0.7)
trainset = subset(df2, split == TRUE)
testset = subset(df2, split == FALSE)
modelAward <- glm(AwardWinner ~ ., data=trainset)
summary(modelAward)

predAward<-predict(modelAward,testset)
predAward2<- ifelse(c(predAward) > 1.40,1,0)
predictAward3=as.vector(predAward2)
testset$AwardWinner[testset$AwardWinner == "1"] = "0"
testset$AwardWinner[testset$AwardWinner == "2"] = "1"
table(testset$AwardWinner, predictAward3)
AccuracyAIC <-(121+21)/(121+21+35+22)
AccuracyAIC

#GLM Model For AwardWinner w/o AIC
df$AwardWinner=as.numeric(df$AwardWinner)
split = sample.split(df$AwardWinner, SplitRatio = 0.7)
trainset = subset(df, split == TRUE)
testset = subset(df, split == FALSE)
modelAward <- glm(AwardWinner ~ ., data=trainset)
summary(modelAward)

predAward<-predict.glm(modelAward,testset)
predAward2<- ifelse(c(predAward) > 1.40,1,0)
predictAward3=as.vector(predAward2)
testset$AwardWinner[testset$AwardWinner == "1"] = "0"
testset$AwardWinner[testset$AwardWinner == "2"] = "1"
table(testset$AwardWinner, predictAward3)
AccuracyLM <-(132+24)/(132+24+31+16)
AccuracyLM


#Random Forest Model
df=dataModern[,c(35,4,5,6,7,18,19,20,21,22,24,26,28,30,33,31)]
df$Domestic=as.vector(df$`DomesticGross($M)`)
df$WorldWide=as.vector(df$`WorldwideGross($M)`)
df$`DomesticGross($M)`=NULL
df$`WorldwideGross($M)`=NULL
df=na.exclude(df)
split = sample.split(df$AwardWinner, SplitRatio = 0.7)
trainset = subset(df, split == TRUE)
testset = subset(df, split == FALSE)
RFMod <- randomForest(as.factor(AwardWinner) ~.,
                      data=trainset, 
                      ntree=5000)
RFPred <- predict(RFMod, testset)
table(testset$AwardWinner, RFPred)
AccuracyRF=(131+27)/(131+27+32+22)
AccuracyRF
