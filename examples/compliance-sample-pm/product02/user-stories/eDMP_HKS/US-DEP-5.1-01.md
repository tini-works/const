## US-DEP-5.1-01 — When practice software generates eDMP Depression XML, eHeader must contain Depression-specific elements

| Field | Value |
|-------|-------|
| **ID** | US-DEP-5.1-01 |
| **Traced from** | [DEP-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-5.1-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the eHeader with Depression-specific differences from the general eDMP eHeader, so that the document is correctly identified as an eDMP Depression documentation.

### Acceptance Criteria

1. Given an eDMP Depression documentation is exported, when the eHeader is generated, then Depression-specific KBV module identifiers are included
2. Given the eHeader, when compared to the general eDMP eHeader, then all Depression-specific deviations per V1.02 are applied

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint generates the clinical_document_header conforming to the eHeader specification with Depression-specific differences when `DMPLabelingValue = "DEPRESSION"` is provided in the `DocumentationOverview`.
2. **Enrollment Prerequisite**: The `EDMPApp.Enroll` endpoint (NATS topic `api.app.app_core.EDMPApp.Enroll`) must be called first with `EnrollmentInfoRequest` containing the Depression DMP labeling; the returned `EnrollResponse.ids` confirm enrollment.
3. **Header Validation**: The `EDMPApp.CheckPlausibility` endpoint validates Depression-specific header field values differ correctly from the generic eHeader specification; mismatches produce `FieldValidationResult` errors.
4. **GetEnrollment Verification**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the returned `EnrollmentWithDocumentModels` list includes an active Depression enrollment.
