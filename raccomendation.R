# dataset
book_tags <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/book_tags.csv")
books <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/books.csv")
ratings <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv")
tags <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/tags.csv")
to_read <- read.csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/to_read.csv")
# RACCOMENDATION SYSTEM
library('dplyr')
library('tidyr')
dimension_names <- list(user_id = sort(unique(ratings$user_id)), book_id = sort(unique(ratings$book_id)))
ratingmat <- spread(select(ratings, book_id, user_id, rating), book_id, rating) %>% select(-user_id)

ratingmat <- as.matrix(ratingmat)

# Assuming your dataset is named 'ratingmat' and it's a matrix where
# rows are users, columns are ooks, and values are ratings
# Load necessary libraries
library(igraph)
library(cluster)

# Convert the rating matrix to a binary matrix (1 if rated, 0 otherwise)
binary_mat <- ifelse(is.na(ratingmat), 0, 1)

# Create a bipartite graph directly from the binary matrix
g <- graph_from_incidence_matrix(binary_mat)

# Define the type of each vertex
V(g)$type <- grepl("^user", V(g)$name)

# Create a bipartite network
bipartite_network <- bipartite_projection(g)

# Calculate the distances between the books
dist_matrix <- distances(bipartite_network, v = V(bipartite_network)[V(bipartite_network)$type == FALSE])

# Perform hierarchical clustering
hc <- hclust(as.dist(dist_matrix))

# Plot the dendrogram
plot(hc)

# Cut the dendrogram into clusters
clusters <- cutree(hc, k = 5)  # Change 'k' to the desired number of clusters

# Add the cluster information to the graph
V(bipartite_network)$cluster <- clusters[V(bipartite_network)$name]

# Plot the bipartite network with clusters
plot(bipartite_network, vertex.color = V(bipartite_network)$cluster)

# Save the graph to a file in the ./plots directory
png("./plots/bipartite_network.png")
pdf("./plots/bipartite_network.pdf")
plot(bipartite_network, vertex.color = V(bipartite_network)$cluster)
dev.off()