# Matching: patient_profile

## File
`backend-core/app/app-core/api/patient_profile/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1212](../user-stories/US-VSST1212.md) | OTC on Kassenrezept for ages 12-17 | AC1 (partial), AC2 (partial) |
| [US-VSST1390](../user-stories/US-VSST1390.md) | Preventive colonoscopy hint | AC1 (partial) |
| [US-VSST1555](../user-stories/US-VSST1555.md) | VERAH TopVersorgt hint | AC1 (partial) |
| [US-VSST593](../user-stories/US-VSST593.md) | Document and modify employment data | AC1 (partial) |
| [US-VSST594](../user-stories/US-VSST594.md) | Display employment status during AU issuance | AC1 (partial) |
| [US-VSST848](../user-stories/US-VSST848.md) | Depression ICD hint on follow-up AU | AC1 (partial) |
| [US-VSST962](../user-stories/US-VSST962.md) | Hilfsmittelkatalog sorting | AC1 (partial) |
| [US-VSST976](../user-stories/US-VSST976.md) | Prescription transmission count display | AC1 (partial) |
| [US-VSST977](../user-stories/US-VSST977.md) | OTC exception age 18+ rule | AC1 (partial), AC2 (partial) |

## Evidence
- `patient_profile.d.go` lines 39-53: `PatientProfileResponse` struct includes `DateOfBirth` (line 43), `PatientMedicalData` (line 46), `PatientInfo` (line 47), `EmploymentInfoUpdatedAt` (line 48), and `MedicalDataUpdatedAt` (line 49) -- provides patient age data needed for [US-VSST1212](../user-stories/US-VSST1212.md), [US-VSST977](../user-stories/US-VSST977.md) age-based rules, and employment timestamp for [US-VSST593](../user-stories/US-VSST593.md)/[US-VSST594](../user-stories/US-VSST594.md)
- `patient_profile.d.go` lines 351-376: `PatientProfileApp` interface provides `GetPatientProfileById`, `GetPatientProfileByIds`, `CreatePatientProfileV2`, `UpdatePatientProfileV2`, `CreatePatientMedicalData`, `GetPatientMedicalData`, `UpdatePatientMedicalHistoryData` -- comprehensive patient data CRUD (matches AC1 for [US-VSST593](../user-stories/US-VSST593.md))
- `patient_profile.d.go` lines 157-163: `UpdatePatientProfileV2Request` includes `PatientMedicalData` field for medical data updates (matches AC1 partial for [US-VSST593](../user-stories/US-VSST593.md) employment/medical data editing)
- `patient_profile.d.go` lines 220-231: `EventPatientProfileChange` includes `EmploymentInfoUpdatedAt` and `MedicalDataUpdatedAt` timestamps, enabling downstream systems to detect when employment data was last updated (matches AC1 partial for [US-VSST594](../user-stories/US-VSST594.md))
- `patient_profile_extend.go` lines 10-24: `ToDocumentManagementPatient()` extracts `DateOfBirth` for downstream use (supports age calculation for [US-VSST1212](../user-stories/US-VSST1212.md), [US-VSST977](../user-stories/US-VSST977.md))
- `patient_profile.d.go` lines 70-77: `CheckPatientProfileHasEnrollment` verifies contract enrollment status (supports [US-VSST1390](../user-stories/US-VSST1390.md), [US-VSST1555](../user-stories/US-VSST1555.md) eligibility context)

## Coverage
- Partial Match -- The package provides patient profile data management including age (DateOfBirth), employment timestamps (EmploymentInfoUpdatedAt), and medical data. However, the specific business logic for age-based prescription rules ([US-VSST1212](../user-stories/US-VSST1212.md), [US-VSST977](../user-stories/US-VSST977.md)), colonoscopy hints ([US-VSST1390](../user-stories/US-VSST1390.md)), VERAH hints ([US-VSST1555](../user-stories/US-VSST1555.md)), depression AU hints ([US-VSST848](../user-stories/US-VSST848.md)), and employment data validation during AU ([US-VSST594](../user-stories/US-VSST594.md)) are not directly implemented in this package. The package serves as the data source for these features.
