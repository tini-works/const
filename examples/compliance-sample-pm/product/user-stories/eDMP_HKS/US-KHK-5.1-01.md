## US-KHK-5.1-01 — When practice software generates eDMP KHK XML, eHeader must contain KHK-specific elements

| Field | Value |
|-------|-------|
| **ID** | US-KHK-5.1-01 |
| **Traced from** | [KHK-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-5.1-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the eHeader with KHK-specific differences from the general eDMP eHeader, so that the document is correctly identified as an eDMP KHK documentation.

### Acceptance Criteria

1. Given an eDMP KHK documentation is exported, when the eHeader is generated, then KHK-specific KBV module identifiers are included
2. Given the eHeader, when compared to the general eDMP eHeader, then all KHK-specific deviations per V4.16 are applied

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint generates the clinical_document_header conforming to the eHeader specification with KHK-specific differences when `DMPLabelingValue = "KHK"` is provided in the `DocumentationOverview`.
2. **Enrollment Prerequisite**: The `EDMPApp.Enroll` endpoint (NATS topic `api.app.app_core.EDMPApp.Enroll`) must be called first with `EnrollmentInfoRequest` containing the KHK DMP labeling; the returned `EnrollResponse.ids` confirm enrollment.
3. **Header Validation**: The `EDMPApp.CheckPlausibility` endpoint validates KHK-specific header field values differ correctly from the generic eHeader specification; mismatches produce `FieldValidationResult` errors.
4. **GetEnrollment Verification**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the returned `EnrollmentWithDocumentModels` list includes an active KHK enrollment.
