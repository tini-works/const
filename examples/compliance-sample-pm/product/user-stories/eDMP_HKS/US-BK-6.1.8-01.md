## US-BK-6.1.8-01 — Practice doctor must document Schulung and Behandlungsplanung in the eDMP Brustkrebs documentation

| Field | Value |
|-------|-------|
| **ID** | US-BK-6.1.8-01 |
| **Traced from** | [BK-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Brustkrebs/BK-6.1.8-01.md) |
| **Source** | KBV eDMP Brustkrebs V4.25 (KBV_ITA_VGEX_Schnittstelle_eDMP_Brustkrebs.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document Schulung and Behandlungsplanung fields in the eDMP Brustkrebs documentation, so that patient education and treatment planning are captured for comprehensive breast cancer care.

### Acceptance Criteria

1. Given an eDMP Brustkrebs documentation is created, when the Schulung/Behandlungsplanung section is filled, then the required education and planning fields are recorded
2. Given required Schulung/Behandlungsplanung fields are missing, when validated, then an error is reported

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Brustkrebs Schulung (training) recommendation fields in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates training recommendation fields against the Brustkrebs permitted value set; missing mandatory selections produce `FieldValidationResult` errors.
3. **Mandatory Selection Enforcement**: The `CheckPlausibility` endpoint enforces that Schulung fields with Ja/Nein options have exactly one value selected; empty submissions produce mandatory field errors.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then retrieve via `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "BRUSTKREBS"` and verify training field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing Schulung selection and confirm `CheckPlausibility` flags the specific mandatory field.
