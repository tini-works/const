## US-COPD-5.1-01 — Practice software must generate eHeader conforming to eHeader spec with COPD-specific differences

| Field | Value |
|-------|-------|
| **ID** | US-COPD-5.1-01 |
| **Traced from** | [COPD-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-5.1-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the clinical_document_header conforming to the eHeader specification with COPD-specific differences applied, so that the header metadata is correct for eDMP COPD transmissions.

### Acceptance Criteria

1. Given an eDMP COPD document is created, when the header is generated, then it conforms to the eHeader specification
2. Given COPD-specific header fields differ from the generic eHeader, when the header is generated, then the COPD-specific values are used

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint generates the clinical_document_header conforming to the eHeader specification with COPD-specific differences when `DMPLabelingValue = "COPD"` is provided in the `DocumentationOverview`.
2. **Enrollment Prerequisite**: The `EDMPApp.Enroll` endpoint (NATS topic `api.app.app_core.EDMPApp.Enroll`) must be called first with `EnrollmentInfoRequest` containing the COPD DMP labeling; the returned `EnrollResponse.ids` confirm enrollment.
3. **Header Validation**: The `EDMPApp.CheckPlausibility` endpoint validates COPD-specific header field values differ correctly from the generic eHeader specification; mismatches produce `FieldValidationResult` errors.
4. **GetEnrollment Verification**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the returned `EnrollmentWithDocumentModels` list includes an active COPD enrollment.
