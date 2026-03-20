# Matching: patient_search

## File
`backend-core/app/app-core/api/patient_search/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1574](../user-stories/US-VSST1574.md) | VERAH TopVersorgt list | AC1 (partial) |

## Evidence
- `patient_search.d.go` lines 30-55: `PatientSearchingRequest` accepts `SearchingKeyword` and `SearchingType`; `PatientSearchingResponse` returns patient data including `Id`, `PatientNumber`, `FirstName`, `LastName`, `DOB`, `InsuranceNumber`, `Gender`, `TypeOfInsurance`, `InsuranceInfo` -- provides the patient listing and search infrastructure (matches AC1 partial for [US-VSST1574](../user-stories/US-VSST1574.md))
- `patient_search.d.go` lines 58-66: `SearchingType` enum supports `PatientName`, `PatientNumber`, `InsuranceNumber`, `Birthdate`, `AdditionalSKTInformation` search types (matches AC1 partial -- search infrastructure exists but no dedicated VERAH TopVersorgt filter type)
- `patient_search.d.go` lines 78-79: `PatientSearchApp` interface with `SearchPatients` method provides the search endpoint (matches AC1 partial for [US-VSST1574](../user-stories/US-VSST1574.md))

## Coverage
- Partial Match -- The package provides general patient search and listing capabilities but does not include a dedicated VERAH TopVersorgt patient list filter or status display. The specific VERAH TopVersorgt eligible patient list with status is not implemented.
