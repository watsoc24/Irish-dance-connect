import type { MetadataRoute } from "next";
import { SITE_URL } from "@/lib/site";

/**
 * Public content (home, feis calendar and calculator, schools, practice,
 * parents, vendors, legal pages) is crawlable. Account, admin, auth and
 * transactional areas are not: they hold personal data or one-off flows
 * with no search value. The marketplace browse pages sit behind sign-in,
 * so their create/manage subroutes are disallowed here too.
 */
export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: "*",
      allow: "/",
      disallow: [
        "/account",
        "/admin",
        "/api",
        "/auth",
        "/forgot-password",
        "/login",
        "/signup",
        "/messages",
        "/mfa",
        "/orders",
        "/sell",
        "/marketplace/new",
        "/marketplace/mine",
        "/parents/new",
        "/schools/claim",
        "/schools/manage",
        "/feis/submit",
      ],
    },
    sitemap: `${SITE_URL}/sitemap.xml`,
  };
}
