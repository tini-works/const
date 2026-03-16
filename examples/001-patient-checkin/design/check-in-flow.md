# Design — Check-In Flow

The complete path a patient takes from scan to ready.

```
Patient scans card at kiosk
    │
    ├── New patient (no prior visit)
    │       → Full Intake Form → Ready
    │
    └── Returning patient (prior visit found)
            │
            ├── Allergy data stale (>6 months since last update)
            │       → SCR-03: Allergy Re-confirmation
            │           ├── "Still correct" → resets clock → continue
            │           └── "Update" → edit form → save → continue
            │
            └── Allergy data fresh (≤6 months)
                    → SCR-01: Welcome Back (pre-filled)
                        ├── No edits → "Confirm" → Ready
                        └── Edits made → "Confirm" → SCR-02: Staff Review Queue → Ready
```

**Every path terminates at Ready.** No dead ends. No state where a patient is stuck.

## What Design negotiated

| With | What was proposed | What Design pushed back on | What we agreed |
|------|-------------------|---------------------------|----------------|
| PM | "Pre-filled data" | Editable or locked? If locked, patients can't fix errors. If editable without flagging, staff can't catch changes. | Editable with change flagging for staff review |
| PM | "Don't re-enter data" | A pre-filled intake form is still an intake form. | Confirm step replaces intake for returning patients. Design originated this. |
| Engineer | Allergy staleness >6mo is unsafe | — (accepted) | Added SCR-03 and staleness branch before Welcome Back |

## What goes suspect if this changes

- If PM adds new commitments (e.g., medication verification), the flow needs new branches
- If Engineer discovers new data staleness risks, the flow needs new guard screens
- If the check-in kiosk hardware changes (e.g., no touchscreen), all screen interactions need re-design
