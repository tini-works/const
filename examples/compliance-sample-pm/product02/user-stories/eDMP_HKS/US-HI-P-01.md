## US-HI-P-01 — When practice software validates eDMP HI data, cross-module plausibility rules (Uebergreifend) must be applied

| Field | Value |
|-------|-------|
| **ID** | US-HI-P-01 |
| **Traced from** | [HI-P-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-P-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to apply the EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend plausibility rules when validating HI documentation, so that cross-module consistency checks are enforced before transmission.

### Acceptance Criteria

1. Given an eDMP HI documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend rules are evaluated
2. Given a cross-module plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint (NATS topic `api.app.app_core.EDMPApp.CheckPlausibility`) applies all cross-program plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_Uebergreifend) when `DMPLabelingValue = "HERZINSUFFIZIENZ"` is specified.
2. **Rule Violation Reporting**: When a cross-program plausibility rule is violated, the `CheckPlausibilityResponse.fieldValidationResults` array contains entries identifying the specific rule, affected field, and violation description.
3. **Plausibility Status**: The `CheckPlausibilityResponse.isPlausible` field returns `false` when any cross-program rule is violated, preventing the document from being finalized via `FinishDocumentationOverview`.
4. **Billing Integration**: The `EDMPApp.CheckValidationForDMPBilling` endpoint also enforces cross-program plausibility rules during billing validation; violations appear in `DMPBillingFieldsValidationResults`.
5. **Negative Test**: Submit a documentation overview that violates a known cross-program rule (e.g., missing mandatory demographic fields) and confirm `CheckPlausibility` returns the specific rule violation.
