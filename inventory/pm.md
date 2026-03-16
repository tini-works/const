# Product Registry

What we've committed to, where it came from, and whether we can prove it's delivered.

**Proven: 10/11 (91%)** | Deferred: 1 | Roadmap: 1

---

## Active Requirements

| ID | What | Why (source) | Who received it | Proven? |
|----|------|-------------|-----------------|---------|
| REQ-101 | Returning patient data pre-filled at check-in | Patient feedback: "I already told you last time" | Design | Yes — SCR-01 shipped |
| REQ-102 | Allergies and insurance persist across visits | Same patient feedback | Engineer | Yes — FLW-02 live |
| REQ-103 | Confirm-not-reenter flow for returning patients | Same patient feedback | Design | Yes — SCR-01 confirm step |
| REQ-104 | Stale allergy re-confirmation (>6mo) | Engineer raised clinical safety concern | Design | Yes — SCR-03 shipped |
| REQ-201 | Payment failure must be visible to customer | Support ticket spike: "nothing happened" | Design | Yes — SCR-10..12 shipped |
| REQ-202 | Actionable failure reason (categorized, not raw) | Support tickets + Design negotiation | Engineer | Yes — error taxonomy live |
| REQ-203 | Recovery without restarting checkout | Support tickets | Design | Yes — state machine updated |
| REQ-204 | Idempotent payment processing | Engineer caught from customer story: "tried 3 times" | Engineer | Yes — idempotency key live |
| REQ-301 | Backward-compatible auth migration (JWT v1→v2) | Security mandate, 30-day deadline | Engineer | Yes — migration complete |
| REQ-302 | No code changes for auth consumers beyond version bump | Downstream team expectation | Engineer | Yes — API unchanged |
| REQ-303 | Per-service rollback for auth | Risk mitigation | Engineer + DevOps | Yes — config flag rollback |
| REQ-401 | Low-light comfort viewing | Usage data: 40% sessions after 8 PM | Design | Yes — reduced brightness shipped |
| REQ-402 | Full-screen dark mode coverage | UX principle: partial = jarring | Design | **Deferred** — needs design tokens |
| REQ-403 | Persistent viewing preference (cross-device) | Standard expectation | Engineer | Yes — localStorage + API sync |
| REQ-404 | Design token system | Design discovered 200+ hardcoded colors | Engineer | **Roadmap** |

## Closed / Removed

| ID | What | Why removed | Date |
|----|------|-------------|------|
| REQ-XX | Monthly report PDF export | Workflow replaced 18mo ago, 0 users, dependency dead | Found in sanity check |
| REQ-304..306 | Auth migration dual-mode, opt-in, grace period | Migration complete, v1 decommissioned | Day 30 post-migration |

## Active Contracts (boxes we've committed to)

These are promises PM has made — either to downstream verticals or accepted from them. Breaking a contract means the requirement goes unproven.

| Contract | With | What PM promised or accepted |
|----------|------|------------------------------|
| Check-in data pre-fill | Design | Pre-filled + editable, changes flagged for staff review |
| Confirm-not-reenter | Design | Confirm step replaces intake for returning patients |
| Allergy staleness guard | Engineer (accepted) | If >6mo stale, force re-confirmation — clinical safety |
| Payment error categorization | Design | Card problem / temp issue / contact bank — not raw errors |
| Cart preservation on error | Design (accepted) | Error state must not lose cart or shipping info |
| Idempotent payments | Engineer (accepted) | No duplicate charges on rapid retry |
| Auth backward compat | Engineer | Migration window with dual-mode validation |
| Auth consumer zero-change | Engineer | No code changes beyond version bump |
| Reduced brightness v1 | Design | Comfort viewing for low-light, 2-week scope |

## What PM watches daily

1. **Is every requirement still alive?** Kill it if the source dried up (see: PDF export — nobody needed it, we carried dead weight for 14 months).
2. **Does every requirement have a downstream match?** If Design or Engineer hasn't picked it up, the requirement is a wish, not a commitment.
3. **Are contracts still holding?** If a downstream vertical changed something, did our contract survive? If not, the requirement is suspect until re-verified.
