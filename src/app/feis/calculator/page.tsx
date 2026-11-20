import Link from "next/link";
import { FeisCalculator } from "@/components/feis-calculator";

export const metadata = { title: "Feis stage time calculator" };

export default function FeisCalculatorPage() {
  return (
    <div className="space-y-4">
      <h1 className="page-title">Stage time calculator</h1>
      <p className="text-sm text-gray-600">
        Feis day runs on one question: when is my dancer on? Enter your dancer&apos;s competition
        number, the stage start time, and the running order from the feis schedule, and we will
        estimate the rest. Competition numbers usually put the level first and the age group last, so
        713 is Open Championship, age 13, and 206 is Beginner 1, age 6. Your entries are saved on this
        device, so they are still here when you check again later.
      </p>
      <FeisCalculator />
      <p className="text-sm text-gray-600">
        Looking for a feis to enter? Browse the <Link href="/feis" className="link">feis calendar</Link>.
      </p>
    </div>
  );
}
