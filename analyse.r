library(igraph)

# sample
book_tags <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/book_tags.csv")
books <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/books.csv")
ratings <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/ratings.csv")
tags = read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/tags.csv")
to_read <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/samples/to_read.csv")

# new bool column "liked_it" TRUE for ratings >= 4
ratings$liked_it <- ifelse(ratings$rating >= 4, TRUE, FALSE)

# merge ratings with book name and author
ratings <- merge(ratings, books, by = "book_id")[
  c("book_id", "user_id", "liked_it", "original_title")
]

ratings[1, ]
head(ratings)

# length of ratings
nrow(ratings)

# filter only liked books
liked_books <- ratings[ratings$liked_it == TRUE, ]

nrow(liked_books)

# bipartite of books and users who liked them
