import { Navbar } from "../components/Navbar";
import { useEffect, useState } from "react";

const emojis = ["🤷🏻‍♂️", "😂", "😅", "🤔"];

export default function Home() {
  const [state, setState] = useState(0);

  useEffect(() => {
    setInterval(() => {
      setState((s) => s + 1);
    }, 500);
  }, []);

  useEffect(() => {
    if (typeof document !== "undefined") {
      document.title = `${emojis[state % emojis.length]} JS Working ${
        emojis[state % emojis.length]
      }`;
    }
  }, [state]);
  return (
    <div>
      <Navbar />
      <h1 className="title">
        Welcome to <a href="https://nextjs.org">Next.js!</a>
      </h1>
    </div>
  );
}
