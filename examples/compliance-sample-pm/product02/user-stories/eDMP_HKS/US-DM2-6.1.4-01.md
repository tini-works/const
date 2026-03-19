## US-DM2-6.1.4-01 — Practice doctor must record Einschreibung wegen Diabetes mellitus Typ 2 in the administrative section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.4-01 |
| **Traced from** | [DM2-6.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.4-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to record the enrollment reason as "Diabetes mellitus Typ 2" in the administrative section of the eDMP DM2 documentation, so that the enrollment reason is correctly transmitted and the patient is assigned to the DM2 programme.

### Acceptance Criteria

1. Given a new eDMP DM2 documentation is created, when the administrative section is filled, then the Einschreibung reason "Diabetes mellitus Typ 2" is recorded
2. Given the Einschreibung reason is missing, when the document is validated, then an error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint automatically sets the "Einschreibung wegen" administrative field to "Diabetes mellitus Typ 2" when `DMPLabelingValue = "DM2"` is provided in the `DocumentationOverview`.
2. **Enrollment Validation**: The `EDMPApp.CheckPlausibility` endpoint validates that "Einschreibung wegen" matches the expected Diabetes mellitus Typ 2 value; mismatches produce `FieldValidationResult` errors.
3. **Enrollment Cross-Check**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the enrollment record's `DMPLabelingValue` matches the administrative field in the documentation.
4. **Negative Test**: Submit a documentation overview where "Einschreibung wegen" contains a value different from the enrolled DMP and confirm `CheckPlausibility` flags the inconsistency.
