/**
 * The site's canonical public URL, used by SEO surfaces (metadata base,
 * sitemap, robots, structured data). It is a constant rather than the
 * runtime SITE_URL env var because metadata is evaluated during the
 * build, where deployment env vars are not guaranteed to exist. It must
 * always match the production SITE_URL: the canonical www domain, with
 * the apex redirecting to it.
 */
export const SITE_URL = "https://www.irishdanceconnect.com";
