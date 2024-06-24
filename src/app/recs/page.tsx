import { Leaderboard } from "@/components/favs/favs";
import Recs, { RecsProps } from "@/components/recs/recs";
import { Book, BookGrade } from "@/components/vote/vote";
import { createClient } from "@supabase/supabase-js";

async function getServerSideProps(): Promise<RecsProps> {
  return {
    nodes: [
      { id: "Node 1", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 2", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 3", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 4", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 5", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 6", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 7", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 8", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Node 9", height: 1, size: 24, color: "rgb(97, 205, 187)" },
      { id: "Harry Potter", height: 2, size: 32, color: "rgb(244, 117, 96)" },
      { id: "Node 1.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 1.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 1.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 1.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 1.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 1.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 1.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 1.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 2.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 3.8", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.8", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 4.9", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.8", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.9", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 5.10", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 6.8", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 7.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 7.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 7.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 7.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 7.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 7.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 7.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 8.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.0", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.1", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.2", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.3", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.4", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.5", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.6", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.7", height: 0, size: 12, color: "rgb(232, 193, 160)" },
      { id: "Node 9.8", height: 0, size: 12, color: "rgb(232, 193, 160)" },
    ],
    links: [
      { source: "Harry Potter", target: "Node 1", distance: 80 },
      { source: "Node 1", target: "Node 1.0", distance: 50 },
      { source: "Node 1", target: "Node 1.1", distance: 50 },
      { source: "Node 1", target: "Node 1.2", distance: 50 },
      { source: "Node 1", target: "Node 1.3", distance: 50 },
      { source: "Node 1", target: "Node 1.4", distance: 50 },
      { source: "Node 1", target: "Node 1.5", distance: 50 },
      { source: "Node 1", target: "Node 1.6", distance: 50 },
      { source: "Node 1", target: "Node 1.7", distance: 50 },
      { source: "Harry Potter", target: "Node 2", distance: 80 },
      { source: "Node 2", target: "Node 9", distance: 80 },
      { source: "Node 2", target: "Node 2.0", distance: 50 },
      { source: "Node 2", target: "Node 2.1", distance: 50 },
      { source: "Node 2", target: "Node 2.2", distance: 50 },
      { source: "Node 2", target: "Node 2.3", distance: 50 },
      { source: "Node 2", target: "Node 2.4", distance: 50 },
      { source: "Node 2", target: "Node 2.5", distance: 50 },
      { source: "Node 2", target: "Node 2.6", distance: 50 },
      { source: "Node 2", target: "Node 2.7", distance: 50 },
      { source: "Harry Potter", target: "Node 3", distance: 80 },
      { source: "Node 3", target: "Node 3.0", distance: 50 },
      { source: "Node 3", target: "Node 3.1", distance: 50 },
      { source: "Node 3", target: "Node 3.2", distance: 50 },
      { source: "Node 3", target: "Node 3.3", distance: 50 },
      { source: "Node 3", target: "Node 3.4", distance: 50 },
      { source: "Node 3", target: "Node 3.5", distance: 50 },
      { source: "Node 3", target: "Node 3.6", distance: 50 },
      { source: "Node 3", target: "Node 3.7", distance: 50 },
      { source: "Node 3", target: "Node 3.8", distance: 50 },
      { source: "Harry Potter", target: "Node 4", distance: 80 },
      { source: "Node 4", target: "Node 5", distance: 80 },
      { source: "Node 4", target: "Node 4.0", distance: 50 },
      { source: "Node 4", target: "Node 4.1", distance: 50 },
      { source: "Node 4", target: "Node 4.2", distance: 50 },
      { source: "Node 4", target: "Node 4.3", distance: 50 },
      { source: "Node 4", target: "Node 4.4", distance: 50 },
      { source: "Node 4", target: "Node 4.5", distance: 50 },
      { source: "Node 4", target: "Node 4.6", distance: 50 },
      { source: "Node 4", target: "Node 4.7", distance: 50 },
      { source: "Node 4", target: "Node 4.8", distance: 50 },
      { source: "Node 4", target: "Node 4.9", distance: 50 },
      { source: "Harry Potter", target: "Node 5", distance: 80 },
      { source: "Node 5", target: "Node 5.0", distance: 50 },
      { source: "Node 5", target: "Node 5.1", distance: 50 },
      { source: "Node 5", target: "Node 5.2", distance: 50 },
      { source: "Node 5", target: "Node 5.3", distance: 50 },
      { source: "Node 5", target: "Node 5.4", distance: 50 },
      { source: "Node 5", target: "Node 5.5", distance: 50 },
      { source: "Node 5", target: "Node 5.6", distance: 50 },
      { source: "Node 5", target: "Node 5.7", distance: 50 },
      { source: "Node 5", target: "Node 5.8", distance: 50 },
      { source: "Node 5", target: "Node 5.9", distance: 50 },
      { source: "Node 5", target: "Node 5.10", distance: 50 },
      { source: "Harry Potter", target: "Node 6", distance: 80 },
      { source: "Node 6", target: "Node 6.0", distance: 50 },
      { source: "Node 6", target: "Node 6.1", distance: 50 },
      { source: "Node 6", target: "Node 6.2", distance: 50 },
      { source: "Node 6", target: "Node 6.3", distance: 50 },
      { source: "Node 6", target: "Node 6.4", distance: 50 },
      { source: "Node 6", target: "Node 6.5", distance: 50 },
      { source: "Node 6", target: "Node 6.6", distance: 50 },
      { source: "Node 6", target: "Node 6.7", distance: 50 },
      { source: "Node 6", target: "Node 6.8", distance: 50 },
      { source: "Harry Potter", target: "Node 7", distance: 80 },
      { source: "Node 7", target: "Node 7.0", distance: 50 },
      { source: "Node 7", target: "Node 7.1", distance: 50 },
      { source: "Node 7", target: "Node 7.2", distance: 50 },
      { source: "Node 7", target: "Node 7.3", distance: 50 },
      { source: "Node 7", target: "Node 7.4", distance: 50 },
      { source: "Node 7", target: "Node 7.5", distance: 50 },
      { source: "Node 7", target: "Node 7.6", distance: 50 },
      { source: "Harry Potter", target: "Node 8", distance: 80 },
      { source: "Node 8", target: "Node 1", distance: 80 },
      { source: "Node 8", target: "Node 8.0", distance: 50 },
      { source: "Node 8", target: "Node 8.1", distance: 50 },
      { source: "Node 8", target: "Node 8.2", distance: 50 },
      { source: "Node 8", target: "Node 8.3", distance: 50 },
      { source: "Node 8", target: "Node 8.4", distance: 50 },
      { source: "Node 8", target: "Node 8.5", distance: 50 },
      { source: "Node 8", target: "Node 8.6", distance: 50 },
      { source: "Node 8", target: "Node 8.7", distance: 50 },
      { source: "Harry Potter", target: "Node 9", distance: 80 },
      { source: "Node 9", target: "Node 3", distance: 80 },
      { source: "Node 9", target: "Node 9.0", distance: 50 },
      { source: "Node 9", target: "Node 9.1", distance: 50 },
      { source: "Node 9", target: "Node 9.2", distance: 50 },
      { source: "Node 9", target: "Node 9.3", distance: 50 },
      { source: "Node 9", target: "Node 9.4", distance: 50 },
      { source: "Node 9", target: "Node 9.5", distance: 50 },
      { source: "Node 9", target: "Node 9.6", distance: 50 },
      { source: "Node 9", target: "Node 9.7", distance: 50 },
      { source: "Node 9", target: "Node 9.8", distance: 50 },
    ],
  };
}
const RecommendationsPage = async () => {
  const data = await getServerSideProps();
const stars = (points: number, avg: number, stdDev: number) => {
  const _value = Math.ceil((points - avg) / stdDev);
  const value =
    _value === 0 || stdDev === 0
      ? 0
      : _value > 0
      ? Math.min(_value, 2)
      : Math.max(_value, -2);

  // value will be in range [-2, +2]
  // result will be in range [+1, +5]
  // that is, from 1 star to 5 stars
  return value + 3;
};

async function getData(): Promise<RecsProps> {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_PROJECT_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );

  const { data, error } = await supabase
    .from("grades")
    .select("*, books(original_title, title, image_url)");
  if (error)
    return {
      leaderboard: [],
      bookRecs: [{ id: "1", title: error.message, cover: "" }],
    };

  const grades: {
    book_id: number;
    books: { image_url: string; original_title: string; title: string };
    grade: BookGrade;
  }[] = data;

  console.log(`[SERVER] acsai grades fetched: ${grades.length}`);

  let _leaderboard: Leaderboard = [];

  for (const gradeObj of grades) {
    const book = {
      id: gradeObj.book_id.toString(),
      title: gradeObj.books.title || gradeObj.books.original_title,
      cover: gradeObj.books.image_url,
    };

    const existing = _leaderboard.find((entry) => entry.book.id === book.id);

    const addingGrade =
      gradeObj.grade === 1
        ? -2
        : gradeObj.grade === 2
        ? -1
        : gradeObj.grade === 3
        ? 0
        : gradeObj.grade === 4
        ? 1
        : 2;

    if (existing) {
      existing.points += addingGrade;
    } else {
      _leaderboard.push({ book, points: addingGrade });
    }
  }

  const leaderboard = _leaderboard.toSorted((a, b) => b.points - a.points);

  console.log(`[SERVER] leaderboard sorted: ${JSON.stringify(leaderboard)}`);

  const avg =
    leaderboard.reduce((acc, curr) => acc + curr.points, 0) /
    leaderboard.length;

  const stddev = Math.sqrt(
    leaderboard.reduce((acc, curr) => acc + curr.points ** 2, 0) /
      leaderboard.length -
      (leaderboard.reduce((acc, curr) => acc + curr.points, 0) /
        leaderboard.length) **
        2
  );

  const BOOKS = 10000;

  const acsaiEmbedding = Array.from(Array(BOOKS).keys()).map((_, index) => {
    const book = leaderboard.find(
      (entry) => String(entry.book.id) === String(index)
    );
    return book ? stars(book.points, avg, stddev) : 0;
  });

  console.log(`[SERVER] acsaiEmbedding created`);

  console.log(`[SERVER] Running match_users RPC`);

  const { data: similarUsers, error: vectorQueryError } = await supabase.rpc(
    "match_users",
    {
      query_embedding: acsaiEmbedding,
      match_threshold: 0.08,
      match_count: 1,
    }
  );

  if (vectorQueryError) {
    console.log(
      `[SERVER] error fetching similar user: ${vectorQueryError.message}`
    );
    return {
      leaderboard: [],
      bookRecs: [{ id: "1", title: vectorQueryError.message, cover: "" }],
    };
  }

  if (!similarUsers || similarUsers.length === 0) {
    console.log(`[SERVER] no similar user found`);
    return {
      leaderboard: [],
      bookRecs: [{ id: "1", title: "No similar user found", cover: "" }],
    };
  }

  const mostSimilarUser = similarUsers[0].id;
  console.log(`[SERVER] similar user found: ${mostSimilarUser}`);

  console.log(`[SERVER] Fetching favorite books of similar user`);
  const { data: favBooksSearchResult, error: favBooksSearchError } =
    await supabase
      .from("ratings")
      .select("book_id, rating, books(title, original_title, image_url)")
      .eq("user_id", mostSimilarUser);

  if (favBooksSearchError) {
    console.log(
      `[SERVER] error fetching favorite books of similar user: ${favBooksSearchError.message}`
    );
    return {
      leaderboard: [],
      bookRecs: [{ id: "1", title: favBooksSearchError.message, cover: "" }],
    };
  }

  console.log(
    `[SERVER] favorite books of similar user fetched: ${favBooksSearchResult.length} books`
  );

  const acsaiReadBooks = leaderboard.map((bookItem) =>
    String(bookItem.book.id)
  );

  const bookRecs = favBooksSearchResult
    .filter(
      (book) =>
        book.rating >= 4 && !acsaiReadBooks.includes(String(book.book_id))
    )
    .map((book) => ({
      id: book.book_id,
      title: (book.books as any).title || (book.books as any).original_title,
      cover: (book.books as any).image_url,
    }));

  console.log(
    `[SERVER] book recommendations filtered: ${bookRecs.length} books`
  );

  return {
    leaderboard,
    bookRecs,
  };
}

export const revalidate = 1;

const RecommendationsPage = async () => {
   const data = await getData();
   return <Recs {...data} />;
};

export default RecommendationsPage;
