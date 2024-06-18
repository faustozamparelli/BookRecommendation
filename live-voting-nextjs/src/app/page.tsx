import Image from "next/image";
import Link from "next/link";

export default function Home() {
  return (
    <main className="flex flex-col justify-center h-screen items-center">
      <div>
        <p>
          {"1. ☑️"}
          <Link href="/vote" className="underline hover:no-underline m-1">
            {"vote"}
          </Link>
        </p>
        <p>
          {"2. ❤️"}
          <Link href="/favs" className="underline hover:no-underline m-1">
            {"acsai's favs"}
          </Link>
        </p>
        <p>
          {"3. 🕸️"}
          <a href="/recs" className="underline hover:no-underline m-1">
            {"acsai's recommendations"}
          </a>
        </p>
      </div>
    </main>
  );
}
