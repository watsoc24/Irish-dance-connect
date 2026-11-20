import Link from "next/link";

export const metadata = { title: "Become a Featured Vendor" };

export default function FeaturedVendorPage() {
  return (
    <div className="space-y-4">
      <Link href="/vendors" className="link">
        &larr; Back to vendor directory
      </Link>
      <h1 className="page-title">Become a founding Featured Vendor</h1>
      <p>
        Irish Dance Connect is a new, free resource for Irish dance families: a feis calendar, a directory of
        810 schools, practice tools and a dress &amp; gear marketplace, run by a dance family in Ohio. We are
        inviting a small number of dress makers and vendors to be our founding Featured Vendors.
      </p>

      <section className="card space-y-2" aria-label="What a featured profile includes">
        <h2 className="text-lg font-semibold">What a featured profile includes</h2>
        <ul className="list-disc space-y-1 pl-5">
          <li>
            <span className="font-semibold">Your own profile page</span> in the vendor directory: what you make,
            where you are, and direct links to your website and Instagram.
          </li>
          <li>
            <span className="font-semibold">A Featured badge and top placement</span>: featured vendors are
            listed first in the directory and in their category.
          </li>
          <li>
            <span className="font-semibold">A rotating slot on our homepage</span>, seen by every family who
            visits.
          </li>
          <li>
            <span className="font-semibold">A rotating slot on our marketplace page</span>: launching with the
            first featured vendors.
          </li>
        </ul>
      </section>

      <section className="card space-y-2" aria-label="Founding terms">
        <h2 className="text-lg font-semibold">Founding terms</h2>
        <ul className="list-disc space-y-1 pl-5">
          <li>
            <span className="font-semibold">Free through the spring 2027 feis season.</span> No fees, no card
            details, nothing to cancel.
          </li>
          <li>
            <span className="font-semibold">One share in return.</span> All we ask is that you share your profile
            once with your customers: a post, a story, or a link on your site.
          </li>
          <li>
            <span className="font-semibold">First refusal, locked for 12 months.</span> If featured placement
            ever becomes paid, founding vendors get first refusal at that rate, and the rate is locked for them
            for 12 months.
          </li>
          <li>
            <span className="font-semibold">No commission, ever.</span> We never take a cut of your own sales.
            Orders always go through you, on your own site, on your own terms.
          </li>
        </ul>
        <p className="text-sm text-gray-600">
          We are new and growing, and we won&apos;t pretend otherwise. There are no traffic numbers to quote
          yet. What we can promise is a genuine profile in front of dance families, built properly and kept up
          to date, for as long as you want it.
        </p>
      </section>

      <section className="card space-y-2" aria-label="How to join">
        <h2 className="text-lg font-semibold">How to join</h2>
        {/*
          TODO (site owner): Irish Dance Connect has NO public contact email
          anywhere in the codebase or on the Privacy page (checked Nov 20,
          2026). Before outreach is sent, add a public contact email here,
          and ideally on the Privacy page too, so vendors have a way to
          reply that isn't the channel the outreach arrived on. Do not ship
          this page to vendors until this is resolved.
        */}
        <p>
          Just reply to the message that brought you here and say you&apos;re in. We&apos;ll build your profile
          from your website, send it to you for approval before it appears in the directory, and you can ask for
          changes or have it taken down at any time.
        </p>
        <p>
          Not for you? No hard feelings at all. Your standard directory listing stays either way, and the offer
          stands whenever it suits you.
        </p>
      </section>

      <p>
        <Link href="/vendors" className="link">
          See the vendor directory
        </Link>
      </p>
    </div>
  );
}
