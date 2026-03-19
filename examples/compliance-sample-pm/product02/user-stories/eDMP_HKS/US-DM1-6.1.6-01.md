## US-DM1-6.1.6-01 — Practice doctor must document Relevante Ereignisse as multi-select in the Anamnese section

| Field | Value |
|-------|-------|
| **ID** | US-DM1-6.1.6-01 |
| **Traced from** | [DM1-6.1.6-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM1-6.1.6-01.md) |
| **Source** | KBV eDMP DM1 V5.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM1.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Relevante Ereignisse selecting from Nierenersatztherapie, Erblindung, Amputation, Herzinfarkt, Schlaganfall, or Keine, so that significant clinical events since last documentation are recorded for outcome tracking.

### Acceptance Criteria

1. Given an eDMP DM1 Anamnese is documented, when Relevante Ereignisse is recorded, then one or more of Nierenersatztherapie, Erblindung, Amputation, Herzinfarkt, Schlaganfall, or Keine is selected
2. Given "Keine" is selected together with another event, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 1-specific additional clinical fields submitted in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each disease-specific field against the Diabetes mellitus Typ 1 plausibility rules; invalid values or missing mandatory selections produce `FieldValidationResult` errors.
3. **Conditional Field Logic**: When fields have conditional dependencies (e.g., sub-fields required only when a parent field has a specific value), the `CheckPlausibility` endpoint enforces these dependencies and returns appropriate errors for missing conditional fields.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "DM1"` and verify all disease-specific field values are correctly persisted.
5. **Negative Test**: Submit incomplete conditional field data and confirm `CheckPlausibility` identifies the specific missing dependent fields.
