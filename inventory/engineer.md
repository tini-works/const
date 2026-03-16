# System Registry

Architecture, APIs, data flows, services. What we've built, how it connects, and whether it still works.

**Proven: 14/14 flows (100%)** | 0 suspect | Last sanity check: today

---

## Service Catalog

| Service | Stack | Status | SLA |
|---------|-------|--------|-----|
| Order Processing | Go 1.22 (microservice) | Live | 99.9% uptime, P95 <500ms |
| Check-In Service | — | Live | HIS API <2s response |
| Payment Gateway Client | — | Live | Canary deployed, feature-flagged |
| Auth Library | v2.1 (v2-only) | Live | All services migrated |

## API Contracts

| API | Contract | Consumers | Last verified |
|-----|----------|-----------|--------------|
| Order Processing API | REST v1 — same endpoints, same shapes post-rewrite | Frontend, Support Portal, Fulfillment | Post-rewrite (Go) |
| Check-In API | Patient lookup by MRN, demographics + allergies fetch | Reception Kiosk, Staff Portal | Post-implementation |
| Payment Gateway | Response body parsing (status + body-level error codes) | Checkout Frontend | Post-rewrite |
| Auth Token Validation | JWT v2, single-mode | All services (A, B, C, D) | Day 30 post-migration |

## Active Flows

### Check-In

| ID | Flow | What it proves |
|----|------|---------------|
| FLW-01 | Check-in scan → lookup patient by MRN → fetch last-visit snapshot | Returning patient detected, data retrieved |
| FLW-02 | Fetch demographics (HIS Module A) + allergies (HIS Module B) | Data persists across visits, two-source fetch |
| FLW-03 | Diff current vs last-visit → populate form → flag changes | Pre-fill works, changes visible to staff |
| FLW-04 | Allergy staleness check (>6mo → force re-confirm) | Clinical safety — stale data caught |

### Payment

| ID | Flow | What it proves |
|----|------|---------------|
| FLW-10 | Checkout → gateway call → parse response (status + body) → categorize → UI | Failure visible, categorized, recoverable |
| FLW-11 | Error categorization: card_expired \| insufficient_funds \| temp_decline \| unknown | Customer gets actionable message |
| FLW-12 | Failed attempt logging with correlation ID | Support can trace complaints |
| FLW-13 | Idempotency: per-session key, gateway deduplicates | No duplicate charges on retry |

### Auth (post-migration steady state)

| ID | Flow | What it proves |
|----|------|---------------|
| FLW-30 | Token validation: v2 only | All services on v2 |
| FLW-31 | Token issuance: v2 only | v1 decommissioned |

### Appearance

| ID | Flow | What it proves |
|----|------|---------------|
| FLW-40 | CSS custom properties for 12 color values | Primary surfaces switch cleanly |
| FLW-41 | prefers-color-scheme media query + manual toggle | Auto-detect + user override |
| FLW-42 | Opacity overlay for non-tokenized surfaces | Coverage for 200+ hardcoded colors |
| FLW-43 | localStorage + profile API sync | Preference persists cross-session + cross-device |

## Archived / Removed

| ID | Flow | Why |
|----|------|-----|
| FLW-99 | Export to PDF — monthly report | Dep dead 8mo, 0 users, PM closed requirement |
| FLW-32 | Auth grace period (v1 valid 30 days) | Grace expired, v1 decommissioned |

## Decisions we made

| Decision | Why | Impact |
|----------|-----|--------|
| Two-source HIS fetch (demographics + allergies) | HIS stores them in separate modules | Added FLW-04 staleness guard |
| Parse gateway response body, not just HTTP status | Gateway returns 200 with error in body | Root cause of silent checkout failure |
| Per-session idempotency key | Customer said "I tried 3 times" | Prevents duplicate charges |
| Python → Go rewrite (order processing) | Performance + resource efficiency | P95: 380ms → 92ms, Memory: 2.1GB → 340MB |
| Opacity overlay for non-token colors | Full token system is months away | Ugly but matches the ask |

## What Engineering protects daily

1. **Every flow must still work against real dependencies.** Not mocks. We carried a dead PDF export for 8 months because the test mocked the library. The mock passed while the real thing returned empty. Never again.
2. **API contracts are the boundary.** We rewrote order processing from Python to Go without asking anyone. That's fine — contracts held. If we'd changed the API shape, every consumer would need to re-verify. Contract changes are renegotiations.
3. **Flows older than 6 months get a manual check.** Staleness is the first warning. Run it for real. If it's broken, check if anyone needs it. If not, kill it.
