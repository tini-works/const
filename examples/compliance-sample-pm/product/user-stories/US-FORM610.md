## US-FORM610 — Muster 52.2 form must be fillable and printable

| Field | Value |
|-------|-------|
| **ID** | US-FORM610 |
| **Traced from** | [FORM610](../compliances/SV/FORM610.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT |

### User Story

As a practice staff (MFA), I want muster 52.2 form is fillable and printable, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given Muster 52.2 selected, when patient data is loaded, then all fields are pre-filled and the form is printable

### Actual Acceptance Criteria

**Status: Implemented**

1. The `FormAPP.GetForm` endpoint retrieves Muster 52.2 (defined as `Muster_52_2_V3` FormName constant) with patient data pre-fill
2. The `FormAPP.Print` and `FormAPP.PrintPlainPdf` endpoints produce printable PDF output of the filled Muster 52.2 form
