# Proof Registry — Silent Checkout Failure

## Verification Paths

| ID | What we prove | How | What tells us it broke |
|----|--------------|-----|----------------------|
| VP-10 | Expired card → "card problem" screen + Update CTA | Integration test with expiry-triggering test card | Alert: unmatched gateway error codes appearing |
| VP-11 | Temporary decline → "try again" screen + Retry CTA | Integration test with decline-triggering test card | Monitor: retry success rate dropping below baseline |
| VP-12 | Unknown error → generic screen + support CTA with correlation ID | Integration test with malformed gateway response | Alert: unknown-category rate exceeds 5% of failures |
| VP-13 | Error state preserves cart and shipping details | Trigger payment error → navigate back → assert cart intact | Monitor: cart-loss events following payment errors |
| VP-14 | **Three rapid retries → single charge** | 3 concurrent requests, same idempotency key, assert 1 charge | Alert: duplicate charges in payment reconciliation |

## Coverage

| Requirement | Paths | Degradation monitored |
|-------------|-------|----------------------|
| REQ-201 Failure visible | VP-10, VP-11, VP-12 | Yes |
| REQ-202 Categorized reason | VP-10, VP-11, VP-12 | Yes |
| REQ-203 Recovery without restart | VP-13 | Yes |
| REQ-204 No duplicate charges | VP-14 | Yes |

Full coverage. Every requirement has at least one verification path and a degradation signal.

## VP-14: the test that exists because of a customer

The customer said "I tried three times." Those words traveled from a support ticket through PM into Engineering, where they became an idempotency requirement, and arrived here as VP-14.

VP-14 sends 3 concurrent payment requests with the same session key and asserts exactly 1 charge. It is the only test that catches duplicate charges from rapid retry. If the customer's words had been summarized as "payment error handling," this test does not exist and triple-charges go undetected until reconciliation.

QA reads the customer's story, not just the requirements. Requirements define what must be true. The story reveals how things actually break.
