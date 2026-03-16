# Design — Checkout Flow

The complete path from "Pay" to resolution. Before this fix, the failure branch didn't exist — the flow just stopped.

```
Customer clicks "Pay"
    │
    → Processing spinner
    │
    ├── Gateway returns success
    │       → Order Confirmation page
    │
    └── Gateway returns failure (HTTP 200 with error body — the root cause)
            │
            → Frontend parses response body (not just HTTP status)
            → Error categorized by taxonomy
            │
            ├── Category: card_expired / card_invalid
            │       → SCR-10: "There's a problem with your card"
            │           → "Update payment method" → re-enter card → retry
            │
            ├── Category: temporary_decline
            │       → SCR-11: "Payment couldn't be processed right now"
            │           → "Try again" (same card, same idempotency key)
            │           → After 3 failed retries → escalate to SCR-12
            │
            └── Category: insufficient_funds / unknown
                    → SCR-12: "Please contact your bank"
                        → "Try different payment method" → re-enter card → retry
                        → "Contact support" (correlation ID passed silently)
```

**Every path terminates at either Order Confirmation or a screen with a next action.** No dead ends. No silence. No "page just sat there."

## The state that was missing

Before this fix, the checkout state machine looked like:

```
Pay → Processing → Success → Confirmation
                 → Failure → (nothing)          ← THE BUG
```

The failure branch existed in the gateway response. It existed in the backend. It just never reached the UI because the frontend only checked HTTP status codes, and the gateway always returns 200.

After this fix:

```
Pay → Processing → Success → Confirmation
                 → Failure → Error State (categorized) →
                     Update Card → return to Payment (card cleared)
                     Retry → return to Processing (card preserved)
                     Different Method → return to Payment (card cleared)
                     Contact Support → support form (correlation ID)
```

## Critical invariant: cart preservation

Across every error path, these are preserved:
- Cart contents (items, quantities)
- Shipping address
- Billing address (except card details on card-problem errors — security)
- Applied coupons / discounts
- Session-level idempotency key

If any error path drops cart state, B4 is violated and VP-04 will catch it.

## What goes suspect if this changes

- If the payment gateway adds new error types --> taxonomy needs updating, flow may need new branches
- If PM adds a "save cart for later" feature --> the error-to-recovery flow interacts with it
- If checkout gains multi-step payment (split pay, gift cards + credit card) --> failure semantics get more complex (partial charges)
