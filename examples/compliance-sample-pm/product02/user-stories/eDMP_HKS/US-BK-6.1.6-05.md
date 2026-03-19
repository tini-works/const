## US-BK-6.1.6-05 — Practice doctor must document Nebenwirkungen endokrine Therapie in the Behandlung section

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1.6-05 |
| **Traced from** | [BK-6.1.6-05](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1.6-05.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Nebenwirkungen (side effects) of endocrine therapy in the Behandlung section, so that side effects of endocrine therapy are tracked for therapy adherence and adjustment.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Behandlung section is documented and endokrine Therapie is active, when Nebenwirkungen is recorded, then the side effect information is stored
2. Given endokrine Therapie is active but Nebenwirkungen field is missing, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Brustkrebs-specific additional clinical fields submitted in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each disease-specific field against the Brustkrebs plausibility rules; invalid values or missing mandatory selections produce `FieldValidationResult` errors.
3. **Conditional Field Logic**: When fields have conditional dependencies (e.g., sub-fields required only when a parent field has a specific value), the `CheckPlausibility` endpoint enforces these dependencies and returns appropriate errors for missing conditional fields.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "BRUSTKREBS"` and verify all disease-specific field values are correctly persisted.
5. **Negative Test**: Submit incomplete conditional field data and confirm `CheckPlausibility` identifies the specific missing dependent fields.
