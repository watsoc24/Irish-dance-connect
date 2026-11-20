"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireUser } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import { rateLimit, RATE_LIMITED } from "@/lib/rate-limit";
import { dbError, validationError, type FormState } from "@/lib/form";
import { formObject, questionSchema, replySchema, uuidSchema } from "@/lib/validation";

export async function createQuestion(_: FormState, formData: FormData): Promise<FormState> {
  const account = await requireUser("/parents/new");
  const parsed = questionSchema.safeParse(formObject(formData));
  if (!parsed.success) return validationError(parsed.error);
  if (!(await rateLimit("parent-question", 5, 3600, account.id))) return RATE_LIMITED;
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("parent_questions")
    .insert({
      author_id: account.id,
      title: parsed.data.title,
      body: parsed.data.body,
      category: parsed.data.category,
    })
    .select("id")
    .single();
  if (error) return dbError(error);
  revalidatePath("/parents");
  redirect(`/parents/${data.id}`);
}

export async function deleteQuestion(questionId: string): Promise<FormState> {
  await requireUser("/parents");
  if (!uuidSchema.safeParse(questionId).success) return { error: "Not found." };
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("parent_questions")
    .delete()
    .eq("id", questionId)
    .select("id");
  if (error) return dbError(error);
  if (!data?.length) return { error: "You can only delete your own questions." };
  revalidatePath("/parents");
  redirect("/parents");
}

export async function createReply(questionId: string, _: FormState, formData: FormData): Promise<FormState> {
  const account = await requireUser(`/parents/${questionId}`);
  if (!uuidSchema.safeParse(questionId).success) return { error: "Not found." };
  const parsed = replySchema.safeParse(formObject(formData));
  if (!parsed.success) return validationError(parsed.error);
  if (!(await rateLimit("parent-reply", 20, 3600, account.id))) return RATE_LIMITED;
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("parent_replies")
    .insert({ question_id: questionId, author_id: account.id, body: parsed.data.body })
    .select("id");
  if (error) return dbError(error);
  if (!data?.length) return { error: "That question can't be replied to." };
  revalidatePath(`/parents/${questionId}`);
  revalidatePath("/parents");
  return { ok: true, message: "Reply posted." };
}

export async function deleteReply(questionId: string, replyId: string): Promise<FormState> {
  await requireUser(`/parents/${questionId}`);
  if (!uuidSchema.safeParse(questionId).success || !uuidSchema.safeParse(replyId).success)
    return { error: "Not found." };
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("parent_replies")
    .delete()
    .eq("id", replyId)
    .eq("question_id", questionId)
    .select("id");
  if (error) return dbError(error);
  if (!data?.length) return { error: "You can only delete your own replies." };
  revalidatePath(`/parents/${questionId}`);
  revalidatePath("/parents");
  return { ok: true, message: "Reply deleted." };
}
