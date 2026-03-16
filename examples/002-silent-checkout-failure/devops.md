# DevOps — Checkout Payment Operations

This is a critical payment path. A bad deploy means silent charge failures, duplicate charges, or lost revenue. Every operational decision reflects that.

## Infrastructure

| Dependency | Detail | SLA |
|------------|--------|-----|
| Payment gateway | External. Returns HTTP 200 for everything (success and failure). | <2s response, 99.95% availability |
| Checkout service | Internal. Parses gateway response, categorizes errors, manages idempotency. | <500ms processing |
| Checkout end-to-end | Customer clicks "Pay" to screen response (confirmation or error) | <3s total |
| Gateway simulator (staging) | Must match production's HTTP-200-for-everything contract | N/A (test infra) |

## Monitoring

### OBS-10: Payment error rate by category

**What it watches:** Dashboard showing payment failure rate broken down by `error_category` (card_problem, temporary, contact_bank) over time.

**Why it matters:** Baseline error rates establish normal. A spike in one category signals either a gateway issue (temporary_decline spike = gateway degradation) or a taxonomy bug (contact_bank spike = new error codes falling to default).

**Verify the signal works:** In staging, send 100 checkout requests: 70 success, 10 card_expired, 10 temporary_decline, 10 insufficient_funds. Dashboard should show 30% error rate with correct category breakdown.

### OBS-11: Unknown-category error rate

**What it watches:** Percentage of payment failures that fall into the `contact_bank` category because the gateway error code wasn't in the taxonomy (i.e., hit the `default` branch in FLW-11).

**Threshold:** Alert if >5% of failures in a 15-minute window are from unknown codes.

**Why it matters:** When the gateway adds new error codes, they silently fall to `contact_bank`. That's safe for the customer but means we might be miscategorizing recoverable errors. A spike means the taxonomy needs updating.

**Verify the signal works:** In staging, configure gateway simulator to return a novel error code (`"new_error_type"`). Send 20 failed checkouts with this code. Alert should fire within 15 minutes.

### OBS-12: Duplicate charge detection

**What it watches:** Payment reconciliation feed. Flags any `cart_id` with more than one successful charge.

**Threshold:** Any duplicate = immediate P0 alert. Zero tolerance.

**Why it matters:** This is the "I tried three times" scenario. If idempotency fails, customers get charged multiple times. This is the most severe degradation — it's financial harm.

**Verify the signal works:** In staging, bypass idempotency (test-only flag) and send two charges for the same cart. Alert should fire immediately. Verify alert includes both transaction IDs and the cart ID.

### OBS-13: Correlation ID lookup dashboard

**What it watches:** Not a threshold alert — a support tool. Dashboard where support agents enter a correlation ID and see: all payment attempts for that session, gateway responses, error categories, timestamps.

**Why it matters:** When the customer calls and says "I tried three times," support can find exactly what happened. Before this, they had nothing.

**Verify the signal works:** Trigger a failed payment in staging. Copy the correlation ID from the "Contact support" link. Enter it in the dashboard. Assert: all attempts for that session are shown with full gateway response details.

---

## Deployment

### Canary strategy

This is a payment path change. Full rollout without canary is unacceptable.

**Plan:**
1. Deploy new gateway client (body parsing + categorization) behind feature flag `checkout.new_gateway_parser`
2. Enable for 5% of traffic (canary)
3. Monitor for 2 hours:
   - Error categorization distribution (OBS-10) — should match expected ratios
   - No duplicate charges (OBS-12) — zero tolerance
   - No increase in checkout abandonment rate
   - No increase in support tickets
4. If clean: ramp to 25% → 50% → 100% over 24 hours
5. Keep old code path available for 7 days post-full-rollout

### Feature flag: `checkout.new_gateway_parser`

**ON:** Checkout service parses gateway response body, categorizes errors, generates idempotency keys, logs correlation IDs. Frontend shows error screens.

**OFF (rollback):** Checkout service uses old behavior — checks HTTP status only. Silent failures return. This is bad but known-bad. It's the state we're in today.

**Rollback trigger:** Any of the following within the canary window:
- OBS-12 fires (duplicate charge) — rollback immediately, investigate
- Checkout error rate doubles vs. baseline — rollback, investigate
- Customer-visible error messages show raw gateway text (taxonomy leak) — rollback, fix

### Rollback procedure

```
1. Disable feature flag: checkout.new_gateway_parser = OFF
2. Verify: new checkouts use old code path (monitor logs for correlation_id presence — old path doesn't generate them)
3. Investigate root cause
4. Fix, re-test in staging, re-deploy behind flag
5. Restart canary from step 1
```

Rollback restores the silent failure behavior. That's worse than the fix, but it's a known state that doesn't create duplicate charges or expose raw errors. The priority after rollback is fixing and re-deploying, not staying rolled back.

---

## Runbook: Payment Error Spike

**When this runs:** OBS-10 shows a sudden increase in payment error rate, or OBS-11 fires (unknown-category spike).

### Step 1: Classify the spike

```bash
# Check error distribution in the last 30 minutes
curl -s "https://monitoring.internal/api/v1/query?query=payment_errors_by_category[30m]" | jq '.'
```

- If one category is spiking and others are flat → likely a gateway-side issue for that error type
- If all categories are spiking → likely a gateway outage or our parsing is broken
- If `contact_bank` (unknown) is spiking → gateway added new error codes

### Step 2: Check gateway health

```bash
# Gateway status page (external)
curl -s "https://status.paymentgateway.com/api/v1/status" | jq '.components[] | select(.name == "Payments")'

# Our gateway call latency and error rate
curl -s "https://monitoring.internal/api/v1/query?query=gateway_response_time_p95[15m]"
```

### Step 3: Decide

| Finding | Action |
|---------|--------|
| Gateway outage | Nothing to fix on our side. Monitor. Consider showing a "payments temporarily unavailable" banner if outage >15 min. |
| New gateway error codes | Safe — they're falling to `contact_bank`. But update the taxonomy (FLW-11) and deploy. Open a ticket for Design to decide if new codes need a different screen. |
| Our parsing is broken | Rollback via feature flag. Fix. Re-deploy. |
| Duplicate charges detected | P0. Rollback immediately. Identify affected customers. Initiate refunds. |

### Step 4: Post-incident

- Update taxonomy if new codes were discovered
- Update staging gateway simulator to include new codes
- If rollback was triggered: add the failure scenario to VP test suite

---

## Test environment

| Data | What's configured | Why |
|------|------------------|-----|
| Test card `4242424242424242` | Always succeeds | Baseline success path |
| Test card `4000000000000069` | Returns `card_expired` | VP-01: card problem flow |
| Test card `4000000000009995` | Returns `insufficient_funds` | VP-03: contact bank flow (privacy-safe) |
| Gateway simulator: `temporary_decline` mode | Returns `temporary_decline` for N attempts, then success | VP-02: retry flow |
| Gateway simulator: `novel_error` mode | Returns an error code not in the taxonomy | OBS-11: unknown-category detection |
| Load test profile | 1000 concurrent checkouts, 70/30 success/fail split | Baseline performance + idempotency under load |

**Critical:** The staging gateway simulator MUST return HTTP 200 for failures, matching production. The original bug existed because staging returned HTTP 402 for declines — a contract mismatch with production. This must never happen again.

## Flow-to-signal coverage

| Flow | Signal | Covers |
|------|--------|--------|
| FLW-10 Gateway response parsing | OBS-10 (error rate by category) | Are errors being categorized? |
| FLW-11 Error categorization | OBS-11 (unknown-category rate) | Are new codes falling through? |
| FLW-12 Correlation ID logging | OBS-13 (lookup dashboard) | Can support trace customer complaints? |
| FLW-13 Idempotency | OBS-12 (duplicate charges) | Are retries safe? |

Every engineering flow has a production signal. No unobservable flows.
