/* eslint-disable @next/next/no-img-element */
"use client";
import { createClient } from "@supabase/supabase-js";
import { useRouter } from "next/navigation";
import React, { useEffect, useState } from "react";

export interface Book {
  title: string;
  id: string;
  cover: string;
}

export type BookGrade = 1 | 2 | 3 | 4 | 5;

const Vote = () => {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_PROJECT_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  const [grades, setGrades] = useState<{ [key: string]: BookGrade }>({});

  const [searchQuery, setSearchQuery] = useState<string>("");

  const [submitted, setSubmitted] = useState(false);

  const [cache, setCache] = useState<{ [key: string]: Book }>({});

  const handleGrade = (id: string, grade: BookGrade) => {
    if (grades[id] === grade) {
      setGrades((prev) => {
        let updated = { ...prev };
        delete updated[id];
        return updated;
      });
    } else {
      setGrades((prev) => ({ ...prev, [id]: grade }));
    }
  };

  const handleSubmit = () => {
    const insertGrades = async () => {
      await supabase.from("grades").insert(
        Object.entries(grades).map(([book_id, grade]) => ({
          book_id,
          grade,
        }))
      );
    };
    insertGrades().then(() => setSubmitted(true));
  };

  useEffect(() => {
    const getData = async () => {
      const { data, error } = await supabase
        .from("books")
        .select("book_id, title, original_title, image_url")
        .ilike("title", `%${searchQuery}%`)
        .limit(420);

      if (error) {
        console.error(error);
        return;
      }

      setCache((prev) => ({
        ...prev,
        ...data.reduce(
          (acc, book) => ({
            ...acc,
            [String(book.book_id)]: {
              id: String(book.book_id),
              title: book.title || book.original_title,
              cover: book.image_url,
            },
          }),
          {}
        ),
      }));
    };
    getData();
  }, [searchQuery, supabase]);

  const router = useRouter();

  if (submitted) {
    router.push("/thankyou");
  }

  return (
    <div className="p-4">
      <h3 className="text-2xl font-bold">💌 Your favorites</h3>
      <div className="grid grid-cols-3 gap-4 overflow-scroll w-full space-x-2 min-h-[20rem]">
        {Object.keys(grades).map((key) => {
          const book = cache[key];
          return (
            <div
              key={book.id}
              className={
                "border p-4 flex flex-col items-center justify-between" +
                (book.id === "" ? " opacity-0" : "")
              }
            >
              <img src={book.cover} alt={book.title} />
              <p className="text-center text-sm">{book.title}</p>

              <div className="flex flex-row space-x-1 pt-4">
                <button
                  className={
                    !Object.keys(grades).includes(book.id) ||
                    grades[book.id] < 1
                      ? "opacity-50"
                      : ""
                  }
                  onClick={() => handleGrade(book.id, 1)}
                >
                  ⭐️
                </button>
                <button
                  className={
                    !Object.keys(grades).includes(book.id) ||
                    grades[book.id] < 2
                      ? "opacity-50"
                      : ""
                  }
                  onClick={() => handleGrade(book.id, 2)}
                >
                  ⭐️
                </button>
                <button
                  className={
                    !Object.keys(grades).includes(book.id) ||
                    grades[book.id] < 3
                      ? "opacity-50"
                      : ""
                  }
                  onClick={() => handleGrade(book.id, 3)}
                >
                  ⭐️
                </button>
                <button
                  className={
                    !Object.keys(grades).includes(book.id) ||
                    grades[book.id] < 4
                      ? "opacity-50"
                      : ""
                  }
                  onClick={() => handleGrade(book.id, 4)}
                >
                  ⭐️
                </button>
                <button
                  className={
                    !Object.keys(grades).includes(book.id) ||
                    grades[book.id] < 5
                      ? "opacity-50"
                      : ""
                  }
                  onClick={() => handleGrade(book.id, 5)}
                >
                  ⭐️
                </button>
              </div>
            </div>
          );
        })}
      </div>

      <button
        className={
          "mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" +
          (Object.keys(grades).length > 0 ? "" : " opacity-0")
        }
        onClick={handleSubmit}
      >
        Submit
      </button>

      <h3 className="text-2xl font-bold mt-4">📚 The library</h3>

      <input
        type="text"
        placeholder="Title"
        className="p-2 border my-8"
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
      />

      <div className="grid grid-cols-3 gap-4">
        {Object.keys(cache)
          .filter((key) => {
            const book = cache[key];
            return book.title.toLowerCase().includes(searchQuery.toLowerCase());
          })
          .map((key) => {
            const book = cache[key];
            return (
              <div
                key={book.id}
                className="border p-4 flex flex-col items-center justify-between"
              >
                <img src={book.cover} alt={book.title} />
                <p className="text-sm text-center">{book.title}</p>

                <div className="flex flex-row space-x-1 pt-4">
                  <button
                    className={
                      !Object.keys(grades).includes(book.id) ||
                      grades[book.id] < 1
                        ? "opacity-50"
                        : ""
                    }
                    onClick={() => handleGrade(book.id, 1)}
                  >
                    ⭐️
                  </button>
                  <button
                    className={
                      !Object.keys(grades).includes(book.id) ||
                      grades[book.id] < 2
                        ? "opacity-50"
                        : ""
                    }
                    onClick={() => handleGrade(book.id, 2)}
                  >
                    ⭐️
                  </button>
                  <button
                    className={
                      !Object.keys(grades).includes(book.id) ||
                      grades[book.id] < 3
                        ? "opacity-50"
                        : ""
                    }
                    onClick={() => handleGrade(book.id, 3)}
                  >
                    ⭐️
                  </button>
                  <button
                    className={
                      !Object.keys(grades).includes(book.id) ||
                      grades[book.id] < 4
                        ? "opacity-50"
                        : ""
                    }
                    onClick={() => handleGrade(book.id, 4)}
                  >
                    ⭐️
                  </button>
                  <button
                    className={
                      !Object.keys(grades).includes(book.id) ||
                      grades[book.id] < 5
                        ? "opacity-50"
                        : ""
                    }
                    onClick={() => handleGrade(book.id, 5)}
                  >
                    ⭐️
                  </button>
                </div>
              </div>
            );
          })}
      </div>
    </div>
  );
};

export default Vote;
