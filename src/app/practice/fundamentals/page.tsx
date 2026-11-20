import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Irish Dance Fundamentals: Point, Turn Out, Cross & Arms",
  description:
    "The building blocks of Irish dance technique explained for dancers and parents: how to point, turn out, cross and hold your arms, with simple drills and the mistakes to watch for.",
  alternates: { canonical: "/practice/fundamentals" },
};

const fundamentals = [
  {
    name: "Point",
    what: "Pointing means extending the foot through the ankle so the whole foot (not just the toes) makes one long line with the leg.",
    drill:
      "Stand tall holding the back of a chair or a wall for balance. Slowly extend one foot forward along the floor, pointing through the ankle, hold for a slow count of three, then return the foot to the floor. Repeat five times on each foot.",
    watchFor: [
      "Point through the ankle; don't just curl the toes.",
      "Keep the foot in line with the leg, not turned in or out.",
      "Keep your hips level and your standing leg steady.",
    ],
    dances: "Reel and light jig",
    metronomeHref: "/practice?dance=reel&level=beginner&bpm=90",
  },
  {
    name: "Turn out",
    what: "Turn out means the feet are turned out from the hips, with the knees tracking over the toes. Turnout always comes from the hip, never by twisting the knee or ankle.",
    drill:
      "Stand tall with your feet in a small V, heels together and toes pointing out. Slowly bend both knees, keeping each knee over its toes, then straighten again. Repeat five times, keeping your heels on the floor.",
    watchFor: [
      "Knees track over the toes as you bend; they should not roll inward.",
      "Turn out from the hips; never force it by twisting a knee or ankle.",
      "Keep your heels on the floor and your weight even across both feet.",
    ],
    dances: "All soft-shoe dances",
    metronomeHref: "/practice?dance=light-jig&level=beginner&bpm=90",
  },
  {
    name: "Cross",
    what: "Crossing means the feet pass in front of each other, as in third or fifth position, so the legs cross cleanly on jumps and steps with the knees together.",
    drill:
      "Stand tall, then step one foot across in front of the other, placing it in a crossed position with the knees together. Hold for a slow count of three, step back to standing, then cross with the other foot in front. Repeat five times on each side.",
    watchFor: [
      "Keep the knees together when the feet are crossed.",
      "Cross cleanly: the feet should not catch or trip each other.",
      "Keep your upper body upright and still while the feet move.",
    ],
    dances: "Reel and treble jig",
    metronomeHref: "/practice?dance=reel&level=beginner&bpm=90",
  },
  {
    name: "Arms",
    what: "In Irish dance the arms are held straight at the sides, hands in relaxed fists, shoulders down. The arms do not swing or flap while the feet are working.",
    drill:
      "Stand tall with your arms straight at your sides and your hands in relaxed fists. March slowly in place, lifting each knee in turn, while keeping your arms still and your shoulders down. Try ten slow steps.",
    watchFor: [
      "Shoulders stay down and relaxed, not up by your ears.",
      "Hands are relaxed fists, not clenched tight and not flapping.",
      "Arms stay still at your sides while the legs move.",
    ],
    dances: "All dances",
    metronomeHref: "/practice?dance=reel&level=beginner&bpm=90",
  },
];

export default function FundamentalsPage() {
  return (
    <article className="space-y-4 text-gray-800">
      <Link href="/practice" className="link">
        &larr; Back to practice music
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
      <div className="space-y-4">
        {fundamentals.map((f) => (
          <section key={f.name} className="card space-y-3" aria-label={f.name}>
            <h2 className="text-lg font-semibold">{f.name}</h2>
            <p>{f.what}</p>
            <div>
              <h3 className="font-semibold">Try this drill</h3>
              <p>{f.drill}</p>
            </div>
            <div>
              <h3 className="font-semibold">What to watch for</h3>
              <ul className="list-disc space-y-1 pl-5">
                {f.watchFor.map((item) => (
                  <li key={item}>{item}</li>
                ))}
              </ul>
            </div>
            <p>
              <span className="font-semibold">Matters most for: </span>
              {f.dances}.
            </p>
            <Link href={f.metronomeHref} className="btn">
              Practice with the metronome
            </Link>
          </section>
        ))}
      </div>
      <p>
        <Link href="/practice" className="link">
          &larr; Back to practice music
        </Link>
      </p>
    </article>
  );
}
