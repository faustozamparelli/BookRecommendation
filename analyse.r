library(igraph)

options(timeout = max(1000, getOption("timeout")))

book_tags <- read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/book_tags.csv"
)
books <- read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/books.csv"
)
ratings <- read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv"
)
tags <- read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/tags.csv"
)
to_read <- read.csv(
  "https://github.com/zygmuntz/goodbooks-10k/raw/master/to_read.csv"
)

# new bool column "liked_it" TRUE for ratings >= 4
ratings$liked_it <- ifelse(ratings$rating >= 4, TRUE, FALSE)

# merge ratings with book name and author
ratings <- merge(ratings, books, by = "book_id")[
  c("book_id", "user_id", "liked_it", "rating", "original_title")
]

head(ratings)

# length of ratings
nrow(ratings)

# distribution of the ratings
table(ratings$rating) / nrow(ratings)

# number of ratings per user

# distribution of mean user ratings

# number of ratings per book

# distribution of mean book ratings

# number of ratings per book

# top 10 books with most ratings

# top 10 with highest average rating

# what influences a book's rating?

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
