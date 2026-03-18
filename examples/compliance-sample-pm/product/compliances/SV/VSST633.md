## VSST633 — Hilfsmittel prescriptions for contract participants must include at minimum: quantity,...

| Field | Value |
|-------|-------|
| **ID** | VSST633 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST633](../../user-stories/US-VSST633.md) |

### Requirement

Hilfsmittel prescriptions for contract participants must include at minimum: quantity, 7- or 10-digit Positionsnummer, period, product type/name/free text, and diagnosis; if elements are missing, the system must warn the user

### Acceptance Criteria

1. Given a Hilfsmittel prescription for a participant, when the form is printed, then it contains quantity, Positionsnummer, period, product description, and diagnosis
2. Given missing elements, then a warning is shown
