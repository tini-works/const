## US-DM1-6.1.4-01 — Practice doctor must record Einschreibung wegen Diabetes mellitus Typ 1 in the administrative section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.4-01 |
| **Traced from** | [DM1-6.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.4-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to record the enrollment reason as "Diabetes mellitus Typ 1" in the administrative section of the eDMP DM1 documentation, so that the enrollment reason is correctly transmitted and the patient is assigned to the DM1 programme.

### Acceptance Criteria

1. Given a new eDMP DM1 documentation is created, when the administrative section is filled, then the Einschreibung reason "Diabetes mellitus Typ 1" is recorded
2. Given the Einschreibung reason is missing, when the document is validated, then an error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint automatically sets the "Einschreibung wegen" administrative field to "Diabetes mellitus Typ 1" when `DMPLabelingValue = "DM1"` is provided in the `DocumentationOverview`.
2. **Enrollment Validation**: The `EDMPApp.CheckPlausibility` endpoint validates that "Einschreibung wegen" matches the expected Diabetes mellitus Typ 1 value; mismatches produce `FieldValidationResult` errors.
3. **Enrollment Cross-Check**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the enrollment record's `DMPLabelingValue` matches the administrative field in the documentation.
4. **Negative Test**: Submit a documentation overview where "Einschreibung wegen" contains a value different from the enrolled DMP and confirm `CheckPlausibility` flags the inconsistency.
