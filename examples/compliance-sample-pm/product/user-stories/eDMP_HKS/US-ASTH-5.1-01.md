## US-ASTH-5.1-01 — Practice software must generate eHeader conforming to eHeader spec with Asthma-specific differences

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-5.1-01 |
| **Traced from** | [ASTH-5.1-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-5.1-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate the clinical_document_header conforming to the eHeader specification with Asthma-specific differences applied, so that the header metadata is correct for eDMP Asthma transmissions.

### Acceptance Criteria

1. Given an eDMP Asthma document is created, when the header is generated, then it conforms to the eHeader specification
2. Given Asthma-specific header fields differ from the generic eHeader, when the header is generated, then the Asthma-specific values are used

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint generates the clinical_document_header conforming to the eHeader specification with Asthma-specific differences when `DMPLabelingValue = "ASTHMA"` is provided in the `DocumentationOverview`.
2. **Enrollment Prerequisite**: The `EDMPApp.Enroll` endpoint (NATS topic `api.app.app_core.EDMPApp.Enroll`) must be called first with `EnrollmentInfoRequest` containing the Asthma DMP labeling; the returned `EnrollResponse.ids` confirm enrollment.
3. **Header Validation**: The `EDMPApp.CheckPlausibility` endpoint validates Asthma-specific header field values differ correctly from the generic eHeader specification; mismatches produce `FieldValidationResult` errors.
4. **GetEnrollment Verification**: Call `EDMPApp.GetEnrollment` with the patient's ID and verify the returned `EnrollmentWithDocumentModels` list includes an active Asthma enrollment.
