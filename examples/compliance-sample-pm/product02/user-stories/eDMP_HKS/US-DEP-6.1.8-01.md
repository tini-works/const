## US-DEP-6.1.8-01 — When a doctor documents eDMP Depression training, Depression-specific Schulung recommendation must be captured

| Field | Value |
|-------|-------|
| **ID** | US-DEP-6.1.8-01 |
| **Traced from** | [DEP-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Depression/DEP-6.1.8-01.md) |
| **Source** | KBV eDMP Depression V1.02 (KBV_ITA_VGEX_Schnittstelle_eDMP_Depression.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether a Depression-specific training (Schulung) is recommended, so that the patient education recommendation is recorded per the eDMP Depression specification.

### Acceptance Criteria

1. Given an eDMP Depression documentation form, when the Schulung section is displayed, then a Depression-specific training recommendation field is available
2. Given a recommendation is made, when the XML is generated, then the Schulung empfohlen value is encoded correctly

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Depression Schulung (training) recommendation fields in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates training recommendation fields against the Depression permitted value set; missing mandatory selections produce `FieldValidationResult` errors.
3. **Mandatory Selection Enforcement**: The `CheckPlausibility` endpoint enforces that Schulung fields with Ja/Nein options have exactly one value selected; empty submissions produce mandatory field errors.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then retrieve via `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "DEPRESSION"` and verify training field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing Schulung selection and confirm `CheckPlausibility` flags the specific mandatory field.
