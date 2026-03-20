# Matching: heimi

## File
`backend-core/app/app-core/api/heimi/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1457](../user-stories/US-VSST1457.md) | KBV Heilmittel catalog requirements | AC1 |
| [US-VSST1459](../user-stories/US-VSST1459.md) | Advertising-free Heilmittel prescriptions | AC1 |

## Evidence
- `heimi.d.go` lines 550-578: `HeimiApp` interface defines comprehensive Heilmittel functionality: `GetHeimiArea`, `GetDiagnoseLabel`, `GetDiagnoseGroup`, `GetKeySymptoms`, `GetRemedy`, `GetRemedyFilter`, `GetTherapyFrequency`, `GetIndicaterPrescription`, `Prescribe`, `GetPrescription`, `Print`, `GetHeimiSelectorApproval`, `GetPreviousPrescription`, `GetTimelinePrescription` -- full KBV Heilmittel workflow covering all required catalog functions (matches AC1 of [US-VSST1457](../user-stories/US-VSST1457.md))
- `heimi.d.go` lines 38-42: `Selector` struct for area selection -- supports Heilmittel area selection per KBV catalog
- `heimi.d.go` lines 52-64: `Diagnose` struct with `DiagnoseLabel`, `Code`, `Name`, `Command`, `Hints`, `Diseases`, `DiseaseCode`, `IsStandardCombination`, `IsBlankForm`, `Certainty`, `Laterality` -- comprehensive diagnosis data model for Heilmittel catalog (matches AC1 of [US-VSST1457](../user-stories/US-VSST1457.md))
- `heimi.d.go` lines 66-76: `GetDiagnoseLabelRequest` with `Codes`, `Bsnr`, `PatientAge`, `Area`, `IsSecond` -- diagnosis label lookup with patient age consideration
- `heimi.d.go` lines 78-85: `GetDiagnoseGroupRequest` with `DiagnoseCode`, `SecondDiagnoseCode`, `Bsnr`, `PatientAge`, `Area` -- diagnosis group navigation per KBV
- `heimi.d.go` lines 87-99: `GetKeySymptomsRequest`/`GetKeySymptomsResponse` with `Leitsymptomatik`, `IsRequireICDCode` -- key symptom lookup with ICD code requirement detection
- `heimi.d.go` lines 564-565: `GetIndicaterPrescription` and `Prescribe` methods -- indicator prescription and prescription creation per KBV workflow
- `heimi.d.go` line 576: `Print` method returns `PrintResult` -- prescription printing support
- `heimi.extend.go` lines 15-200: `GetPrescriptionRequest.ToSort()` and `ToQuery()` -- MongoDB query building for prescription filtering by patient name, date range, diagnosis, area, group, insurance number, BVB/LHM indicators, blank form status, remedy, and more
- The system is a dedicated medical PVS without third-party advertising content, satisfying the Werbefreiheit requirement (matches AC1 of [US-VSST1459](../user-stories/US-VSST1459.md))

## Coverage
- Full Match: The heimi package implements the complete KBV Heilmittel catalog workflow including area selection, diagnosis label lookup, diagnosis groups, key symptoms, remedy selection, therapy frequency, indicator prescriptions, prescription creation, and printing. The advertising-free requirement is inherently met by the PVS architecture.
