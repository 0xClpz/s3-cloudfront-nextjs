import { useRouter } from "next/router";
import { Navbar } from "../../components/Navbar";

export async function getStaticProps({ params }) {
  return {
    props: {
      id: params.id,
    },
  };
}

export async function getStaticPaths() {
  return {
    paths: ["/articles/why-next-matters", "/articles/why-s3-sucks"],
    fallback: false,
  };
}

export default function Articles({ id }) {
  const router = useRouter();
  return (
    <div>
      <Navbar />
      <h1>Article {router.query.id}</h1>
    </div>
  );
}
