library(dplyr)
library(ggplot2)
library(caret)
library(tidyverse)

duplicated_rows <- duplicated(Tweets)

twitter_clean <- subset(Tweets, !duplicated_rows)
twitter_clean <- twitter_clean[, c("airline_sentiment", "text", "airline_sentiment_confidence", "airline", "negativereason", "user_timezone")]

twitter_clean$negativereason[twitter_clean$negativereason == ""] <- "No reason"
twitter_clean$user_timezone[twitter_clean$user_timezone == ""] <- "No timezone specified"
twitter_clean$airline_sentiment[twitter_clean$airline_sentiment == ""] <- "No sentiment"
sum(is.na(twitter_clean$airline_sentiment_confidence))
head(twitter_clean)


tweets_df <- Tweets
tweets_df %>%
  mutate(weekday = weekdays(as.Date(tweet_created))) %>%
  group_by(weekday, airline, airline_sentiment) %>%
  summarise(count=n()) %>%
  ggplot(aes(x=weekday, y=count, fill=airline_sentiment)) +
  geom_bar(stat="identity", position = "stack") +
  ggtitle("Sentiment Distribution of Tweets from Different Airlines on Each Day of the Week") +
  xlab("Weekday") +
  ylab("Count") +
  facet_grid(~ airline) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8))

tweets_df %>%
  mutate(tweet_length = nchar(text)) %>%
  group_by(airline, airline_sentiment) %>%
  ggplot(aes(x=airline_sentiment, y=tweet_length, fill=airline_sentiment)) +
  geom_boxplot() +
  ggtitle("Distribution of Tweet Sentiment by the Length of the Tweet for Each Airline") +
  xlab("Sentiment") +
  ylab("Tweet Length") +
  scale_fill_brewer(palette = "Set1") +
  theme_minimal()

tweets_df %>%
  group_by(airline_sentiment) %>%
  ggplot(aes(x=airline_sentiment, y=airline_sentiment_confidence, fill=airline_sentiment)) +
  geom_boxplot() +
  ggtitle("Distribution of Confidence Scores for Each Tweet Sentiment Category") +
  xlab("Sentiment") +
  ylab("Confidence Score") +
  scale_fill_brewer(palette = "Set1") +
  theme_minimal()

summary(twitter_clean)


ggplot(twitter_clean, aes(x = airline_sentiment, fill = airline_sentiment, group = sentiment)) + 
  geom_bar(color="blue", fill=rgb(0.1,0.4,0.5,0.7), aes(y = ..prop.., group = airline), stat = "count") +
  ggtitle("Distribution of Tweets by Sentiment and Airline") +
  xlab("Sentiment") +
  ylab("Proportion of Tweets") +
  scale_fill_discrete(name = "Sentiment") +
  scale_y_continuous(labels = scales::percent_format()) +
  facet_wrap(~ airline, ncol = 3)

negative_reasons <- twitter_clean %>%
  filter(airline_sentiment == "negative") %>%
  count(negativereason) %>%
  arrange(desc(n)) %>%
  top_n(10)

# Plot the bar chart
ggplot(negative_reasons, aes(x = reorder(negativereason, -n), y = n)) +
  geom_bar(stat = "identity", fill = "#0072B2") +
  xlab("") +
  ylab("Count") +
  ggtitle("Top 10 Negative Reasons") +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title.y = element_text(size = 14, face = "bold"),
        axis.text.x = element_text(size = 12, angle = 45, hjust = 1),
        axis.text.y = element_text(size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank())




# Load the dataset

# Split the dataset
# Remove all rows with "neutral" as its value for airline_sentiment

twitter_clean$airline_sentiment <- factor(twitter_clean$airline_sentiment)


# View the summary of the variable
summary(twitter_clean$airline_sentiment)

set.seed(123)
trainIndex <- createDataPartition(twitter_clean$airline_sentiment, p = .8, list = FALSE)
training <- twitter_clean[trainIndex,]
testing <- twitter_clean[-trainIndex,]

# Fit the logistic regression model
model <- glm(airline_sentiment ~ negativereason + airline + user_timezone, data = training, family = binomial)

# Evaluate the model
predictions <- predict(model, newdata = testing, type = "response")
predicted_classes <- ifelse(predictions > 0.5, "positive", "negative")

# Convert the predicted_classes to a factor with the same levels as testing$airline_sentiment
predicted_classes <- factor(predicted_classes, levels = levels(testing$airline_sentiment))

# Create a confusion matrix object
cm <- confusionMatrix(predicted_classes, testing$airline_sentiment)

# Convert the confusion matrix object to a data frame
cm_df <- as.data.frame(cm$table)

# Plot the confusion matrix
ggplot(data = cm_df, aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "steelblue") +
  geom_text(aes(label = Freq), color = "black", size = 5) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1)) +
  labs(title = "Confusion Matrix", x = "Predicted Class", 
       y = "True Class", fill = "Frequency")



