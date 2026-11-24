import type { Metadata } from "next";
import Link from "next/link";
import { EXPERT_VIDEOS, TRAINER_LINKS } from "@/lib/conditioning";

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
        &larr; Back to practice music
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
        {EXPERT_VIDEOS.map((video) => (
          <a
            key={video.youtubeId}
            href={`https://www.youtube.com/watch?v=${video.youtubeId}`}
            target="_blank"
            rel="noreferrer"
            className="card block space-y-2"
          >
            <span className="relative block aspect-video w-full overflow-hidden rounded-xl">
              {/* YouTube's own thumbnail for this video; the whole card is the link. */}
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={`https://i.ytimg.com/vi/${video.youtubeId}/hqdefault.jpg`}
                alt=""
                loading="lazy"
                className="h-full w-full object-cover"
              />
              <span className="absolute inset-0 flex items-center justify-center">
                <span className="flex h-14 w-14 items-center justify-center rounded-full bg-black/70 text-white">
                  <svg viewBox="0 0 24 24" className="ml-1 h-6 w-6 fill-current" aria-hidden="true">
                    <path d="M8 5v14l11-7z" />
                  </svg>
                </span>
              </span>
            </span>
            <span className="block font-semibold">{video.title}</span>
            <span className="block text-sm text-gray-600">
              {video.trainer} · {video.covers}
            </span>
            <span className="link block text-sm">Watch on YouTube</span>
          </a>
        ))}
      </section>
      <section className="card space-y-3" aria-label="Trainers we link to">
        <h2 className="text-lg font-semibold">Trainers we link to</h2>
        <p>
          When you are ready for more than these basics, these established Irish dance conditioning
          professionals run their own structured programmes. They are paid, professional services, and Irish
          Dance Connect is not affiliated with any of them. We simply link to their official websites so you
          can explore them directly.
        </p>
        <ul className="space-y-3">
          {TRAINER_LINKS.map((trainer) => (
            <li key={trainer.url}>
              <a href={trainer.url} target="_blank" rel="noreferrer" className="link font-semibold">
                {trainer.name}
              </a>
              <p className="text-sm text-gray-600">{trainer.blurb}</p>
            </li>
          ))}
        </ul>
      </section>
      <p>
        <Link href="/practice" className="link">
          &larr; Back to practice music
        </Link>
      </p>
    </article>
  );
}
