## US-HKS-7.1.8-03 — Practice doctor must document Histopathologie Spinozellulaeres Karzinom with Klassifikation and Grading in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.8-03 |
| **Traced from** | [HKS-7.1.8-03](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.8-03.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Histopathologie Spinozellulaeres Karzinom as Ja or Nein in HKS-D documents, and when Ja, to record Klassifikation (in situ or invasiv) and Grading (Gx, G1, G2, G3, G4), so that squamous cell carcinoma histopathology findings are captured with classification and grading.

### Acceptance Criteria

1. Given an HKS-D document is created, when Histopathologie Spinozellulaeres Karzinom is Ja, then Klassifikation (in situ or invasiv) is selected
2. Given Klassifikation is invasiv, when documented, then Grading is one of Gx, G1, G2, G3, or G4
3. Given Histopathologie Spinozellulaeres Karzinom is Nein, then no sub-fields are required

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists eHKS clinical documentation fields submitted in the `DocumentationOverview.fields` array for the specific eHKS document type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each eHKS clinical field against the eHKS plausibility catalog; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Conditional Field Logic**: When fields have conditional dependencies (e.g., sub-fields required only when a parent field is Ja), the `CheckPlausibility` endpoint enforces these dependencies and returns errors for missing conditional sub-fields.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "HKS"` and verify all clinical field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing mandatory eHKS fields or invalid conditional field combinations and confirm `CheckPlausibility` identifies each specific error.
