## US-FORM588 — The Vertragssoftware must support Blankoformularbedruckung (blank form printing) per KBV...

| Field | Value |
|-------|-------|
| **ID** | US-FORM588 |
| **Traced from** | [FORM588](../compliances/SV/FORM588.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT |

### User Story

As a practice staff (MFA), I want the Vertragssoftware support Blankoformularbedruckung (blank form printing) per KBV specifications for: Muster 2 (hospital referral), Muster 6 (referral), Muster 12 (home nursing), Muster 13 (Heilmittel), and Muster 61 (medical rehabilitation), so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a contract participant, when blank form printing is requested for Muster 2/6/12/13/61, then the form is printed per current KBV Blankoformularbedruckung specifications

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves Muster forms (Muster 2A/2B/2C for hospital referral, Muster 6 for referral, Muster 12A/12B/12C for home nursing, Muster 13 for Heilmittel, Muster 61/61A-D for rehabilitation) -- all defined as `FormName` constants
2. The `FormAPP.Print` and `FormAPP.PrintPlainPdf` endpoints support Blankoformularbedruckung by generating PDF output per KBV specifications
3. The `HeimiApp.Prescribe` endpoint handles Heilmittel (Muster 13) prescription workflows specifically
4. Printer profiles via `PrinterApp.FindPrinterProfileGroupsByFormId` allow form-specific print configuration per KBV Blankoformularbedruckung rules
