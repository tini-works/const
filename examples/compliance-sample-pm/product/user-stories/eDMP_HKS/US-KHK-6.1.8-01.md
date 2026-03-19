## US-KHK-6.1.8-01 — When a doctor documents eDMP KHK training, KHK-Schulung empfohlen must be recorded

| Field | Value |
|-------|-------|
| **ID** | US-KHK-6.1.8-01 |
| **Traced from** | [KHK-6.1.8-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/KHK/KHK-6.1.8-01.md) |
| **Source** | KBV eDMP KHK V4.16 (KBV_ITA_VGEX_Schnittstelle_eDMP_KHK.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice doctor, I want to document whether a KHK-specific training (KHK-Schulung) is recommended, so that the patient education recommendation is recorded per the eDMP KHK specification.

### Acceptance Criteria

1. Given an eDMP KHK documentation form, when the Schulung section is displayed, then a KHK-Schulung empfohlen field is available
2. Given a recommendation is made, when the XML is generated, then the Schulung empfohlen value is encoded correctly

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.SaveDocumentationOverview` endpoint persists KHK Schulung (training) recommendation fields in the `DocumentationOverview.fields` array.
2. **Field-Level Plausibility**: The `EDMPApp.CheckPlausibility` endpoint validates training recommendation fields against the KHK permitted value set; missing mandatory selections produce `FieldValidationResult` errors.
3. **Mandatory Selection Enforcement**: The `CheckPlausibility` endpoint enforces that Schulung fields with Ja/Nein options have exactly one value selected; empty submissions produce mandatory field errors.
4. **Save-Retrieve Roundtrip**: Call `EDMPApp.SaveDocumentationOverview`, then retrieve via `EDMPApp.GetIncompleteDocumentationOverviews` with `DMPLabelingValue = "KHK"` and verify training field values are correctly persisted.
5. **Negative Test**: Submit a documentation overview with missing Schulung selection and confirm `CheckPlausibility` flags the specific mandatory field.
