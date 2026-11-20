import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getAccount } from "@/lib/auth";
import { searchTerm } from "@/lib/validation";
import { PARENT_GUIDELINES, QUESTION_CATEGORIES, questionCategoryLabel } from "@/lib/parent-questions";

export const metadata = { title: "Ask a Parent" };

type QuestionRow = {
  id: string;
  title: string;
  body: string;
  category: string;
  author_id: string;
  created_at: string;
};

function excerpt(body: string): string {
  const flat = body.replace(/\s+/g, " ").trim();
  return flat.length > 180 ? `${flat.slice(0, 180)}…` : flat;
}

export default async function ParentsPage({ searchParams }: PageProps<"/parents">) {
  const sp = await searchParams;
  const q = searchTerm(sp.q);
  const category = QUESTION_CATEGORIES.some(([v]) => v === sp.category) ? (sp.category as string) : "";
  const account = await getAccount();
  const supabase = await createClient();

  let query = supabase
    .from("parent_questions")
    .select("id, title, body, category, author_id, created_at")
    .eq("is_hidden", false)
    .order("created_at", { ascending: false })
    .limit(100);
  if (q) query = query.or(`title.ilike."%${q}%",body.ilike."%${q}%"`);
  if (category) query = query.eq("category", category);
  const { data } = await query;
  const questions = (data ?? []) as QuestionRow[];
  const hasFilter = Boolean(q || category);

  // Reply counts and author display names, fetched the same way the
  // marketplace looks up a seller's name (profiles, "Member" fallback).
  const replyCounts = new Map<string, number>();
  const authorNames = new Map<string, string>();
  if (questions.length) {
    const questionIds = questions.map((x) => x.id);
    const authorIds = [...new Set(questions.map((x) => x.author_id))];
    const [{ data: replyRows }, { data: profiles }] = await Promise.all([
      supabase.from("parent_replies").select("question_id").in("question_id", questionIds).eq("is_hidden", false),
      supabase.from("profiles").select("id, display_name").in("id", authorIds),
    ]);
    for (const r of replyRows ?? []) {
      replyCounts.set(r.question_id, (replyCounts.get(r.question_id) ?? 0) + 1);
    }
    for (const p of profiles ?? []) authorNames.set(p.id, p.display_name);
  }

  return (
    <div className="space-y-4">
      <h1 className="page-title">Ask a Parent</h1>
      <p className="text-sm text-gray-600">
        Questions from dance parents, answered by dance parents. {PARENT_GUIDELINES}
      </p>
      <Link href="/parents/new" className="btn w-full">
        Ask a question
      </Link>
      <form className="space-y-2" role="search">
        <input
          name="q"
          defaultValue={q}
          placeholder="Search questions"
          className="input w-full"
          maxLength={60}
          aria-label="Search questions"
        />
        <div className="flex gap-2">
          <select name="category" defaultValue={category} className="input min-w-0 flex-1" aria-label="Filter by category">
            <option value="">All categories</option>
            {QUESTION_CATEGORIES.map(([value, label]) => (
              <option key={value} value={value}>
                {label}
              </option>
            ))}
          </select>
          <button className="btn-secondary">Search</button>
          {hasFilter ? (
            <Link href="/parents" className="btn-secondary">
              Clear
            </Link>
          ) : null}
        </div>
      </form>

      <p className="text-sm text-gray-600" role="status">
        {questions.length === 1 ? "1 question" : `${questions.length} questions`}
        {hasFilter ? " matching your search" : ""}
      </p>

      {questions.length ? (
        <ul className="space-y-3">
          {questions.map((x) => {
            const count = replyCounts.get(x.id) ?? 0;
            return (
              <li key={x.id}>
                <Link href={`/parents/${x.id}`} className="card block space-y-1">
                  <span className="badge bg-brand-100 text-brand-900">{questionCategoryLabel(x.category)}</span>
                  <span className="block text-lg font-semibold">{x.title}</span>
                  <span className="block text-sm text-gray-600">{excerpt(x.body)}</span>
                  <span className="block text-sm text-gray-500">
                    Asked by {authorNames.get(x.author_id) ?? "Member"} ·{" "}
                    {new Date(x.created_at).toLocaleDateString()} · {count === 1 ? "1 reply" : `${count} replies`}
                    {account?.id === x.author_id ? " · Your question" : ""}
                  </span>
                </Link>
              </li>
            );
          })}
        </ul>
      ) : (
        <p className="card text-gray-600">
          No questions{hasFilter ? " match your search" : " yet — be the first to ask"}.
        </p>
      )}
    </div>
  );
}
