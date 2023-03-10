# Data_Assessment.md

## Summary of Data
The Twitter Airline Sentiment dataset available on Kaggle contains 14,641 tweets(rows) about six major US airlines, including American, Delta, Southwest, United, US Airways, and Virgin America. The goal of the dataset is to classify the sentiment of each tweet as positive, negative, or neutral. The dataset was created by Crowdflower (now known as Figure Eight) by collecting tweets between February 2015 and February 2016 and asking the crowdworkers to classify the sentiment of each tweet. There is a variety of columns that ranged from the sentiment score, airline, timezone/location, and even description from each tweet.

## Data Assessment

### Data Size and Format:
The dataset is available in a CSV format with 14,641 rows and 15 columns. Each row represents a single tweet, and each column contains a different attribute of the tweet, such as the text of the tweet, the airline mentioned in the tweet, the sentiment of the tweet, and the location of the user who posted the tweet.

### Missing Values:
There are no missing values in the dataset. However, there are some tweets with missing information, such as the location of the user who posted the tweet.

### Overall Data Quality:
The quality of the dataset is good overall, with no obvious errors or anomalies. However, the text of the tweets contains a lot of noise, including hashtags, mentions, and links, which may affect the accuracy of sentiment analysis. 

### Potential Obstacles:
The main obstacles in this dataset are going to be the unreliability of human nature as seen in the text of the tweets. These have a lot of information that may be hard to interpret for a sentiment analysis model, sucha sarcasm. Otherwise most of the other information is straightforward or categorical that has value in our analysis.