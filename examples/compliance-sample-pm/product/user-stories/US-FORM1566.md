## US-FORM1566 — The user must be able to fill and print a...

| Field | Value |
|-------|-------|
| **ID** | US-FORM1566 |
| **Traced from** | [FORM1566](../compliances/SV/FORM1566.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT, TE |

### User Story

As a practice staff (MFA), I want the user is able to fill and print a Teilnahmeerklaerung (participation declaration) per AKA-Basisdatei Volldruck rules; the form is not transmitted but remains with the practice and the patient, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a patient, when the Teilnahmeerklaerung is opened, then it can be filled and printed as Volldruck per AKA template; the form is stored locally, not transmitted

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves the Teilnahmeerklaerung form (multiple variants defined as FormName constants per AKA-Basisdatei, e.g., `Versichertenteilnahmeerklaerung_Online_Variante_A_V12`, `AWH_01_Versichertenteilnahmeerklaerung_Volldruck_V13`, and many insurance-specific variants)
2. The `FormAPP.Print` endpoint generates Volldruck PDF output per AKA template
3. The form is stored locally (not transmitted) -- `FormAPP.PrescribeV2` saves to patient timeline without external transmission
