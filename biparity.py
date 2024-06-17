import pandas as pd
import ssl
import matplotlib.pyplot as plt
import networkx as nx
import scipy

# Disable SSL verification
ssl._create_default_https_context = ssl._create_unverified_context

DISABLE_HARRY_POTTER_FILTER = True

# Load the books dataset
books = pd.read_csv(
    # "/Users/danielfalbo/Developer/acsais-fav-books/public/data/books.csv"
    "https://github.com/zygmuntz/goodbooks-10k/raw/master/book_tags.csv"
)
print("loaded books")

# Load the ratings dataset
ratings = pd.read_csv(
    # "/Users/danielfalbo/Developer/acsais-fav-books/public/data/ratings.csv"
    "https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv"
)
print("loaded ratings")

# sample of 0.01% of the ratings dataset
# ratings = ratings.sample(frac=0.0001)


# first 1000 ratings
ratings = ratings.head(1000)

print(len(ratings))

# Remove multiple columns
books = books.drop(
    [
        "goodreads_book_id",
        "best_book_id",
        "work_id",
        "books_count",
        "isbn",
        "isbn13",
        "original_publication_year",
        "ratings_1",
        "ratings_2",
        "ratings_3",
        "ratings_4",
        "ratings_5",
        "original_title",
        "work_text_reviews_count",
        "image_url",
        "small_image_url",
        "average_rating",
        "ratings_count",
        "work_ratings_count",
        "language_code",
    ],
    axis=1,
)

print(books.head())
print(ratings.head())

bookid_to_booktitle = {}
G = nx.Graph()

for book in books.itertuples():
    bookid = book.book_id
    title = book.title
    bookid_to_booktitle[bookid] = title

books_ids = set()

for rating in ratings.itertuples():
    userid = rating.user_id
    bookid = rating.book_id
    rating = rating.rating
    books_ids.add(bookid)

for bookid in books_ids:
    if "Harry Potter" in bookid_to_booktitle[bookid] or DISABLE_HARRY_POTTER_FILTER:
        G.add_nodes_from([(bookid_to_booktitle[bookid], {"color": "red"})])

print(f"added book nodes: {[bookid_to_booktitle[bookid] for bookid in books_ids]}")

users = set()

for rating in ratings.itertuples():
    userid = rating.user_id
    bookid = rating.book_id
    rating = rating.rating
    if "Harry Potter" in bookid_to_booktitle[bookid] or DISABLE_HARRY_POTTER_FILTER:
        users.add(userid)

for userid in users:
    G.add_nodes_from([(userid, {"color": "green"})])


for rating in ratings.itertuples():
    userid = rating.user_id
    bookid = rating.book_id
    rating = rating.rating
    if "Harry Potter" in bookid_to_booktitle[bookid] or DISABLE_HARRY_POTTER_FILTER:
        G.add_edge(userid, bookid_to_booktitle[bookid], weight=rating)


edge_list = G.edges(data=False)

pos = nx.spring_layout(G)  # positions for all nodes - seed for reproducibility

colors = [
    node[1]["color"] if "color" in node[1] else "blue" for node in G.nodes(data=True)
]
# nodes
nx.draw_networkx_nodes(G, pos, node_size=40, node_color=colors)

# edges
nx.draw_networkx_edges(G, pos, edgelist=edge_list, width=1)

# node labels
nx.draw_networkx_labels(G, pos, font_size=10, font_family="sans-serif")

# edge weight labels
edge_labels = nx.get_edge_attributes(G, "weight")
nx.draw_networkx_edge_labels(G, pos, edge_labels)

ax = plt.gca()
ax.margins(0.08)
plt.axis("off")
plt.tight_layout()
plt.show()
