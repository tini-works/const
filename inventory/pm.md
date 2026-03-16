# PM Inventory — Faces Outward

The interface between the outside world and the internal system.

**Contains:** Requirements matched to sources. Boxes sent downstream. Business/compliance alignment.

**Proven means:** Every item traces to an external source and has a matched response in a downstream vertical.

---

## Entry 001 — Patient Check-In

**Source:** Patient feedback session.

> "Every time I visit, the receptionist asks me the same questions."

### Requirements added

| ID | Requirement | Source | Downstream match |
|----|-------------|--------|-----------------|
| REQ-101 | Returning patient data pre-filled at check-in | Patient feedback | Design → SCR-01 |
| REQ-102 | Allergies and insurance persist across visits | Patient feedback | Engineer → FLW-02 |
| REQ-103 | Confirm-not-reenter flow | Patient feedback | Design → SCR-01, B4 |
| REQ-104 | Stale allergy re-confirmation (>6mo) | Engineer (upward box B5) | Design → SCR-03 |

### Boxes negotiated

| Box | Direction | Content | Status |
|-----|-----------|---------|--------|
| B1 | → Design | Pre-filled + editable, changes flagged for staff | PROVEN |
| B2 | → Design | Data persistence across visits | PROVEN |
| B3 | → Design | Confirm, not re-enter | PROVEN |
| B4 | ← Design | Confirm step replaces intake for returning patients | PROVEN |
| B5 | ← Engineer | Allergy staleness guard (>6mo → force re-confirm) | PROVEN |

**Observation:** Engineer surfaced B5 upward. PM accepted it — clinical safety. PM's job isn't just to push requirements down. It's to recognize when a downstream vertical discovers something the outside world (patient safety) demands.

### Proven?

All 4 requirements have matched responses downstream. All 5 boxes resolved. **PROVEN.**

---

## Entry 002 — Silent Checkout Failure

**Source:** Support ticket spike — "I clicked Pay and nothing happened."

> "I hit the pay button, the page just sat there. I tried three times. Then I gave up and bought it somewhere else."

### Requirements added

| ID | Requirement | Source | Downstream match |
|----|-------------|--------|-----------------|
| REQ-201 | Payment failure must be visible to customer | Support tickets | Design → SCR-10..12 |
| REQ-202 | Actionable failure reason (categorized) | Support tickets + Design negotiation | Engineer → FLW-11 |
| REQ-203 | Recovery without restarting checkout | Support tickets | Design → state machine |
| REQ-204 | Idempotent payment processing | Engineer (from customer's words: "tried 3 times") | Engineer → FLW-13 |

### Boxes negotiated

| Box | Direction | Content | Status |
|-----|-----------|---------|--------|
| B1 | → Design | Customer must know payment failed | PROVEN |
| B2 | → Design | Categorized reason (card/temp/bank), not raw error | PROVEN |
| B3 | → Design | Recovery path without restart | PROVEN |
| B4 | ← Design | Error state preserves cart + shipping | PROVEN |
| B5 | ← Engineer | Parse both HTTP status and body error codes | PROVEN |
| B6 | ← Engineer | Correlation ID logging for support | PROVEN |
| B7 | ← Engineer | No duplicate charges on rapid retry | PROVEN |

**Observation:** B7 came from the customer's exact words — "I tried three times." PM's job is to carry the customer's story faithfully enough that downstream verticals can extract boxes from it. If PM had sanitized the story into "payment error handling," the idempotency edge case is invisible.

### Proven?

All 4 requirements matched downstream. All 7 boxes resolved. **PROVEN.**

---

## Entry 003 — Auth Library Migration

**Source:** Security mandate — JWT v1 → v2, 30-day deadline.

**Customer:** Downstream service teams.

> "I don't want my service to break. I don't want to rewrite auth code. I don't want a flag day."

### Requirements added

| ID | Requirement | Source | Downstream match |
|----|-------------|--------|-----------------|
| REQ-301 | Backward-compatible migration window | Security + team safety | Engineer → FLW-30, FLW-32 |
| REQ-302 | No code changes beyond version bump | Downstream team expectation | Engineer → API unchanged |
| REQ-303 | Per-service rollback capability | Risk mitigation | Engineer → FLW-31, DevOps → DEP-32 |
| REQ-304 | Dual-mode validation window | Engineer discovery | Engineer → FLW-30 |
| REQ-305 | Per-service opt-in for v2 issuance | Engineer discovery | Engineer → FLW-31 |
| REQ-306 | 30-day v1 token grace period | Engineer discovery | Engineer → FLW-32 |
| REQ-307 | Service D test suite repair | Discovered during migration | Service D team backlog |

### Boxes negotiated

| Box | Direction | Content | Status |
|-----|-----------|---------|--------|
| B1 | → Engineer | Backward compatibility during transition | PROVEN |
| B2 | → Engineer | No consumer code changes | PROVEN |
| B3 | → Engineer | Per-service rollback | PROVEN |
| B4 | ← Engineer | Dual-mode validation (v2 try, v1 fallback) | PROVEN |
| B5 | ← Engineer | Per-service opt-in for v2 issuance | PROVEN |
| B6 | ← Engineer | v1 valid for 30 days | PROVEN (expired, archived) |

**Observation:** REQ-307 was a bonus. The migration didn't cause Service D's test failure — it exposed a pre-existing rot. PM's inventory grew because sanity reconciliation surfaced something that was already broken. This is the inventory doing its job: correctness checks catch things that were silently wrong.

### Proven?

REQ-301..306 all matched and verified. REQ-307 filed to Service D's backlog. **PROVEN.**

---

## Entry 004 — Dark Mode

**Source:** CEO competitive reaction. No customer story initially.

PM's job: find the story or acknowledge there isn't one.

**Research findings:**
- 12 dark mode requests / 2,000 total (low signal)
- No churn correlation
- 40% of sessions after 8 PM (users work late — real signal)

### Requirements added

| ID | Requirement | Source | Downstream match |
|----|-------------|--------|-----------------|
| REQ-401 | Low-light comfort viewing | Usage data (40% evening sessions) | Design → SCR-40..41 |
| REQ-402 | Full-screen dark mode coverage | UX principle | **DEFERRED** — blocked by missing design tokens |
| REQ-403 | Persistent preference (cross-session, cross-device) | Standard expectation | Engineer → FLW-43 |
| REQ-404 | Design token system as infrastructure | Design discovery | **ROADMAP** |

### Boxes negotiated

| Box | Direction | Content | Status |
|-----|-----------|---------|--------|
| B1 | → Design | Reduced-brightness mode (v1 scope) | PROVEN |
| B2 | → Design | Full dark mode (all screens) | DEFERRED |
| B3 | → Design | Preference persists | PROVEN |
| B4 | → Design/Engineer | Design token system | ROADMAP |

**Observation:** PM grounded the CEO's whim in data, then let Design discover the architectural blocker. The result: a 2-week deliverable (reduced brightness) + a roadmap item (design tokens → full dark mode). The framework didn't say no — it said "here's the honest scope."

### Proven?

REQ-401, REQ-403: PROVEN. REQ-402: DEFERRED. REQ-404: ROADMAP. **Partially proven — deferred items are explicitly tracked, not forgotten.**

---

## Entry 005 — Ghost Feature Removal

**Source:** Engineer's routine sanity check.

No customer request. No ticket. Inventory reconciliation surfaced a dead feature.

### Requirements removed

| ID | Requirement | Source | Action |
|----|-------------|--------|--------|
| REQ-XX | Monthly report PDF export | Original workflow (2 years ago) | **REMOVED** — workflow replaced 18 months ago, zero active users |

**Observation:** PM's inventory shrank. This is healthy. A requirement that traces to a dead workflow and has no active stakeholder is inventory rot. Removing it is as important as adding new items. The warehouse must be reconciled — staleness is a real threat.

### Proven?

Removal is proven by: no active stakeholder, no active workflow, 3 uses in 90 days (all failed, all by one intern). **PROVEN by absence of need.**

---

## Entry 006 — Order Service Rewrite

**Source:** No source. Engineer exercised freedom.

### PM's involvement

**None.** PM was not notified because no PM boxes were affected.

| Box | Content | Before rewrite | After rewrite |
|-----|---------|----------------|---------------|
| B1 | Order status queryable <5s | PROVEN | PROVEN (faster) |
| B2 | 500 concurrent orders | PROVEN | PROVEN (4x headroom) |

PM learned about the rewrite at standup. Response: "Our boxes still match? Great."

**Observation:** Freedom works. PM didn't need to be in the loop because the contract (boxes) was unchanged. PM's inventory didn't change at all. This is the Constitution working as designed — verticals don't micromanage each other's implementation.

---

## Sanity checklist (daily reconciliation)

Run across all requirements:

| Dimension | Question | Action if yes |
|-----------|----------|---------------|
| Staleness | Is this requirement still tied to an active external source? | Remove if source is dead (see Entry 005) |
| Correctness | Does the downstream match still hold? | Flag suspect, trigger re-verification |
| Coverage | Are there customer needs, compliance changes, or business goals not yet captured? | Add new requirements |
