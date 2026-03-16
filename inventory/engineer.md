# Engineer Inventory — Faces the System

Translates design into a working system.

**Contains:** System design artifacts (architecture, data models, APIs). Flows (sequences matching upstream asks). Code (traceable to flows).

**Proven means:** Every flow demonstrates a match against boxes from upstream. Code implements what flows describe. Tests verify what code implements.

---

## Entry 001 — Patient Check-In

**Boxes to match:** B1 (pre-filled + editable), B2 (persistence), B3 (confirm flow), B4 (confirm step), B5 (allergy staleness — originated here)

### Flows added

| ID | Flow | Matches |
|----|------|---------|
| FLW-01 | Check-in scan → lookup patient by MRN → fetch last-visit snapshot | B1, B4 |
| FLW-02 | Fetch demographics (HIS Module A) + fetch allergies (HIS Module B) | B2 |
| FLW-03 | Diff current vs last-visit → populate form → flag changes | B1, B3 |
| FLW-04 | Allergy staleness check (>6mo → force re-confirm) | B5 |

### System design added

| Item | Detail |
|------|--------|
| Two-source data fetch | Demographics and allergies live in separate HIS modules — two API calls |
| Staleness threshold | 6-month cutoff on allergy records |

### Box originated upward

**B5** — Engineer discovered that HIS stores allergies separately, with potential staleness. A returning patient confirming stale allergy data is a clinical safety risk. Engineer surfaced this as a box to PM and Design.

This is the system talking back. Engineer's job isn't just to implement — it's to discover constraints the upstream verticals can't see.

---

## Entry 002 — Silent Checkout Failure

**Boxes to match:** B1 (failure visible), B2 (categorized reason), B3 (recovery path), B4 (cart preserved), B5 (parse body), B6 (correlation ID), B7 (idempotency)

### Root cause

The payment gateway returns HTTP 200 with an error in the response body. Frontend only checks HTTP status code. That's why "nothing happens."

### Flows added

| ID | Flow | Matches |
|----|------|---------|
| FLW-10 | Checkout → gateway call → parse response (status + body) → categorize → UI | B1, B3, B4, B5 |
| FLW-11 | Error categorization: card_expired \| insufficient_funds \| temp_decline \| unknown | B2 |
| FLW-12 | Failed attempt logging with correlation ID | B6 |
| FLW-13 | Idempotency: per-session key, gateway deduplicates | B7 |

### System design added

| Item | Detail |
|------|--------|
| Payment error taxonomy | 4 categories → 3 UI variants |
| Gateway client rewrite | Response body parsing, not just HTTP status |
| Idempotency key | Generated per checkout session, passed to gateway |

### Boxes originated upward

**B5** — HTTP 200 with error body is a parsing problem, not a UI problem. PM and Design can't see this.

**B6** — Support needs correlation IDs to debug customer complaints. Without logging, support is blind.

**B7** — From the customer's words: "I tried three times." If three clicks create three charges, that's fraud-adjacent. The customer's story, carried faithfully by PM, let Engineer spot this.

---

## Entry 003 — Auth Library Migration

**Boxes to match:** B1 (backward compat), B2 (no code changes), B3 (per-service rollback), B4 (dual-mode validation), B5 (opt-in issuance), B6 (grace period)

### Flows added

| ID | Flow | Matches |
|----|------|---------|
| FLW-30 | Token validation: try v2 → fallback v1 → reject | B1, B4 |
| FLW-31 | Token issuance: check service config → v2 if opted-in, else v1 | B3, B5 |
| FLW-32 | Grace period: v1 tokens valid 30 days post-migration-start | B1, B6 |

### System design added

| Item | Detail |
|------|--------|
| Auth library v2.0 | Dual-mode validator |
| Service config flag | `auth.token_version = v1 \| v2` |
| v1 key retention | Signing key kept for grace period |

### System design modified (post-grace)

| Item | Before | After |
|------|--------|-------|
| Auth library | v2.0 (dual-mode) | v2.1 (v2-only, v1 code removed) |
| v1 signing key | Retained | Decommissioned |
| FLW-32 | Active | Archived |

### Transition mechanic

When the library changed, every dependent service was flagged SUSPECT in their own inventories. Engineer published the library; the propagation was automatic. Each service team re-verified independently. This is inventory dependency tracking — no spreadsheet, no Slack ping.

---

## Entry 004 — Dark Mode

**Boxes to match:** B1 (reduced brightness), B3 (persistent preference)

**Not matching:** B2 (full dark mode — deferred), B4 (design tokens — roadmap)

### Flows added

| ID | Flow | Matches |
|----|------|---------|
| FLW-40 | CSS custom properties for 12 most-used color values | B1 |
| FLW-41 | Media query `prefers-color-scheme: dark` + manual toggle | B1 |
| FLW-42 | Opacity overlay (0.85 filter) for non-tokenized surfaces | B1 |
| FLW-43 | Preference: localStorage (instant) + profile API sync (cross-device) | B3 |

### System design added

| Item | Detail |
|------|--------|
| 12 CSS custom properties | Primary bg, text, borders, accent, etc. |
| Opacity overlay | Blunt instrument for 200+ hardcoded colors |
| Toggle state | localStorage + API sync |

### Explicit non-action

Engineer does NOT refactor the 200+ hardcoded colors. That's B2/B4 (deferred). Matching the current boxes means: 12 tokens + overlay + toggle. The overlay is ugly in the code. The boxes match. That's the deal.

Freedom means matching what's asked, not gold-plating what isn't.

---

## Entry 005 — Ghost Feature Removal

**Source:** Routine sanity check.

### Discovery sequence

1. **Staleness:** FLW-99 (Export to PDF) untouched for 14 months.
2. **Correctness:** Ran it manually. PDF library deprecated 8 months ago. Returns HTTP 200 + empty body. Test passes because it mocks the library.
3. **Coverage:** 3 invocations in 90 days, all by one intern, all 0-byte downloads.

### Flows removed

| ID | Flow | Reason |
|----|------|--------|
| FLW-99 | Export to PDF — monthly report generation | REMOVED: stale, broken, unused |

### Code removed

- PDF export endpoint, controller, service layer
- PDF library removed from package manifest

### Systemic lesson

The test mocked the dependency. The mock passes forever. The real dependency died 8 months ago. **A passing mock is not a proof.** It's a lie that looks like a proof.

Engineer adds a staleness rule: any flow untouched >6 months gets a manual correctness check during reconciliation.

---

## Entry 006 — Order Service Rewrite

**Boxes to match:** B1 (status queryable <5s), B2 (500 concurrent orders), B3 (confirmation <2s), B4 (99.9% uptime), B5 (P95 <500ms)

### What changed

| Aspect | Before | After |
|--------|--------|-------|
| Language | Python | Go |
| Architecture | Monolith (order module) | Microservice |
| P95 latency | 380ms | 92ms |
| Memory | 2.1GB | 340MB |
| Cold start | 12s | 0.8s |
| API contract | v1 | v1 (unchanged) |
| Boxes | All matched | All matched (better) |

### What did NOT change

- API endpoints (same paths, same request/response shapes)
- Event emissions (same events, same payloads)
- Boxes (all 5 still match — implementation changed, contracts didn't)

### Freedom exercised

No proposal. No RFC. No approval. No notification to PM or Design.

QA was auto-notified (transition mechanic — implementation changed). Re-ran 47 verification paths. All passed.

DevOps was auto-notified (deployment pipeline changed). Verified operational boxes. All exceeded SLA.

PM and Design found out at standup. Didn't care. Their boxes still matched.

**Freedom is the reward for maintaining proven matches.**

---

## Sanity checklist (daily reconciliation)

Run across all flows and system design:

| Dimension | Question | Action if yes |
|-----------|----------|---------------|
| Staleness | Has this flow been untouched >6 months? | Manual correctness check (see Entry 005) |
| Correctness | Does the flow still work when run against real dependencies (not mocks)? | Fix or remove |
| Coverage | Are there Design screens or PM requirements with no matching flow? | Add flows |

### Integrity rules

1. **Every flow must trace to an upstream box.** No orphan flows.
2. **Tests must hit real dependencies** or have a companion degradation signal. Mocked-only proofs are not proofs.
3. **API contracts are the boundary.** Change implementation freely. Change contracts = renegotiate boxes.
