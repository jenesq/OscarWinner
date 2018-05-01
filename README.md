
# Predicting the Future Oscar Winners from the Nominations

This project used three datasets with over 72,000 rows of data for movie nominations and winners dating back to 1903.    

## Project Description    

I completed this project for my Data Science practicum II. I thought it would be a fun project to practice my skills on.   
I anlayzed four datasets to complete this project.  Two of the datasets were downloaded from www.statcruch.com.  The Academy Awards dataset was downloaded from https://www.kaggle.com/theacademy/academy-awards/data.     
       
## Project Inspiration   
My project inspiration was to answer the following questions:    
- Build a model that predicts the next Oscar winner in any Academy Award category by inputting the nominated movies.    
- Determine what variables are significant in predicting an Oscar winning movie?    
- Are movie rankings directly correlated to Oscar winning movies?    
- Are there any trends between movie genre and sales?    
- Is there a relationship between IMDB rating, number of votes, and Oscar winners?    

## Observations on the quality of the data    
The three datasets were user friendly and consistantly formated     
- Dataset 1: Academy Awards - 8,381 observations and 6 variables      
- Dataset 2: Budget/Earnings - 5,222 observations and 7 variables     
- Dataset 3: IMDB - 58,786 observations and 25 variables        
    
The fourth dataset was created in R using SQL by bringing together the three above datasets.        
- Dataset 4: Combined Dataset - 2,143 observations and 36 variables    
    
## Process for project
I completed this project using R and Tableau.  The joining of tables, (GLM) Regression, Random Forest, and a Neuralnet were built within R.  The exploratory data was completed in Tableau.  

## Data cleaning and preparation
- Data Preparation    
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
      
   - The final data variables in the combined dataset are: movieid, title, year, length, budget, rating, votes, r1, r2, r3, r4, r5, r6,  r7, r8, r9, r10, mpaa, action, animation, comedy, drama, documentary, romance, short, month, day, releaseyear, budget($M),       domesticGross($M), worldwideGross($M), awardyear, awardceremony, awardtype, awardWinner, awardnomineename.  

- Data Cleaning
I had variables that needed to be converted:       
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
   
- Checking the data after conversion:       
    summary(data)    
    dim(data)    
    str(data)     
  
    
           
  
## Export dataset to excel to make sure it is what I want    
write.csv(data, "C:/Users/Jenny Esquibel/Dropbox/Jenny Folder/Data Science Masters/MSDS 696 - Practicum II/CurrentMovieData.xlsx")    
        
## Exploratory Data Analysis (EDA):    
Most of the data exploration was performed in Tableau and moved to Tableu Public.  All chart descriptions are in the TableauPublic Charts.md file in this project.  The direct link to Tableau Public page is https://public.tableau.com/profile/jenny6450#!/.    

A few of the charts are in the data analysis section of this project.    

  
    

   
   
## Building the Models:    

I needed the following libraries to run my models:    
   install.packages("sqldf")    
   install.packages("lubridate")    
   library(sqldf)    
   library(readxl)    
   library(lubridate)    
   library(caTools)    
   library(caret)    
   library(MASS)       
       
### The models were designed in two phasees:    
Phase 1: Includes data in each year provided by websites   
- SQL to combine the three datasets    
- Correlation Model with all data years    
- Step AIC    
- GLM Model with AIC    
- GLM MOdel without AIC    
- Random Forest Model with Grid Search    
    
Phase 2: Includes only data from 1990 on (Modern Data)    
- Correclaton Model with a subet of data for 1990 on    
- Step AIC    
- GLM Model with AIC     
- GLM MOdel withou AIC     
- Random Forest Model with Grid Search    
- Neural Network    
   
#### Correlation Matrix
Phase 1: Looked at all years and used all variables.  The following varaibles were highly correlated:    
       - Domestic($M) and Worldwid($M) = .967
       - Award Ceremony & Award Type = .761    
       
Phase 2: Modern data and used all variables. The following variables were highly correlated:   
       - Domestic($M) and Worldwid($M) = .967    
       - Award Ceremony & Award Type = .761     
    

#### Step AIC    
Phase 1: Looked at all years and used all variables.  The following varaibles 10 variables were selected from the original 17 variables.        - AwardWinner, length, budget, rating, action, romance, month, releaseYear, AwardType, worldwideGross($M)    
    
Phase 2: Modern data and used all variables. The following varaibles 9 variables were selected from the original 17 variables.     
       - AwardWinner, length, budget, rating, action, animation, romance, releaseYear, worldwideGross($M)    

    
#### GLM Models    
Phase 1: All Data       
- Running with only the AIC variables:    
   - Accuracy = .708 ~ 71%    
   
- Running with all original variables:    
   - Accuracy = .690 ~ 69%    
    
Phase 2: Modern Data    
- Running with only the AIC variables:    
   - Accuracy = .725 ~ 73%    
   
- Running with all original variables:    
   - Accuracy = .690 ~ 69%    
   
#### Random Forest Models    
Phase 1: All Data       
- Running with all original variables:    
   - Accuracy = .706 ~ 71%    
    
Phase 2:  Modern Data     
- Running with all original variables:     
   - Accuracy = .747 ~ 75%    

#### Neural Network with the Modern Data
Phase 1: All Data      
- I did not run with all the data.  
    
Phase 2: Modern Data   
- Running with all original variables:     
   - Accuracy = .660 ~ 66%   


## Analysis results    


    
## References:    

 
