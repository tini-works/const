## US-HKS-P-02 — Practice software must validate eHKS documents against EXT_ITA_VGEX_Plausi_Praevention_eHKS rules

| Field | Value |
|-------|-------|
| **ID** | US-HKS-P-02 |
| **Traced from** | [HKS-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-P-02.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eHKS documents against the EXT_ITA_VGEX_Plausi_Praevention_eHKS prevention-specific plausibility rule set, so that prevention-specific plausibility errors are detected and reported before submission.

### Acceptance Criteria

1. Given an eHKS document is completed, when plausibility validation is run, then all EXT_ITA_VGEX_Plausi_Praevention_eHKS rules are evaluated
2. Given a prevention plausibility rule is violated, when validation completes, then the specific rule violation and affected field are reported to the user

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint applies all eHKS-specific plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_eHKS) when `DMPLabelingValue = "HKS"` is specified in the `CheckPlausibilityRequest`.
2. **Disease-Specific Validation**: The `CheckPlausibilityResponse.fieldValidationResults` array contains entries for each eHKS-specific rule violation, identifying the affected field and the specific plausibility rule.
3. **Sequential Validation**: Cross-program rules (P-01) are applied before eHKS-specific rules (P-02); the document must pass both validation stages before `FinishDocumentationOverview` succeeds.
4. **Billing File Generation**: When all plausibility rules pass, `CheckPlausibilityResponse.billingFile` contains the generated eHKS billing XML file ready for transmission.
5. **Negative Test**: Submit a documentation overview that violates a eHKS-specific rule (e.g., invalid field combination for the disease type) and confirm `CheckPlausibility` returns the specific eHKS rule violation.
