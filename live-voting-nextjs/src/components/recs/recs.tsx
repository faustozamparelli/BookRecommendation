"use client";
/* eslint-disable @next/next/no-img-element */
import React, { useEffect, useMemo, useState } from "react";
import { Leaderboard } from "../favs/favs";
import { createClient } from "@supabase/supabase-js";
import { Book, BookGrade } from "../vote/vote";

export interface RecsProps {
  leaderboard: Leaderboard;
  bookRecs: Book[];
}

const Recs = (data: RecsProps) => {
  const stars = (points: number, avg: number, stdDev: number) => {
    const _value = Math.ceil((points - avg) / stdDev);
    const value =
      _value === 0
        ? 0
        : _value > 0
        ? Math.min(_value, 2)
        : Math.max(_value, -2);

    // value will be in range [-2, +2]
    // result will be in range [+1, +5]
    // that is, from 1 star to 5 stars
    return value + 3;
  };

  const Stars = ({ stars }: { stars: number }) => {
    return (
      <div className="flex flex-row items-center justify-center">
        {Array.from(Array(stars).keys()).map((_, index) => (
          <span key={index} className="text-2xl">
            ⭐
          </span>
        ))}
      </div>
    );
  };

  const bookRecs = data.bookRecs;
  const leaderboard = data.leaderboard;

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

  const acsaiGrades = leaderboard.map((bookItem) => {
    return {
      id: bookItem.book.id,
      stars: stars(bookItem.points, avg, stdDev),
    };
  });
  const BOOKS = 10000;

  const acsaiEmbedding = Array.from(Array(BOOKS).keys()).map((_, index) => {
    const book = leaderboard.find((entry) => entry.book.id === String(index));
    return book ? stars(book.points, avg, stdDev) : 0;
  });

  if (leaderboard.length < 3) {
    return (
      <div className="min-h-screen min-w-screen flex justify-center items-center">
        keep voting: too few book on acsai leaderboard
      </div>
    );
  }

  return (
    <div className="p-4">
      <div className="min-h-[50dvh]">
        <div className="p-4">
          <h3 className="text-2xl font-bold text-center">
            {"🧑‍💻 ACSAI's favorite books"}
          </h3>

          <div className="grid grid-cols-3 items-center justify-center">
            {/* silver second  on the left */}
            <div className="flex flex-col items-center scale-90">
              <h3 className="text-6xl font-bold text-gray-300 p-2">🥈</h3>
              <img
                src={leaderboard[1].book.cover}
                alt={leaderboard[1].book.title}
              />
              <p className="text-center">{leaderboard[1].book.title}</p>
              <Stars stars={stars(leaderboard[1].points, avg, stdDev)} />
            </div>

            {/* golden big UI for 1st (leaderboard[0]) at the center */}
            <div className="flex flex-col items-center">
              <h3 className="text-6xl font-bold text-yellow-500 p-2">🥇</h3>
              <img
                src={leaderboard[0].book.cover}
                alt={leaderboard[0].book.title}
              />
              <p className="text-center">{leaderboard[0].book.title}</p>
              <Stars stars={stars(leaderboard[0].points, avg, stdDev)} />
            </div>

            {/* bronze third on the right */}
            <div className="flex flex-col items-center scale-75">
              <h3 className="text-6xl font-bold text-yellow-300 p-2">🥉</h3>
              <img
                src={leaderboard[2].book.cover}
                alt={leaderboard[2].book.title}
              />
              <p className="text-center">{leaderboard[2].book.title}</p>
              <Stars stars={stars(leaderboard[2].points, avg, stdDev)} />
            </div>
          </div>

          {/* table list single column leaderboard for 4th+ */}
          <div className="flex flex-col items-center mt-8">
            {leaderboard.slice(3).map(({ book, points }, index) => (
              <div key={book.id}>
                <div className="flex flex-row items-center justify-between min-w-96 space-x-4">
                  <p>{index + 4}.</p>
                  <p>{book.title}</p>
                  <Stars stars={stars(points, avg, stdDev)} />
                </div>
                <hr className="w-full m-2 p-2" />
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="min-h-screen">
        <pre className="mt-2">
          ACSAI Sparsevec: {JSON.stringify(acsaiGrades)}
        </pre>
        <pre className="my-2">
          ACSAI Embedding: {JSON.stringify(acsaiEmbedding)}
        </pre>

        <h3 className="text-2xl font-bold text-center py-4">
          {"🔖 ACSAI's New Books Recommendations"}
        </h3>
        <div>
          {bookRecs.length > 0 && (
            <div className="grid grid-cols-3 gap-4">
              {bookRecs.map((book) => (
                <div key={book.id} className="flex flex-col items-center">
                  <img src={book.cover} alt={book.title} />
                  <p>{book.title}</p>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* <h3 className="text-2xl font-bold text-center">
        {"Bipartite > Unipartite"}
      </h3>
      <div className="h-[50vh] w-screen">
        <MyResponsiveNetworkCanvas data={data} />
      </div> */}
    </div>
  );
};

export default Recs;
