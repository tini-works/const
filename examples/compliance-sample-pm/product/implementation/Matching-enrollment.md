# Matching: enrollment

## File
`backend-core/app/app-core/api/enrollment/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1107](../user-stories/US-VSST1107.md) | PraCMan-Cockpit launch for contract participants | AC1 (partial) |
| [US-VSST1231](../user-stories/US-VSST1231.md) | Versorgungssteuerung functions for substitute physician | AC1 (partial) |
| [US-VSST537](../user-stories/US-VSST537.md) | Insurance-specific drug categories display | (infrastructure only) |
| [US-VSST538](../user-stories/US-VSST538.md) | Contract-specific prescription data requirements | AC1 (partial) |

## Evidence
- `enrollment.d.go` lines 115-142: `EnrollmentApp` interface defines comprehensive contract enrollment management including `CheckParticipation`, `CreatePatientEnrollment`, `GetPatientEnrollment`, `UpdatePatientEnrollment`, `SendParticipation` -- identifies contract participants (matches AC1 of [US-VSST1107](../user-stories/US-VSST1107.md))
- `enrollment.d.go` lines 32-45: `CheckParticipationRequest` includes `DoctorId`, `PatientId`, `ContractId`, `IkNumber`, `InsuranceNumber` -- supports contract participant identification with doctor context (matches AC1 of [US-VSST1231](../user-stories/US-VSST1231.md) partially, DoctorId enables multi-doctor support)
- `enrollment.d.go` lines 47-51: `GetContractInformationFromAppCoreRequest` includes `ContractType` and `IsTerminated` fields -- supports contract-specific data handling (matches AC1 of [US-VSST538](../user-stories/US-VSST538.md) partially)
- `enrollment.d.go` lines 125-128: `GetContractInformationFromAppCore`, `GetFavContractInformationFromAppCore`, `GetHzvContractFromHpmService`, `GetContractsInformationFromHpmService` -- provides contract information lookup for both HZV and FAV contracts
- `enrollment.d.go` lines 129-131: `ActionOnHzvContract`, `ActionOnFavContract`, `ActionOnFavContractGroup` -- supports contract actions
- `enrollment.d.go` lines 105-110: `CheckPotentialVerah`, `IsPracticeSupportCompliance`, `IsPracticeSupportHpmFunction` -- compliance and HPM function support verification
- `enrollment.d.go` line 136: `Prescribe` method -- supports prescription within enrollment context

## Coverage
- Partial Match: The enrollment package provides comprehensive contract participant management and HPM integration but does not specifically implement PraCMan-Cockpit parameter passing ([US-VSST1107](../user-stories/US-VSST1107.md) gap), explicit Stellvertreterarzt function parity enforcement ([US-VSST1231](../user-stories/US-VSST1231.md) gap), or contract-specific prescription data requirement enforcement ([US-VSST538](../user-stories/US-VSST538.md) gap). The package serves as infrastructure for these requirements.
