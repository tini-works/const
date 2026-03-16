# Engineer — Root Cause Discovery

## The bug

The payment gateway returns **HTTP 200 for all responses**, including failures. The error information is in the response body, not the HTTP status code.

```
// What the gateway actually returns on a declined card:
HTTP/1.1 200 OK

{
  "status": "failed",
  "error_code": "card_expired",
  "error_message": "The card has expired.",
  "transaction_id": "txn_abc123"
}
```

The frontend checkout code checks `response.status === 200` and treats it as success. It never reads the body. The "processing" spinner stays forever because the success handler runs but has no order confirmation to display.

```
// The bug — simplified:
const response = await fetch('/api/checkout/pay', { ... });
if (response.ok) {
    // This runs even on gateway failures because HTTP status is always 200
    showConfirmation(await response.json());
    // But there's no confirmation data in a failure response
    // So the page just... sits there
}
// No else branch. No error handling. Silence.
```

## Why it existed

This isn't a careless mistake. The gateway's HTTP-200-for-everything pattern is a legitimate design choice — some gateways do this because they consider the HTTP layer to be about transport (the request was received and processed) and the business result is in the body.

The frontend was written when the only test path was success. Nobody tested with a real declined card during development. The staging gateway simulator at the time returned HTTP 402 for declines — a different contract than production.

**Two failures compounded:**
1. Frontend assumed HTTP status = business result
2. Staging simulator had a different error contract than production

## What Engineer surfaced

This root cause led to three new boxes that PM couldn't have known about:

| Box | What | Why it came from the root cause |
|-----|------|-------------------------------|
| B5 | Parse response body, not just HTTP status | Direct fix for the bug |
| B6 | Log failed attempts with correlation ID | Support needs to trace "I tried three times" — which three? |
| B7 | Idempotency key for retries | "I tried three times" means the gateway may have received three charge requests |

B7 is the one that matters most to the customer. The silent failure caused retries. Retries without idempotency can cause duplicate charges. The customer's words — "I tried three times" — revealed this.

## Verify the root cause is fixed

```bash
# In staging — trigger an expired card response:
curl -X POST https://staging.example.com/api/checkout/pay \
  -H "Content-Type: application/json" \
  -d '{
    "cart_id": "test-cart-001",
    "payment": { "card": "4000000000000069" },
    "idempotency_key": "test-idem-001"
  }'

# Before the fix: HTTP 200, frontend shows nothing
# After the fix: HTTP 200, frontend reads body, shows SCR-10
```

The HTTP status is still 200. That hasn't changed — we don't control the gateway. What changed is that the frontend now reads the body.

## What goes suspect if this changes

- If the payment gateway changes its response body format --> FLW-10 (parsing) breaks, all error categorization breaks
- If new error codes are added by the gateway --> FLW-11 (taxonomy) needs updating or they fall into "unknown"
- If the staging gateway simulator is updated --> verify it still matches production's HTTP-200-for-everything pattern (the original divergence caused this bug)
