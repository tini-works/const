## US-COPD-P-01 — Practice software must validate eDMP COPD data against EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend

| Field | Value |
|-------|-------|
| **ID** | US-COPD-P-01 |
| **Traced from** | [COPD-P-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/COPD/COPD-P-01.md) |
| **Source** | KBV eDMP COPD V4.06 (KBV_ITA_VGEX_Schnittstelle_eDMP_COPD.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP COPD documentation data against the cross-program plausibility rules defined in EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend, so that general eDMP plausibility requirements are met before transmission.

### Acceptance Criteria

1. Given an eDMP COPD documentation is completed, when validation is triggered, then all rules from EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend are applied
2. Given a plausibility rule is violated, when validation runs, then the specific rule violation and affected field are reported to the user
3. Given all cross-program rules pass, when validation completes, then the document is cleared for COPD-specific validation

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) applies all cross-program plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend) when `DMPLabelingValue = "COPD"` is specified.
2. **Rule Violation Reporting**: When a cross-program plausibility rule is violated, the `CheckPlausibilityResponse.fieldValidationResults` array contains entries identifying the specific rule, affected field, and violation description.
3. **Plausibility Status**: The `CheckPlausibilityResponse.isPlausible` field returns `false` when any cross-program rule is violated, preventing the document from being finalized via `FinishDocumentationOverview`.
4. **Billing Integration**: The `EDMPApp.CheckValidationForDMPBilling` endpoint also enforces cross-program plausibility rules during billing validation; violations appear in `DMPBillingFieldsValidationResults`.
5. **Negative Test**: Submit a documentation overview that violates a known cross-program rule (e.g., missing mandatory demographic fields) and confirm `CheckPlausibility` returns the specific rule violation.
