# Matching: patient_encounter

## File
`backend-core/app/app-core/api/patient_encounter/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST976](../user-stories/US-VSST976.md) | Display count of transmitted prescriptions after real-data transmission | (infrastructure only) |

## Evidence
- `patient_encounter.d.go` lines 190-205: `PatientEncounterApp` interface defines `GetContractDoctorGroup`, `GetEbms`, `SearchEbmsComposer`, `GetMaterialCosts`, `GetAdditionalInfoFieldsKv`, `GetAdditionalInfoFieldsSelectiveContract`, `GetPseudoGnr`, `GetAdditionalInfoFields`, `SearchDiagnosis`, `SearchOps`, `SearchOmimG`, `SearchOmimP`, `SearchSdva`, `SearchHgnc` -- provides encounter-level clinical data management
- `patient_encounter.d.go` lines 44-46: `GetEbmsRequest` with `SelectedDate` -- EBM service code retrieval by date
- `patient_encounter.d.go` lines 86-94: `SearchEbmsRequest`/`SearchEbmsResponse` with `SelectedDate`, `Query`, `OrganizationId` -- EBM search with organization context
- `patient_encounter.d.go` lines 96-100: `SearchDiagnosisRequest` with `Query`, `SelectedDate`, `Catalog`, `DoctorSpecialistType` -- diagnosis search with specialist type filtering
- `patient_encounter.d.go` lines 60-67: `GetAdditionalInfoFieldsKvRequest` and `GetAdditionalInfoFieldsSelectiveContractRequest` -- supports both KV and selective contract additional info fields
- `patient_encounter.d.go` lines 73-84: `GetPseudoGnrRequest`/`GetPseudoGnrResponse` with `PseudoGNR` key-value pairs -- pseudo-GNR code management for billing

## Coverage
- Partial Match: The patient_encounter package provides clinical encounter data management including EBM service codes, diagnosis search, OPS codes, and additional info fields for both KV and selective contracts. However, the specific requirement from [US-VSST976](../user-stories/US-VSST976.md) (displaying count of transmitted prescriptions after real-data transmission, excluding test transmissions and deleted prescriptions) is a billing transmission concern not directly implemented in this package. The package is listed as relevant infrastructure but the transmission count logic resides in the billing/pvs_billing packages.
