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
    geom_bar(stat = "identity", color = "grey20", size = 0.35) +
    coord_flip() +
    labs(x = "language", title = "english included") +
    guides(fill = FALSE)
p2 <- books %>%
    mutate(language = factor(language_code)) %>%
    filter(!language %in% c("en-US", "en-GB", "eng", "en-CA", "")) %>%
    group_by(language) %>%
    summarize(number_of_books = n()) %>%
    arrange(-number_of_books) %>%
    ggplot(aes(reorder(language, number_of_books), number_of_books, fill = reorder(language, number_of_books))) +
    geom_bar(stat = "identity", color = "grey20", size = 0.35) +
    coord_flip() +
    labs(x = "", title = "english excluded") +
    guides(fill = FALSE)
plot5 <- grid.arrange(p1, p2, ncol = 2)
ggsave("./plots/language_distribution.png", plot5)
################################################################################
# [F] top 10 books with most ratings
books %>%
    mutate(image = paste0('<img src="', small_image_url, '"></img>')) %>%
    arrange(-ratings_count) %>%
    top_n(10, wt = ratings_count) %>%
    select(image, title, ratings_count, average_rating) %>%
    datatable(class = "nowrap hover row-border", escape = FALSE, options = list(dom = "t", scrollX = TRUE, autoWidth = TRUE))
################################################################################
# [F] what influence a books rating 
# Specify the file name and the size of the plot
png(filename = "./plots/correlation_plot.png", width = 800, height = 800)

# Generate the plot
tmp <- books %>% 
  select(one_of(c("books_count","original_publication_year","ratings_count", "work_ratings_count", "work_text_reviews_count", "average_rating"))) %>% 
  as.matrix()

corrplot(cor(tmp, use = 'pairwise.complete.obs'), type = "lower")

# Close the graphics device
dev.off()
################################################################################
# Define a function to calculate correlation
get_cor <- function(df) {
  # Check if all values are greater than zero
  if(all(df$x > 0)) {
    # Transform the data
    df$x <- sqrt(df$x)
  }
  
  # Calculate correlation
  cor <- cor(df$x, df$y)
  
  list(cor = paste0("italic(r) == ", round(cor, 2)))
}

# [F] relationship number or rating and the average rating 
filtered_books <- books %>% filter(ratings_count < 1e+5)

cor <- get_cor(data.frame(x = filtered_books$ratings_count, y = filtered_books$average_rating))

plot7 <- filtered_books %>% 
  ggplot(aes(ratings_count, average_rating)) + stat_bin_hex(bins = 50) + scale_fill_distiller(palette = "Spectral") + 
  stat_smooth(method = "lm", color = "orchid", size = 2) +
  annotate("text", x = 85000, y = 2.7, label = cor$cor, parse = TRUE, color = "orchid", size = 7)

ggsave("./plots/rating_vs_average_rating.png", plot7)

# [F] relationship between rating and average_rating
filtered_books <- books %>% filter(books_count <= 500)

cor <- get_cor(data.frame(x = filtered_books$books_count, y = filtered_books$average_rating))

plot8 <- filtered_books %>% 
  ggplot(aes(books_count, average_rating)) + stat_bin_hex(bins = 50) + scale_fill_distiller(palette = "Spectral") + 
  stat_smooth(method = "lm", color = "orchid", size = 2) +
  annotate("text", x = 400, y = 2.7, label = cor$cor, parse = TRUE, color = "orchid", size = 7)

ggsave("./plots/average_rating_vs_books_count.png", plot8)

# [F] do frequent raters rate differently?
tmp <- ratings %>% 
  group_by(user_id) %>% 
  summarize(mean_rating = mean(rating), number_of_rated_books = n())

filtered_tmp <- tmp %>% filter(number_of_rated_books <= 100)

cor <- get_cor(data.frame(x = filtered_tmp$number_of_rated_books, y = filtered_tmp$mean_rating))

plot10 <- filtered_tmp %>% 
  ggplot(aes(number_of_rated_books, mean_rating)) + stat_bin_hex(bins = 50) + scale_fill_distiller(palette = "Spectral") + stat_smooth(method = "lm", color = "orchid", size = 2, se = FALSE) +
  annotate("text", x = 80, y = 1.9, label = cor$cor, color = "orchid", size = 7, parse = TRUE)

ggsave("./plots/mean_rating_vs_number_of_rated_books.png", plot10)

# [F] series of books
books <- books %>% 
  mutate(series = str_extract(title, "\\(.*\\)"), 
         series_number = as.numeric(str_sub(str_extract(series, ', #[0-9]+\\)$'),4,-2)),
         series_name = str_sub(str_extract(series, '\\(.*,'),2,-2))

tmp <- books %>% 
  filter(!is.na(series_name) & !is.na(series_number)) %>% 
  group_by(series_name) %>% 
  summarise(number_of_volumes_in_series = n(), mean_rating = mean(average_rating))

cor <- get_cor(data.frame(x = tmp$number_of_volumes_in_series, y = tmp$mean_rating))
  
plot12 <- tmp %>% 
  ggplot(aes(number_of_volumes_in_series, mean_rating)) + 
  stat_bin_hex(bins = 50) + 
  scale_fill_distiller(palette = "Spectral") +
  stat_smooth(method = "lm", se = FALSE, size = 2, color = "orchid") +
  annotate("text", x = 35, y = 3.95, label = cor$cor, color = "orchid", size = 7, parse = TRUE)

ggsave("./plots/number_of_volumes_vs_mean_rating.png", plot12)

################################################################################
# [F] is the sequel better
plot13 <- books %>% 
  filter(!is.na(series_name) & !is.na(series_number) & series_number %in% c(1,2)) %>% 
  group_by(series_name, series_number) %>% 
  summarise(m = mean(average_rating)) %>% 
  ungroup() %>% 
  group_by(series_name) %>% 
  mutate(n = n()) %>% 
  filter(n == 2) %>% 
  ggplot(aes(factor(series_number), m, color = factor(series_number))) +
  geom_boxplot() + coord_cartesian(ylim = c(3,5)) + guides(color = FALSE) + labs(x = "Volume of series", y = "Average rating") 
ggsave("./plots/sequel_better.png", plot13)

# How long should a title be
books <- books %>% 
  mutate(title_cleaned = str_trim(str_extract(title, '([0-9a-zA-Z]| |\'|,|\\.|\\*)*')),
         title_length = str_count(title_cleaned, " ") + 1) 

tmp <- books %>% 
  group_by(title_length) %>% 
  summarize(n = n()) %>% 
  mutate(ind = rank(title_length))

plot14 <- books %>% 
  ggplot(aes(factor(title_length), average_rating, color=factor(title_length), group=title_length)) +
  geom_boxplot() + guides(color = FALSE) + labs(x = "Title length") + coord_cartesian(ylim = c(2.2,4.7)) + geom_text(aes(x = ind,y = 2.25,label = n), data = tmp)

ggsave("./plots/title_length.png", plot14)

# subtitle
books <- books %>% 
  mutate(subtitle = str_detect(books$title, ':') * 1, subtitle = factor(subtitle))

plot14 <- books %>% 
  ggplot(aes(subtitle, average_rating, group = subtitle, color = subtitle)) + 
  geom_boxplot() + guides(color = FALSE)
ggsave("./plots/subtitle.png", plot14)

# number of authors
books <- books %>% 
  mutate(number_of_authors = lengths(str_split(authors, ",")))
filtered_books <- books %>% filter(number_of_authors <= 10)
cor <- get_cor(data.frame(x = filtered_books$number_of_authors, y = filtered_books$average_rating))
plot15 <- filtered_books %>% 
  ggplot(aes(number_of_authors, average_rating)) + 
  stat_bin_hex(bins = 50) + 
  scale_fill_distiller(palette = "Spectral") +
  stat_smooth(method = "lm", size = 2, color = "orchid", se = FALSE) + 
  annotate("text", x = 8.5, y = 2.75, label = cor$cor, color = "orchid", size = 7, parse = TRUE)

ggsave("./plots/number_of_authors.png", plot15)


# lord of the rings
# lotr_books <- books %>% 
#   filter(str_detect(str_to_lower(title), '\\(the lord of the rings')) %>% 
#   select(book_id, title, average_rating)
# plot7 <- lotr_books %>% 
#   ggplot(aes(x = reorder(title, -average_rating), y = average_rating)) +
#   geom_bar(stat = "identity", fill = "orchid") +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
#   labs(x = "Book Title", y = "Average Rating")
# ggsave("./plots/lord_of_the_rings.png", plot7)

# harry potter
# hp_books <- books %>% 
#   filter(str_detect(str_to_lower(title), 'harry potter')) %>% 
#   select(book_id, title, average_rating)
# plot_hp <- hp_books %>% 
#   ggplot(aes(x = reorder(title, -average_rating), y = average_rating)) +
#   geom_bar(stat = "identity", fill = "orchid") +
#   theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
#   labs(x = "Book Title", y = "Average Rating")
# ggsave("./plots/harry_potter.png", plot_hp)



