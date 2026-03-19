## US-BK-P-01 — Practice software must validate eDMP Brustkrebs documents against EXT_ITA_VGEX_Plausi_eDMP_Brustkrebs rules

| Field | Value |
|-------|-------|
| **ID** | US-BK-P-01 |
| **Traced from** | [BK-P-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-P-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP Brustkrebs documents against the EXT_ITA_VGEX_Plausi_eDMP_Brustkrebs plausibility rule set before transmission, so that Brustkrebs-specific plausibility errors are detected and reported before submission.

### Acceptance Criteria

1. Given an eDMP Brustkrebs document is completed, when plausibility validation is run, then all EXT_ITA_VGEX_Plausi_eDMP_Brustkrebs rules are evaluated
2. Given a plausibility rule is violated, when validation completes, then the specific rule violation and affected field are reported to the user

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) applies all cross-program plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend) when `DMPLabelingValue = "BRUSTKREBS"` is specified.
2. **Rule Violation Reporting**: When a cross-program plausibility rule is violated, the `CheckPlausibilityResponse.fieldValidationResults` array contains entries identifying the specific rule, affected field, and violation description.
3. **Plausibility Status**: The `CheckPlausibilityResponse.isPlausible` field returns `false` when any cross-program rule is violated, preventing the document from being finalized via `FinishDocumentationOverview`.
4. **Billing Integration**: The `EDMPApp.CheckValidationForDMPBilling` endpoint also enforces cross-program plausibility rules during billing validation; violations appear in `DMPBillingFieldsValidationResults`.
5. **Negative Test**: Submit a documentation overview that violates a known cross-program rule (e.g., missing mandatory demographic fields) and confirm `CheckPlausibility` returns the specific rule violation.
