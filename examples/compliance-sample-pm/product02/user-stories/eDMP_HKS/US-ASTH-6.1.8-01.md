## US-ASTH-6.1.8-01 — Schulung must capture Asthma-Schulung empfohlen (Ja/Nein)

| Field | Value |
|-------|-------|
| **ID** | US-ASTH-6.1.8-01 |
| **Traced from** | [ASTH-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Asthma/ASTH-6.1.8-01.md) |
| **Source** | KBV eDMP Asthma V4.46 (KBV_ITA_VGEX_Schnittstelle_eDMP_Asthma.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether an Asthma training was recommended (Asthma-Schulung empfohlen: Ja/Nein), so that patient education recommendations are tracked per eDMP requirements.

### Acceptance Criteria

1. Given an eDMP Asthma Schulung section is displayed, when Asthma-Schulung empfohlen is presented, then Ja or Nein must be selected
2. Given no selection is made, when the form is submitted, then a mandatory field error is raised

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Asthma Schulung (training) recommendation fields in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates training recommendation fields against the Asthma permitted value set; missing mandatory selections produce `FieldValidationResult` errors.
3. **Mandatory Selection Enforcement**: The `CheckPlausibility` endpoint enforces that Schulung fields with Ja/Nein options have exactly one value selected; empty submissions produce mandatory field errors.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then retrieve via `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "ASTHMA"` and verify training field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing Schulung selection and confirm `CheckPlausibility` flags the specific mandatory field.
