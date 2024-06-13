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

# 20% at random
# set.seed(1)
# user_fraction <- 0.2
# users <- unique(ratings$user_id)
# sample_users <- sample(users, round(user_fraction * length(users)))

# cat('Number of ratings (before): ', nrow(ratings))
# ratings <- ratings[user_id %in% sample_users]
# cat('Number of ratings (after): ', nrow(ratings))

# [F] Distribution of ratings
plot1 <- ratings %>%
    ggplot(aes(x = rating, fill = factor(rating))) +
    geom_bar(color = "grey20") +
    scale_fill_brewer(palette = "YlGnBu") +
    guides(fill = FALSE)
ggsave("./plots/rating_distribution.png", plot1)

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
plot2 <- ggplot(user_rating_counts, aes(x = Number_of_Ratings, y = Number_of_Users)) +
    geom_bar(stat = "identity", fill = "cadetblue3", color = "grey20") +
    labs(
        title = "Number of Ratings per User",
        x = "Number of Ratings",
        y = "Number of Users"
    ) +
    theme_bw() +
    theme(
        plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12)
    )
ggsave("./plots/number_of_ratings_distribution.png", plot2)

# [F] distribution of mean user ratings
# Group by user_id and calculate mean rating
mean_user_ratings <- ratings %>%
    group_by(user_id) %>%
    summarize(mean_rating = mean(rating)) %>%
    ungroup()

# Rename the columns for clarity
colnames(mean_user_ratings) <- c("User_ID", "Mean_Rating")

# Create the plot
plot3 <- ratings %>%
    group_by(book_id) %>%
    summarize(mean_book_rating = mean(rating)) %>%
    ggplot(aes(mean_book_rating)) +
    geom_histogram(fill = "orange", color = "grey20") +
    coord_cartesian(c(1, 5))

ggsave("./plots/mean_user_ratings_distribution.png", plot3)

# [F] number of ratings per book
# Group by book_id and count ratings
book_rating_counts <- ratings %>%
    group_by(book_id) %>%
    summarize(number_of_ratings = n()) %>%
    ungroup()

# rename the columns for clarity
colnames(book_rating_counts) <- c("book_id", "number_of_ratings")

# create the plot
plot4 <- ggplot(book_rating_counts, aes(x = number_of_ratings)) +
    geom_histogram(binwidth = 0.5, fill = "cadetblue3", color = "grey20") +
    labs(
        title = "number of ratings per book",
        x = "number of ratings",
        y = "number of books"
    ) +
    theme_bw() +
    theme(
        plot.title = element_text(hjust = 0.5),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12)
    )
ggsave("./plots/number_of_ratings_per_book_distribution.png", plot4)
# [F] distribution of mean book ratings

# [F] number of ratings per book

# [F] top 10 books with most ratings
