/**
 * Renders a schema.org JSON-LD block. Data must be factual and built from
 * fields the site actually stores or displays; never invent ratings,
 * reviews, prices or attendance figures.
 */
export function JsonLd({ data }: { data: Record<string, unknown> | Record<string, unknown>[] }) {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(data).replace(/</g, "\\u003c") }}
    />
  );
}
