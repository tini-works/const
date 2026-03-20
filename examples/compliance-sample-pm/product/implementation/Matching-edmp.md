# Matching: edmp

## File
`backend-core/app/app-core/api/edmp/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST592](../user-stories/US-VSST592.md) | DMP integration per KBV: DM1, DM2, KHK, Asthma, COPD, Brustkrebs | AC1, AC2, AC3, AC4 |
| [US-VSST1020](../user-stories/US-VSST1020.md) | eDMP transmission | AC1, AC2, AC3 |
| [US-VSST1547](../user-stories/US-VSST1547.md) | eDMP Diabetes Type 1 and Type 2 | AC1, AC2 |
| [US-VSST1749](../user-stories/US-VSST1749.md) | eDMP workflow | AC1, AC2, AC3 |
| [US-VSST677](../user-stories/US-VSST677.md) | eDMP Koronare Herzkrankheit | AC1, AC2 |

## Evidence
- `edmp.d.go` lines 473-497: `EDMPApp` interface defines `Enroll`, `Terminate`, `CreateDocument`, `GetEnrollment`, `SaveDocumentationOverview`, `FinishDocumentationOverview`, `CheckPlausibility`, `CheckValidationForDMPBilling`, `SendKIMMail`, `SendKVForDMPBilling`, `GetDMPBillingHistories`, `ZipDMPBillingHistories`, and many more -- implementing the complete eDMP lifecycle (matches AC1 of [US-VSST592](../user-stories/US-VSST592.md), [US-VSST1749](../user-stories/US-VSST1749.md))
- `edmp.d.go` lines 37-43: `EnrollRequest` with `EnrollmentInfoRequest` and `EnrollResponse` with `Ids` handles DMP enrollment for all DMP types (matches AC1 of [US-VSST592](../user-stories/US-VSST592.md), AC1 of [US-VSST1547](../user-stories/US-VSST1547.md), AC1 of [US-VSST677](../user-stories/US-VSST677.md))
- `edmp.d.go` lines 59-65: `DMPAdvanceFilters` with `DMPLabelingValues` field supports filtering by DMP type (DM1, DM2, KHK, Asthma, COPD, Brustkrebs) via labeling values (matches AC2 of [US-VSST592](../user-stories/US-VSST592.md))
- `edmp.d.go` lines 67-71: `TerminateRequest` with `EnrollmentId`, `DMPLabelingValue`, and `TerminateTime` handles DMP termination (matches AC1 of [US-VSST592](../user-stories/US-VSST592.md))
- `edmp.d.go` lines 73-80: `CreateDocumentRequest`/`CreateDocumentResponse` with `DocumentationOverview` and `CheckPlausibilityResponse` implements DMP documentation with plausibility validation (matches AC2 of [US-VSST1547](../user-stories/US-VSST1547.md), AC2 of [US-VSST677](../user-stories/US-VSST677.md))
- `edmp.d.go` lines 327-348: `CheckPlausibilityRequest` with `RelatedFields`, `DocumentType`, `DMPLabelingValue`, `DoctorId`, `PatientId`, `DMPCaseNumber`, `DocumentDate`, `ScheinId`, `DoctorRelationType`, `DMPVersion` implements comprehensive KBV-compliant plausibility checking (matches AC2 of [US-VSST1749](../user-stories/US-VSST1749.md))
- `edmp.d.go` lines 219-232: `CheckValidationForDMPBillingRequest`/`CheckValidationForDMPBillingResponse` with `Status`, `DMPBillingHistoryId`, `DMPBillingFiles`, `DMPBillingFieldsValidationResults`, `TransferLetters` implements DMP billing validation (matches AC1 of [US-VSST1020](../user-stories/US-VSST1020.md))
- `edmp.d.go` lines 274-288: `SendMailRequest` with `Quarter`, `Year`, `DoctorId`, `TypeOfBilling`, `KvConnectId`, `DMPBillingHistoryId`, `KimMailSettingId` and `SendMailResponse` handles KIM mail transmission to DMP-Datenstelle (matches AC2 of [US-VSST1020](../user-stories/US-VSST1020.md))
- `edmp.d.go` lines 290-297: `GetDMPBillingHistoriesRequest`/`GetDMPBillingHistoriesResponse` tracks DMP billing histories (matches AC3 of [US-VSST1020](../user-stories/US-VSST1020.md))
- `edmp.d.go` lines 358-364: `ZipDMPBillingHistoriesRequest`/`ZipDMPBillingHistoriesResponse` enables packaging DMP billing files for download (matches AC3 of [US-VSST1749](../user-stories/US-VSST1749.md))
- `edmp.d.go` lines 323-325: `SendMailRetryRequest` with `BillingHistoryId` supports retry of failed DMP transmissions (matches AC1 of [US-VSST1020](../user-stories/US-VSST1020.md))
- `edmp.d.go` lines 182-207: `DMPBillingValidationModel` with `DMPLabeling`, `DMPDocumentationTypeED/FD/PED`, `DataCenters` and `GetDMPBillingValidationListRequest`/`Response` provides per-patient DMP billing validation (matches AC4 of [US-VSST592](../user-stories/US-VSST592.md))
- `edmp.d.go` lines 464: `EVENT_OnPatientUpdate` integrates with patient profile updates for DMP data synchronization (matches AC3 of [US-VSST1749](../user-stories/US-VSST1749.md))

## Coverage
- Full Match: The edmp package provides a comprehensive eDMP system covering all matched user stories. It supports all 6 DMP types (DM1, DM2, KHK, Asthma, COPD, Brustkrebs) via DMPLabelingValue, implements enrollment/termination, KBV-compliant documentation with plausibility checking, DMP billing with validation, KIM mail transmission to DMP-Datenstelle, billing history tracking, and patient update integration. All acceptance criteria for [US-VSST592](../user-stories/US-VSST592.md), [US-VSST1020](../user-stories/US-VSST1020.md), [US-VSST1547](../user-stories/US-VSST1547.md), [US-VSST1749](../user-stories/US-VSST1749.md), and [US-VSST677](../user-stories/US-VSST677.md) are addressed.
