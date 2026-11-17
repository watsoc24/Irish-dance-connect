"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { requireSchoolAdmin } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import { rateLimit, RATE_LIMITED } from "@/lib/rate-limit";
import { dbError, validationError, type FormState } from "@/lib/form";
import { choreographySchema, claimSchema, formObject, schoolEditSchema, uuidSchema } from "@/lib/validation";

export async function submitClaim(_: FormState, formData: FormData): Promise<FormState> {
  const account = await requireSchoolAdmin("/schools/claim");
  const parsed = claimSchema.safeParse(formObject(formData));
  if (!parsed.success) return validationError(parsed.error);
  if (!(await rateLimit("school-claim", 5, 86400, account.id))) return RATE_LIMITED;
  const d = parsed.data;
  const supabase = await createClient();
  const { error } = await supabase.from("school_claims").insert({
    school_id: d.schoolId,
    proposed_name: d.schoolId ? null : d.proposedName,
    proposed_city: d.schoolId ? null : d.proposedCity,
    proposed_region: d.schoolId ? null : d.proposedRegion,
    proposed_country: d.schoolId ? null : d.proposedCountry,
    proposed_website: d.schoolId ? null : d.proposedWebsite,
    claimant_title: d.claimantTitle,
    contact_email: d.contactEmail,
    evidence: d.evidence,
  });
  if (error) {
    if (error.code === "23505") return { error: "You already have a pending claim for this school." };
    return dbError(error);
  }
  redirect("/schools/manage?claimed=1");
}

export async function updateSchool(schoolId: string, _: FormState, formData: FormData): Promise<FormState> {
  await requireSchoolAdmin("/schools/manage");
  if (!uuidSchema.safeParse(schoolId).success) return { error: "Not found." };
  const parsed = schoolEditSchema.safeParse(formObject(formData));
  if (!parsed.success) return validationError(parsed.error);
  const d = parsed.data;
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("schools")
    .update({
      city: d.city,
      region: d.region,
      country: d.country,
      website_url: d.websiteUrl,
      public_email: d.publicEmail,
      description: d.description,
    })
    .eq("id", schoolId)
    .select("slug");
  if (error) return dbError(error);
  if (!data?.length) return { error: "You don't manage this school." };
  revalidatePath(`/schools/${data[0].slug}`);
  return { ok: true, message: "Saved." };
}

export async function addChoreography(schoolId: string, _: FormState, formData: FormData): Promise<FormState> {
  const account = await requireSchoolAdmin("/schools/manage");
  if (!uuidSchema.safeParse(schoolId).success) return { error: "Not found." };
  const parsed = choreographySchema.safeParse(formObject(formData));
  if (!parsed.success) return validationError(parsed.error);
  if (!(await rateLimit("school-choreography", 10, 3600, account.id))) return RATE_LIMITED;
  const d = parsed.data;
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_choreography")
    .insert({
      school_id: schoolId,
      created_by: account.id,
      title: d.title,
      dance: d.dance,
      level: d.level,
      notes: d.notes,
      video_url: d.videoUrl,
      is_published: d.isPublished,
    })
    .select("id");
  if (error) return dbError(error);
  if (!data?.length) return { error: "You don't manage this school." };
  revalidatePath("/schools/manage");
  return { ok: true, message: "Choreography added." };
}

export async function updateChoreography(
  schoolId: string,
  itemId: string,
  _: FormState,
  formData: FormData,
): Promise<FormState> {
  const account = await requireSchoolAdmin("/schools/manage");
  if (!uuidSchema.safeParse(schoolId).success || !uuidSchema.safeParse(itemId).success)
    return { error: "Not found." };
  const parsed = choreographySchema.safeParse(formObject(formData));
  if (!parsed.success) return validationError(parsed.error);
  if (!(await rateLimit("school-choreography", 10, 3600, account.id))) return RATE_LIMITED;
  const d = parsed.data;
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_choreography")
    .update({
      title: d.title,
      dance: d.dance,
      level: d.level,
      notes: d.notes,
      video_url: d.videoUrl,
      is_published: d.isPublished,
    })
    .eq("id", itemId)
    .eq("school_id", schoolId)
    .select("id");
  if (error) return dbError(error);
  if (!data?.length) return { error: "You don't manage this school." };
  revalidatePath("/schools/manage");
  return { ok: true, message: "Saved." };
}

export async function deleteChoreography(schoolId: string, itemId: string): Promise<FormState> {
  await requireSchoolAdmin("/schools/manage");
  if (!uuidSchema.safeParse(schoolId).success || !uuidSchema.safeParse(itemId).success)
    return { error: "Not found." };
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("school_choreography")
    .delete()
    .eq("id", itemId)
    .eq("school_id", schoolId)
    .select("id");
  if (error) return dbError(error);
  if (!data?.length) return { error: "You don't manage this school." };
  revalidatePath("/schools/manage");
  return { ok: true, message: "Deleted." };
}
