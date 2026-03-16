# PM Inventory — 001 Patient Check-In

**Source:** Patient feedback — "I already told you last time."

## Requirements

| ID | Requirement | External source | Downstream match | Status |
|----|-------------|----------------|-----------------|--------|
| REQ-101 | Returning patient data pre-filled at check-in | Patient feedback | Design → SCR-01 | PROVEN |
| REQ-102 | Allergies and insurance persist across visits | Patient feedback | Engineer → FLW-02 | PROVEN |
| REQ-103 | Confirm-not-reenter flow | Patient feedback | Design → SCR-01, B4 | PROVEN |
| REQ-104 | Stale allergy re-confirmation (>6mo) | Engineer (upward box B5) | Design → SCR-03 | PROVEN |

## Boxes

| Box | Direction | Content | Negotiation notes | Status |
|-----|-----------|---------|-------------------|--------|
| B1 | PM → Design | Pre-filled + editable, changes flagged for staff | Revised: Design asked "editable or locked?" | PROVEN |
| B2 | PM → Design | Data persistence across visits | Accepted as-is | PROVEN |
| B3 | PM → Design | Confirm, not re-enter | Accepted as-is | PROVEN |
| B4 | Design → PM | Confirm step replaces intake for returning patients | Originated by Design | PROVEN |
| B5 | Engineer → PM | Allergy staleness guard (>6mo → force re-confirm) | Originated by Engineer — clinical safety | PROVEN |

## Observations

- Engineer surfaced B5 upward. PM accepted it because patient safety is an external concern PM faces. PM doesn't only push requirements down — it recognizes when downstream verticals discover something the outside world demands.
- 1 customer sentence → 4 requirements, 5 boxes.
