import Link from "next/link";
import { getAccount } from "@/lib/auth";
import { ActionForm } from "@/components/action-form";
import { Select, TextArea, TextField } from "@/components/fields";
import { PARENT_GUIDELINES, QUESTION_CATEGORIES } from "@/lib/parent-questions";
import { createQuestion } from "../actions";

export const metadata = { title: "Ask a question" };

export default async function NewQuestionPage() {
  const account = await getAccount();
  return (
    <div className="space-y-4">
      <h1 className="page-title">Ask a question</h1>
      <p className="text-sm text-gray-600">{PARENT_GUIDELINES}</p>
      {account ? (
        <ActionForm action={createQuestion} submitLabel="Post question" pendingLabel="Posting…">
          <TextField
            label="Title"
            name="title"
            required
            minLength={5}
            maxLength={140}
            placeholder="e.g. What does our first feis morning actually look like?"
          />
          <Select label="Category" name="category" options={QUESTION_CATEGORIES} placeholder="Choose a category" required />
          <TextArea
            label="Your question"
            name="body"
            required
            minLength={10}
            maxLength={4000}
            hint="Details help other parents answer — your dancer's level and what you've already tried are great to include."
          />
        </ActionForm>
      ) : (
        <div className="card space-y-3">
          <p className="text-gray-700">
            You need a free account to ask a question, so other parents know who they&apos;re talking with. It only
            takes a minute.
          </p>
          <Link href="/login?next=/parents/new" className="btn w-full">
            Sign in
          </Link>
          <Link href="/signup" className="btn-secondary w-full">
            Create free account
          </Link>
          <p className="text-sm text-gray-600">
            Just browsing? You can read everything on the{" "}
            <Link href="/parents" className="link">
              Ask a Parent board
            </Link>{" "}
            without an account.
          </p>
        </div>
      )}
    </div>
  );
}
