import type { Metadata, Viewport } from "next";
import Link from "next/link";
import { Analytics } from "@vercel/analytics/next";
import { Cormorant_Garamond, IBM_Plex_Mono, Public_Sans } from "next/font/google";
import "./globals.css";
import { SITE_URL } from "@/lib/site";
import { getAccount } from "@/lib/auth";
import { BottomNav } from "@/components/bottom-nav";

const publicSans = Public_Sans({
  subsets: ["latin"],
  variable: "--font-public-sans",
  display: "swap",
});

const cormorant = Cormorant_Garamond({
  subsets: ["latin"],
  weight: ["600", "700"],
  style: ["normal", "italic"],
  variable: "--font-cormorant",
  display: "swap",
});

const plexMono = IBM_Plex_Mono({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  variable: "--font-plex-mono",
  display: "swap",
});

const SITE_TITLE = "Irish Dance Connect | Feis Calendar, Schools, Dresses & Practice Tools";
const SITE_DESCRIPTION =
  "Find upcoming feiseanna on the feis calendar, locate Irish dance schools near you, buy and sell used solo dresses and gear, and practise with free feis tempo music and tools. Built for Irish dance families.";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: { default: SITE_TITLE, template: "%s | Irish Dance Connect" },
  description: SITE_DESCRIPTION,
  applicationName: "Irish Dance Connect",
  alternates: { canonical: "/" },
  openGraph: {
    type: "website",
    siteName: "Irish Dance Connect",
    title: SITE_TITLE,
    description: SITE_DESCRIPTION,
    url: "/",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    title: SITE_TITLE,
    description: SITE_DESCRIPTION,
  },
  appleWebApp: { capable: true, title: "Dance Connect", statusBarStyle: "default" },
  icons: { icon: "/icons/icon-192.png", apple: "/icons/apple-touch-icon.png" },
  robots: { index: true, follow: true },
};

export const viewport: Viewport = {
  themeColor: "#0A5C36",
  width: "device-width",
  initialScale: 1,
  viewportFit: "cover",
};

export default async function RootLayout({ children }: LayoutProps<"/">) {
  const account = await getAccount();
  return (
    <html lang="en" className={`h-full antialiased ${publicSans.variable} ${cormorant.variable} ${plexMono.variable}`}>
      <body className="flex min-h-full flex-col font-sans">
        <header className="sticky top-0 z-20 border-b border-line bg-cream pt-[env(safe-area-inset-top)]">
          <div className="mx-auto flex max-w-3xl items-center justify-between px-4 py-3">
            <Link href="/" className="font-display text-[22px] leading-none font-bold text-brand-700">
              Irish Dance Connect
            </Link>
            <nav className="hidden gap-4 text-sm font-medium sm:flex">
              <Link href="/feis">Feis calendar</Link>
              <Link href="/schools">Schools</Link>
              <Link href="/practice">Practice</Link>
              <Link href="/parents">Parents</Link>
              <Link href="/vendors">Vendors</Link>
              <Link href="/marketplace">Marketplace</Link>
              {account ? <Link href="/messages">Messages</Link> : null}
              {account?.isPlatformAdmin ? <Link href="/admin">Admin</Link> : null}
            </nav>
            {account ? (
              <Link href="/account" className="text-sm font-semibold text-brand-700">
                Account
              </Link>
            ) : (
              <Link href="/login" className="text-sm font-semibold text-brand-700">
                Sign in
              </Link>
            )}
          </div>
          <div className="knot-strip" aria-hidden="true" />
        </header>
        <main className="mx-auto w-full max-w-3xl flex-1 px-4 pt-6 pb-28 sm:pb-10">{children}</main>
        <div className="knot-strip" aria-hidden="true" />
        <footer className="mx-auto mb-24 w-full max-w-3xl px-4 py-6 text-sm text-muted sm:mb-0">
          <p className="mb-3">
            Irish Dance Connect: feis calendar, school directory, and a dress &amp; gear marketplace. Run by a dance
            family in Ohio.
          </p>
          <div className="flex flex-wrap gap-4">
            <Link href="/privacy">Privacy</Link>
            <Link href="/terms">Terms</Link>
            <Link href="/safety">Safety</Link>
          </div>
        </footer>
        <BottomNav signedIn={Boolean(account)} />
        <Analytics />
      </body>
    </html>
  );
}
