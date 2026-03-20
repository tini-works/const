# Matching: patient_participation

## File
`backend-core/app/app-core/api/patient_participation/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1107](../user-stories/US-VSST1107.md) | PraCMan-Cockpit launch for contract participants | AC1 (partial) |
| [US-VSST537](../user-stories/US-VSST537.md) | Insurance-specific drug categories display | AC1 (partial) |
| [US-VSST538](../user-stories/US-VSST538.md) | Contract-specific prescription data requirements | AC1 (partial) |

## Evidence
- `patient_participation.d.go` lines 66-71: Defines `PatientParticipationApp` interface with `GetPatientParticipation`, `CheckPatientParticipation`, `HandleEventPatientParticipationChange`, and `GetDoctorsCanTreatAsDeputy` methods -- provides the contract participation checking infrastructure referenced by all three stories (matches AC1 partial for [US-VSST1107](../user-stories/US-VSST1107.md), [US-VSST537](../user-stories/US-VSST537.md), [US-VSST538](../user-stories/US-VSST538.md))
- `patient_participation.d.go` lines 33-36: `EventPatientParticipationChange` struct carries `PatientId` and `ContractId`, enabling downstream systems to react to participation changes (matches AC1 partial for [US-VSST538](../user-stories/US-VSST538.md))
- `patient_participation.d.go` lines 38-45: `GetDoctorsCanTreatAsDeputyRequest/Response` provides contract-scoped doctor lookup by `DoctorId` and `ContractId` (matches AC1 partial for [US-VSST1107](../user-stories/US-VSST1107.md))
- `patient_participation.d.go` lines 106-115: Subscribes to `PatientParticipationChange` events for real-time participation state propagation (matches AC1 partial for [US-VSST538](../user-stories/US-VSST538.md))

## Coverage
- Partial Match -- The package provides contract participation identification and checking but does not directly implement PraCMan-Cockpit launching ([US-VSST1107](../user-stories/US-VSST1107.md)), insurance-specific drug category display ([US-VSST537](../user-stories/US-VSST537.md)), or contract-specific prescription data enforcement ([US-VSST538](../user-stories/US-VSST538.md)). It serves as a foundational dependency for these features.
