import { EXPERT_VIDEOS, TRAINER_LINKS } from "@/lib/conditioning";

/** Clickable video cards: each one opens the teaching video on YouTube. */
export function ConditioningVideos() {
  return (
    <div className="space-y-5">
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
    </div>
  );
}

/** The established trainers section, linking out to their official sites. */
export function TrainerLinks() {
  return (
    <section className="card space-y-3" aria-label="Trainers we link to">
      <h3 className="text-lg font-semibold">Trainers we link to</h3>
      <p>
        When you are ready for more than these basics, these established Irish dance conditioning professionals
        run their own structured programmes. They are paid, professional services, and Irish Dance Connect is
        not affiliated with any of them. We simply link to their official websites so you can explore them
        directly.
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
  );
}
