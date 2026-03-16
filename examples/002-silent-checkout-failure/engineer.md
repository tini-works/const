# Engineer Inventory — 002 Silent Checkout Failure

**Boxes to match:** B1-B7

## Root Cause

The payment gateway returns HTTP 200 with an error in the response body. Frontend only checks HTTP status. "Nothing happens" because the frontend thinks 200 = success.

## Flows

| ID | Flow | Matches |
|----|------|---------|
| FLW-10 | Checkout → gateway call → parse response (status + body) → categorize → UI | B1, B3, B4, B5 |
| FLW-11 | Error categorization: card_expired \| insufficient_funds \| temp_decline \| unknown | B2 |
| FLW-12 | Failed attempt logging with correlation ID | B6 |
| FLW-13 | Idempotency: per-session key, gateway deduplicates | B7 |

## System Design

| Item | Detail |
|------|--------|
| Payment error taxonomy | 4 gateway codes → 3 UI variants (card/temp/bank) |
| Gateway client rewrite | Parse response body, not just HTTP status |
| Idempotency key | Generated per checkout session, passed to gateway |

## Upward boxes: B5, B6, B7

- **B5** — HTTP 200 with error body is invisible to upstream verticals. Only Engineer sees the parsing problem.
- **B6** — Support team needs correlation IDs to debug complaints. Without logging, support is blind.
- **B7** — From the customer's exact words: "I tried three times." Three clicks could create three charges. This box exists because the customer's story was carried faithfully.
