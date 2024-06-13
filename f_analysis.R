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

# sample
book_tags <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/book_tags.csv")
books <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/books.csv")
ratings <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/ratings.csv")
tags = read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/tags.csv")
to_read <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/to_read.csv")

# data cleaning
ratings <- data.table(ratings)
ratings[, N := .N, .(user_id, book_id)]
cat('Number of duplicate ratings: ', nrow(ratings[N > 1]))
ratings <- ratings[N == 1]

# 20% at random
# set.seed(1)
# user_fraction <- 0.2
# users <- unique(ratings$user_id)
# sample_users <- sample(users, round(user_fraction * length(users)))

# cat('Number of ratings (before): ', nrow(ratings))
# ratings <- ratings[user_id %in% sample_users]
# cat('Number of ratings (after): ', nrow(ratings))

ratings %>% 
  ggplot(aes(x = rating, fill = factor(rating))) +
  geom_bar(color = "grey20") + scale_fill_brewer(palette = "YlGnBu") + guides(fill = FALSE)
