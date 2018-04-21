
## PREDICTING THE NEXT OSCAR MOVIE WINNER

This dataset contains over  reports of Movie nominations and winners dating back to .    

## Project Description    

This project for my Data Science practicum II. I collected the Movie data by downloading three datasets from the NUFORC the following websites:     

 

My inspiration was to answer the following questions:    
- 

## Observations on the quality of the data    

The three datasets were user friendly and little effort was needed to start coding.     



I completed this project using R.  The exploratory data was completed in Tableau and the prediction code was doen with R.  The data columns in the final combined dataset are         .          
  
## Combine Data sets with SQl:    
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

 
