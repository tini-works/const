# Product Registry — Patient Check-In

**Source:** Patient feedback — "I already told you last time."

**Proven: 4/4 (100%)**

---

## Active Requirements

| ID | What | Why (source) | Who received it | Proven? |
|----|------|-------------|-----------------|---------|
| REQ-101 | Returning patient data pre-filled at check-in | Patient feedback | Design | Yes — SCR-01 shipped |
| REQ-102 | Allergies and insurance persist across visits | Patient feedback | Engineer | Yes — FLW-02 live |
| REQ-103 | Confirm-not-reenter flow for returning patients | Patient feedback | Design | Yes — SCR-01 confirm step |
| REQ-104 | Stale allergy re-confirmation (>6mo) | Engineer raised clinical safety concern | Design | Yes — SCR-03 shipped |

One patient sentence. Four requirements. One of them (REQ-104) didn't come from the patient at all — Engineer discovered it during implementation and surfaced it because patient safety is an external concern PM faces.

## Active Contracts

Promises PM has made — either to downstream verticals or accepted from them.

| Contract | With | What PM promised or accepted |
|----------|------|------------------------------|
| Check-in data pre-fill | Design | Pre-filled + editable, changes flagged for staff review |
| Data persistence | Engineer | Allergies and insurance available from prior visits |
| Confirm-not-reenter | Design | Confirm step replaces intake for returning patients |
| Allergy staleness guard | Engineer (accepted) | If >6mo stale, force re-confirmation — clinical safety |

## What PM watches

1. **Is every requirement still alive?** The patient's complaint is real and ongoing. All four requirements have active sources.
2. **Does every requirement have a downstream match?** All four are picked up — Design has SCR-01 and SCR-03, Engineer has FLW-01..04.
3. **Are contracts holding?** The "editable or locked?" question from Design refined the pre-fill contract. The allergy staleness guard from Engineer added a contract PM didn't anticipate but accepted because patient safety is PM's external facing concern.
