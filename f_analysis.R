library(recommenderlab)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(DT)
library(knitr)
library(grid)
library(gridExtra)
library(corrplot)
library(qgraph)
library(methods)
library(Matrix)

# dataset
book_tags <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/book_tags.csv")
books <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/books.csv")
ratings <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv")
tags <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/tags.csv")
to_read <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/to_read.csv")

# data cleaning
ratings <- data.table(ratings)
ratings[, N := .N, .(user_id, book_id)]
cat("Number of duplicate ratings: ", nrow(ratings[N > 1]))
ratings <- ratings[N == 1]

ratings[, N := .N, .(user_id)]
cat("Number of users who rated fewer than 3 books: ", uniqueN(ratings[N <= 2, user_id]))
ratings <- ratings[N > 2]

# 20% at random
# set.seed(1)
# user_fraction <- 0.2
# users <- unique(ratings$user_id)
# sample_users <- sample(users, round(user_fraction * length(users)))

# cat('Number of ratings (before): ', nrow(ratings))
# ratings <- ratings[user_id %in% sample_users]
# cat('Number of ratings (after): ', nrow(ratings))

# [F] Distribution of ratings
ratings %>%
    ggplot(aes(x = rating, fill = factor(rating))) +
    geom_bar(color = "grey20") +
    scale_fill_brewer(palette = "YlGnBu") +
    guides(fill = FALSE)

# [F] number of ratings per user
# Group and count users with the same number of ratings
user_rating_counts <- ratings %>%
  group_by(user_id) %>%
  summarize(number_of_ratings = n()) %>%
  ungroup() %>%
  count(number_of_ratings)

# Rename the columns for clarity
colnames(user_rating_counts) <- c("Number_of_Ratings", "Number_of_Users")

# Create the plot
ggplot(user_rating_counts, aes(x = Number_of_Ratings, y = Number_of_Users)) +
  geom_bar(stat = "identity", fill = "cadetblue3", color = "grey20") +
  labs(
    title = "Number of Ratings per User",
    x = "Number of Ratings",
    y = "Number of Users"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )

# [F] distribution of mean user ratings

# [F] number of ratings per book

# [F] distribution of mean book ratings

# [F] number of ratings per book

# [F] top 10 books with most ratings
