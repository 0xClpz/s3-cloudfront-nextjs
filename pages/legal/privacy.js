import Head from 'next/head'
import {Navbar} from "../../components/Navbar";

export default function Privacy() {
  return (
    <div className="container">
      <Navbar />
      <Head>
        <title>Create Next App</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <h1>Privacy</h1>
    </div>
  )
}
