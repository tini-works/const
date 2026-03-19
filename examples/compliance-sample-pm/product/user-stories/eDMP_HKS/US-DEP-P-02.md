## US-DEP-P-02 — When practice software validates eDMP Depression data, Depression-specific plausibility rules must be applied

| Field | Value |
|-------|-------|
| **ID** | US-DEP-P-02 |
| **Traced from** | [DEP-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-P-02.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to apply the EXT_ITA_VGEX_Plausi_eDMP_Depression plausibility rules when validating Depression documentation, so that Depression-specific consistency checks are enforced before transmission.

### Acceptance Criteria

1. Given an eDMP Depression documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_Depression rules are evaluated
2. Given a Depression-specific plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint applies all Depression-specific plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_Depression) when `DMPLabelingValue = "DEPRESSION"` is specified in the `CheckPlausibilityRequest`.
2. **Disease-Specific Validation**: The `CheckPlausibilityResponse.fieldValidationResults` array contains entries for each Depression-specific rule violation, identifying the affected field and the specific plausibility rule.
3. **Sequential Validation**: Cross-program rules (P-01) are applied before Depression-specific rules (P-02); the document must pass both validation stages before `FinishDocumentationOverview` succeeds.
4. **Billing File Generation**: When all plausibility rules pass, `CheckPlausibilityResponse.billingFile` contains the generated Depression billing XML file ready for transmission.
5. **Negative Test**: Submit a documentation overview that violates a Depression-specific rule (e.g., invalid field combination for the disease type) and confirm `CheckPlausibility` returns the specific Depression rule violation.
