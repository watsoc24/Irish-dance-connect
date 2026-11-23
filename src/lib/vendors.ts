// Content for /vendors: a curated directory of Irish dance vendors:
// dress makers, shoe brands and retailers, wig specialists, and
// accessories / practice-wear shops.
//
// Every business below was verified on Nov 20, 2026 by fetching its
// official website. Blurbs are written in our own words from what each
// business publicly offers. Irish Dance Connect is not affiliated with
// any of them and does not sell their products. Families order from
// each maker directly. See ~/workspace/irish-dance-connect-vendors/
// vendor-research.md for the full research notes, including the
// businesses that were dropped because they could not be verified.

export type VendorCategory = "dress-makers" | "shoes" | "wigs-and-hair" | "accessories";

export interface VendorCategoryInfo {
  slug: VendorCategory;
  name: string;
  intro: string;
}

export const VENDOR_CATEGORIES: VendorCategoryInfo[] = [
  {
    slug: "dress-makers",
    name: "Dress makers",
    intro:
      "The ateliers and independent makers who design and sew solo dresses, school costumes and team wear, from the biggest Belfast studios to small US workshops.",
  },
  {
    slug: "shoes",
    name: "Shoes",
    intro:
      "The shoe brands dancers trust for pumps and jig shoes, plus US retailers who stock them with no customs delays.",
  },
  {
    slug: "wigs-and-hair",
    name: "Wigs & hair",
    intro: "Wig specialists and feis shops for full wigs, bun wigs and colour matching.",
  },
  {
    slug: "accessories",
    name: "Accessories & practice wear",
    intro: "Number clips, headpieces, practice wear and the finishing touches for feis day.",
  },
];

export function findVendorCategory(slug: string | undefined): VendorCategoryInfo | undefined {
  return VENDOR_CATEGORIES.find((c) => c.slug === slug);
}

export function vendorCategoryName(slug: VendorCategory): string {
  return VENDOR_CATEGORIES.find((c) => c.slug === slug)?.name ?? slug;
}

export interface Vendor {
  name: string;
  slug: string;
  category: VendorCategory;
  /** City / region / country as the business publicly states it. */
  location: string;
  /** One or two sentences in our own words on what they offer. */
  blurb: string;
  /** What they offer, as short factual phrases. */
  offers: string[];
  website: string;
  /** Instagram handle without the @, if the business links it publicly. */
  instagram?: string;
}

export const VENDORS: Vendor[] = [
  // ---- Dress makers ----
  {
    name: "Eire Designs by Gavin Doherty",
    slug: "eire-designs",
    category: "dress-makers",
    location: "Belfast, Northern Ireland",
    blurb:
      "One of the best-known Irish dance ateliers, making bespoke solo costumes in Belfast and shipping them worldwide, with a ready-to-wear range alongside the custom work.",
    offers: ["Bespoke solo dresses", "Ready-to-wear dresses", "Boys' costumes"],
    website: "https://www.gavindoherty.co.uk",
    instagram: "eiredesigns_official",
  },
  {
    name: "Elevation Design",
    slug: "elevation-design",
    category: "dress-makers",
    location: "Northern Ireland",
    blurb:
      "Founded in 2005 by sisters Jacqueline Kennedy Bohill and Una Kennedy Boyd, Elevation designs bespoke solo dresses and class costumes from its Northern Ireland design centre.",
    offers: ["Bespoke solo dresses", "Class costumes"],
    website: "https://elevationdesign.ie",
  },
  {
    name: "John Carey Design",
    slug: "john-carey-design",
    category: "dress-makers",
    location: "Dublin, Ireland",
    blurb:
      "Dublin-based maker (formerly Siopa Rince) offering fully bespoke solo dresses alongside a more accessible Essential Range.",
    offers: ["Bespoke solo dresses", "Essential Range dresses"],
    website: "https://johncareydesign.ie",
    instagram: "johncareydesign",
  },
  {
    name: "Celtic Klass Designs",
    slug: "celtic-klass-designs",
    category: "dress-makers",
    location: "Crossgar, Co. Down, Northern Ireland",
    blurb:
      "Custom-made solo dresses and team costumes from Crossgar, run by Josephine Brennan King and Carl King; solo orders include the headpiece, kick pants and number clip.",
    offers: ["Custom solo dresses", "Team and class costumes", "Headpieces"],
    website: "https://celticklass.com",
  },
  {
    name: "Doire Dress Designs",
    slug: "doire-dress-designs",
    category: "dress-makers",
    location: "Derry, Northern Ireland",
    blurb:
      "Designer Shauna Shiels has been making bespoke Irish dance dresses since 2006, with tiered solo ranges, team dresses and boys' waistcoats and jackets.",
    offers: ["Bespoke solo dresses", "Team dresses", "Boys' waistcoats and jackets"],
    website: "https://doiredressdesigns.com",
    instagram: "doiredressdesign",
  },
  {
    name: "Rising Star Designs",
    slug: "rising-star-designs",
    category: "dress-makers",
    location: "Belfast, Northern Ireland",
    blurb:
      "Belfast studio making bespoke solo costumes plus the budget-friendly Rince Collection, and proudly not affiliated with any one dance school, so every dancer is treated the same.",
    offers: ["Bespoke solo costumes", "Rince Collection (budget range)"],
    website: "https://www.risingstardesigns.co.uk",
  },
  {
    name: "Taylor Dresses",
    slug: "taylor-dresses",
    category: "dress-makers",
    location: "Belfast, Northern Ireland",
    blurb:
      "A family-run Belfast dressmaker with more than 25 years behind it, taking dress and waistcoat orders from dancers anywhere in the world, with remote measuring help.",
    offers: ["Solo dresses", "Boys' waistcoats"],
    website: "https://www.tayloririshdancingdresses.com",
    instagram: "taylordressesbelfast",
  },
  {
    name: "Prime Dress Designs",
    slug: "prime-dress-designs",
    category: "dress-makers",
    location: "Augusta, New Jersey, USA",
    blurb:
      "US maker specialising in school and team dresses designed with growing room for young dancers, plus solo dresses, beginner skirts, vests and headpieces.",
    offers: ["School and team dresses", "Solo dresses", "Beginner skirts and vests", "Headpieces and dress bags"],
    website: "https://primedressdesigns.com",
    instagram: "primedressdesigns",
  },
  {
    name: "Heidi Bird Design",
    slug: "heidi-bird-design",
    category: "dress-makers",
    location: "Brown Deer, Wisconsin, USA",
    blurb:
      "Family-owned US costume maker with more than 25 years in Irish dance; school, team and solo costumes are designed and manufactured in its own Wisconsin factory.",
    offers: ["School and team costumes", "Solo dresses"],
    website: "https://heidibird.com",
    instagram: "heidibirddesign",
  },
  {
    name: "Dance Bling",
    slug: "dance-bling",
    category: "dress-makers",
    location: "New York, USA",
    blurb:
      "Made-in-the-USA solo and team dresses with genuine crystals, plus vests, practice wear and custom headpieces. No customs charges for US families.",
    offers: ["Solo and team dresses", "Practice wear", "Custom headpieces", "Alterations"],
    website: "https://www.dancebling.com",
  },

  // ---- Shoes ----
  {
    name: "Antonio Pacelli",
    slug: "antonio-pacelli",
    category: "shoes",
    location: "London, United Kingdom",
    blurb:
      "Forty years in Irish dance: own-brand pumps and jig shoes for every level from first shoes to championship, other major brands, and socks, wigs and accessories, with worldwide delivery.",
    offers: ["Pumps and jig shoes", "Poodle socks", "Wigs and accessories"],
    website: "https://www.antoniopacelli.com",
  },
  {
    name: "Hullachan",
    slug: "hullachan",
    category: "shoes",
    location: "London, United Kingdom",
    blurb:
      "Irish dance pumps designed by Craig Coussins with a strong focus on foot health; the full Hullachan range is sold through Antonio Pacelli.",
    offers: ["Irish dance pumps", "Highland ghillies"],
    website: "https://www.hullachan.co.uk",
  },
  {
    name: "Rutherford Shoes",
    slug: "rutherford-shoes",
    category: "shoes",
    location: "United States",
    blurb:
      "US maker of hand-made jig shoes and reel pumps (including the Ultra-Lite Gold jig shoe and Galway Gold pump with Soundblaster heels and tips), plus feis accessories.",
    offers: ["Jig shoes", "Reel pumps", "Feis accessories"],
    website: "https://www.rutherfordshoes.com",
  },
  {
    name: "Keily's",
    slug: "keilys",
    category: "shoes",
    location: "Mount Vernon, New York, USA",
    blurb:
      "US retailer serving Irish dancers since 2004, stocking Antonio Pacelli, Corr's, Rutherford, Fays and Hullachan shoes (all shipped from the US), plus socks, wigs and accessories.",
    offers: ["Irish dance shoes (major brands)", "Poodle socks", "Wigs and accessories"],
    website: "https://www.keilys.com",
  },

  // ---- Wigs & hair ----
  {
    name: "Camelia Rose",
    slug: "camelia-rose",
    category: "wigs-and-hair",
    location: "United States & United Kingdom",
    blurb:
      "Irish dance wig specialist whose wigs and bun wigs (the Ciara is a school staple) are sold online and at competitions, where they also offer colour matching.",
    offers: ["Full wigs", "Bun wigs", "Colour matching at competitions"],
    website: "https://www.cameliarosewigs.com",
    instagram: "cameliarosewigs",
  },
  {
    name: "Irish Seams",
    slug: "irish-seams",
    category: "wigs-and-hair",
    location: "Boonsboro, Maryland, USA",
    blurb:
      "A one-stop feis shop (wigs, shoes, costume jewelry and accessories) selling online, from a Maryland retail shop, and from a mobile store at feiseanna.",
    offers: ["Wigs", "Shoes", "Costume jewelry and accessories"],
    website: "https://irishseams.com",
  },

  // ---- Accessories & practice wear ----
  {
    name: "Roisin Rince",
    slug: "roisin-rince",
    category: "accessories",
    location: "San Francisco Bay Area, California, USA",
    blurb:
      "Custom Irish dance accessories, clothing and gifts from a small Bay Area shop run by two sisters, a familiar face at California feiseanna.",
    offers: ["Custom accessories", "Dance clothing and gifts"],
    website: "https://roisinrinceshop.com",
    instagram: "roisinrince",
  },
  {
    name: "Dowsa Performance Wear",
    slug: "dowsa-performance-wear",
    category: "accessories",
    location: "Online, ships worldwide",
    blurb:
      "Made-to-order Irish dance performance wear (embellished leotards and dresses), plus feis finishing touches such as personalised number clips, hair clips and shoe buckles.",
    offers: ["Performance wear and leotards", "Number clips and hair clips", "Shoe buckles"],
    website: "https://dowsawear.com",
  },
];

export function getVendor(slug: string): Vendor | undefined {
  return VENDORS.find((v) => v.slug === slug);
}
