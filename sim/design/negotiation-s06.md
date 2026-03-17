# Design Negotiation — Story 06 (Medication List Mandate)

## Context

Compliance requirement with hard Q3 deadline. State Health Board mandates medication list collection at every check-in visit. This adds a new data category with unique characteristics.

## Boxes Received from PM

| Box | Verdict | Notes |
|-----|---------|-------|
| BOX-22: Medication list collected at every check-in | **Accepted with design specificity** | "Always expanded, never skippable" — I accept this. The medications section on S3P will behave differently from other sections: it cannot be collapsed, it cannot show a "Still correct" one-tap, and it requires explicit confirmation action. This is a deliberate friction point mandated by compliance. |
| BOX-23: Variable-length structured data | **Accepted — this requires a new interaction pattern** | Address is a fixed form. Insurance is a fixed form. Medications are a list. The UI pattern is fundamentally different: add rows, remove rows, edit rows. I'm designing a list-management component that doesn't exist in the current S3P design. |
| BOX-24: Medication confirmation is auditable | **Accepted — no new screen needed** | Audit is a data/backend concern. The only design implication: the confirmation action must be unambiguous. The patient taps a specific "I confirm my medication list is current" button, not just scrolls past it. This creates a clean audit event. |
| BOX-25: Integrates with existing check-in flow | **Accepted** | Medications become a section in S3P. I'm placing it AFTER allergies (natural clinical grouping) and BEFORE the "Done" button. It's the last substantive section, because it requires the most attention. |

## Boxes I'm Adding

### BOX-D13: Medication section has explicit confirmation that cannot be conflated with section scrolling

Unlike other sections where "Still correct" is a one-tap action, medications require the patient to actively affirm: "My current medications are: [list]. I confirm this is accurate." This is not a scroll-past — it's a deliberate action with compliance implications.

**Why this matters:** BOX-24 requires auditable proof that the patient confirmed their medications. If the confirmation is a subtle tap easily confused with "scrolled past," the audit trail is meaningless. The compliance proof depends on the UX being unambiguous.

**Design:** A medications section with a two-step confirmation:
1. Review the list (add/remove/edit as needed)
2. Tap "I confirm this medication list is current" — a distinct, labeled action

### BOX-D14: Empty medication list is a valid state, explicitly confirmed

A patient on zero medications must still confirm "I am not currently taking any medications." This is not a skip — it's an affirmative statement. The audit trail must distinguish between "patient has no medications" (confirmed) and "medication data was not collected" (not confirmed).

**Why PM almost covered this:** BOX-23 says "No medications is a valid, confirmable state." I'm making the design concrete: an empty list shows "No medications listed" with a confirm button AND an "Add a medication" button. The patient explicitly affirms or adds.

## Design Changes to S3P

The medications section is the most complex section in the check-in flow. Here's the detailed design:

### Medications Section on S3P

**Header:** "Your Medications" (always expanded, amber "Confirm every visit" badge)

**If medications on file:**
```
Your Medications                    [Confirm every visit]
----------------------------------------
Lisinopril 10mg — Once daily           [Edit] [Remove]
Metformin 500mg — Twice daily          [Edit] [Remove]
Atorvastatin 20mg — Once daily         [Edit] [Remove]

                                  [+ Add a medication]

[ I confirm this medication list is current ]
```

**If no medications on file:**
```
Your Medications                    [Confirm every visit]
----------------------------------------
No medications currently listed.

Are you taking any medications?

[No, I am not taking any medications]   [+ Add a medication]
```

**Adding a medication:**
```
Drug name:     [________________]
Dosage:        [________________]
Frequency:     [Daily ▼]
Prescriber:    [________________] (optional)

[Save]  [Cancel]
```

**Removing a medication:**
- Tap "Remove" -> confirmation: "Remove Lisinopril 10mg from your list?" [Remove] [Cancel]
- Removed medications are shown as struck-through until final confirmation (recoverable within the session)

### Interaction Rules

1. Medications section is ALWAYS expanded. No collapse. No "Still correct" shortcut.
2. The "I confirm" button only activates after the patient has scrolled through the full list (if list > screen height) or after 3 seconds of visibility (if list fits on screen). This prevents accidental confirmation.
3. If the patient adds, removes, or edits any medication, the "I confirm" button text changes to "I confirm these changes to my medication list."
4. The "All Confirmed" master button on S3P cannot activate until the medications confirmation is complete.

## Push-back to PM

1. **This section adds 30-60 seconds to check-in time.** PM and the clinic administrator should understand: every check-in now includes a mandatory medication review. For patients on multiple medications, this is not a quick tap. For the Monday morning crush (S-09), this makes things worse. S-03 (mobile pre-check-in) becomes even more important as a mitigation.

2. **Drug name entry is error-prone.** Patients misspell medication names. "Lisinopril" vs "Lisinipril" vs "that blood pressure pill." Should we offer autocomplete from a drug database? This is a significant engineering dependency. For Q3, I recommend free-text entry with a note that autocomplete is a future enhancement. PM should decide.

3. **Medication interactions are explicitly OUT OF SCOPE for Q3.** The mandate says "collect and display." It does not say "analyze for interactions." If PM wants interaction checking, that's a separate story with clinical safety implications. I'm flagging it now so nobody assumes it's included.
