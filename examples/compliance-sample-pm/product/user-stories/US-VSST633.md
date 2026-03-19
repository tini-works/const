## US-VSST633 — Hilfsmittel prescriptions for contract participants must include at minimum: quantity,...

| Field | Value |
|-------|-------|
| **ID** | US-VSST633 |
| **Traced from** | [VSST633](../compliances/SV/VSST633.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, DX, FRM |

### User Story

As a practice staff, I want hilfsmittel prescriptions for contract participants include at minimum: quantity, 7- or 10-digit Positionsnummer, period, product type/name/free text, and diagnosis; if elements are missing, the system warn the user, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Hilfsmittel prescription for a participant, when the form is printed, then it contains quantity, Positionsnummer, period, product description, and diagnosis
2. Given missing elements, then a warning is shown

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/himi`, `api/form`

1. **HIMI prescription data** -- The `himi` `Prescribe` method creates Hilfsmittel prescriptions. The `Print` method generates prescription output.
2. **Gap: Minimum field validation** -- The specific validation that Hilfsmittel prescriptions contain quantity, Positionsnummer, period, product description, and diagnosis with warnings for missing elements needs verification in the prescription validation logic.
