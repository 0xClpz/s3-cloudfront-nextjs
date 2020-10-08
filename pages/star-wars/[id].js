import { Navbar } from "../../components/Navbar";
import * as axios from "axios";

export async function getStaticProps({ params }) {
  const { id } = params;
  const { data } = await axios.get(`https://swapi.dev/api/people/${id}`);
  return {
    props: {
      data,
    },
  };
}

export async function getStaticPaths() {
  return {
    paths: new Array(10).fill(0).map((_, index) => `/star-wars/${index + 1}`),
    fallback: false,
  };
}

export default function StarWars({ data }) {
  if (!data) {
    return null;
  }
  return (
    <div>
      <Navbar />
      <h1>{data.name}</h1>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </div>
  );
}
