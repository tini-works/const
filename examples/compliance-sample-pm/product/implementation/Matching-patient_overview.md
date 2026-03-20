# Matching: patient_overview

## File
`backend-core/app/app-core/api/patient_overview/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1574](../user-stories/US-VSST1574.md) | VERAH TopVersorgt list | AC1 (partial) |

## Evidence
- `patient_overview.d.go` lines 206-212: `PatientOverviewApp` interface defines `GetPatientOverview`, `GetPatientOverviewWithTotal`, `GetPatientOverviewContracts`, `GetPatientOverviewInsuranceNames`, `GetForm1450HandoverPatients` -- patient overview with filtering capabilities
- `patient_overview.d.go` lines 170-186: `QuickFilter` enum includes `Verah_All`, `Verah_Potential`, `Verah_Documented` -- dedicated VERAH quick filters that enable filtering the patient overview by VERAH status (matches AC1 of [US-VSST1574](../user-stories/US-VSST1574.md))
- `patient_overview.d.go` lines 134-138: `VerahRelatedIcd` struct with `Id`, `Code`, `Description`, `Chronic` -- tracks VERAH-related ICD codes and chronic disease indicators for VERAH eligibility
- `patient_overview.d.go` lines 38-42: `GetPatientOverviewRequest` with `Pagination`, `QuickFilter`, `AdvancedFilters` -- supports paginated patient overview retrieval with VERAH quick filters
- `patient_overview.d.go` lines 61-89: `PatientOverview` struct includes `PatientContracts`, `HasUhu35Service`, `Uhu35SubmissionDate`, `SubmitUhu35Status` -- comprehensive patient overview data with contract and service status
- `patient_overview.d.go` lines 91-100: `PatientContract` struct with `ContractId`, `ContractName`, `Status`, `HpmErrors`, `DoctorId`, `DoctorFunctionType`, `EnrolledBy`, `AssigneeId` -- contract enrollment details per patient
- `patient_overview.d.go` lines 128-132: `FilterData` struct with `FilterName`, `CompareMethod`, `Value` -- supports advanced filtering for patient lists
- `patient_overview.d.go` lines 173-176: Additional QuickFilter values `NotEnrolledHZV`, `NotSubmittedEnrollment`, `PendingContracts`, `SelectiveContractPatients` -- contract enrollment status filters

## Coverage
- Partial Match: The patient_overview package directly supports the VERAH TopVersorgt list through dedicated `Verah_All`, `Verah_Potential`, and `Verah_Documented` quick filters, along with the `VerahRelatedIcd` data structure for tracking VERAH-eligible patients by chronic ICD codes. The `GetPatientOverviewWithTotal` method returns a paginated, filtered patient list showing all eligible patients with their contract status. While the specific "TopVersorgt" label is not explicitly referenced, the VERAH filtering infrastructure covers the core requirement of listing VERAH-eligible patients with their status.
