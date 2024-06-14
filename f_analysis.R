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

################################################################################
# [F] Distribution of ratings
plot1 <- ratings %>%
    ggplot(aes(x = rating, fill = factor(rating))) +
    geom_bar(color = "grey20") +
    scale_fill_brewer(palette = "YlGnBu") +
    guides(fill = FALSE)
ggsave("./plots/rating_distribution.png", plot1)
################################################################################
# [F] number of ratings per user
# Group and count users with the same number of ratings
plot2 <- ratings %>%
    group_by(user_id) %>%
    summarize(number_of_ratings_per_user = n()) %>%
    ggplot(aes(number_of_ratings_per_user)) +
    geom_bar(fill = "cadetblue3", color = "grey20")
ggsave("./plots/number_of_ratings_per_user.png", plot2)
###############################################################################
# [F] distribution of mean user ratings
# Group by user_id and calculate mean rating
plot3 <- ratings %>%
    group_by(user_id) %>%
    summarize(mean_user_rating = mean(rating)) %>%
    ggplot(aes(mean_user_rating)) +
    geom_histogram(fill = "cadetblue3", color = "grey20")
ggsave("./plots/mean_user_ratings_distribution.png", plot3)
#################################################################################
# [F] number of ratings per book
# Group by book_id and count ratings
plot4 <- ratings %>%
    group_by(book_id) %>%
    summarize(number_of_ratings_per_book = n()) %>%
    ggplot(aes(number_of_ratings_per_book)) +
    geom_bar(fill = "orange", color = "grey20", width = 1)
ggsave("./plots/number_of_ratings_per_book.png", plot4)
#################################################################################
# [F] distribution of mean book ratings
plot5 <- ratings %>%
    group_by(book_id) %>%
    summarize(mean_book_rating = mean(rating)) %>%
    ggplot(aes(mean_book_rating)) +
    geom_histogram(fill = "orange", color = "grey20") +
    coord_cartesian(c(1, 5))
ggsave("./plots/mean_book_ratings_distribution.png", plot5)
###############################################################################
# [F] genres distribution
genres <- str_to_lower(c("Art", "Biography", "Business", "Chick Lit", "Children's", "Christian", "Classics", "Comics", "Contemporary", "Cookbooks", "Crime", "Ebooks", "Fantasy", "Fiction", "Gay and Lesbian", "Graphic Novels", "Historical Fiction", "History", "Horror", "Humor and Comedy", "Manga", "Memoir", "Music", "Mystery", "Nonfiction", "Paranormal", "Philosophy", "Poetry", "Psychology", "Religion", "Romance", "Science", "Science Fiction", "Self Help", "Suspense", "Spirituality", "Sports", "Thriller", "Travel", "Young Adult"))
exclude_genres <- c("fiction", "nonfiction", "ebooks", "contemporary")
genres <- setdiff(genres, exclude_genres)
available_genres <- genres[str_to_lower(genres) %in% tags$tag_name]
available_tags <- tags$tag_id[match(available_genres, tags$tag_name)]
tmp <- book_tags %>%
    filter(tag_id %in% available_tags) %>%
    group_by(tag_id) %>%
    summarize(n = n()) %>%
    ungroup() %>%
    mutate(sumN = sum(n), percentage = n / sumN) %>%
    arrange(-percentage) %>%
    left_join(tags, by = "tag_id")
plot5 <- tmp %>%
    ggplot(aes(reorder(tag_name, percentage), percentage, fill = percentage)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    scale_fill_distiller(palette = "YlOrRd") +
    labs(y = "Percentage", x = "Genre")
ggsave("./plots/genre_distribution.png", plot5)
################################################################################
# [F] languages distribution
p1 <- books %>% 
  mutate(language = factor(language_code)) %>% 
  group_by(language) %>% 
  summarize(number_of_books = n()) %>% 
  arrange(-number_of_books) %>% 
  ggplot(aes(reorder(language, number_of_books), number_of_books, fill = reorder(language, number_of_books))) +
  geom_bar(stat = "identity", color = "grey20", size = 0.35) + coord_flip() +
  labs(x = "language", title = "english included") + guides(fill = FALSE)
p2 <- books %>% 
  mutate(language = factor(language_code)) %>% 
  filter(!language %in% c("en-US", "en-GB", "eng", "en-CA", "")) %>% 
  group_by(language) %>% 
  summarize(number_of_books = n()) %>% 
  arrange(-number_of_books) %>% 
  ggplot(aes(reorder(language, number_of_books), number_of_books, fill = reorder(language, number_of_books))) +
  geom_bar(stat = "identity", color = "grey20", size = 0.35) + coord_flip() +
  labs(x = "", title = "english excluded") + guides(fill = FALSE)
plot5 <- grid.arrange(p1,p2, ncol=2)
ggsave("./plots/language_distribution.png", plot5)
################################################################################
# [F] top 10 books with most ratings
plot6 <- books %>% 
  mutate(image = paste0('<img src="', small_image_url, '"></img>')) %>% 
  arrange(-ratings_count) %>% 
  top_n(10,wt = ratings_count) %>% 
  select(image, title, ratings_count, average_rating) %>% 
  datatable(class = "nowrap hover row-border", escape = FALSE, options = list(dom = 't',scrollX = TRUE, autoWidth = TRUE))
ggsave("./plots/top_10_books_with_most_ratings.png", plot6)