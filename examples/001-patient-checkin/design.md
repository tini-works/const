# Design Inventory — 001 Patient Check-In

**Boxes received:** B1 (pre-filled + editable), B2 (persistence), B3 (confirm flow), B4 (confirm step), B5 (allergy staleness)

## Screens

| ID | Screen | Regions | Matches |
|----|--------|---------|---------|
| SCR-01 | "Welcome Back" | Pre-filled fields, edit toggles, confirm button | B1, B3, B4 |
| SCR-02 | "Staff Review Queue" | Flagged-change list for receptionist review | B1 |
| SCR-03 | "Allergy Re-confirmation" | Forced re-entry for stale allergy data | B5 |

## State Machine

```
New Patient → Full Intake → Ready

Returning Patient → Confirm Info →
    (allergies stale >6mo?) → Allergy Re-confirmation → back to Confirm Info
    (edits made?) → Staff Review Queue → Ready
    (no edits) → Ready
```

**Hanging state check:** Every path terminates at Ready. No dead ends.

## Negotiation contributions

- Pushed back on B1: "editable or locked?" — produced better box (pre-filled + editable + flagged)
- Originated B4: confirm step replaces intake form for returning patients
- Accepted B5 from Engineer: added SCR-03 and conditional branch in state machine
