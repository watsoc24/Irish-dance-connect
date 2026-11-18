import Link from "next/link";

// Shown on the paid marketplace surfaces while Stripe checkout is not
// configured yet. The banner disappears on its own once STRIPE_SECRET_KEY
// is set (see env.stripeConfigured). Free parts of the site — the feis
// calendar and the school directory — stay fully usable throughout.
export function MarketplaceComingSoon() {
  return (
    <section className="rounded-xl border border-line bg-brand-50 p-4" aria-label="Marketplace coming soon">
      <p className="mb-1 flex items-center gap-2 font-semibold text-brand-900">
        The marketplace is opening soon
        <span className="badge bg-brand-100 text-brand-900">Coming soon</span>
      </p>
      <p className="text-sm text-brand-900">
        We&apos;re still building more ways to connect you with the Irish dance community around you — including
        buying and selling dresses and gear with secure checkout. While we finish that, everything else here is
        ready to use:{" "}
        <Link href="/feis" className="link">
          find a feis
        </Link>{" "}
        or{" "}
        <Link href="/schools" className="link">
          find a school near you
        </Link>
        , and check back soon for the marketplace.
      </p>
    </section>
  );
}
