# Matching: edoku

## File
`backend-core/app/app-core/api/edoku/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST592](../user-stories/US-VSST592.md) | DMP integration per KBV: DM1, DM2, KHK, Asthma, COPD, Brustkrebs | AC3 |
| [US-VSST1547](../user-stories/US-VSST1547.md) | eDMP Diabetes Type 1 and Type 2 | AC2 |
| [US-VSST1749](../user-stories/US-VSST1749.md) | eDMP workflow | AC1, AC2 |
| [US-VSST677](../user-stories/US-VSST677.md) | eDMP Koronare Herzkrankheit | AC2 |

## Evidence
- `edoku.d.go` lines 140-150: `EdokuApp` interface defines `CreateDocument`, `GetEDOKUDocument`, `CheckPlausibility`, `SaveDocumentationOverview`, `FinishDocumentationOverview`, `IsCaseNumberExist`, `GetEdokuPatientInfo`, `DeleteDocumentationOverview`, and `UpdateStatusEdokuDocumentByIds` providing the complete eDoku documentation workflow (matches AC1 of [US-VSST1749](../user-stories/US-VSST1749.md), AC3 of [US-VSST592](../user-stories/US-VSST592.md))
- `edoku.d.go` lines 33-39: `CreateDocumentRequest` with `DocumentationOverview` and `CreateDocumentResponse` with `DocumentId` and `CheckPlausibilityResponse` implements document creation with automatic plausibility validation (matches AC2 of [US-VSST1749](../user-stories/US-VSST1749.md))
- `edoku.d.go` lines 47-68: `CheckPlausibilityRequest` with `RelatedFields`, `Field`, `DocumentType`, `DMPLabelingValue`, `DoctorId`, `PatientId`, `DMPCaseNumber`, `DocumentDate`, `ScheinId`, `DoctorRelationType`, `AdditionalContracts`, and `IsBillingCheck` provides comprehensive KBV-compliant plausibility checking (matches AC2 of [US-VSST1547](../user-stories/US-VSST1547.md), AC2 of [US-VSST677](../user-stories/US-VSST677.md))
- `edoku.d.go` lines 63-68: `CheckPlausibilityResponse` with `IsPlausible`, `FieldValidationResults`, `BillingFile`, and `XPMPFile` returns validation results and billing file generation (matches AC3 of [US-VSST592](../user-stories/US-VSST592.md))
- `edoku.d.go` lines 70-73: `UpdateDocumentationOverviewRequest` with `Id` and `DocumentationOverview` supports documentation updates (matches AC1 of [US-VSST1749](../user-stories/US-VSST1749.md))
- `edoku.d.go` lines 75-83: `GetEDOKUDocumentRequest` with `DMPLabelingValue`, `DocumentType`, `DocumentDate` retrieves eDoku documents by DMP type (matches AC2 of [US-VSST1547](../user-stories/US-VSST1547.md), AC2 of [US-VSST677](../user-stories/US-VSST677.md))
- `edoku.d.go` lines 94-100: `GetEdokuPatientInfoRequest`/`GetEdokuPatientInfoResponse` with `EdokuPatientOverviewList` provides patient-level eDoku overview (matches AC1 of [US-VSST1749](../user-stories/US-VSST1749.md))
- `edoku.d.go` lines 42-45: `EventEDokuDocumentStatusChanged` with `EdokuDocumentId` and `Status` tracks document status changes (matches AC2 of [US-VSST1749](../user-stories/US-VSST1749.md))
- `edoku.d.go` lines 106-109: `UpdateStatusEdokuDocumentByIdsRequest` with `DocumentIds` and `Status` enables batch status updates for eDoku documents (matches AC1 of [US-VSST1749](../user-stories/US-VSST1749.md))
- `edoku.d.go` lines 85-92: `IsCaseNumberExistRequest`/`IsCaseNumberExistResponse` validates case number uniqueness (matches AC1 of [US-VSST1749](../user-stories/US-VSST1749.md))

## Coverage
- Full Match: The edoku package provides the complete eDoku documentation workflow supporting all DMP types. It implements document creation with plausibility validation, documentation overview save/finish/delete lifecycle, KBV-compliant plausibility checking per DMP labeling value, eDoku patient info overview, document status tracking, and case number validation. This addresses the KBV-compliant documentation requirements for all DMP types including Diabetes Type 1/2 ([US-VSST1547](../user-stories/US-VSST1547.md)), KHK ([US-VSST677](../user-stories/US-VSST677.md)), and the full set ([US-VSST592](../user-stories/US-VSST592.md)).
