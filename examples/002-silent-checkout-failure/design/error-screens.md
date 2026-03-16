# Design — Checkout Error Screens

Three screen variants. Each maps to one error category from the taxonomy. The mapping is 1:1 — no ambiguity about which screen shows for which error.

---

## SCR-10: Card Problem

**Who sees this:** Customer whose card was declined due to a card-level issue (expired, invalid number, card reported lost).

**What it shows:**
- Checkout page remains visible (cart summary, shipping info — all intact)
- Inline error banner at the top of the payment section
- Message: "There's a problem with your card"
- Subtext: "Your card couldn't be charged. Please update your payment method."
- CTA button: "Update payment method" (scrolls to / focuses payment input)
- Cart and shipping info remain untouched below

**Behavior:**
- Error banner appears where the "processing" spinner was
- Payment fields are re-enabled and editable
- Previously entered card info is cleared (security — don't persist declined card details)
- Cart total, items, shipping address are all preserved
- Customer can enter new card details and retry without leaving the page

**Exists because:** Commitment 1 (customer knows it failed) + Commitment 2 (actionable reason: "update your card") + Commitment 3 (recovery without restart).

**Verify:** In staging, use test card `4000000000000069` (expired card). Complete checkout. SCR-10 appears with "There's a problem with your card." Cart and shipping info visible and intact. Enter a valid card. Payment succeeds.

---

## SCR-11: Temporary Decline

**Who sees this:** Customer whose payment was declined for a transient reason (processor timeout, rate limit, temporary hold).

**What it shows:**
- Checkout page remains visible (cart summary, shipping info — all intact)
- Inline error banner at the top of the payment section
- Message: "Payment couldn't be processed right now"
- Subtext: "This might be temporary. You can try again in a moment."
- CTA button: "Try again" (re-submits with same payment details)
- Secondary link: "Try a different payment method"

**Behavior:**
- Same card details are preserved (this is a temporary issue, not a card problem)
- "Try again" re-submits the payment with the same idempotency key (safe — gateway deduplicates)
- If retry succeeds → confirmation page
- If retry fails again → same screen, but subtext changes to "Still having trouble? Try a different payment method or contact support."
- After 3 failed retries on the same session → screen shifts to SCR-12 (contact bank)

**Exists because:** Commitment 2 (actionable reason: "try again") + Commitment 4 (retries are safe via idempotency).

**Verify:** In staging, configure gateway simulator to return `temporary_decline` for the first two attempts, then success. Trigger checkout. SCR-11 appears. Click "Try again" twice. Third attempt succeeds. Assert only one charge was created.

---

## SCR-12: Contact Bank

**Who sees this:** Customer whose payment was declined for a reason we can't resolve (insufficient funds, fraud flag, bank-side block). Also shown as fallback after repeated temporary declines.

**What it shows:**
- Checkout page remains visible (cart summary, shipping info — all intact)
- Inline error banner at the top of the payment section
- Message: "Please contact your bank"
- Subtext: "We weren't able to process this payment. Your bank can provide more details."
- CTA button: "Try a different payment method"
- Secondary link: "Contact support" (pre-fills support form with correlation ID — customer doesn't see the ID itself, support does)

**What it does NOT show:** "Insufficient funds." Design rejected this explicitly. Showing financial status on-screen is a privacy violation — someone could be standing behind the customer, or screen-sharing.

**Behavior:**
- Payment fields are re-enabled for a different card
- "Contact support" link includes the correlation ID as a URL parameter (not visible to customer, available to support agent)
- Cart and shipping preserved

**Exists because:** Commitment 2 (actionable without being humiliating — Design's privacy pushback) + Commitment 3 (recovery path exists).

**Verify:** In staging, use test card `4000000000009995` (insufficient funds). Complete checkout. SCR-12 appears with "Please contact your bank." Message does NOT contain "insufficient funds" or any financial detail. Click "Contact support." Support form opens with correlation ID pre-filled (check URL params). Cart is preserved.

---

## What Design negotiated

| With | What was proposed | What Design pushed back on | What we agreed |
|------|-------------------|---------------------------|----------------|
| PM | B2: "Show why it failed" | Raw gateway errors expose sensitive info. "Insufficient funds" is not something you display. | Three categories: card problem, temporary, contact bank. Actionable but not humiliating. |
| PM | B3: "Path to resolve" | Design agreed, but added B4: the recovery path must not lose cart state. PM hadn't specified this. | Error states preserve cart, shipping, and session. Design originated B4. |
| Engineer | Taxonomy of 4 error types | 4 gateway categories map to 3 UI variants (insufficient_funds and unknown both map to "contact bank"). | Design decides the user-facing grouping. Engineer keeps the full taxonomy for logging. |

## What goes suspect if this changes

- If Engineer adds new error categories to the taxonomy --> Design needs to decide which screen variant they map to
- If PM requires showing more specific error details (e.g., regulatory requirement) --> privacy pushback needs re-evaluation
- If checkout adds new payment methods (PayPal, Apple Pay) --> error screens need variant review (these methods have different error semantics)
- If the "3 retries then escalate" rule changes --> SCR-11 to SCR-12 transition logic needs updating
