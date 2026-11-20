"use server";

import { redirect } from "next/navigation";
import { requireUser } from "@/lib/auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { rateLimit, RATE_LIMITED } from "@/lib/rate-limit";
import type { FormState } from "@/lib/form";
import { COUNTRIES } from "@/lib/money";
import { env } from "@/lib/env";
import { stripe } from "@/lib/stripe";

/**
 * Creates (once) a Stripe connected account for the seller and sends them to
 * Stripe-hosted onboarding. Stripe collects identity and bank details.
 * we never see or store them.
 */
export async function startPayoutOnboarding(_: FormState, formData: FormData): Promise<FormState> {
  const account = await requireUser("/sell/payouts");
  if (!env.stripeConfigured) return { error: "Payouts aren't available yet." };
  if (!(await rateLimit("payout-onboarding", 10, 3600, account.id))) return RATE_LIMITED;

  const admin = createAdminClient();
  const { data: existing } = await admin
    .from("seller_accounts")
    .select("stripe_account_id")
    .eq("user_id", account.id)
    .maybeSingle();

  let accountId = existing?.stripe_account_id;
  let onboardingUrl: string;
  try {
    if (!accountId) {
      const country = String(formData.get("country") ?? "");
      if (!COUNTRIES.some((c) => c.code === country)) return { error: "Choose your country." };
      // Accounts v2 (POST /v2/core/accounts): Stripe no longer allows new
      // Connect integrations to create accounts with the v1 API. The values
      // below are the v2 equivalents of the old v1 controller settings:
      // full dashboard; Stripe collects its processing fees directly from
      // the seller (so the application fee stays exactly our 7%); Stripe,
      // not the platform, is liable for negative balances; and because
      // losses sit with Stripe, Stripe also collects KYC requirements.
      const created = await stripe().v2.core.accounts.create(
        {
          contact_email: account.email ?? undefined,
          identity: { country: country.toLowerCase() },
          dashboard: "full",
          defaults: {
            responsibilities: { fees_collector: "stripe", losses_collector: "stripe" },
          },
          configuration: {
            merchant: { capabilities: { card_payments: { requested: true } } },
          },
          metadata: { user_id: account.id },
        },
        { idempotencyKey: `connect-account-${account.id}` },
      );
      accountId = created.id;
      const { error } = await admin.from("seller_accounts").insert({ user_id: account.id, stripe_account_id: accountId });
      if (error) return { error: "Couldn't save your payout account. Please try again." };
    }
    // Account Links v2 (POST /v2/core/account_links), Stripe-hosted onboarding.
    const link = await stripe().v2.core.accountLinks.create({
      account: accountId,
      use_case: {
        type: "account_onboarding",
        account_onboarding: {
          // Collect everything up front, as the v1 hosted flow did.
          collection_options: { fields: "eventually_due" },
          refresh_url: `${env.siteUrl}/sell/payouts`,
          return_url: `${env.siteUrl}/sell/payouts/return`,
        },
      },
    });
    onboardingUrl = link.url;
  } catch (e) {
    const err = e as { code?: string; message?: string };
    console.error("onboarding failed", err.code, err.message);
    return { error: "Stripe couldn't start onboarding. Please try again." };
  }
  redirect(onboardingUrl);
}
