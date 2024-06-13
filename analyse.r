library(igraph)
library(dplyr)
library(data.table)

options(timeout = max(1000, getOption("timeout")))

book_tags <- data.table(read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/book_tags.csv"
))
books <- data.table(read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/books.csv"
))
ratings <- data.table(read.csv(
  # "https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv"
  "~/Developer/StartupAnalysis/ratings.csv"
))
tags <- data.table(read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/tags.csv"
))
to_read <- data.table(read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/to_read.csv"
))

# new bool column "liked_it" TRUE for ratings >= 4
ratings$liked_it <- ifelse(ratings$rating >= 4, TRUE, FALSE)

head(ratings)
head(books)

# merge ratings with book name and author
augmented_ratings <- merge(ratings, books, by = "book_id") %>%
  select(
    "book_id", "user_id", "liked_it", "rating", "original_title"
  )
head(augmented_ratings)

# length of ratings
nrow(ratings)

# distribution of the ratings
table(ratings$rating) / nrow(ratings)

# top 10 with highest average rating

# what influences a book's rating?
# 1. Relationship between rating and number of ratings
head(ratings)
cor(ratings$rating, ratings$rating_count)

# 2. Relationship between rating and average rating of the author's other books
author_avg_rating <- aggregate(rating ~ author, data = ratings, FUN = mean)
cor(ratings$rating, author_avg_rating$rating)

# 3. Relationship between rating and book length (number of pages)
cor(ratings$rating, books$num_pages)

# 4. Relationship between rating and book publication year
cor(ratings$rating, books$publication_year)

# 5. Relationship between rating and book genre
genre_ratings <- merge(ratings, book_tags, by = "book_id")
genre_avg_rating <- aggregate(rating ~ tag_name, data = genre_ratings, FUN = mean)
cor(ratings$rating, genre_avg_rating$rating)

# is there correlation between average rating and number of ratings?

# do frequet raters rate differently?

# how long should a title be?

# does the number of authors matter?

# all unique language_code s
unique(books$language_code)

# all "ita" language_code books
books[books$language_code == "ita", ]

# filter only liked books
liked_books <- ratings[ratings$liked_it == TRUE, ]

nrow(liked_books)

# bipartite of books and users who liked them

# cluster books by users who liked them

# collaborative filtering / book recommendation
