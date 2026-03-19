## US-HKS-7.1.7-01 — Practice doctor must document Biopsie/Exzision with Anzahl, anderweitige Therapie, and derzeit keine weitere in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.7-01 |
| **Traced from** | [HKS-7.1.7-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.7-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Biopsie/Exzision as Ja or Nein in HKS-D documents, and when Ja, to record Anzahl, anderweitige Therapie, or derzeit keine weitere, so that biopsy and excision procedures are tracked for histopathological workup.

### Acceptance Criteria

1. Given an HKS-D document is created, when Biopsie/Exzision is Ja, then Anzahl (count) is recorded as a positive integer
2. Given Biopsie/Exzision is Ja, when the procedure details are documented, then anderweitige Therapie or derzeit keine weitere can be indicated
3. Given Biopsie/Exzision is Nein, then no Anzahl or sub-fields are required

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists eHKS clinical documentation fields submitted in the `DocumentationOverview.fields` array for the specific eHKS document type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each eHKS clinical field against the eHKS plausibility catalog; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Conditional Field Logic**: When fields have conditional dependencies (e.g., sub-fields required only when a parent field is Ja), the `CheckPlausibility` endpoint enforces these dependencies and returns errors for missing conditional sub-fields.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "HKS"` and verify all clinical field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing mandatory eHKS fields or invalid conditional field combinations and confirm `CheckPlausibility` identifies each specific error.
