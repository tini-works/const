# QA Inventory — 002 Silent Checkout Failure

**Boxes to cover:** B1-B7

## Verification Paths

| ID | Path | Mechanism | Degradation signal | Covers |
|----|------|-----------|-------------------|--------|
| VP-10 | Expired card → "card problem" + update CTA | Integration test, expiry-triggering card | Alert on unmatched gateway error codes | B1, B2, B5 |
| VP-11 | Temporary decline → "temp issue" + retry CTA | Integration test, decline-triggering card | Monitor retry success rate | B1, B2, B5 |
| VP-12 | Unknown error → generic + support CTA with correlation ID | Integration test, malformed response | Alert on unknown-category rate >5% | B1, B2, B5, B6 |
| VP-13 | Error state preserves cart and shipping | Trigger error, navigate back, assert cart intact | Monitor cart-loss events post-error | B3, B4 |
| VP-14 | Three rapid retries → single charge | 3 concurrent requests, same idempotency key | Duplicate charge alerts from reconciliation | B7 |

## Coverage Matrix

| Box | Verification paths | Degradation signal? |
|-----|-------------------|-------------------|
| B1 | VP-10, VP-11, VP-12 | Yes |
| B2 | VP-10, VP-11, VP-12 | Yes |
| B3 | VP-13 | Yes |
| B4 | VP-13 | Yes |
| B5 | VP-10, VP-11, VP-12 | Yes |
| B6 | VP-12 | Yes |
| B7 | VP-14 | Yes |

**Full coverage.**

## VP-14: the story-driven edge case

The customer said "I tried three times." VP-14 exists because those words were carried from PM through the system. If the story had been cleaned into "payment error handling," this path doesn't exist and duplicate charges go undetected.

**QA must read the customer's story, not just the boxes.** Boxes define what must be true. The story reveals how things actually break.
