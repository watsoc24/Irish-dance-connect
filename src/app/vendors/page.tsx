import type { Metadata } from "next";
import Link from "next/link";
import { VENDOR_CATEGORIES, VENDORS, findVendorCategory, vendorCategoryName, type Vendor } from "@/lib/vendors";

export const metadata: Metadata = {
  title: "Irish Dance Vendors: Dress Makers, Shoes & Wigs",
  description:
    "A directory of Irish dance vendors, each checked against its official website: solo dress makers, shoe brands and retailers, wig specialists and accessory shops in Ireland, the UK and the United States.",
  alternates: { canonical: "/vendors" },
};

function VendorCard({ vendor }: { vendor: Vendor }) {
  return (
    <li>
      <Link href={`/vendors/${vendor.slug}`} className="card block">
        <h2 className="flex flex-wrap items-center gap-2 text-lg font-semibold">
          {vendor.name}
          {vendor.featured ? <span className="badge bg-brand-100 text-brand-900">Featured</span> : null}
        </h2>
        <p className="text-sm text-muted">
          {vendorCategoryName(vendor.category)} · {vendor.location}
        </p>
        <p className="text-muted">{vendor.blurb}</p>
      </Link>
    </li>
  );
}

export default async function VendorsPage({ searchParams }: PageProps<"/vendors">) {
  const sp = await searchParams;
  const category = findVendorCategory(typeof sp.category === "string" ? sp.category : undefined);
  const filtered = VENDORS.filter((v) => !category || v.category === category.slug).sort(
    (a, b) => Number(b.featured) - Number(a.featured),
  );

  return (
    <div className="space-y-4">
      <h1 className="page-title">Vendor directory</h1>
      <p>
        The dress makers, shoe brands, wig specialists and accessory shops Irish dance families actually use,
        each one checked against its official website. Irish Dance Connect doesn&apos;t sell their products and
        isn&apos;t affiliated with them: every profile links you straight to the maker, and orders always go
        through them directly.
      </p>
      <p className="text-sm text-gray-600">
        Are you a maker or shop?{" "}
        <Link href="/vendors/featured" className="link">
          Become a founding Featured Vendor
        </Link>{" "}
        (free through the spring 2027 feis season).
      </p>
      <form className="flex gap-2" role="search">
        <select name="category" defaultValue={category?.slug ?? ""} className="input min-w-0 flex-1" aria-label="Filter by category">
          <option value="">All categories</option>
          {VENDOR_CATEGORIES.map((c) => (
            <option key={c.slug} value={c.slug}>
              {c.name}
            </option>
          ))}
        </select>
        <button type="submit" className="btn">
          Filter
        </button>
      </form>
      {category ? (
        <section className="space-y-2" aria-label={category.name}>
          <h2 className="text-lg font-semibold">{category.name}</h2>
          <p className="text-muted">{category.intro}</p>
        </section>
      ) : (
        VENDOR_CATEGORIES.map((c) => (
          <p key={c.slug} className="text-sm text-gray-600">
            <span className="font-semibold text-ink">{c.name}:</span> {c.intro}
          </p>
        ))
      )}
      {filtered.length ? (
        <ul className="space-y-3">
          {filtered.map((v) => (
            <VendorCard key={v.slug} vendor={v} />
          ))}
        </ul>
      ) : (
        <p className="text-muted">No vendors in this category yet.</p>
      )}
    </div>
  );
}
