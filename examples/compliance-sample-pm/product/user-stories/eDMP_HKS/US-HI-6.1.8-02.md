## US-HI-6.1.8-02 — When a doctor documents eDMP HI training, Schulung vor Einschreibung wahrgenommen must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-HI-6.1.8-02 |
| **Traced from** | [HI-6.1.8-02](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-6.1.8-02.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether the patient attended training before enrollment (Schulung vor Einschreibung wahrgenommen), so that prior education status is recorded per the eDMP HI specification.

### Acceptance Criteria

1. Given an eDMP HI documentation form, when the Schulung section is displayed, then a Schulung vor Einschreibung wahrgenommen field is available
2. Given a value is selected, when the XML is generated, then it is encoded correctly

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists Herzinsuffizienz Schulung (training) recommendation fields in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates training recommendation fields against the Herzinsuffizienz permitted value set; missing mandatory selections produce `FieldValidationResult` errors.
3. **Mandatory Selection Enforcement**: The `CheckPlausibility` endpoint enforces that Schulung fields with Ja/Nein options have exactly one value selected; empty submissions produce mandatory field errors.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then retrieve via `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "HERZINSUFFIZIENZ"` and verify training field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing Schulung selection and confirm `CheckPlausibility` flags the specific mandatory field.
