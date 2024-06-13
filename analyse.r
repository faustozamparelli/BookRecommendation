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
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv"
  # "~/Developer/StartupAnalysis/ratings.csv"
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

# === distribution of the ratings
table(ratings$rating) / nrow(ratings)


# === relationship between rating and number of ratings

# new table with book_id, rating_avg, and rating_count
book_ratings <- aggregate(rating ~ book_id, data = ratings, FUN = mean)
book_ratings$count <- aggregate(rating ~ book_id,
  data = ratings, FUN = length
)$rating

head(book_ratings)
book_ratings

cor(book_ratings$rating, book_ratings$count)

# relationship between rating and average rating of the author's other books

# relationship between rating and book length (number of pages)

# relationship between rating and book publication year

# relationship between rating and book genre

# === top 10 with highest average rating

# is there correlation between average rating and number of ratings?


# do frequent raters rate differently?

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
