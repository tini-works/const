# Matching: eau

## File
`backend-core/app/app-core/api/eau/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST621](../user-stories/US-VSST621.md) | Prevent AU/eAU when employment data missing or outdated | AC1 |
| [US-VSST622](../user-stories/US-VSST622.md) | Confirm employment data currency with timestamp | AC1 |
| [US-VSST623](../user-stories/US-VSST623.md) | Integrate Hilfsmittelkatalog from AKA-Basisdatei | -- |
| [US-VSST624](../user-stories/US-VSST624.md) | Support Hilfsmittel searches by multiple criteria | -- |

## Evidence
- `eau.d.go` lines 137-148: `EAUApp` interface defines `GetEAU`, `CreateEAU`, `SignAndSendEAU`, `RemoveEAU`, `CancelEAU`, `UpdateDocumentState`, `Print`, `OnPatientUpdate`, `RetryFailedSendAndCancelEAU`, and `GetEAUByFormId` providing complete AU/eAU lifecycle (matches AC1 of [US-VSST621](../user-stories/US-VSST621.md))
- `eau.d.go` lines 77-87: `CreateEAURequest` struct with `PatientId`, `ScheinId`, `DoctorId`, `FormMap`, `FormId`, and `PrescribeDate` validates required fields for eAU creation (matches AC1 of [US-VSST621](../user-stories/US-VSST621.md))
- `eau.d.go` lines 61-65: `SignAndSendEAURequest` with `DocumentIds`, `BsnrCode`, and `CardType` handles eAU signing and transmission (matches AC1 of [US-VSST621](../user-stories/US-VSST621.md))
- `eau.d.go` lines 71-75: `CancelEAURequest` with `DocumentIds`, `BsnrCode`, and `CardType` supports eAU cancellation (matches AC1 of [US-VSST621](../user-stories/US-VSST621.md))
- `eau.d.go` lines 41-46: `GetEAURequest` with `Pagination`, `Query`, `DateRange`, and `Statuses` filtering supports eAU list management (matches AC1 of [US-VSST621](../user-stories/US-VSST621.md))
- `eau.d.go` lines 145: `OnPatientUpdate` method handles patient profile change events, enabling revalidation when employment data changes (matches AC1 of [US-VSST622](../user-stories/US-VSST622.md))
- `eau.d.go` lines 97-103: `EventEAUChanged` and `EventEAUSent` event types provide eAU status change notifications (supports AC1 of [US-VSST621](../user-stories/US-VSST621.md))

## Coverage
- Partial Match: The eau package provides the complete eAU workflow (create, sign, send, cancel, print, retry). For [US-VSST621](../user-stories/US-VSST621.md), the CreateEAU endpoint with required fields and validation infrastructure supports blocking eAU issuance, but the specific employment data validation (blocking when employment status/type is not filled or not current) must be verified at the service implementation layer. For [US-VSST622](../user-stories/US-VSST622.md), the OnPatientUpdate hook provides integration capability, but the specific 'Datum letzte Ueberpruefung' field is in the patient_profile package, not eau. [US-VSST623](../user-stories/US-VSST623.md) and [US-VSST624](../user-stories/US-VSST624.md) are addressed by the himi package, not eau.
