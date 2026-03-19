## US-HKS-7.1.5-01 — Practice doctor must document Angabe Verdachtsdiagnose ueberweisender Arzt with conditional blocks in HKS-D documents

| Field | Value |
|-------|-------|
| **ID** | US-HKS-7.1.5-01 |
| **Traced from** | [HKS-7.1.5-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/eHKS/HKS-7.1.5-01.md) |
| **Source** | KBV eHKS V2.33 (KBV_ITA_VGEX_Schnittstelle_eHKS.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Angabe Verdachtsdiagnose ueberweisender Arzt as Ja or Nein in HKS-D documents, with conditional sub-diagnosis blocks when Ja, so that the referring physician's suspected diagnosis is captured for diagnostic continuity.

### Acceptance Criteria

1. Given an HKS-D document is created and Angabe Verdachtsdiagnose ueberweisender Arzt is Ja, when the conditional block is presented, then the referring doctor's suspected diagnosis details are recorded
2. Given Angabe Verdachtsdiagnose ueberweisender Arzt is Nein, then no sub-diagnosis block is required
3. Given Ja is selected but the conditional sub-diagnosis block is empty, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists eHKS clinical documentation fields submitted in the `DocumentationOverview.fields` array for the specific eHKS document type.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates each eHKS clinical field against the eHKS plausibility catalog; invalid values or missing mandatory fields produce `FieldValidationResult` errors.
3. **Conditional Field Logic**: When fields have conditional dependencies (e.g., sub-fields required only when a parent field is Ja), the `CheckPlausibility` endpoint enforces these dependencies and returns errors for missing conditional sub-fields.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "HKS"` and verify all clinical field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing mandatory eHKS fields or invalid conditional field combinations and confirm `CheckPlausibility` identifies each specific error.
