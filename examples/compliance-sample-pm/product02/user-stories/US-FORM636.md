## US-FORM636 — The Vertragssoftware must provide a patient-specific FaV cardiology report (Befundbericht...

| Field | Value |
|-------|-------|
| **ID** | US-FORM636 |
| **Traced from** | [FORM636](../compliances/SV/FORM636.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want the Vertragssoftware provide a patient-specific FaV cardiology report (Befundbericht FaV - Kardiologie) for printing, containing at minimum: patient master data, diagnoses, ICD codes, anamnesis, pre-medication, lab values, diagnostic findings, assessment, therapy proposal, and a 'Teilnahme am Facharztvertrag' note, so that forms are generated correctly for submission.

### Acceptance Criteria

1. Given a FaV cardiology patient, when the Befundbericht is generated, then it contains: patient master data, diagnoses, ICD codes, anamnesis, pre-medication, lab values, findings, assessment, therapy proposal, and 'Teilnahme am Facharztvertrag' note

### Actual Acceptance Criteria

**Status: Partially implemented**

1. The `FormAPP.GetForm` endpoint can retrieve FaV specialty report forms, and `FormAPP.GetIcdForm` returns ICD codes for a given `contractId`
2. The `FormAPP.Print` endpoint generates the Befundbericht PDF with patient master data and diagnoses populated
3. No dedicated cardiology-specific (`Befundbericht FaV - Kardiologie`) endpoint exists -- the generic form infrastructure handles it via form configuration, but specialty-specific field composition (anamnesis, pre-medication, lab values, findings, assessment, therapy proposal, Teilnahme note) relies on client-side form field mapping
