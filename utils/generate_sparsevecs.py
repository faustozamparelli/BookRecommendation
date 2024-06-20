import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()
from supabase import Client as SupabaseClient, create_client as create_supabase_client
from pprint import pprint as print
from typing import TypedDict, Literal


supa: SupabaseClient = create_supabase_client(
    supabase_url=os.getenv("NEXT_PUBLIC_SUPABASE_PROJECT_URL"),
    supabase_key=os.getenv("SUPABASE_SERVICE_ROLE_KEY"),
)


DB_CONNECTION = f"postgresql://postgres.chrxbcqwiosxzqnngzjt:{os.getenv('DB_PASSWORD')}@aws-0-eu-central-1.pooler.supabase.com:6543/postgres"


USERS = 52300
# USERS = 6

BOOKS = 10000


vx = psycopg2.connect(DB_CONNECTION)


class Rating(TypedDict):
    user_id: int
    book_id: int
    rating: Literal[0, 1, 2, 3, 4, 5]


def get_sparsevec(ratings: list[Rating]):
    ratings_sparsevec = {}
    for rating in ratings:
        ratings_sparsevec[rating["book_id"]] = rating["rating"]
    result = f"{ratings_sparsevec}/{BOOKS}"
    return result


for user_id in range(1, USERS):
    ratings: list[Rating] = (
        supa.table("ratings")
        .select("user_id, book_id, rating")
        .eq("user_id", user_id)
        .execute()
        .data
    )
    if len(ratings) == 0:
        continue
    ratings_vec = get_sparsevec(ratings)
    curr = vx.cursor()
    curr.execute(
        f"INSERT INTO vecs.ratings_vectors (id, vec) VALUES ({user_id}, '{ratings_vec}') ON CONFLICT (id) DO NOTHING"
    )
    print(f"Just upserted ratings vector for user {user_id}: {ratings_vec}")

curr = vx.cursor()
curr.execute(f"SELECT * FROM vecs.ratings_vectors")
print(curr.fetchall())
