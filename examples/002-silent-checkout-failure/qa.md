# QA — Checkout Failure Proofs

Five things we prove. Each is runnable. Each has a degradation signal. VP-05 exists because a customer said "I tried three times."

---

## VP-01: Expired card shows "card problem" screen

**What we're proving:** When a customer's card is expired, they see SCR-10 with the message "There's a problem with your card" and a CTA to update their payment method. Not silence. Not a spinner. A clear message with a next step.

**Run:**
1. In staging, start a checkout with test cart `CART-TEST-01`
2. Enter test card `4000000000000069` (triggers `card_expired` from gateway)
3. Click "Pay"
4. Assert: SCR-10 appears — "There's a problem with your card"
5. Assert: CTA reads "Update payment method"
6. Assert: cart contents and shipping info are still visible and intact
7. Enter a valid test card (`4242424242424242`)
8. Click "Pay" again
9. Assert: Order Confirmation appears

**Proves:** B1 (failure is visible), B2 (actionable reason: "update your card"), B3 (recovery without restart), B4 (cart preserved), B5 (body parsing works — HTTP status was 200).

**If it breaks:** Monitor `error_category` distribution in production logs. If `card_problem` stops appearing but gateway still returns `card_expired`, the categorization in FLW-11 is broken.

---

## VP-02: Temporary decline shows "try again" screen

**What we're proving:** When the gateway returns a transient error, the customer sees SCR-11 with "Payment couldn't be processed right now" and can retry safely.

**Run:**
1. In staging, configure gateway simulator to return `temporary_decline` for the first attempt, then `success` on retry
2. Start checkout with test cart `CART-TEST-02`
3. Enter a valid test card
4. Click "Pay"
5. Assert: SCR-11 appears — "Payment couldn't be processed right now"
6. Assert: CTA reads "Try again"
7. Assert: card details are preserved (temporary issue, not a card problem)
8. Click "Try again"
9. Assert: Order Confirmation appears
10. Assert: exactly one charge was created (idempotency key was reused on retry)

**Proves:** B1 (failure is visible), B2 (actionable reason: "try again"), B5 (body parsing), B7 (retry didn't create a duplicate charge).

**If it breaks:** Monitor retry success rate. If retries on `temporary_decline` always fail, the category might be wrong — it could be a permanent decline miscategorized as temporary.

---

## VP-03: Unknown error shows "contact bank" with correlation ID

**What we're proving:** When the gateway returns an error we can't categorize (or `insufficient_funds` — which we intentionally don't name), the customer sees SCR-12 with "Please contact your bank" and support gets a traceable correlation ID.

**Run:**
1. In staging, configure gateway simulator to return `insufficient_funds`
2. Start checkout with test cart `CART-TEST-03`
3. Enter test card `4000000000009995` (insufficient funds)
4. Click "Pay"
5. Assert: SCR-12 appears — "Please contact your bank"
6. Assert: message does NOT contain "insufficient funds" or any financial detail
7. Click "Contact support"
8. Assert: support form opens with correlation ID in URL params
9. Search staging logs by that correlation ID
10. Assert: log entry contains `error_code: "insufficient_funds"`, `gateway_transaction_id`, and full response

**Proves:** B1 (failure is visible), B2 (actionable without being humiliating — Design's privacy rule), B6 (correlation ID is logged and reachable by support).

**If it breaks:** Monitor `unknown`-category rate via OBS-11. If >5% of failures are uncategorized, the gateway may have introduced new error codes not in the taxonomy.

---

## VP-04: Error state preserves cart and shipping

**What we're proving:** When any payment error occurs, the customer's cart contents, shipping address, and applied discounts survive. The customer never has to re-enter anything except (optionally) their card.

**Run:**
1. In staging, set up a cart with 3 items, a shipping address, and a 10%-off coupon
2. Enter expired test card
3. Click "Pay"
4. Assert: SCR-10 appears (error)
5. Assert: cart still shows 3 items with correct quantities
6. Assert: shipping address is unchanged
7. Assert: coupon is still applied, total reflects 10% discount
8. Update card to a valid one
9. Complete payment
10. Assert: Order Confirmation shows the same 3 items, same shipping address, same discount

**Proves:** B4 (cart preservation — Design's contribution).

**If it breaks:** Monitor `cart_loss_after_error` events. If cart contents change between the payment attempt and the error screen render, session state management is broken.

---

## VP-05: Three rapid retries create only one charge

**What we're proving:** When a customer hits "Pay" three times in quick succession — exactly what our customer did — the payment gateway processes exactly one charge. This is the idempotency proof.

**This VP exists because of the customer's exact words: "I tried three times."** Without that story, this test doesn't get written. A traditional test plan would test "payment succeeds" and "payment fails." It wouldn't test "payment is submitted three times concurrently."

**Run:**
1. In staging, start checkout with test cart `CART-TEST-05`
2. Generate idempotency key: `idem-checkout-CART-TEST-05-v1`
3. Send three concurrent POST requests to `/api/checkout/pay`:
   ```bash
   for i in 1 2 3; do
     curl -X POST https://staging.example.com/api/checkout/pay \
       -H "Content-Type: application/json" \
       -d '{
         "cart_id": "CART-TEST-05",
         "payment": { "card_token": "tok_valid" },
         "idempotency_key": "idem-checkout-CART-TEST-05-v1"
       }' &
   done
   wait
   ```
4. Assert: gateway transaction log shows exactly ONE charge for `CART-TEST-05`
5. Assert: all three responses return the same `transaction_id`
6. Assert: customer balance is debited once, not three times
7. Check OBS-12 (duplicate charge monitor) — it should NOT fire

**Proves:** B7 (idempotency — from the customer's story).

**If it breaks:** OBS-12 fires — duplicate charges detected in reconciliation. This is a P0: customer is overcharged, chargebacks incoming.

---

## Coverage

| Box | What | Verified by | Degradation signal |
|-----|------|-------------|-------------------|
| B1 | Failure is visible | VP-01, VP-02, VP-03 | Error screen render rate vs. gateway failure rate |
| B2 | Actionable reason | VP-01, VP-02, VP-03 | `error_category` distribution in logs |
| B3 | Recovery without restart | VP-01, VP-02, VP-03, VP-04 | Cart-loss-after-error events |
| B4 | Cart preserved on error | VP-04 | Cart-loss-after-error events |
| B5 | Response body parsing | VP-01, VP-02, VP-03 | Unmatched error codes (gateway returns error, frontend shows nothing) |
| B6 | Correlation ID logging | VP-03 | Support lookup success rate |
| B7 | Idempotent retries | VP-05 | Duplicate charge alerts (OBS-12) |

Every box has a proof. Every proof is runnable. Every proof has a degradation signal. VP-05 came from listening to the customer.
