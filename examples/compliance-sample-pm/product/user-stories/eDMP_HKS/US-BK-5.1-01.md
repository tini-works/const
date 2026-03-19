## US-BK-5.1-01 — Practice software must include a correct eHeader with Brustkrebs-specific fields in eDMP Brustkrebs documents

| Field | Value |
|-------|-------|
| **ID** | US-BK-5.1-01 |
| **Traced from** | [BK-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-5.1-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to include a correct eHeader with Brustkrebs-specific differences in every eDMP Brustkrebs CDA document, so that the document header identifies the DMP module and version unambiguously.

### Acceptance Criteria

1. Given an eDMP Brustkrebs document is generated, when the eHeader is written, then it contains Brustkrebs-specific code and version identifiers
2. Given an eHeader missing Brustkrebs-specific fields, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint generates the clinical_document_header conforming to the eHeader specification with Brustkrebs-specific differences when `DMPLabelingValue = "BRUSTKREBS"` is provided in the `DocumentationOverview`.
2. **Enrollment Prerequisite**: The `EDMPApp.Enroll` endpoint (NATS topic `api.app.app_core.EDMPApp.Enroll`) must be called first with `EnrollmentInfoRequest` containing the Brustkrebs DMP labeling; the returned `EnrollResponse.ids` confirm enrollment.
3. **Header Validation**: The `EDMPApp.CheckPlausibility` endpoint validates Brustkrebs-specific header field values differ correctly from the generic eHeader specification; mismatches produce `FieldValidationResult` errors.
4. **GetEnrollment Verification**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the returned `EnrollmentWithDocumentModels` list includes an active Brustkrebs enrollment.
