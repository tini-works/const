## US-HI-P-02 — When practice software validates eDMP HI data, HI-specific plausibility rules must be applied

| Field | Value |
|-------|-------|
| **ID** | US-HI-P-02 |
| **Traced from** | [HI-P-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-P-02.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to apply the EXT_ITA_VGEX_Plausi_eDMP_HI plausibility rules when validating HI documentation, so that Herzinsuffizienz-specific consistency checks are enforced before transmission.

### Acceptance Criteria

1. Given an eDMP HI documentation is complete, when plausibility validation is triggered, then all EXT_ITA_VGEX_Plausi_eDMP_HI rules are evaluated
2. Given an HI-specific plausibility rule is violated, when validation completes, then the specific violation is displayed to the user

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CheckPlausibility` endpoint applies all Herzinsuffizienz-specific plausibility rules (EXT_ITA_VGEX_Plausi_eDMP_Herzinsuffizienz) when `DMPLabelingValue = "HERZINSUFFIZIENZ"` is specified in the `CheckPlausibilityRequest`.
2. **Disease-Specific Validation**: The `CheckPlausibilityResponse.fieldValidationResults` array contains entries for each Herzinsuffizienz-specific rule violation, identifying the affected field and the specific plausibility rule.
3. **Sequential Validation**: Cross-program rules (P-01) are applied before Herzinsuffizienz-specific rules (P-02); the document must pass both validation stages before `FinishDocumentationOverview` succeeds.
4. **Billing File Generation**: When all plausibility rules pass, `CheckPlausibilityResponse.billingFile` contains the generated Herzinsuffizienz billing XML file ready for transmission.
5. **Negative Test**: Submit a documentation overview that violates a Herzinsuffizienz-specific rule (e.g., invalid field combination for the disease type) and confirm `CheckPlausibility` returns the specific Herzinsuffizienz rule violation.
