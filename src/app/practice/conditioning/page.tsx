import type { Metadata } from "next";
import Link from "next/link";
import { CONDITIONING_GROUPS, EXPERT_VIDEOS, TRAINER_LINKS } from "@/lib/conditioning";

export const metadata: Metadata = {
  title: "Conditioning & Stretching for Irish Dancers",
  description:
    "Gentle conditioning and stretching routines for Irish dancers: ankles and calves, hips and turnout, core and posture, and balance, plus free videos from recommended Irish dance trainers.",
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
        A little light conditioning goes a long way for an Irish dancer. Stronger ankles, hips and core muscles
        mean more height, better balance and control, and landings that are kinder to your joints, and building
        that strength a few minutes at a time helps protect against the aches and overuse injuries dancers are
        prone to.
      </p>
      <p>
        Everything below is a simple, common exercise described in plain words, the kind of movement any good
        teacher or trainer would recognise. There is no equipment, no weight, and nothing extreme. Work slowly,
        and remember that turnout always comes from the hips: no exercise here should ever be forced through the
        knees or ankles.
      </p>
      <p className="rounded-xl bg-brand-50 p-3 text-sm text-brand-900">
        Before you start: warm up first with two or three minutes of marching, easy jogging on the spot or gentle
        skipping. Never exercise hard or stretch on cold muscles. Stop straight away if anything hurts; a stretch
        should feel like a gentle pull, never pain. This page is general information, not medical advice. If your
        dancer is injured, or pain keeps coming back, talk to a doctor or physiotherapist. Young dancers should do
        these with a parent nearby, and it is always worth checking with your dance teacher before adding something
        new.
      </p>
      <section className="card space-y-3" aria-label="Free videos from the experts">
        <h2 className="text-lg font-semibold">Free videos from the experts</h2>
        <p>
          Prefer to watch an expert first? These free videos are from Target Training&apos;s own YouTube channel,
          and they play here through YouTube&apos;s own player. The other trainers linked below keep their video
          teaching inside their own programmes, so we link out to them instead. The same gentle rules apply: warm
          up first, work slowly, and stop if anything hurts.
        </p>
        <div className="space-y-5">
          {EXPERT_VIDEOS.map((video) => (
            <div key={video.youtubeId} className="space-y-2">
              <h3 className="font-semibold">{video.title}</h3>
              <p className="text-sm text-gray-600">
                {video.trainer} · {video.covers}
              </p>
              <div className="aspect-video w-full overflow-hidden rounded-xl">
                <iframe
                  className="h-full w-full"
                  src={`https://www.youtube-nocookie.com/embed/${video.youtubeId}`}
                  title={video.title}
                  loading="lazy"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                  allowFullScreen
                />
              </div>
            </div>
          ))}
        </div>
      </section>
      <div className="space-y-4">
        {CONDITIONING_GROUPS.map((group) => (
          <section key={group.slug} className="card space-y-3" aria-label={group.name}>
            <h2 className="text-lg font-semibold">{group.name}</h2>
            <p>{group.intro}</p>
            <div className="space-y-4">
              {group.exercises.map((exercise) => (
                <div key={exercise.name} className="space-y-1">
                  <h3 className="font-semibold">{exercise.name}</h3>
                  <p>{exercise.howTo}</p>
                  <p>
                    <span className="font-semibold">Try: </span>
                    {exercise.dose}.
                  </p>
                  <p>
                    <span className="font-semibold">Watch for: </span>
                    {exercise.watchFor}
                  </p>
                </div>
              ))}
            </div>
          </section>
        ))}
      </div>
      <section className="card space-y-3" aria-label="Trainers we link to">
        <h2 className="text-lg font-semibold">Trainers we link to</h2>
        <p>
          When you are ready for more than these basics, these established Irish dance conditioning professionals
          run their own structured programmes. They are paid, professional services, and Irish Dance Connect is not
          affiliated with any of them. We simply link to their official websites so you can explore them directly.
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
