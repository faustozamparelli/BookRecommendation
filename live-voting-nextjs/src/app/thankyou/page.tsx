import React from "react";

const ThankYou = () => {
  return (
    <div className="flex h-screen flex-col items-center justify-center">
      <div>
        <pre>{"Thank You! You're the best :)"}</pre>
        <pre className="text-sm text-gray-500">
          -{" "}
          <a
            className="underline hover:no-underline"
            target="_blank"
            rel="noopener noreferrer"
            href="https://github.com/danielfalbo"
          >
            Daniel
          </a>{" "}
          and{" "}
          <a
            className="underline hover:no-underline"
            target="_blank"
            rel="noopener noreferrer"
            href="https://github.com/faustozamparelli"
          >
            Fausto
          </a>
        </pre>
      </div>
    </div>
  );
};

export default ThankYou;
