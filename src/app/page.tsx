import Link from "next/link";
import { env } from "@/lib/env";

export default async function Home({ searchParams }: PageProps<"/">) {
  const { notice } = await searchParams;
  const sections = [
    {
      href: "/feis",
      title: "Feis calendar",
      body: "Upcoming feiseanna in one place, with a direct link to each organizer's official registration page.",
    },
    {
      href: "/marketplace",
      title: "Dress & gear marketplace",
      body: "Buy and sell solo dresses, shoes, wigs and more with other dance families. Secure checkout through Stripe.",
      badge: !env.stripeConfigured ? "Coming soon" : null,
    },
    {
      href: "/schools",
      title: "School directory",
      body: "Find Irish dance schools near you. Verified badges mean the school itself has confirmed its listing.",
    },
  ];
  return (
    <div className="space-y-6">
      {notice === "account-deleted" ? (
        <p role="status" className="rounded-lg bg-brand-50 p-3 text-sm text-brand-900">
          Your account and its data have been deleted.
        </p>
      ) : null}
      <section className="double-rule">
        <p className="kicker">Feis calendar · 810 schools · Marketplace</p>
        <h1 className="mt-2 font-display text-[40px] leading-[1.1] font-bold text-ink">
          The Irish dance world, in one place
        </h1>
        <p className="mt-3 max-w-xl text-ink/80">
          For dance parents and schools: find feiseanna, find schools, and pass on dresses and gear your dancer has
          outgrown.
        </p>
        <div className="mt-5 flex flex-wrap gap-2 pb-2">
          <Link href="/signup" className="btn">
            Create free account
          </Link>
          <Link href="/feis" className="btn-secondary">
            Browse feiseanna
          </Link>
        </div>
      </section>
      <ul className="space-y-3">
        {sections.map((s, i) => (
          <li key={s.href}>
            <Link href={s.href} className="card block">
              <h2 className="flex items-center gap-2 text-lg font-semibold">
                <span className="font-mono text-sm font-medium text-brand-700">{String(i + 1).padStart(2, "0")} —</span>
                {s.title}
                {"badge" in s && s.badge ? <span className="badge bg-brand-100 text-brand-900">{s.badge}</span> : null}
              </h2>
              <p className="text-muted">{s.body}</p>
            </Link>
          </li>
        ))}
      </ul>
      <section className="card text-sm text-ink/80">
        <h2 className="mb-1 font-semibold text-ink">Built with dancers&apos; privacy in mind</h2>
        <p>
          Only parents and school staff have accounts. Dancer details stay private to their parent, and we never
          show children&apos;s names or photos publicly.
        </p>
      </section>
    </div>
  );
}
