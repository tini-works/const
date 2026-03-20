# Matching: erezept

## File
`backend-core/app/app-core/api/erezept/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST515](../user-stories/US-VSST515.md) | Prescription data transmission prerequisites | AC1 (partial) |
| [US-VSST550](../user-stories/US-VSST550.md) | Display substitution feasibility hint | (infrastructure only) |

## Evidence
- `erezept.d.go` lines 168-176: `ErezeptApp` interface defines `GetErezept`, `GetPdfUrl`, `SignAndSendERP`, `RemoveErezept`, `CreateBundles`, `PrescribeERP`, `ResendERP` -- implements the electronic prescription (eRezept) workflow with signing and transmission capabilities (matches AC1 of [US-VSST515](../user-stories/US-VSST515.md))
- `erezept.d.go` lines 86-96: `CreateBundlesRequest` requires `PatientId`, `DoctorId`, `FormInfos`, `TreatmentDoctorId`, `ScheinId` -- enforces required fields before bundle creation, serving as prerequisite validation (matches AC1 of [US-VSST515](../user-stories/US-VSST515.md))
- `erezept.d.go` lines 124-136: `PrescribeERPRequest` includes `HasSupportForm907` and `ErezeptRequestType` -- supports different prescription types and form requirements
- `erezept.d.go` lines 73-84: `SignAndSendERPRequest`, `AbortErezeptRequest`, `RemoveErezeptRequest` -- full lifecycle management of eRezept documents
- `erezept.d.go` lines 51-66: `ErezeptDto` includes `Patient`, `Doctor`, `MedicineInfo`, `Bundle`, `Status`, `Errors`, `IsEvdga` -- comprehensive prescription data structure with status tracking and error handling
- `erezept.d.go` lines 210-217: Router registration with `CARE_PROVIDER_MEMBER` security -- secured access to prescription functions

## Coverage
- Partial Match: The erezept package implements electronic prescription creation, signing, and transmission workflows. It provides prerequisite validation through required fields in request structs. However, the specific AKA-specified prerequisite checklist ([US-VSST515](../user-stories/US-VSST515.md)) and the substitution feasibility hint text ([US-VSST550](../user-stories/US-VSST550.md)) are not implemented in this package. [US-VSST550](../user-stories/US-VSST550.md) is a UI-level concern.
