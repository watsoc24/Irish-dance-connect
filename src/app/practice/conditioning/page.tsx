import type { Metadata } from "next";
import Link from "next/link";
import { ConditioningVideos, TrainerLinks } from "@/components/conditioning-videos";

export const metadata: Metadata = {
  title: "Conditioning & Stretching for Irish Dancers",
  description:
    "Follow-along conditioning and stretching videos for Irish dancers from Target Training: ankles, turnout, core and full-body work, plus links to established Irish dance trainers.",
  alternates: { canonical: "/practice/conditioning" },
};

export default function ConditioningPage() {
  return (
    <article className="space-y-4 text-gray-800">
      <Link href="/practice" className="link">
        &larr; Back to practice
      </Link>
      <h1 className="page-title">Conditioning &amp; stretching</h1>
      <p>
        A little conditioning goes a long way for an Irish dancer. Stronger ankles, hips and core muscles mean
        more height, better balance and control, and landings that are kinder to your joints. Rather than
        describe exercises in text, we would rather you learn them from a trainer: the free teaching videos
        below are from Target Training, and tapping one opens it on YouTube.
      </p>
      <p className="rounded-xl bg-brand-50 p-3 text-sm text-brand-900">
        Before you start: warm up first with two or three minutes of marching, easy jogging on the spot or
        gentle skipping, and follow the trainer&apos;s cues as you go. Stop straight away if anything hurts.
        This page is general information, not medical advice. If your dancer is injured, or pain keeps coming
        back, talk to a doctor or physiotherapist, and it is always worth checking with your dance teacher
        before adding something new.
      </p>
      <section className="space-y-5" aria-label="Free teaching videos">
        <h2 className="text-lg font-semibold">Free teaching videos</h2>
        <ConditioningVideos />
      </section>
      <TrainerLinks />
      <p>
        <Link href="/practice" className="link">
          &larr; Back to practice
        </Link>
      </p>
    </article>
  );
}
