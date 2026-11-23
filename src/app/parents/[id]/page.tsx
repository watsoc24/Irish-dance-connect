import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { getAccount } from "@/lib/auth";
import { uuidSchema } from "@/lib/validation";
import { questionCategoryLabel } from "@/lib/parent-questions";
import { ActionForm } from "@/components/action-form";
import { TextArea } from "@/components/fields";
import { createReply, deleteQuestion, deleteReply, setQuestionPinned } from "../actions";

export const metadata = { title: "Question" };

type QuestionRow = {
  id: string;
  title: string;
  body: string;
  category: string;
  author_id: string;
  is_hidden: boolean;
  is_pinned: boolean;
  created_at: string;
};

type ReplyRow = {
  id: string;
  body: string;
  author_id: string;
  created_at: string;
};

export default async function ParentQuestionPage({ params }: PageProps<"/parents/[id]">) {
  const { id } = await params;
  if (!uuidSchema.safeParse(id).success) notFound();
  const account = await getAccount();
  const supabase = await createClient();

  // RLS decides visibility: a hidden question comes back empty for
  // everyone except its author and platform admins, so it 404s here.
  // Until the pinning migration is applied the is_pinned column does
  // not exist and the first query errors, so fall back without it.
  let questionResult = await supabase
    .from("parent_questions")
    .select("id, title, body, category, author_id, is_hidden, is_pinned, created_at")
    .eq("id", id)
    .maybeSingle();
  if (questionResult.error) {
    questionResult = await supabase
      .from("parent_questions")
      .select("id, title, body, category, author_id, is_hidden, created_at")
      .eq("id", id)
      .maybeSingle();
  }
  const questionRow = questionResult.data as Omit<QuestionRow, "is_pinned"> | null;
  const question: QuestionRow | null = questionRow
    ? { ...questionRow, is_pinned: Boolean((questionRow as { is_pinned?: boolean }).is_pinned) }
    : null;
  if (!question) notFound();

  const { data: replyData } = await supabase
    .from("parent_replies")
    .select("id, body, author_id, created_at")
    .eq("question_id", id)
    .eq("is_hidden", false)
    .order("created_at", { ascending: true })
    .limit(500);
  const replies = (replyData ?? []) as ReplyRow[];

  // Author display names, the same profiles lookup the marketplace uses.
  const authorIds = [...new Set([question.author_id, ...replies.map((r) => r.author_id)])];
  const { data: profiles } = await supabase.from("profiles").select("id, display_name").in("id", authorIds);
  const authorNames = new Map((profiles ?? []).map((p) => [p.id, p.display_name]));
  const nameOf = (authorId: string) => authorNames.get(authorId) ?? "Member";

  const isAuthor = account?.id === question.author_id;

  return (
    <div className="space-y-4">
      <Link href="/parents" className="link text-sm">
        ← All questions
      </Link>
      <div className="space-y-2">
        <div className="flex flex-wrap items-center gap-2">
          <span className="badge bg-brand-100 text-brand-900">{questionCategoryLabel(question.category)}</span>
          {question.is_pinned ? <span className="badge">Pinned</span> : null}
          {question.is_hidden ? <span className="badge">Hidden</span> : null}
        </div>
        <h1 className="text-2xl font-bold">{question.title}</h1>
        <p className="text-sm text-gray-500">
          Asked by {nameOf(question.author_id)} · {new Date(question.created_at).toLocaleDateString()}
        </p>
        <p className="whitespace-pre-line text-gray-800">{question.body}</p>
      </div>

      {account?.isPlatformAdmin ? (
        <div className="card space-y-2">
          <h2 className="font-semibold">Admin</h2>
          <ActionForm
            action={setQuestionPinned.bind(null, id, !question.is_pinned)}
            submitLabel={question.is_pinned ? "Unpin question" : "Pin question"}
            pendingLabel="Saving…"
            buttonClassName="btn-secondary w-full"
          >
            <p className="text-sm text-gray-600">
              {question.is_pinned
                ? "This question is pinned to the top of the board. Unpinning returns it to the normal newest-first order."
                : "Pinning keeps this question at the top of the board for every visitor, above newer questions."}
            </p>
          </ActionForm>
        </div>
      ) : null}

      {isAuthor ? (
        <div className="card space-y-2">
          <h2 className="font-semibold">Your question</h2>
          <ActionForm
            action={deleteQuestion.bind(null, id)}
            submitLabel="Delete question"
            pendingLabel="Deleting…"
            buttonClassName="btn-secondary w-full"
          >
            <p className="text-sm text-gray-600">Deleting removes the question and all of its replies.</p>
          </ActionForm>
        </div>
      ) : null}

      <section className="space-y-3">
        <h2 className="font-semibold">{replies.length === 1 ? "1 reply" : `${replies.length} replies`}</h2>
        {replies.length ? (
          <ul className="space-y-3">
            {replies.map((r) => (
              <li key={r.id} className="card space-y-1">
                <p className="whitespace-pre-line text-gray-800">{r.body}</p>
                <p className="text-sm text-gray-500">
                  {nameOf(r.author_id)} · {new Date(r.created_at).toLocaleDateString()}
                  {account?.id === r.author_id ? " · Your reply" : ""}
                </p>
                {account?.id === r.author_id ? (
                  <ActionForm
                    action={deleteReply.bind(null, id, r.id)}
                    submitLabel="Delete reply"
                    pendingLabel="Deleting…"
                    className="pt-1"
                    buttonClassName="btn-secondary"
                  />
                ) : null}
              </li>
            ))}
          </ul>
        ) : (
          <p className="card text-gray-600">No replies yet. If you&apos;ve been through this, your answer helps.</p>
        )}
      </section>

      {account ? (
        <div className="card">
          <h2 className="mb-2 font-semibold">Your reply</h2>
          <ActionForm action={createReply.bind(null, id)} submitLabel="Post reply" pendingLabel="Posting…">
            <TextArea
              label="Reply"
              name="body"
              required
              maxLength={4000}
              hint="Be kind, and please don't share children's full names or photos."
            />
          </ActionForm>
        </div>
      ) : (
        <div className="card space-y-3">
          <p className="text-gray-700">Sign in to reply to this question.</p>
          <Link href={`/login?next=/parents/${id}`} className="btn w-full">
            Sign in
          </Link>
        </div>
      )}
    </div>
  );
}
