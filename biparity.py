import pandas as pd
import ssl

# Disable SSL verification
ssl._create_default_https_context = ssl._create_unverified_context

# Load the books dataset
books = pd.read_csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/books.csv")

# Load the ratings dataset
ratings = pd.read_csv("https://github.com/zygmuntz/goodbooks-10k/raw/master/ratings.csv")

# Remove multiple columns
books = books.drop(['goodreads_book_id', 'best_book_id', 'work_id','books_count', 'isbn', 'isbn13', 'original_publication_year', 'ratings_1','ratings_2','ratings_3','ratings_4','ratings_5','original_title','work_text_reviews_count', 'image_url', 'small_image_url','average_rating', 'ratings_count', 'work_ratings_count','language_code'], axis=1)

print(books.head())
print(ratings.head())