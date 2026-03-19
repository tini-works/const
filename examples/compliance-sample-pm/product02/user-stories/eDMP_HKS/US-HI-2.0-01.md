## US-HI-2.0-01 — When practice software generates eDMP HI export file, naming must follow KBV XML-Schnittstellen convention

| Field | Value |
|-------|-------|
| **ID** | US-HI-2.0-01 |
| **Traced from** | [HI-2.0-01](../../compliances/raw/eDMP-HKS/eDMP-HKS/Herzinsuffizienz/HI-2.0-01.md) |
| **Source** | KBV eDMP HI V1.03 (KBV_ITA_VGEX_Schnittstelle_eDMP_HI.pdf) |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice software, I want to generate eDMP Herzinsuffizienz export files with naming conventions per KBV XML-Schnittstellen, so that files are accepted by the KBV infrastructure without rejection.

### Acceptance Criteria

1. Given an eDMP HI documentation is exported, when the file is created, then the filename follows the KBV XML-Schnittstellen naming pattern
2. Given a file with incorrect naming, when validation is run, then an error is reported before transmission

### Actual Acceptance Criteria

1. **API Coverage**: The `EDMPApp.CreateDocument` endpoint (NATS topic `api.app.app_core.EDMPApp.CreateDocument`) generates Herzinsuffizienz export files with KBV-conformant naming when `DMPLabelingValue = "HERZINSUFFIZIENZ"` is specified in the `DocumentationOverview`.
2. **File Naming Validation**: The `EDMPApp.CheckPlausibility` endpoint validates that generated XML file names follow the KBV XML-Schnittstellen naming pattern before transmission; non-conforming names produce `FieldValidationResult` errors.
3. **Integration Verification**: Call `EDMPApp.FinishDocumentationOverview` with a complete Herzinsuffizienz documentation overview and verify the returned `CheckPlausibilityResponse.billingFile` has a correctly-named file.
4. **Negative Test**: Submit a `CreateDocumentRequest` with missing or malformed `DMPLabelingValue` and confirm the API returns a validation error before any file is created.
