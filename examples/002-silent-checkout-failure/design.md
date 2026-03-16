# Design Registry — Silent Checkout Failure

## Error Screens

| ID | Screen | Headline | CTA | When shown |
|----|--------|----------|-----|------------|
| SCR-10 | Card problem | "There's a problem with your card" | Update payment method | `card_expired`, `card_declined` |
| SCR-11 | Temporary decline | "Payment couldn't be processed right now" | Try again | `temp_decline`, `rate_limit` |
| SCR-12 | Contact bank | "Your bank declined this payment" | Use different card / Contact support | `do_not_honor`, `bank_decline` |

Three variants, not one. Each maps to a different user action. Generic "something went wrong" is banned — it tells the customer nothing and creates another support ticket.

## Checkout State Machine (updated)

```
Cart → Shipping → Payment → Processing →
    ✓ Success → Confirmation
    ✗ Failure → Error State (categorized) →
        Card problem → "Update Card" → Payment step (cart preserved)
        Temporary   → "Retry"       → Processing   (cart preserved)
        Bank issue  → "Alt payment"  → Payment step (cart preserved)
                    → "Contact support" → Support flow
```

Every error path leads to either resolution or explicit exit. No dead ends. Cart and shipping details preserved on all paths — the customer never has to re-add items.

## User Flows

**Happy path:** Cart → Pay → Confirmation
**Card error:** Cart → Pay → SCR-10 → Update card → Pay → Confirmation
**Temp error:** Cart → Pay → SCR-11 → Retry → Confirmation (or SCR-11 again, max 2 retries then SCR-12)
**Bank error:** Cart → Pay → SCR-12 → Alt payment or Support

## What Design pushed back on

**Raw error messages.** PM initially wanted to show the gateway's reason. "Insufficient funds" is sensitive — showing it in a shared screen or over-shoulder situation is a privacy problem. Design proposed the three-category approach instead: specific enough to act on, general enough to respect the user.

**Cart preservation.** Design originated this requirement. PM's brief was "show an error." But if the error state drops the cart, the customer has to re-add everything after a failed payment — that's worse than the original silent failure. This became a hard requirement going upstream.
