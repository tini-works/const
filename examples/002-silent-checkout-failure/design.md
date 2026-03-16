# Design Inventory — 002 Silent Checkout Failure

**Boxes received:** B1 (failure visible), B2 (categorized reason), B3 (recovery path), B4 (cart preserved)

## Screens

| ID | Screen | Content | Matches |
|----|--------|---------|---------|
| SCR-10 | Checkout Error — card problem | "There's a problem with your card" / "Update payment method" CTA | B1, B2 |
| SCR-11 | Checkout Error — temporary decline | "Payment couldn't be processed right now" / "Try again" CTA | B1, B2 |
| SCR-12 | Checkout Error — contact bank | "Please contact your bank" / Alt payment + support CTA | B1, B2 |

## State Machine (modified)

```
Pay → Processing →
    Success → Confirmation
    Failure → Error State (categorized) →
        Card problem → "Update Card" → return to Payment step
        Temporary → "Retry" → return to Processing
        Bank issue → "Alt payment" or "Contact support"
        (all paths) → Cart + shipping preserved (B4)
```

**Hanging state check:** Every error path leads to resolution (retry/update) or explicit exit (support). Cart preserved on all paths. **No hanging states.**

## Negotiation contributions

- Pushed back on B2: raw gateway errors are inappropriate. "Insufficient funds" is sensitive. Created the categorization approach instead.
- Originated B4: error state must not lose cart contents. Without this, users would have to re-add items after a failed payment — worse than the original bug.
