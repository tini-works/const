# Product Registry — Silent Checkout Failure

**Trigger:** Support ticket spike, March 2024
**Customer:** "I hit the pay button, the page just sat there. I tried three times. Then I gave up and bought it somewhere else."

## Requirements

| ID | Requirement | Source | Downstream | Proven |
|----|-------------|--------|------------|--------|
| REQ-201 | Payment failure must be visible to customer | Support tickets (47 in 2 weeks) | Design: SCR-10..12 | Yes |
| REQ-202 | Failure reason categorized for user action | Support tickets + Design pushback on raw errors | Engineer: error taxonomy | Yes |
| REQ-203 | Recovery without restarting checkout | Support tickets ("had to re-add everything") | Design: state machine | Yes |
| REQ-204 | No duplicate charges on retry | Customer's exact words: "I tried three times" | Engineer: idempotency key | Yes |

REQ-204 is the one that matters most. The customer said "three times." Three clicks = three potential charges. If PM had summarized the ticket as "payment error handling," nobody discovers the idempotency edge case.

## Contracts

| With | PM commits to | They commit to | Negotiation |
|------|--------------|----------------|-------------|
| Design | Categorized failure reasons (card/temp/bank) | Error screens with actionable CTAs | Design rejected raw gateway messages — "insufficient funds" is sensitive. PM agreed. Categories are better. |
| Design | — | Cart + shipping preserved on error | Design originated this. Without it, failed payment = lost cart = worse than the original bug. |
| Engineer | Root cause fix + idempotency | Parse gateway body, not just HTTP status | Engineer found the root cause: gateway returns 200 with error in body. Frontend never checked. |
| Engineer | — | Correlation ID for support debugging | Engineer originated. Support was flying blind on payment complaints. |
| QA | All 4 requirements verified | Proof that "3 retries = 1 charge" | VP-14 exists because PM carried the customer's words, not a cleaned-up summary. |

## What PM learned

The instinct was "just show an error." Carrying the customer's exact story through the process revealed 4 requirements instead of 1. The words matter — "three times" created REQ-204. "Page just sat there" created REQ-201. PM's job is to carry the story faithfully, not sanitize it.
