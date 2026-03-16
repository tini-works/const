# PM — Silent Checkout Failure

## The customer's words

> "I hit the pay button, the page just sat there. I tried three times. Then I gave up and bought it somewhere else."

This is not a bug report. This is a lost sale, a broken promise, and a trust failure. The customer told us exactly what happened — three attempts, silence each time, then gone. Every commitment below traces back to this moment.

## What we committed to

### 1. When payment fails, the customer knows it failed

The page "just sat there." That's the first failure — not the payment itself, but the silence. The system knew the payment failed (the gateway said so in the response body). It just didn't tell anyone.

Negotiated with Design. Design accepted B1 immediately — no pushback. A silent failure is indefensible.

**Verify:** Design has three error screen variants (SCR-10, SCR-11, SCR-12) — one for each failure category. Engineer's FLW-10 parses the gateway response body (not just HTTP status) and surfaces the failure to the UI. QA's VP-01, VP-02, VP-03 each trigger a different error category and confirm the correct screen appears.

### 2. The customer knows why it failed — in terms they can act on

PM's first instinct was "show an error message." Design pushed back hard:

> "We can't expose raw gateway errors. For expired cards, 'update your card' is the action. But for 'insufficient funds' — we can't say that. It's sensitive."

**Negotiation result:** Three categories, not raw errors. Card problem ("update your card"), temporary issue ("try again"), or contact bank. The reason is actionable without being humiliating.

**Verify:** Engineer's FLW-11 maps gateway error codes to three categories. Design's screens match 1:1 with the categories. QA's VP-01 through VP-03 each verify one category end-to-end: trigger the error, see the right message, see the right call-to-action.

### 3. The customer can recover without restarting checkout

The customer picked items, entered shipping, typed their card number. A payment error shouldn't erase all of that. Recovery must return the customer to the payment step — not to an empty cart.

**Verify:** Design's error state flows all return to the payment step with cart and shipping intact. QA's VP-04 triggers an error, navigates back, and asserts cart contents and shipping info are preserved.

### 4. Three retries must not create three charges

This came from the customer's exact words: "I tried three times." Without those words, this edge case is invisible. If the gateway processed any of those attempts before the frontend gave up, the customer could be charged multiple times for the same order.

Engineer surfaced this as B7. PM accepted it immediately — a triple charge on a "broken" checkout is a support nightmare and a chargeback risk.

**Verify:** Engineer's FLW-13 generates an idempotency key per checkout session and passes it to the gateway. QA's VP-05 sends three concurrent payment requests with the same idempotency key and asserts only one charge is created.

## Who originated what

| Commitment | Originated by | Context |
|------------|---------------|---------|
| 1. Failure visibility | PM (from customer story) | "the page just sat there" |
| 2. Categorized reason | PM, **revised by Design** | Design refused to show raw errors — privacy concern for "insufficient funds" |
| 3. Recovery without restart | PM (from customer story) | "I gave up" — because there was no path back |
| 4. Idempotent retries | **Engineer** (from customer story) | "I tried three times" — Engineer heard the triple-charge risk |
| Cart preservation on error | **Design** (B4) | Design added this — PM hadn't thought about cart state during errors |

## What goes suspect if things change

- If the payment gateway changes its error codes or response format --> commitments 1, 2, 4 go suspect (taxonomy, parsing, idempotency all depend on gateway contract)
- If Design changes the error screen categories --> commitment 2 goes suspect
- If the gateway changes its idempotency key handling --> commitment 4 goes suspect
- If new payment methods are added (e.g., Apple Pay, crypto) --> all commitments need re-evaluation against the new method's error semantics
- If the customer's story changes (new complaints, new failure modes) --> all commitments need re-evaluation against the new reality
