## US-KHK-P-02 — When practice software validates eDMP KHK data, KHK-specific plausibility rules must be applied

| Field | Value |
|-------|-------|
| **ID** | US-KHK-P-02 |
| **Traced from** | [KHK-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-P-02.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to apply the EXT_ITA_VGEX_Plausi_eDMP_KHK plausibility rules when validating KHK documentation, so that KHK-specific consistency checks are enforced before transmission.

### Acceptance Criteria

1. Given an eDMP KHK documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_KHK rules are evaluated
2. Given a KHK-specific plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint applies all KHK-specific plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_KHK) when `DMPLabelingValue = "KHK"` is specified in the `CheckPlausibilityRequest`.
2. **Disease-Specific Validation**: The `CheckPlausibilityResponse.fieldValidationResults` array contains entries for each KHK-specific rule violation, identifying the affected field and the specific plausibility rule.
3. **Sequential Validation**: Cross-program rules (P-01) are applied before KHK-specific rules (P-02); the document must pass both validation stages before `FinishDocumentationOverview` succeeds.
4. **Billing File Generation**: When all plausibility rules pass, `CheckPlausibilityResponse.billingFile` contains the generated KHK billing XML file ready for transmission.
5. **Negative Test**: Submit a documentation overview that violates a KHK-specific rule (e.g., invalid field combination for the disease type) and confirm `CheckPlausibility` returns the specific KHK rule violation.
