# QA Inventory — Faces Proof Integrity

The constitutional court. QA does not write the laws (boxes). QA audits that proofs hold across all verticals.

**Contains:** Verification paths (how is each match proven?). Proof mechanisms (automated + manual). Degradation signals (how do we know when proof breaks?).

**Proven means:** The proof registry covers every box. No match without a verification path. No path without a mechanism. No mechanism without a degradation signal.

---

## Entry 001 — Patient Check-In

**Boxes to cover:** B1 (pre-filled + editable), B2 (persistence), B3 (confirm flow), B4 (confirm step), B5 (allergy staleness)

### Verification paths added

| ID | Path | Mechanism | Degradation signal | Boxes |
|----|------|-----------|-------------------|-------|
| VP-01 | Returning patient, no changes → confirm, no staff review | Integration test with test patient | Monitor review queue false positives | B1, B2, B3, B4 |
| VP-02 | Returning patient, insurance changed → staff review populated | Integration test, mutate insurance field | Monitor queue miss rate | B1, B2 |
| VP-03 | Allergy data >6mo stale → forced re-confirmation | Integration test with backdated allergy record | Monitor allergy-fetch response age headers | B2, B5 |
| VP-04 | New patient → full intake flow (regression) | Existing intake test suite | Existing monitors | B4 |

### Coverage check

| Box | Covered by | Degradation signal? |
|-----|------------|-------------------|
| B1 | VP-01, VP-02 | Yes |
| B2 | VP-01, VP-02, VP-03 | Yes |
| B3 | VP-01 | Yes |
| B4 | VP-01, VP-04 | Yes |
| B5 | VP-03 | Yes |

**Full coverage. Every box has a verification path, mechanism, and degradation signal.**

---

## Entry 002 — Silent Checkout Failure

**Boxes to cover:** B1 (failure visible), B2 (categorized reason), B3 (recovery path), B4 (cart preserved), B5 (body parsing), B6 (correlation ID), B7 (idempotency)

### Verification paths added

| ID | Path | Mechanism | Degradation signal | Boxes |
|----|------|-----------|-------------------|-------|
| VP-10 | Expired card → "card problem" + update CTA | Integration test, expiry-triggering card | Alert on unmatched gateway error codes | B1, B2, B5 |
| VP-11 | Temporary decline → "temp issue" + retry CTA | Integration test, decline-triggering card | Monitor retry success rate | B1, B2, B5 |
| VP-12 | Unknown error → generic + support CTA with correlation ID | Integration test, malformed gateway response | Alert on unknown-category rate >5% | B1, B2, B5, B6 |
| VP-13 | Error state preserves cart and shipping | Trigger error, navigate back, assert cart | Monitor cart-loss events post-error | B3, B4 |
| VP-14 | Three rapid retries → single charge | 3 concurrent requests, same idempotency key | Duplicate charge alerts from reconciliation | B7 |

### VP-14: the edge case from the customer's story

The customer said "I tried three times." If PM had cleaned the story into "payment error handling," this verification path wouldn't exist. VP-14 exists because the customer's words were carried faithfully through the system.

**This is why QA must read the customer's story, not just the boxes.** Boxes define what must be true. The story reveals how things actually break.

### Coverage check

| Box | Covered by | Degradation signal? |
|-----|------------|-------------------|
| B1 | VP-10, VP-11, VP-12 | Yes |
| B2 | VP-10, VP-11, VP-12 | Yes |
| B3 | VP-13 | Yes |
| B4 | VP-13 | Yes |
| B5 | VP-10, VP-11, VP-12 | Yes |
| B6 | VP-12 | Yes |
| B7 | VP-14 | Yes |

**Full coverage.**

---

## Entry 003 — Auth Library Migration

**Boxes to cover:** B1 (backward compat), B2 (no code changes), B3 (rollback), B4 (dual-mode), B5 (opt-in issuance), B6 (grace period)

### Verification approach: service-level re-verification

This isn't a single feature with verification paths. It's a library change that affects every dependent service. QA's role: track which services have re-verified.

### Proof registry — service verification tracking

| Service | Status | Detail |
|---------|--------|--------|
| Service A | PROVEN | v2 tokens, backward compat confirmed |
| Service B | PROVEN | v1 tokens, grace period confirmed |
| Service C | PROVEN (day 20) | v2 tokens, opted-in late |
| Service D | PROVEN (day 22) | v1 tokens, pre-existing test issue fixed first |

### Timeline

```
Day 0:  Library published → all services flagged SUSPECT (transition mechanic)
Day 3:  Service A re-verified ✓
Day 5:  Service B re-verified ✓
Day 8:  Service D discovered BLOCKED — test suite broken (unrelated cause)
Day 20: Service C re-verified ✓
Day 22: Service D fixed tests, re-verified ✓
Day 30: Grace period expired, v1 decommissioned
```

### Bonus finding: Service D

Service D's test suite was broken before the migration. The migration didn't break it — it exposed it. When the transition mechanic flagged Service D as SUSPECT, re-verification revealed a pre-existing correctness gap.

**Sanity reconciliation caught rot that predated the change.** This is the system working.

### Post-migration verification

| ID | Path | Mechanism | Degradation signal |
|----|------|-----------|-------------------|
| VP-30 | No service accepts v1 tokens after grace period | Regression test: v1 token → 401 | Alert if v1 tokens seen in production after day 30 |

---

## Entry 004 — Dark Mode

**Boxes to cover:** B1 (reduced brightness), B3 (persistent preference)

### Verification paths added

| ID | Path | Mechanism | Degradation signal | Boxes |
|----|------|-----------|-------------------|-------|
| VP-40 | Toggle switches modes, preference persists | E2E: toggle, close, reopen, assert mode | Monitor localStorage clear events | B3 |
| VP-41 | 12 primary surfaces correct in reduced-brightness | Screenshot diffing (12 surfaces, approved baselines) | Visual regression CI on every deploy | B1 |
| VP-42 | Non-tokenized areas meet WCAG AA in reduced brightness | Automated contrast ratio check on overlay'd elements | New hardcoded colors bypass overlay | B1 |
| VP-43 | No regression in light mode | Existing visual regression suite | Existing monitors | — |

### Known coverage gap

VP-42 has a degradation risk: if engineers add new hardcoded colors (bypassing the 12 CSS custom properties), those colors won't be covered by the overlay. This gap closes when B4 (design token system) lands.

**QA documents the gap explicitly.** It's not a failure — it's an honest limitation of the v1 scope. The gap is tracked, not hidden.

---

## Entry 005 — Ghost Feature Removal

### Proof registry failure exposed

QA had a verification path for the PDF export feature:

| ID | Path | Mechanism | Degradation signal | Status |
|----|------|-----------|-------------------|--------|
| VP-99 | Export to PDF generates valid PDF | Unit test with **mocked** PDF library | **None** | **FALSE PROOF** |

The mock passes forever. The real library died 8 months ago. QA's registry said "proven" for a feature that was silently broken.

**This is a QA-level failure.** The proof mechanism was disconnected from reality. The degradation signal was missing.

### Verification paths removed

| ID | Path | Reason |
|----|------|--------|
| VP-99 | Export to PDF | Feature removed from all inventories |

### Systemic rule added

**No mock-only proofs for external dependencies.** Every mocked test must have either:

1. A companion integration test that hits the real dependency, **OR**
2. A production degradation signal that fires when the dependency changes or dies

A mock that passes while the real dependency is dead is not a proof. It's a proof-shaped lie.

---

## Entry 006 — Order Service Rewrite

### Transition mechanic fires

Engineer's inventory changed (Python → Go). QA is auto-notified. All 47 verification paths for order processing must be re-run against the new implementation.

### Re-verification

| Verification paths | Count | Result |
|-------------------|-------|--------|
| VP-01 through VP-47 | 47 | ALL PASS |

No paths added. No paths removed. No paths modified. The verification paths test **what** the service does, not **how** it's implemented. The "what" didn't change.

**This is proof portability.** Good verification paths survive implementation rewrites because they test boxes, not code.

### Performance observation

The Go service is 4x faster and uses 6x less memory. QA doesn't care about this — it's not a box. But QA notes that all timing-sensitive paths (B3: confirmation <2s) now pass with larger margins.

---

## Proof registry integrity rules

| Rule | Rationale | Source |
|------|-----------|--------|
| No match without a verification path | A claimed match with no proof is not a match | Constitution |
| No path without a mechanism | A verification path with no way to execute it is theater | Constitution |
| No mechanism without a degradation signal | A test that can't tell you when it's stale is a time bomb | Entry 005 |
| No mock-only proofs for external deps | Mocks survive dependency death — they lie by default | Entry 005 |
| Verification paths test boxes, not code | Paths must survive implementation rewrites | Entry 006 |
| QA reads the customer's story, not just boxes | The story reveals how things actually break | Entry 002 (VP-14) |
