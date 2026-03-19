## US-VSST530 — The Vertragssoftware must prevent transmission of Hilfsmittelverordnungen (medical device prescriptions)

| Field | Value |
|-------|-------|
| **ID** | US-VSST530 |
| **Traced from** | [VSST530](../compliances/SV/VSST530.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware prevent transmission of Hilfsmittelverordnungen (medical device prescriptions), so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a Hilfsmittelverordnung, when prescription data transmission runs, then Hilfsmittel prescriptions are excluded from the transmission

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/himi`, `api/billing`, `api/pvs_billing`

1. **Hilfsmittel management** -- The `himi` API package implements Hilfsmittelverordnung (HIMI) management with search, prescribe, and print functionality.
2. **Transmission exclusion** -- The billing pipeline processes Verordnungsdaten for transmission.
3. **Gap: Explicit HIMI exclusion from transmission** -- While HIMI prescriptions are managed separately from medication prescriptions, the explicit exclusion of Hilfsmittelverordnungen from prescription data transmission needs verification in the billing transmission logic.
