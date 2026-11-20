import Link from "next/link";
import { FeisCalculator } from "@/components/feis-calculator";

export const metadata = { title: "Feis stage time calculator" };

export default function FeisCalculatorPage() {
  return (
    <div className="space-y-4">
      <h1 className="page-title">Stage time calculator</h1>
      <p className="text-sm text-gray-600">
        Feis day runs on one question: when is my dancer on? Enter the stage start time and the running
        order from the feis schedule, mark your dancer&apos;s competition, and we will estimate the rest.
        Your entries are saved on this device, so they are still here when you check again later.
      </p>
      <FeisCalculator />
      <p className="text-sm text-gray-600">
        Looking for a feis to enter? Browse the <Link href="/feis" className="link">feis calendar</Link>.
      </p>
    </div>
  );
}
