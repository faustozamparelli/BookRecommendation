# Load the necessary libraries
library(igraph)
library(stringr)
library(dplyr)

# Load the data
books <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/books.csv")
ratings <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv")

# Remove duplicates based on original_title
books <- distinct(books, title, .keep_all = TRUE)

# Load the necessary libraries
library(reshape2)
library(proxy)

# Calculate the number of ratings for each user and book
user_counts <- table(ratings$user_id)
book_counts <- table(ratings$book_id)

# Get the top N users and books based on the number of ratings
N <- 1000
top_users <- names(user_counts)[order(user_counts, decreasing = TRUE)][1:N]
top_books <- names(book_counts)[order(book_counts, decreasing = TRUE)][1:N]

# Filter the ratings data frame
ratings <- ratings[ratings$user_id %in% top_users & ratings$book_id %in% top_books, ]

# Merge the books and ratings data frames
data <- merge(books, ratings, by = "book_id")

# Select the necessary columns
data <- data[, c("user_id", "book_id", "rating")]

# Pivot the data to create a user-book matrix
user_book_matrix <- dcast(data, user_id ~ book_id, value.var = "rating", na.rm = TRUE)

# Remove the user_id column
user_book_matrix <- user_book_matrix[, -1]

# Calculate the cosine similarity between users
user_similarity <- proxy::simil(as.matrix(user_book_matrix), method = "cosine")

# Convert the similarity matrix to a full matrix
user_similarity <- as.matrix(user_similarity)

# Convert the matrix to a data frame
user_similarity_df <- as.data.frame(user_similarity)

# Set the row names as a new column
user_similarity_df$user_id <- rownames(user_similarity_df)

# Convert the data frame to long format
user_similarity_long <- reshape2::melt(user_similarity_df, id.vars = "user_id", variable.name = "other_user_id", value.name = "similarity")

# Remove self-similarity entries
user_similarity_long <- user_similarity_long[user_similarity_long$user_id != user_similarity_long$other_user_id, ]

head(user_similarity_long)

# Remove unnecessary columns
books <- select(books, -c(
  goodreads_book_id, best_book_id, work_id, books_count, isbn, isbn13,
  original_publication_year, original_title, language_code, work_ratings_count,
  work_text_reviews_count, ratings_1, ratings_2, ratings_3, ratings_4,
  ratings_5, image_url, small_image_url
))
head(books)
# Calculate the average rating for each book
average_ratings <- ratings %>%
  group_by(book_id) %>%
  summarise(average_rating = mean(rating, na.rm = TRUE))

# Get the top 100 books by average rating
top_books <- average_ratings %>%
  top_n(150, average_rating) %>%
  pull(book_id)

# Filter the books data frame
books <- books %>%
  filter(book_id %in% top_books)

# Calculate the number of ratings for each user
user_ratings <- ratings %>%
  group_by(user_id) %>%
  summarise(num_ratings = n())

# Get the top 100 users by number of ratings
top_users <- user_ratings %>%
  top_n(100, num_ratings) %>%
  pull(user_id)

# Filter the ratings data frame
ratings <- ratings %>%
  filter(user_id %in% top_users)

# Merge the books and ratings data frames
data <- merge(books, ratings, by = "book_id")

# Extract the first three words from the title column
data$title <- sapply(data$title, function(x) paste(word(x, 1, 3), collapse = " "))

# Create a bipartite graph
g <- graph_from_data_frame(data, directed = FALSE)
V(g)$type <- bipartite_mapping(g)$type

# Set the vertex attributes
V(g)$color <- ifelse(V(g)$type, "lightblue", "lightgreen")
V(g)$label <- ifelse(V(g)$type, as.character(data$title), NA)
V(g)$size <- ifelse(V(g)$type, 10, 2) # Make books' vertices bigger and users' vertices smaller

# Plot the graph
plot(g, vertex.label.cex = 0.8, edge.color = "black")
