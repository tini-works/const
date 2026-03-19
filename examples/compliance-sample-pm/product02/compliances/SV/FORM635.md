## FORM635 — The Vertragssoftware must provide the FaV cover letter (Begleitschreiben) form...

| Field | Value |
|-------|-------|
| **ID** | FORM635 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.5 FORM — Form Management |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Form output check |
| Matched by | [US-FORM635](../../user-stories/US-FORM635.md) |

### Requirement

The Vertragssoftware must provide the FaV cover letter (Begleitschreiben) form per AKA-Basisdatei, allowing the user to save it to the patient record and auto-fill permanent diagnoses and allergy fields from the patient record while keeping other fields manually editable

### Acceptance Criteria

1. Given a FaV patient, when the Begleitschreiben is opened, then it can be saved to the patient record
2. Given stored Dauerdiagnosen and allergies exist, then those fields are pre-filled
3. Given other fields, then they remain manually editable
