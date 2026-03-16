# System Registry — Silent Checkout Failure

## Root Cause

The payment gateway returns **HTTP 200 with an error in the response body**. The frontend checks HTTP status only. 200 = success, so it does nothing. The page "just sits there" because the UI is waiting for a confirmation that will never come.

```
Frontend sends POST /pay
Gateway returns: HTTP 200 { "status": "declined", "code": "card_expired", ... }
Frontend sees: 200 → assumes success → waits for redirect → nothing happens
```

## Flows

| ID | Flow | Purpose |
|----|------|---------|
| FLW-10 | Checkout → gateway call → **parse response body** → categorize → route to UI | Fix the root cause: read the body, not just the status code |
| FLW-11 | Error taxonomy: `card_expired` `insufficient_funds` `temp_decline` `do_not_honor` `unknown` → 3 UI categories | Map gateway codes to user-actionable categories |
| FLW-12 | Failed payment → log with correlation ID → expose to support dashboard | Give support team a way to debug customer complaints |
| FLW-13 | Generate idempotency key per checkout session → pass to gateway → gateway deduplicates | Prevent duplicate charges on rapid retry |

## Decisions

| Decision | Rationale |
|----------|-----------|
| Parse body, not just HTTP status | Root cause. Gateway's 200-with-error-body pattern is a known quirk of this provider. |
| 4 gateway codes → 3 UI categories | `card_expired` + `insufficient_funds` both map to "card problem." Design requirement: no raw codes shown to user. |
| Idempotency key per session, not per click | Per-click keys don't protect against "I clicked three times fast." Per-session key means the gateway sees one charge regardless of retries. |
| Correlation ID on every failed attempt | Support was diagnosing payment complaints with nothing but a timestamp and email. Correlation ID links customer → attempt → gateway response. |

## The key discovery

The customer said "I tried three times." Engineer heard: three POST requests, same card, same amount, no dedup. Without idempotency, three clicks = three charges when the gateway eventually processes them. FLW-13 exists because the customer's words reached Engineering intact.

## What Engineer surfaced upstream

- **Gateway parsing problem.** No other team could have found this — it's invisible unless you read the HTTP response body.
- **Correlation ID need.** Support team had no tooling. Engineer added it to the contract.
- **Idempotency requirement.** Translated "I tried three times" into a technical constraint. This went back to PM as REQ-204.
