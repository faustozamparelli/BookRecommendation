/* eslint-disable @next/next/no-img-element */
"use client";
import React, { useEffect, useMemo, useState } from "react";
import { Book, BookGrade } from "../vote/vote";
import { createClient } from "@supabase/supabase-js";

export type Leaderboard = { book: Book; points: number }[];

export interface FavsProps {
  leaderboard: Leaderboard;
}

const Favs = () => {
  const [leaderboard, setLeaderboard] = useState<Leaderboard>([]);

  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_PROJECT_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  useEffect(() => {
    const getLeaderboard = async () => {
      const { data, error } = await supabase
        .from("grades")
        .select("*, books(original_title, title, image_url)");
      if (error) return;

      const grades: {
        book_id: number;
        books: { image_url: string; original_title: string; title: string };
        grade: BookGrade;
      }[] = data;

      let _leaderboard: Leaderboard = [];

      for (const gradeObj of grades) {
        const book = {
          id: gradeObj.book_id.toString(),
          title: gradeObj.books.title || gradeObj.books.original_title,
          cover: gradeObj.books.image_url,
        };

        const existing = _leaderboard.find(
          (entry) => entry.book.id === book.id
        );

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

        setLeaderboard(_leaderboard.toSorted((a, b) => b.points - a.points));
      }
    };

    getLeaderboard();
  }, [supabase]);

  const stdAwayFromAvg = (points: number, avg: number, stdDev: number) => {
    const _value = Math.ceil((points - avg) / stdDev);
    if (_value === 0) return " = ~ avg";
    const value = _value > 0 ? Math.min(_value, 2) : Math.max(_value, -2);
    return String(
      " = avg " +
        (value > 0 ? "+" : "") +
        value +
        (value === +1 || value === -1 ? " std dev" : " std devs")
    );
  };

  const avg = useMemo(
    () =>
      leaderboard.reduce((acc, curr) => acc + curr.points, 0) /
      leaderboard.length,
    [leaderboard]
  );

  const stdDev = useMemo(
    () =>
      Math.sqrt(
        leaderboard.reduce((acc, curr) => acc + curr.points ** 2, 0) /
          leaderboard.length -
          (leaderboard.reduce((acc, curr) => acc + curr.points, 0) /
            leaderboard.length) **
            2
      ),
    [leaderboard]
  );

  if (leaderboard.length < 3) {
    return (
      <div className="min-h-screen min-w-screen flex justify-center items-center"></div>
    );
  }

  return (
    <div className="p-4">
      <h3 className="text-2xl font-bold text-center">
        {"🧑‍💻 ACSAI's favorite books"}
      </h3>
      <div className="text-center">
        <p>{"avg score: " + avg.toFixed(2)}</p>

        <p>{"std dev: " + stdDev.toFixed(2)}</p>
      </div>

      <div className="grid grid-cols-3 items-center justify-center">
        {/* silver second  on the left */}
        <div className="flex flex-col items-center scale-90">
          <h3 className="text-6xl font-bold text-gray-300 p-2">🥈</h3>
          <img
            src={leaderboard[1].book.cover}
            alt={leaderboard[1].book.title}
          />
          <p className="text-center">{leaderboard[1].book.title}</p>
          <div className="text-sm text-gray-400">
            <p>
              Score: {leaderboard[1].points}
              {stdAwayFromAvg(leaderboard[1].points, avg, stdDev)}
            </p>
          </div>
        </div>

        {/* golden big UI for 1st (leaderboard[0]) at the center */}
        <div className="flex flex-col items-center">
          <h3 className="text-6xl font-bold text-yellow-500 p-2">🥇</h3>
          <img
            src={leaderboard[0].book.cover}
            alt={leaderboard[0].book.title}
          />
          <p className="text-center">{leaderboard[0].book.title}</p>
          <div className="text-sm text-gray-400">
            <p>
              Score: {leaderboard[0].points}
              {stdAwayFromAvg(leaderboard[0].points, avg, stdDev)}
            </p>
          </div>
        </div>

        {/* bronze third on the right */}
        <div className="flex flex-col items-center scale-75">
          <h3 className="text-6xl font-bold text-yellow-300 p-2">🥉</h3>
          <img
            src={leaderboard[2].book.cover}
            alt={leaderboard[2].book.title}
          />
          <p className="text-center">{leaderboard[2].book.title}</p>
          <div className="text-sm text-gray-400">
            <p>
              Score: {leaderboard[2].points}
              {stdAwayFromAvg(leaderboard[2].points, avg, stdDev)}
            </p>
          </div>
        </div>
      </div>

      {/* table list single column leaderboard for 4th+ */}
      <div className="flex flex-col items-center mt-8">
        {leaderboard.slice(3).map(({ book, points }, index) => (
          <div key={book.id}>
            <div className="flex flex-row items-center justify-between min-w-96 space-x-4">
              <p>{index + 4}.</p>
              <p>{book.title}</p>
              <p className="text-sm text-gray-400">
                Score: {points}
                {stdAwayFromAvg(points, avg, stdDev)}
              </p>
            </div>
            <hr className="w-full m-2 p-2" />
          </div>
        ))}
      </div>
    </div>
  );
};

export default Favs;
