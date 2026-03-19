## US-DM2-6.1.8-01 — Practice doctor must document empfohlene Schulungen as multi-select in the Schulung section

| Field | Value |
|-------|-------|
| **ID** | US-DM2-6.1.8-01 |
| **Traced from** | [DM2-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Diabetes_m1_m2/DM2-6.1.8-01.md) |
| **Source** | KBV eDMP DM2 V6.07 (KBV_ITA_VGEX_Schnittstelle_eDMP_DM2.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document empfohlene Schulungen selecting from Keine, Diabetes-Schulung, or Hypertonie-Schulung in the Schulung section, so that recommended patient education programmes are recorded for care planning.

### Acceptance Criteria

1. Given an eDMP DM2 Schulung section is documented, when empfohlene Schulung is recorded, then one or more of Keine, Diabetes-Schulung, or Hypertonie-Schulung is selected
2. Given "Keine" is selected together with a specific Schulung, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Diabetes mellitus Typ 2 Schulung (training) recommendation fields in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates training recommendation fields against the Diabetes mellitus Typ 2 permitted value set; missing mandatory selections produce `FieldValidationResult` errors.
3. **Mandatory Selection Enforcement**: The `CheckPlausibility` endpoint enforces that Schulung fields with Ja/Nein options have exactly one value selected; empty submissions produce mandatory field errors.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then retrieve via `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "DM2"` and verify training field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing Schulung selection and confirm `CheckPlausibility` flags the specific mandatory field.
