# 002 — E-Commerce: Checkout Fails Silently on Expired Card

**Trigger:** Support ticket spike. Customers say "I clicked Pay and nothing happened."

> "I hit the pay button, the page just sat there. I tried three times. Then I gave up and bought it somewhere else."

---

### Step 1: PM resists the obvious fix

PM's instinct: "just show an error message." The Constitution says don't derive, match. Discover boxes first.

**Boxes created:**
- `B1` When payment fails, the customer must know it failed
- `B2` The customer must know **why** it failed (actionable reason)
- `B3` The customer must have a path to resolve it without restarting checkout

PM sends B1-B3 to Design.

#### Inventory

```
PM
  Requirements
    + [REQ-201] Payment failure visibility              → source: support ticket spike
    + [REQ-202] Actionable failure reason                → source: support ticket spike
    + [REQ-203] Recovery without restart                 → source: support ticket spike
  Boxes sent
    + B1 → Design
    + B2 → Design
    + B3 → Design

Design        (empty)
Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 2: Design negotiates B2 — "actionable" has limits

Design pushes back on B2:

> "We can't expose raw gateway errors. For expired cards, 'update your card' is the action. But for 'insufficient funds' — we can't say that. It's sensitive."

**Negotiation result:**
- `B2` revised → Show a **categorized** reason: card problem (update card), temporary issue (retry), or contact bank
- `B4` new (from Design) → Error state must not lose cart contents or shipping info

#### Inventory

```
PM
  Requirements
    [REQ-201..203]
  Boxes sent
    B1 → Design
    ~ B2 → Design (categorized reason, not raw error)          ← REVISED
    B3 → Design
    + B4 → Design (preserve cart on error)                      ← NEW from Design

Design
  Boxes received
    + B1, B2 (revised), B3, B4

Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 3: Design produces error states

Design translates boxes into screen states and updates the checkout state machine.

#### Inventory

```
PM             (unchanged)

Design
  Boxes received
    B1, B2, B3, B4
  Screens
    + [SCR-10] Checkout Error — card problem variant
        Message: "There's a problem with your card"
        CTA: "Update payment method"
    + [SCR-11] Checkout Error — temporary decline variant
        Message: "Payment couldn't be processed right now"
        CTA: "Try again"
    + [SCR-12] Checkout Error — contact bank variant
        Message: "Please contact your bank"
        CTA: "Try different payment method" / "Contact support"
  State machine
    ~ Pay → Processing →
        Success → Confirmation
        + Failure → Error State (categorized) →
            Update Card → return to Payment
            Retry → return to Processing
            Exit → Cart preserved, session saved
  Boxes sent
    + B1-B4 → Engineer (with screen specs)

Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 4: Engineer finds the root cause and surfaces new boxes

Engineer investigates the silent failure. Discovers:

> The payment gateway returns HTTP 200 with an error in the response body. The frontend only checks HTTP status. That's why "nothing happens."

Engineer also thinks about the customer's story — "I tried three times."

**New boxes surfaced:**
- `B5` (Engineer) → Gateway response parsing must check both HTTP status **and** body-level error codes
- `B6` (Engineer) → Failed payment attempts must be logged with correlation ID for support
- `B7` (Engineer) → Rapid retries must not create duplicate charges (idempotency)

B7 came directly from the customer's words. Without the story, this edge case is invisible.

#### Inventory

```
PM
  Requirements
    [REQ-201..203]
    + [REQ-204] Idempotent payment processing           → source: customer story ("tried 3 times")
  Boxes
    B1-B4 → Design
    + B5 (from Engineer, accepted)
    + B6 (from Engineer, accepted)
    + B7 (from Engineer, accepted)                       ← from customer's exact words

Design         (unchanged — B5-B7 don't affect screens)

Engineer
  Root cause
    + Gateway returns HTTP 200 with error body; frontend only checks status code
  Flows
    + [FLW-10] Checkout → Gateway call → parse response (status + body) → categorize
    + [FLW-11] Error categorization: card_expired | insufficient_funds | temporary_decline | unknown
    + [FLW-12] Failed attempt logging with correlation ID
    + [FLW-13] Idempotency: generate idempotency key per checkout session, gateway deduplicates
  System design
    + Payment error taxonomy (4 categories mapped to 3 UI variants)
    + Gateway client rewrite — response body parsing
    + Idempotency key generation (per-session, passed to gateway)
  Boxes matched
    + B1 ← FLW-10 (failure now surfaces to UI)
    + B2 ← FLW-11 (categorized reason)
    + B3 ← FLW-10 (returns to checkout, not restart)
    + B4 ← FLW-10 (cart state preserved in session)
    + B5 ← FLW-10 (body parsing)
    + B6 ← FLW-12 (correlation ID logging)
    + B7 ← FLW-13 (idempotency key)

QA            (empty)
DevOps        (empty)
```

---

### Step 5: QA maps verification paths

QA looks at the customer's story, the flows, and the state machine. Maps every proof.

Note VP-05 — it exists because someone listened to "I tried three times."

#### Inventory

```
PM             (unchanged)
Design         (unchanged)
Engineer       (unchanged)

QA
  Verification paths
    + [VP-01] Expired card → "card problem" message + "Update payment method" CTA
        Mechanism: integration test with test card number that triggers expiry
        Degradation: alert on unmatched error codes (new gateway codes not in taxonomy)
    + [VP-02] Temporary decline → "temporary issue" + "Try again" CTA
        Mechanism: integration test with decline-triggering card
        Degradation: monitor retry success rate (if always failing, category might be wrong)
    + [VP-03] Unknown error → generic message + "Contact support" with correlation ID visible
        Mechanism: integration test with malformed gateway response
        Degradation: alert on unknown-category rate >5%
    + [VP-04] Error state preserves cart and shipping info
        Mechanism: trigger error, navigate back, assert cart intact
        Degradation: monitor cart-loss events post-error
    + [VP-05] Three rapid retries don't create duplicate charges          ← FROM THE STORY
        Mechanism: send 3 concurrent requests with same idempotency key, assert single charge
        Degradation: monitor duplicate charge alerts from payment reconciliation
  Proof coverage
    B1 → VP-01, VP-02, VP-03
    B2 → VP-01, VP-02, VP-03
    B3 → VP-01, VP-02, VP-03, VP-04
    B4 → VP-04
    B5 → VP-01, VP-02, VP-03 (all parse body)
    B6 → VP-03 (correlation ID shown)
    B7 → VP-05

DevOps        (empty)
```

---

### Step 6: DevOps adds operational proof

#### Inventory

```
PM             (unchanged)
Design         (unchanged)
Engineer       (unchanged)
QA             (unchanged)

DevOps
  Observability
    + [OBS-10] Dashboard: payment error rate by category (card/temp/unknown)
    + [OBS-11] Alert: unknown-category errors >5% of total failures
    + [OBS-12] Alert: duplicate charge detected in reconciliation feed
    + [OBS-13] Dashboard: correlation ID lookup for support team
  Deployment
    + Gateway client change requires canary deploy (payment path = critical)
    + Rollback plan: feature flag on new body-parsing logic, fallback to old behavior
  Environment parity
    + Staging gateway simulator supports all 4 error categories
    + Load test: 1000 concurrent checkouts with mixed success/failure
```

---

### Final inventory snapshot

```
PM (4 requirements, 7 boxes — 3 surfaced by Engineer)
  REQ-201..204, B1..B7

Design (4 boxes received, 3 error screen variants, updated state machine)
  SCR-10..12, checkout state machine with failure branch

Engineer (4 flows, error taxonomy, gateway rewrite, idempotency)
  FLW-10..13, 7 boxes matched

QA (5 verification paths, 7 boxes covered)
  VP-01..05 — VP-05 exists because of the customer's exact words

DevOps (4 observability items, canary + rollback plan, staging simulator)
  OBS-10..13, feature flag rollback
```

**A "simple bug fix" became: a taxonomy, a gateway client rewrite, idempotency verification, 5 proof paths, and 4 monitoring rules.**

The customer's words — "I tried three times" — created VP-05. A requirements doc would have missed it.
