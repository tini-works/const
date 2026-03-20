# Matching: patient_sidebar

## File
`backend-core/app/app-core/api/patient_sidebar/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1390](../user-stories/US-VSST1390.md) | Preventive colonoscopy hint | AC1 (partial) |
| [US-VSST1555](../user-stories/US-VSST1555.md) | VERAH TopVersorgt hint | AC1 (partial) |

## Evidence
- `patient_sidebar.d.go` lines 32-34: `GetPermanentDiagnoseRequest` takes `PatientId` to retrieve patient-level diagnose data (matches AC1 partial -- sidebar provides patient context data)
- `patient_sidebar.d.go` lines 55-58: `PermanentDiagnoseResponse` returns `PatientId` and `Diagnoses` list -- provides patient clinical context in the sidebar view (matches AC1 partial for [US-VSST1390](../user-stories/US-VSST1390.md), [US-VSST1555](../user-stories/US-VSST1555.md))
- `patient_sidebar.d.go` lines 65-85: `P4ValidationRequest/Response` provides validation reports per quarter with `DiseaseAnalysisPatientResponse` -- existing sidebar validation infrastructure that could surface hints (matches AC1 partial for [US-VSST1390](../user-stories/US-VSST1390.md), [US-VSST1555](../user-stories/US-VSST1555.md))
- `patient_sidebar.d.go` lines 111-116: `PatientSidebarApp` interface exposes `GetPermanentDiagnose`, `GetP4ValidationReport`, `GetP4ValidationReportByQuarter`, `UpdatePermanentDiagnoseEndDate` -- sidebar data endpoints (matches AC1 partial)

## Coverage
- Partial Match -- The package provides sidebar patient context (diagnoses, validation reports) but does not include specific colonoscopy reminder hints ([US-VSST1390](../user-stories/US-VSST1390.md)) or VERAH TopVersorgt hints ([US-VSST1555](../user-stories/US-VSST1555.md)). These would need to be added as new sidebar elements based on patient eligibility criteria.
