// 1. Define types for the API data
interface Post {
  id: number;
  title: string;
  body: string;
}

// 2. Fetch all post IDs at build time
export async function generateStaticParams() {
  const res = await fetch(
    "https://jsonplaceholder.typicode.com/posts?_limit=10",
  );
  const posts: Post[] = await res.json();

  // Return an array of objects matching your folder name, e.g., [id]
  return posts.map((post) => ({
    id: post.id.toString(),
  }));
}

// 3. The Page Component
export default async function Page({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;

  const res = await fetch(`https://jsonplaceholder.typicode.com/posts/${id}`);

  if (!res.ok) return <div>Post not found</div>;

  const post: Post = await res.json();

  return (
    <main style={{ padding: "2rem", maxWidth: "600px" }}>
      <header style={{ borderBottom: "1px solid #ccc", marginBottom: "1rem" }}>
        <span>Post ID: {id}</span>
      </header>

      <article>
        <h1 style={{ textTransform: "capitalize" }}>{post.title}</h1>
        <p>{post.body}</p>
      </article>

      <footer style={{ marginTop: "2rem" }}>
        <a href="/">← Back to Home</a>
      </footer>
    </main>
  );
}
