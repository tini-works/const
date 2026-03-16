# PM Inventory — 002 Silent Checkout Failure

**Source:** Support ticket spike — "I clicked Pay and nothing happened."

> "I hit the pay button, the page just sat there. I tried three times. Then I gave up and bought it somewhere else."

## Requirements

| ID | Requirement | External source | Downstream match | Status |
|----|-------------|----------------|-----------------|--------|
| REQ-201 | Payment failure must be visible to customer | Support tickets | Design → SCR-10..12 | PROVEN |
| REQ-202 | Actionable failure reason (categorized) | Support tickets + Design negotiation | Engineer → FLW-11 | PROVEN |
| REQ-203 | Recovery without restarting checkout | Support tickets | Design → state machine | PROVEN |
| REQ-204 | Idempotent payment processing | Engineer — from customer's words | Engineer → FLW-13 | PROVEN |

## Boxes

| Box | Direction | Content | Negotiation notes | Status |
|-----|-----------|---------|-------------------|--------|
| B1 | PM → Design | Customer must know payment failed | Accepted | PROVEN |
| B2 | PM → Design | Categorized reason: card/temp/bank | Revised: Design said "can't show raw errors" | PROVEN |
| B3 | PM → Design | Recovery path without restart | Accepted | PROVEN |
| B4 | Design → PM | Error state preserves cart + shipping | Originated by Design | PROVEN |
| B5 | Engineer → PM | Parse HTTP status + body error codes | Originated by Engineer (root cause) | PROVEN |
| B6 | Engineer → PM | Correlation ID for support debugging | Originated by Engineer | PROVEN |
| B7 | Engineer → PM | No duplicate charges on rapid retry | Originated by Engineer — from customer story | PROVEN |

## Observations

- PM's instinct was "just show an error message." The framework forced box discovery first, which revealed 7 boxes instead of 1.
- B7 exists because PM carried the customer's story faithfully: "I tried three times." If PM had sanitized it into "payment error handling," the idempotency edge case is invisible.
- The customer's exact words matter. PM's job is to carry them, not clean them.
