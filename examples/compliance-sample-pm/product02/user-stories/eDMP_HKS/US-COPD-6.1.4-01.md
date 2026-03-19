## US-COPD-6.1.4-01 — Administrative data field "Einschreibung wegen" must contain "COPD"

| Field | Value |
|-------|-------|
| **ID** | US-COPD-6.1.4-01 |
| **Traced from** | [COPD-6.1.4-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-6.1.4-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want the administrative data field "Einschreibung wegen" to be automatically set to "COPD" in eDMP COPD documentation, so that the enrollment reason is correctly recorded.

### Acceptance Criteria

1. Given an eDMP COPD document is created, when the administrative section is generated, then "Einschreibung wegen" contains "COPD"
2. Given any other value in "Einschreibung wegen", when validated, then an error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint automatically sets the "Einschreibung wegen" administrative field to "COPD" when `DMPLabelingValue = "COPD"` is provided in the `DocumentationOverview`.
2. **Enrollment Validation**: The `EDMPApp.CheckPlausibility` endpoint validates that "Einschreibung wegen" matches the expected COPD value; mismatches produce `FieldValidationResult` errors.
3. **Enrollment Cross-Check**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the enrollment record's `DMPLabelingValue` matches the administrative field in the documentation.
4. **Negative Test**: Submit a documentation overview where "Einschreibung wegen" contains a value different from the enrolled DMP and confirm `CheckPlausibility` flags the inconsistency.
