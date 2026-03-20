# Matching: service/arriba

## File
`backend-core/service/arriba/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST522](../user-stories/US-VSST522.md) | arriba target path | AC1 |
| [US-VSST523](../user-stories/US-VSST523.md) | arriba invocation | AC1 |

## Evidence
- `arriba_service.go` lines 195-209: `getArribaSettingPath()` retrieves the arriba path from settings using `SelectiveContracts_ArribaPath` key -- resolves the target path for arriba (matches AC1 for [US-VSST522](../user-stories/US-VSST522.md))
- `builder.go` lines 24-32: `BuildKonfiguration()` constructs `Konsultation` XML configuration using patient profile, employee profile, contract ID, and arriba path (matches AC1 for [US-VSST522](../user-stories/US-VSST522.md))
- `builder.go` lines 97-111: `buildSpeicherorte()` sets file paths for status, XML results, and PDF outputs (af, cvp, dep, dia, exp, mqu, ppi) based on the arriba path directory (matches AC1 for [US-VSST522](../user-stories/US-VSST522.md))
- `builder.go` lines 48-93: `buildParameter()` populates patient parameters (Vorname, Nachname, Geschlecht, Geburtsdatum, Plz), doctor parameters (Lanr, Bsnr, HaevgId), insurance parameters (KostentraegerId, VersNr, StatusArt, StatusBesPersGr, StatusDmp), medical data (Raucher, Koerpergroesse, Gewicht, BlutdruckSystolisch), and VertragsId (matches AC1 for [US-VSST523](../user-stories/US-VSST523.md))
- `arriba_service.go` lines 211-303: `StartSession()` checks patient eligibility via `checkPatientEligibleForArriba()`, retrieves arriba path from settings, generates presigned MinIO URLs, builds arriba XML config, and calls `OpenArriba()` asynchronously -- full arriba invocation with patient context (matches AC1 for [US-VSST523](../user-stories/US-VSST523.md))
- `arriba_service.go` lines 376-386: `OpenArriba()` delegates to companion service `GetArribaApp()` then calls `arribaApp.OpenArriba()` with config data and storage paths (matches AC1 for [US-VSST523](../user-stories/US-VSST523.md))
- `arriba_service.go` lines 411-439: `checkPatientEligibleForArriba()` verifies active HZV participation and checks contract supports VSST522 compliance via `CheckExistAnforderung` (matches AC1 for [US-VSST522](../user-stories/US-VSST522.md), [US-VSST523](../user-stories/US-VSST523.md))
- `arriba_service.go` lines 305-346: `UpdateArribaSessions()` polls MinIO for status files, parses XML status, updates arriba records and timeline entries -- session lifecycle management (matches AC1 for [US-VSST523](../user-stories/US-VSST523.md))

## Coverage
- Full Match -- The `service/arriba` package fully implements arriba target path resolution ([US-VSST522](../user-stories/US-VSST522.md)) via settings-based path configuration and the `buildSpeicherorte` builder, and arriba invocation with patient context ([US-VSST523](../user-stories/US-VSST523.md)) via `StartSession` which validates eligibility, builds XML configuration with patient/doctor/insurance data, and launches arriba through the companion service.
