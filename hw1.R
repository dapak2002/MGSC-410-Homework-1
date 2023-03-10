duplicated_rows <- duplicated(Tweets)

twitter_clean <- subset(Tweets, !duplicated_rows)
twitter_clean <- twitter_clean[, c("airline_sentiment", "airline_sentiment_confidence", "airline", "retweet_count", "user_timezone")]

twitter_clean$airline[twitter_clean$airline == ""] <- "No airline"
twitter_clean$airline_sentiment[twitter_clean$airline_sentiment == ""] <- "No sentiment"
sum(is.na(twitter_clean$airline_sentiment_confidence))
head(twitter_clean)