## US-ASTH-P-02 — Practice software must validate eDMP Asthma data against EXT_ITA_VGEX_Plausi_eDMP_Asthma

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-P-02 |
| **Traced from** | [ASTH-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-P-02.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to validate all eDMP Asthma documentation data against the Asthma-specific plausibility rules defined in EXT_ITA_VGEX_Plausi_eDMP_Asthma, so that Asthma-specific data consistency is ensured before transmission.

### Acceptance Criteria

1. Given an eDMP Asthma documentation is completed, when validation is triggered, then all rules from EXT_ITA_VGEX_Plausi_eDMP_Asthma are applied
2. Given an Asthma-specific plausibility rule is violated, when validation runs, then the specific rule violation and affected field are reported to the user
3. Given all Asthma-specific rules pass, when validation completes, then the document is cleared for export

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint applies all Asthma-specific plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_Asthma) when `DMPLabelingValue = "ASTHMA"` is specified in the `CheckPlausibilityRequest`.
2. **Disease-Specific Validation**: The `CheckPlausibilityResponse.fieldValidationResults` array contains entries for each Asthma-specific rule violation, identifying the affected field and the specific plausibility rule.
3. **Sequential Validation**: Cross-program rules (P-01) are applied before Asthma-specific rules (P-02); the document must pass both validation stages before `FinishDocumentationOverview` succeeds.
4. **Billing File Generation**: When all plausibility rules pass, `CheckPlausibilityResponse.billingFile` contains the generated Asthma billing XML file ready for transmission.
5. **Negative Test**: Submit a documentation overview that violates a Asthma-specific rule (e.g., invalid field combination for the disease type) and confirm `CheckPlausibility` returns the specific Asthma rule violation.
