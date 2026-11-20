/**
 * Categories for the parents' Q&A board ("Ask a Parent"), plus the one
 * guideline sentence shown wherever parents post. Slugs are stored in
 * parent_questions.category and checked in the database, so this list,
 * the migration's check constraint, and the zod schemas must stay in step
 * (spec: specs/parent-questions-v1.md).
 */
export const QUESTION_CATEGORIES = [
  ["getting-started", "Getting started"],
  ["feis-day", "Feis day"],
  ["dresses-and-gear", "Dresses & gear"],
  ["practice", "Practice"],
  ["schools-and-teachers", "Schools & teachers"],
  ["competitions", "Competitions"],
  ["other", "Other"],
] as const;

export type QuestionCategory = (typeof QUESTION_CATEGORIES)[number][0];

export const questionCategoryLabel = (v: string) =>
  QUESTION_CATEGORIES.find(([k]) => k === v)?.[1] ?? v;

/** Shown on the question list and the ask form. */
export const PARENT_GUIDELINES =
  "Be kind, no selling (the marketplace is for that), and please don't share children's full names or photos.";
