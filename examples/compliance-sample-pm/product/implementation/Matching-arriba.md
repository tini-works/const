# Matching: arriba

## File
`backend-core/app/app-core/api/arriba/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST522](../user-stories/US-VSST522.md) | arriba target path | AC1, AC2 |
| [US-VSST523](../user-stories/US-VSST523.md) | arriba invocation | AC1, AC2, AC3 |

## Evidence
- `arriba.d.go` lines 29-31: `StartArribaRequest` struct with `PatientID *uuid.UUID` field provides patient context for arriba invocation (matches AC1 of [US-VSST523](../user-stories/US-VSST523.md))
- `arriba.d.go` lines 59-63: `ArribaApp` interface defines `StartArriba`, `RemoveArriba`, and `UpdateArribaSessions` methods implementing the full arriba lifecycle (matches AC1 of [US-VSST522](../user-stories/US-VSST522.md), AC2 of [US-VSST523](../user-stories/US-VSST523.md))
- `arriba.d.go` lines 37-40: `EventStartArribaApp` struct with `StartSuccess` and `ErrorMessage` fields provides launch success/failure notification (matches AC3 of [US-VSST523](../user-stories/US-VSST523.md))
- `arriba.d.go` lines 48-53: NATS event constants `EVENT_StartArriba`, `EVENT_RemoveArriba`, `EVENT_UpdateArribaSessions` register the arriba target path resolution endpoints (matches AC1 of [US-VSST522](../user-stories/US-VSST522.md))
- `arriba.d.go` lines 85-92: Router registers all arriba endpoints with authentication and `CARE_PROVIDER_MEMBER` authorization (matches AC2 of [US-VSST522](../user-stories/US-VSST522.md))
- `arriba.d.go` lines 163-165: `NotifyStartArribaApp` publishes arriba launch events to subscribers (matches AC3 of [US-VSST523](../user-stories/US-VSST523.md))

## Coverage
- Full Match: Both [US-VSST522](../user-stories/US-VSST522.md) and [US-VSST523](../user-stories/US-VSST523.md) acceptance criteria are fully addressed by the arriba API package. The package provides target path resolution via StartArriba, patient context invocation via PatientID, session management via UpdateArribaSessions/RemoveArriba, and event notification via EventStartArribaApp.
