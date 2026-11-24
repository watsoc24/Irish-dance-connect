import type { Metadata } from "next";
import Link from "next/link";
import { FundamentalsList } from "@/components/fundamentals-list";

export const metadata: Metadata = {
  title: "Irish Dance Fundamentals: Point, Turn Out, Cross & Arms",
  description:
    "The building blocks of Irish dance technique explained for dancers and parents: how to point, turn out, cross and hold your arms, with simple drills and the mistakes to watch for.",
  alternates: { canonical: "/practice/fundamentals" },
};

export default function FundamentalsPage() {
  return (
    <article className="space-y-4 text-gray-800">
      <Link href="/practice" className="link">
        &larr; Back to practice
      </Link>
      <h1 className="page-title">Fundamentals</h1>
      <p>
        Four basics every Irish dancer works on: point, turn out, cross, and arms. These drills are simple,
        beginner-level, and safe to do at home. Work through them slowly. Good habits built slowly last.
      </p>
      <p className="rounded-xl bg-brand-50 p-3 text-sm text-brand-900">
        Safety note: stop if anything hurts, and ask your teacher if you are unsure about any of these. If a
        movement causes pain, don&apos;t push through it.
      </p>
      <FundamentalsList />
      <p>
        <Link href="/practice" className="link">
          &larr; Back to practice
        </Link>
      </p>
    </article>
  );
}
