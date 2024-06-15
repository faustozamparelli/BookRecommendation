import ssl
ssl._create_default_https_context = ssl._create_stdlib_context
import pandas as pd
import networkx as nx
from networkx.algorithms import bipartite
from sklearn.cluster import SpectralClustering
from bokeh.models import NodesAndLinkedEdges, EdgesAndLinkedNodes
from bokeh.plotting import from_networkx, figure, show
from bokeh.io import output_notebook

# Load the datasets
ratings = pd.read_csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv")

# Create a bipartite graph from the ratings dataset
B = nx.Graph()
B.add_nodes_from(ratings['book_id'].unique(), bipartite=0)
B.add_nodes_from(ratings['user_id'].unique(), bipartite=1)
B.add_weighted_edges_from([(row['user_id'], row['book_id'], row['rating']) for idx, row in ratings.iterrows()])

# Project the bipartite graph to get a weighted graph of books
weighted_projected_graph = bipartite.weighted_projected_graph(B, ratings['book_id'].unique())

# Use spectral clustering to cluster the books
sc = SpectralClustering(5, affinity='precomputed', n_init=100)
sc.fit(nx.to_numpy_matrix(weighted_projected_graph))
clusters = sc.labels_

# Add cluster information to the graph
nx.set_node_attributes(weighted_projected_graph, {node: {'cluster': clusters[i]} for i, node in enumerate(weighted_projected_graph)})

# Visualize the graph using Bokeh
plot = figure(title="Book Similarity Network", x_range=(-1.1,1.1), y_range=(-1.1,1.1))
network_graph = from_networkx(weighted_projected_graph, nx.spring_layout, scale=1, center=(0,0))
network_graph.node_renderer.glyph = Circle(size=15, fill_color='cluster')
network_graph.node_renderer.selection_glyph = Circle(size=15, fill_color='cluster')
network_graph.node_renderer.hover_glyph = Circle(size=15, fill_color='cluster')

# Specify the output file
output_file("./plots/book_similarity_network.html")

# Display the plot
show(plot)
import pandas as pd