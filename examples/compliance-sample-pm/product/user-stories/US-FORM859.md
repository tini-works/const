## US-FORM859 — The Vertragssoftware must provide a patient-specific FaV PNP report (Befundbericht...

| Field | Value |
|-------|-------|
| **ID** | US-FORM859 |
| **Traced from** | [FORM859](../compliances/SV/FORM859.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E4: Form Generation](../epics/E4-form-generation.md) |
| **Data Entity** | FRM, PAT, DX |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a patient-specific FaV PNP report (Befundbericht FaV - PNP) for printing, containing at minimum: patient master data and diagnoses, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a FaV PNP patient, when the Befundbericht is generated, then it contains at minimum: patient master data and diagnoses

### Actual Acceptance Criteria

**Status: Partially implemented**

1. The `FormAPP.GetForm` endpoint can retrieve FaV specialty report forms, and `FormAPP.GetIcdForm` returns ICD codes per contract
2. The `FormAPP.Print` endpoint generates the Befundbericht PDF with patient master data and diagnoses
3. No dedicated PNP-specific (`Befundbericht FaV - PNP`) endpoint exists -- the generic form infrastructure handles it via form configuration, and the minimum content (patient master data, diagnoses) is supported through form field mapping on the client side
