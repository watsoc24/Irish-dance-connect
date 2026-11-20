import { ImageResponse } from "next/og";

export const alt =
  "Irish Dance Connect: feis calendar, schools, marketplace and practice tools for Irish dance families";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

/**
 * Default social share image for the whole site, drawn in the Sevenfold
 * brand for Irish Dance Connect: cream paper, deep emerald, feis gold.
 * No external assets; type is set with the renderer's built-in font.
 */
export default function OpengraphImage() {
  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          padding: "72px 84px",
          backgroundColor: "#FAF5EA",
          color: "#1B2420",
        }}
      >
        <div style={{ display: "flex", height: 6, backgroundColor: "#B97F06", marginBottom: 18 }} />
        <div style={{ display: "flex", height: 2, backgroundColor: "#0A5C36", marginBottom: 54 }} />
        <div
          style={{
            display: "flex",
            fontSize: 30,
            letterSpacing: 6,
            textTransform: "uppercase",
            color: "#B97F06",
            marginBottom: 20,
          }}
        >
          For Irish dance families
        </div>
        <div style={{ display: "flex", fontSize: 92, fontWeight: 700, lineHeight: 1.05, color: "#0A5C36" }}>
          Irish Dance Connect
        </div>
        <div style={{ display: "flex", fontSize: 36, lineHeight: 1.35, marginTop: 30, maxWidth: 900 }}>
          Feis calendar, schools, marketplace and practice tools for Irish dance families
        </div>
        <div style={{ display: "flex", height: 2, backgroundColor: "#0A5C36", marginTop: 54 }} />
        <div style={{ display: "flex", height: 6, backgroundColor: "#B97F06", marginTop: 18 }} />
      </div>
    ),
    { ...size },
  );
}
