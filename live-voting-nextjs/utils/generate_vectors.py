import os
import vecs
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


vx = vecs.create_client(DB_CONNECTION)
ratings_vecs = vx.get_or_create_collection(name="ratings_vectors", dimension=BOOKS)


class Rating(TypedDict):
    user_id: int
    book_id: int
    rating: Literal[0, 1, 2, 3, 4, 5]


def get_vec(ratings: list[Rating]):
    ratings_vec = [0] * BOOKS
    for rating in ratings:
        ratings_vec[rating["book_id"]] = rating["rating"]
    return ratings_vec


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
    ratings_vec = get_vec(ratings)
    ratings_vecs.upsert(records=[(user_id, ratings_vec, {})])
    print(f"Just upserted ratings vector for user {user_id}")

    # print(
    #     ratings_vecs.query(
    #         data=ratings_vec,
    #         limit=5,
    #         filters={},
    #         measure="cosine_distance",
    #         include_value=True,
    #         include_metadata=False,
    #     )
    # )
