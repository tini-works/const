## US-BK-6.1.6-03 — Practice doctor must document Chemotherapie status in the Behandlung section

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1.6-03 |
| **Traced from** | [BK-6.1.6-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1.6-03.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Chemotherapie status in the Behandlung section of the eDMP Brustkrebs documentation, so that chemotherapy treatment status is captured for multimodal treatment tracking.

### Acceptance Criteria

1. Given an eDMP Brustkrebs Behandlung section is documented, when Chemotherapie is recorded, then the chemotherapy status is stored
2. Given the Chemotherapie field is missing, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Brustkrebs-specific additional clinical fields submitted in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each disease-specific field against the Brustkrebs plausibility rules; invalid values or missing mandatory selections produce `FieldValidationResult` errors.
3. **Conditional Field Logic**: When fields have conditional dependencies (e.g., sub-fields required only when a parent field has a specific value), the `CheckPlausibility` endpoint enforces these dependencies and returns appropriate errors for missing conditional fields.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "BRUSTKREBS"` and verify all disease-specific field values are correctly persisted.
5. **Negative Test**: Submit incomplete conditional field data and confirm `CheckPlausibility` identifies the specific missing dependent fields.
