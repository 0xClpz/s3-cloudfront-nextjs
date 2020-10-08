import Link from "next/link";
import React from "react";

const Links = [
  {
    name: "Home",
    url: "/",
  },
  {
    name: "Page 2",
    url: "/page2",
  },
  {
    name: "Privacy",
    url: "/legal/privacy",
  },
  {
    name: "Why next matters",
    url: "/articles/why-next-matters",
  },
  {
    name: "Why s3 sucks",
    url: "/articles/why-s3-sucks",
  },
  {
    name: "Luke skywalker",
    url: "/star-wars/1",
  },
  {
    name: "C-3PO",
    url: "/star-wars/2",
  },
];

export const Navbar = () => {
  return (
    <ul>
      {Links.map((link) => (
        <li key={link.url}>
          <Link href={link.url}>
            <a>{link.name}</a>
          </Link>
        </li>
      ))}
    </ul>
  );
};
