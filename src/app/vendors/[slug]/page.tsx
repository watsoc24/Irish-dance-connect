import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { VENDORS, getVendor, vendorCategoryName } from "@/lib/vendors";

export function generateStaticParams() {
  return VENDORS.map((v) => ({ slug: v.slug }));
}

export async function generateMetadata({ params }: PageProps<"/vendors/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  const vendor = getVendor(slug);
  if (!vendor) return { title: "Vendor" };
  return {
    title: vendor.name,
    description: `${vendor.name} (${vendorCategoryName(vendor.category)}, ${vendor.location}): ${vendor.blurb}`,
    alternates: { canonical: `/vendors/${vendor.slug}` },
  };
}

export default async function VendorPage({ params }: PageProps<"/vendors/[slug]">) {
  const { slug } = await params;
  if (!/^[a-z0-9-]{1,140}$/.test(slug)) notFound();
  const vendor = getVendor(slug);
  if (!vendor) notFound();

  return (
    <div className="space-y-4">
      <Link href="/vendors" className="link">
        &larr; Back to vendor directory
      </Link>
      <div>
        <h1 className="page-title">{vendor.name}</h1>
        <p className="text-gray-600">
          {vendorCategoryName(vendor.category)} · {vendor.location}
        </p>
      </div>
      <p>{vendor.blurb}</p>
      <section className="card space-y-2" aria-label="What they offer">
        <h2 className="font-semibold">What they offer</h2>
        <ul className="list-disc space-y-1 pl-5">
          {vendor.offers.map((offer) => (
            <li key={offer}>{offer}</li>
          ))}
        </ul>
      </section>
      <section className="card space-y-2 text-sm" aria-label="Visit this vendor">
        <p>
          Website:{" "}
          <a href={vendor.website} target="_blank" rel="noreferrer" className="link break-all">
            {vendor.website}
          </a>
        </p>
        {vendor.instagram ? (
          <p>
            Instagram:{" "}
            <a
              href={`https://www.instagram.com/${vendor.instagram}`}
              target="_blank"
              rel="noreferrer"
              className="link break-all"
            >
              @{vendor.instagram}
            </a>
          </p>
        ) : null}
      </section>
      <p className="rounded-xl bg-brand-50 p-3 text-sm text-brand-900">
        Irish Dance Connect doesn&apos;t sell {vendor.name}&apos;s products and takes no commission on their
        sales. To order, ask about prices or book a fitting, contact {vendor.name} directly through their own
        website. Every order goes through the maker.
      </p>
    </div>
  );
}
