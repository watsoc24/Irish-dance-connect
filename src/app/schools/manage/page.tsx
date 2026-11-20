import Link from "next/link";
import { requireSchoolAdmin } from "@/lib/auth";
import { createClient } from "@/lib/supabase/server";
import { ActionForm } from "@/components/action-form";
import { Checkbox, Select, TextArea, TextField } from "@/components/fields";
import type { FormState } from "@/lib/form";
import {
  CHOREOGRAPHY_DANCES,
  CHOREOGRAPHY_LEVELS,
  choreographyDanceLabel,
  choreographyLevelLabel,
} from "@/lib/validation";
import { addChoreography, deleteChoreography, updateChoreography, updateSchool } from "../actions";

export const metadata = { title: "My school" };

type School = {
  id: string;
  name: string;
  slug: string;
  city: string | null;
  region: string | null;
  country: string | null;
  website_url: string | null;
  public_email: string | null;
  description: string | null;
};

type ChoreographyItem = {
  id: string;
  school_id: string;
  title: string;
  dance: string;
  level: string;
  notes: string | null;
  video_url: string | null;
  is_published: boolean;
};

/** Add/edit fields for one choreography item (prefilled when `item` is given). */
function ChoreographyForm({
  action,
  submitLabel,
  item,
}: {
  action: (state: FormState, formData: FormData) => Promise<FormState>;
  submitLabel: string;
  item?: ChoreographyItem;
}) {
  return (
    <ActionForm action={action} submitLabel={submitLabel}>
      <TextField label="Title" name="title" maxLength={120} defaultValue={item?.title ?? ""} />
      <Select
        label="Dance"
        name="dance"
        options={CHOREOGRAPHY_DANCES}
        placeholder="Choose a dance"
        defaultValue={item?.dance ?? ""}
      />
      <Select
        label="Level"
        name="level"
        options={CHOREOGRAPHY_LEVELS}
        placeholder="Choose a level"
        defaultValue={item?.level ?? ""}
      />
      <TextArea label="Notes" name="notes" maxLength={2000} defaultValue={item?.notes ?? ""} />
      <TextField
        label="Video link"
        name="videoUrl"
        type="url"
        maxLength={300}
        placeholder="https://"
        defaultValue={item?.video_url ?? ""}
        hint="YouTube or Vimeo link only. The video is never uploaded here."
      />
      <Checkbox
        label="Ready to share later (not visible to dancers yet)"
        name="isPublished"
        defaultChecked={item?.is_published ?? false}
      />
    </ActionForm>
  );
}

export default async function ManageSchoolPage({ searchParams }: PageProps<"/schools/manage">) {
  const account = await requireSchoolAdmin("/schools/manage");
  const { claimed } = await searchParams;
  const supabase = await createClient();
  const [{ data: memberships }, { data: claims }] = await Promise.all([
    supabase.from("school_admins").select("schools(*)").eq("user_id", account.id),
    supabase
      .from("school_claims")
      .select("id, status, proposed_name, reviewer_note, created_at, schools(name)")
      .order("created_at", { ascending: false }),
  ]);
  const schools = (memberships ?? []).map((m) => m.schools as unknown as School).filter(Boolean);

  // Staff-only choreography for the schools this admin manages. RLS on
  // school_choreography already limits rows to the caller's schools; the
  // .in() filter below only scopes the fetch to the sections on this page.
  let choreography: ChoreographyItem[] = [];
  if (schools.length) {
    const { data } = await supabase
      .from("school_choreography")
      .select("id, school_id, title, dance, level, notes, video_url, is_published")
      .in(
        "school_id",
        schools.map((s) => s.id),
      )
      .order("created_at", { ascending: false });
    choreography = (data ?? []) as ChoreographyItem[];
  }
  const choreographyBySchool = new Map<string, ChoreographyItem[]>();
  for (const item of choreography) {
    const list = choreographyBySchool.get(item.school_id) ?? [];
    list.push(item);
    choreographyBySchool.set(item.school_id, list);
  }

  return (
    <div className="space-y-6">
      <h1 className="page-title">My school</h1>
      {claimed ? (
        <p role="status" className="rounded-xl bg-brand-50 p-3 text-sm text-brand-900">
          Claim submitted. We&apos;ll contact you at the email you gave us.
        </p>
      ) : null}

      {schools.map((s) => {
        const items = choreographyBySchool.get(s.id) ?? [];
        return (
          <section key={s.id} className="card space-y-3">
            <div className="flex items-center justify-between">
              <h2 className="font-semibold">{s.name}</h2>
              <Link href={`/schools/${s.slug}`} className="link text-sm">
                View public page
              </Link>
            </div>
            <ActionForm action={updateSchool.bind(null, s.id)} submitLabel="Save school details">
              <TextField label="City" name="city" maxLength={80} defaultValue={s.city ?? ""} />
              <TextField label="State / region" name="region" maxLength={80} defaultValue={s.region ?? ""} />
              <TextField label="Country" name="country" maxLength={56} defaultValue={s.country ?? ""} />
              <TextField label="Website" name="websiteUrl" type="url" maxLength={300} placeholder="https://" defaultValue={s.website_url ?? ""} />
              <TextField label="Public contact email" name="publicEmail" type="email" maxLength={254} defaultValue={s.public_email ?? ""} />
              <TextArea
                label="About the school"
                name="description"
                maxLength={2000}
                defaultValue={s.description ?? ""}
                hint="Public. Don't include students' names or photos."
              />
            </ActionForm>
            <p className="text-xs text-gray-500">To change the school&apos;s name, contact the platform team.</p>

            <div className="space-y-3 border-t pt-3">
              <div>
                <h3 className="font-semibold">Choreography</h3>
                <p className="text-xs text-gray-500">
                  Staff-only: dancers can&apos;t see this yet. Add the steps your school teaches, with an optional
                  video link.
                </p>
              </div>
              {items.length ? (
                <ul className="space-y-3">
                  {items.map((item) => (
                    <li key={item.id} className="space-y-3 rounded-xl border p-3">
                      <div className="flex items-center justify-between gap-2">
                        <p className="text-sm font-medium">{item.title}</p>
                        <span className="badge">{item.is_published ? "Ready to share later" : "Draft"}</span>
                      </div>
                      <p className="text-sm text-gray-600">
                        {choreographyDanceLabel(item.dance)} · {choreographyLevelLabel(item.level)}
                      </p>
                      <ChoreographyForm
                        action={updateChoreography.bind(null, s.id, item.id)}
                        submitLabel="Save choreography"
                        item={item}
                      />
                      <ActionForm
                        action={deleteChoreography.bind(null, s.id, item.id)}
                        submitLabel="Delete"
                        buttonClassName="btn-secondary w-full"
                      />
                    </li>
                  ))}
                </ul>
              ) : (
                <p className="text-sm text-gray-500">No choreography yet.</p>
              )}
              <h4 className="font-medium">Add choreography</h4>
              <ChoreographyForm action={addChoreography.bind(null, s.id)} submitLabel="Add choreography" />
            </div>
          </section>
        );
      })}

      {claims?.length ? (
        <section>
          <h2 className="mb-2 font-semibold">Your claims</h2>
          <ul className="space-y-2">
            {claims.map((c) => (
              <li key={c.id} className="card text-sm">
                <span className="font-medium">{(c.schools as unknown as { name: string } | null)?.name ?? c.proposed_name}</span> ·{" "}
                <span className="badge">{c.status}</span>
                {c.reviewer_note ? <p className="mt-1 text-gray-600">Note: {c.reviewer_note}</p> : null}
              </li>
            ))}
          </ul>
        </section>
      ) : null}

      {!schools.length ? (
        <Link href="/schools" className="btn w-full">
          Find and claim your school
        </Link>
      ) : (
        <Link href="/feis/submit" className="btn-secondary w-full">
          Submit a feis
        </Link>
      )}
    </div>
  );
}
