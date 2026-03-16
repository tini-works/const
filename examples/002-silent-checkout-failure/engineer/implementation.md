# Engineer — Implementation

Four flows, one taxonomy, one gateway client rewrite. Each flow proves a specific box works.

---

## Payment Error Taxonomy

Four gateway error codes map to three UI categories. Design decides the user-facing grouping — Engineer keeps the full taxonomy for logging and monitoring.

| Gateway error code | UI category | Screen | Rationale |
|-------------------|-------------|--------|-----------|
| `card_expired` | card_problem | SCR-10 | Customer can fix this: update card |
| `card_invalid` | card_problem | SCR-10 | Customer can fix this: re-enter card |
| `temporary_decline` | temporary | SCR-11 | Retry may work |
| `insufficient_funds` | contact_bank | SCR-12 | Customer can't fix on our site. **Not displayed as "insufficient funds"** — Design's privacy rule |
| `fraud_suspected` | contact_bank | SCR-12 | Bank-side decision, customer must contact bank |
| (anything else) | contact_bank | SCR-12 | Unknown errors default to safest category |

The 4-to-3 mapping is deliberate. `insufficient_funds` is a distinct gateway code but the same UI treatment as `unknown` — because Design ruled that we can't expose financial status on screen.

---

## FLW-10: Gateway response parsing

**What happens:** Customer clicks "Pay." The checkout service calls the payment gateway. The response comes back as HTTP 200 regardless of result. The checkout service reads the response body, extracts `status` and `error_code`, and determines the outcome.

```
POST /api/checkout/pay
Body: {
  "cart_id": "cart-789",
  "payment": { "card_token": "tok_xxx" },
  "idempotency_key": "idem-checkout-789-v1"
}

Gateway response (HTTP 200):
{
  "status": "failed",
  "error_code": "card_expired",
  "error_message": "The card has expired.",
  "transaction_id": "txn_abc123"
}

Checkout service response to frontend:
{
  "result": "error",
  "error_category": "card_problem",
  "correlation_id": "corr-20240115-abc",
  "cart_preserved": true
}
```

The frontend reads `result`, not HTTP status. If `result === "error"`, it reads `error_category` and renders the matching screen.

**Verify:** `POST /api/checkout/pay` with expired test card in staging. Response body contains `result: "error"`, `error_category: "card_problem"`. Frontend shows SCR-10.

**Depends on:** Gateway response body contract. If the gateway changes its body format, this breaks.

---

## FLW-11: Error categorization

**What happens:** The checkout service maps gateway `error_code` to a UI `error_category` using the taxonomy above. Unknown codes default to `contact_bank` (safest fallback — doesn't claim the error is fixable when we don't know).

```
function categorize(gatewayErrorCode: string): ErrorCategory {
  switch (gatewayErrorCode) {
    case 'card_expired':
    case 'card_invalid':
      return 'card_problem';
    case 'temporary_decline':
      return 'temporary';
    case 'insufficient_funds':
    case 'fraud_suspected':
    default:
      return 'contact_bank';
  }
}
```

**Verify:** Unit test with every known gateway error code. Assert mapping matches taxonomy table above. Also test with an invented code (`"new_error_xyz"`) — must map to `contact_bank`.

**Depends on:** Gateway error code list. If the gateway adds new codes, they'll silently fall to `contact_bank` (safe default), but OBS-11 will alert if the unknown-category rate exceeds 5%.

---

## FLW-12: Correlation ID logging

**What happens:** Every payment attempt — success or failure — gets a correlation ID. On failure, this ID is:
1. Logged server-side with the full gateway response (including fields we don't show the customer)
2. Returned to the frontend (included in the "Contact support" link)
3. Available to the support team when the customer calls

The customer said "I tried three times." Without correlation IDs, support has no way to find which three attempts those were, whether any were charged, or what the gateway said.

```
Log entry:
{
  "correlation_id": "corr-20240115-abc",
  "cart_id": "cart-789",
  "attempt": 2,
  "gateway_status": "failed",
  "gateway_error_code": "card_expired",
  "gateway_error_message": "The card has expired.",
  "gateway_transaction_id": "txn_abc123",
  "idempotency_key": "idem-checkout-789-v1",
  "timestamp": "2024-01-15T14:32:01Z"
}
```

**Verify:** Trigger a failed payment in staging. Search logs by correlation ID. Assert: full gateway response is logged, including `error_code`, `error_message`, and `transaction_id`. Click "Contact support" on SCR-12. Assert: support form URL contains the correlation ID.

**Depends on:** Log infrastructure being available. If logging is down, payment still works — but support loses traceability.

---

## FLW-13: Idempotency

**What happens:** When the checkout session starts, the frontend generates an idempotency key: `idem-checkout-{cart_id}-v{attempt}`. This key is sent with every payment request. The gateway uses it to deduplicate — if the same key arrives twice, the gateway returns the result of the first attempt without charging again.

```
// First attempt:
POST /gateway/charge
{ "idempotency_key": "idem-checkout-789-v1", "amount": 49.99, ... }
→ Gateway processes, returns result

// Customer retries (same session):
POST /gateway/charge
{ "idempotency_key": "idem-checkout-789-v1", "amount": 49.99, ... }
→ Gateway recognizes key, returns same result, does NOT charge again

// Customer updates card and retries (new attempt):
POST /gateway/charge
{ "idempotency_key": "idem-checkout-789-v2", "amount": 49.99, ... }
→ Gateway treats as new charge (different key, different card)
```

The key increments the version suffix only when the customer changes their payment method (new card = new attempt). Same card retry = same key = safe.

**Why this matters:** The customer said "I tried three times." If those three clicks each sent a charge request without idempotency, the customer could have three pending charges for one order. This is the exact scenario that creates chargebacks and support escalations.

**Verify:** In staging, send three concurrent `POST /api/checkout/pay` requests with the same `idempotency_key`. Assert: gateway logs show one charge, not three. Assert: customer is charged once.

**Depends on:** Gateway supporting idempotency keys. Most major gateways (Stripe, Braintree, Adyen) do. If the gateway doesn't, we need client-side deduplication as a fallback.

---

## System design summary

```
Customer clicks "Pay"
    → Frontend generates idempotency key (idem-checkout-{cart_id}-v{n})
    → POST /api/checkout/pay { cart_id, payment, idempotency_key }
    → Checkout Service:
        → Generate correlation ID
        → Call gateway with idempotency key
        → Read response BODY (not just HTTP status)
        → Categorize error code via taxonomy
        → Log full response with correlation ID
        → Return to frontend: { result, error_category, correlation_id, cart_preserved }
    → Frontend:
        → If result === "success" → Order Confirmation
        → If result === "error" → render screen by error_category
            → cart_problem → SCR-10
            → temporary → SCR-11
            → contact_bank → SCR-12
```

## What goes suspect if this changes

- If the gateway changes its idempotency key format or behavior --> FLW-13 needs re-verification, VP-05 must re-run
- If new payment methods are added --> each method may have different error codes, taxonomy needs expansion
- If the gateway adds new error codes --> they'll default to `contact_bank` (safe), but OBS-11 will detect the spike
- If the checkout service is rewritten --> all four flows need re-verification
