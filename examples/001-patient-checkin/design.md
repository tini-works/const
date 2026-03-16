# Screen Catalog — Patient Check-In

**Proven: 3/3 screens (100%)** | No hanging states

---

## Screens

| ID | Screen | Key regions | Traces to |
|----|--------|-------------|-----------|
| SCR-01 | Welcome Back (returning patient) | Pre-filled demographic fields, edit toggles, confirm button | REQ-101, REQ-103 |
| SCR-02 | Staff Review Queue | Flagged-change list for receptionist review | REQ-101 |
| SCR-03 | Allergy Re-confirmation | Forced allergy re-entry when data >6mo stale | REQ-104 |

## User Flow

```
Is returning patient?
  No  → Full Intake Form → Ready
  Yes → Welcome Back (SCR-01) →
          Allergies stale (>6mo)? → Allergy Re-confirm (SCR-03) → back to SCR-01
          Edits made? → Staff Review Queue (SCR-02) → Ready
          No edits → Ready
```

Every path terminates at Ready. No dead ends.

## Negotiations

| With | What Design pushed back on | Result |
|------|---------------------------|--------|
| PM | "Pre-filled" — editable or locked? | Editable + change flagging for staff. Better than either extreme alone. |
| PM | Confirm step for returning patients | Originated by Design — returning patients shouldn't see an intake form at all |
| Engineer | Allergy staleness guard (>6mo) | Accepted — added SCR-03 and conditional branch in flow |

Design originated the confirm step (SCR-01 replaces intake form). PM didn't ask for it — Design identified that a pre-filled intake form is still an intake form, and returning patients deserve a different experience.
