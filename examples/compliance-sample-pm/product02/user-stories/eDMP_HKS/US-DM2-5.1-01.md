## US-DM2-5.1-01 — Practice software must include a correct eHeader with DM2-specific fields in eDMP DM2 documents

| Field | Value |
|-------|-------|
| **ID** | US-DM2-5.1-01 |
| **Traced from** | [DM2-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-5.1-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to include a correct eHeader with DM2-specific differences in every eDMP DM2 CDA document, so that the document header identifies the DMP module and version unambiguously.

### Acceptance Criteria

1. Given an eDMP DM2 document is generated, when the eHeader is written, then it contains DM2-specific code and version identifiers
2. Given an eHeader missing DM2-specific fields, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint generates the clinical_document_header conforming to the eHeader specification with Diabetes mellitus Typ 2-specific differences when `DMPLabelingValue = "DM2"` is provided in the `DocumentationOverview`.
2. **Enrollment Prerequisite**: The `EDMPApp.Enroll` endpoint (NATS topic `api.app.app_core.EDMPApp.Enroll`) must be called first with `EnrollmentInfoRequest` containing the Diabetes mellitus Typ 2 DMP labeling; the returned `EnrollResponse.ids` confirm enrollment.
3. **Header Validation**: The `EDMPApp.CheckPlausibility` endpoint validates Diabetes mellitus Typ 2-specific header field values differ correctly from the generic eHeader specification; mismatches produce `FieldValidationResult` errors.
4. **GetEnrollment Verification**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the returned `EnrollmentWithDocumentModels` list includes an active Diabetes mellitus Typ 2 enrollment.
