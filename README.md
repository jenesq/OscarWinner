
# Predicting the Future Oscar Winners from the Nominations

This project used three datasets with over 72,000 rows of data for movie nominations and winners dating back to 1903.    

## Project Description    

I completed this project for my Data Science practicum II. I thought it would be a fun project to practice my skills on.   
I anlayzed four datasets to complete this project.  Three of the datasets were downloaded from www.statcruch.com.  The Academy Awards dataset was downloaded from https://www.kaggle.com/theacademy/academy-awards/data.     
       
## Project Inspiration   
My project inspiration was to answer the following questions:    
- Build a model that predicts the next Oscar in any Academy Award category by inputting the nominated movies.    
- What variables are significant in predicting an Oscar winning movie?    
- Are movie rankings directly correlated to Oscar winning movies?    
- Are there any trends between movie genre and sales?    
- Is there a relationship between IMDB rating, number of votes, and Oscar winners?    

## Observations on the quality of the data    
The three datasets were user friendly and clean.     
- Dataset 1: Academy Awards - 8,381 observations and 6 variables      
- Dataset 2: Budget/Earnings - 5,222 observations and 7 variables     
- Dataset 3: IMDB - 58,786 observations and 25 variables        
    
The fourth dataset was created in R using SQL by bringing together the three above datasets.        
- Dataset 4: Combined Dataset - 2,143 observations and 36 variables    
    
I completed this project using R and Tableau.  The joining of tables, GLM and Neuralnet were built within R.  The exploratory data was completed in Tableau.  
    
I used the following code in order to combine the three datasets:    
data = sqldf("SELECT IMDB.*,BudEarn.* FROM IMDB    
INNER JOIN BudEarn ON IMDB.Title = BudEarn.Movie")    
str(data)    
data$Movie=NULL    
data = sqldf("SELECT data.*,Academy.* FROM data    
INNER JOIN Academy ON data.title = Academy.FilmName")    
data$FilmName=NULL    
data    
str(data)    
summary(data) 

The data columns in the final combined dataset are: movieid, title,	year, length, budget, rating, votes, r1, r2, r3, r4, r5, r6, r7,	r8,	r9, r10, mpaa, action, animation, comedy, drama, documentary, romance, short, month, day, releaseyear, budget($M), domesticGross($M), worldwideGross($M), awardyear, awardceremony, awardtype, awardWinner, awardnomineename.      
           
  
## Export dataset to excel to make sure it is what I want    
write.csv(data, "C:/Users/Jenny Esquibel/Dropbox/Jenny Folder/Data Science Masters/MSDS 696 - Practicum II/CurrentMovieData.xlsx")    
        
## Exploratory Data Analysis (EDA):    
    

## Data Cleaning:    
    
I noticed my variables needed to be converted:    
    
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
   
   
### Building the Models:    

I needed the following libraries to run my models:    
install.packages("sqldf")    
install.packages("lubridate")    
library(sqldf)    
library(readxl)    
library(lubridate)    
library(caTools)    
library(caret)    
library(MASS)       
       
    

## Analysis results    


    
## References:    

 
