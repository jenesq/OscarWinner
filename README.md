
# Predicting the Next Oscar Winner

This dataset contains over  reports of Movie nominations and winners dating back to .    

## Project Description    

This project is for my Data Science practicum II. I thought it woudld be a fun project to practice my skills on.   
I collected the Movie data by downloading three datasets from the following websites:     
    
https://www.kaggle.com/theacademy/academy-awards/data    
https://www.statcrunch.com/app/index.php?dataid=1736023    
https://www.statcrunch.com/app/index.php?dataid=1958225    
https://www.statcrunch.com/5.0/shareddata.php?keywords=movies    
    
My inspiration was to answer the following questions:    
- 

## Observations on the quality of the data    

The three datasets were user friendly and little effort was needed to start coding.     

Dataset 1: Academy Awards - 8,381 observations and 6 variables    
Dataset 2: Budget/Earnings - 5,222 observations and 7 variables    
Dataset 3: IMDB - 58,786 observations and 25 variables    
    
Dataset 4: Combined Dataset - 2,143 observations and 36 variables    

I completed this project using R and Tableau.  The joining of tables, GLM and Neuralnet were built within R.  The exploratory data was completed in Tableau.  

The data columns in the final combined dataset are (movieid,	title,	year,	length,	budget,	rating,	votes,	r1,	r2,	r3,	r4,	r5,	r6,	r7,	r8,	r9, r10,	mpaa,	Action,	Animation,	Comedy,	Drama,	Documentary,	Romance,	Short,	Month,	Day,	ReleaseYear,	Budget($M),	DomesticGross($M),	WorldwideGross($M),	AwardYear,	AwardCeremony,	AwardType,	AwardWinner,	AwardNomineeName.    
        .          
  
## Combine the three datasets using a SQL command:    
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

 
