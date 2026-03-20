# Matching: settings

## File
`backend-core/app/app-core/api/settings/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1106](../user-stories/US-VSST1106.md) | Manage PraCMan-Cockpit URL | AC1 (partial) |
| [US-VSST1107](../user-stories/US-VSST1107.md) | Launch PraCMan-Cockpit for contract participants | AC1 (partial) |

## Evidence
- `settings.d.go` lines 44-50: `SaveSettingsRequest` with `Feature`, `Settings` (map[string]string), `Signal`, `BsnrId` -- generic settings save capability that can store any URL including PraCMan-Cockpit URL (matches AC1 partial for [US-VSST1106](../user-stories/US-VSST1106.md))
- `settings.d.go` lines 59-65: `GetSettingsRequest/GetSettingsResponse` retrieves settings by feature key -- enables reading the PraCMan-Cockpit URL setting (matches AC1 partial for [US-VSST1106](../user-stories/US-VSST1106.md), [US-VSST1107](../user-stories/US-VSST1107.md))
- `settings.d.go` lines 191-197: `SettingsApp` interface provides `SaveSettings`, `RemoveSettings`, `GetSettings`, `GetSetting`, `HandleEventSettingChange` -- full CRUD for system settings (matches AC1 partial for [US-VSST1106](../user-stories/US-VSST1106.md))
- `settings.d.go` lines 159-164: `SelectiveContractsKey` enum defines `SelectiveContracts_ArribaPath` and `SelectiveContracts_BillingSubmission` setting keys -- demonstrates contract-specific settings pattern (matches AC1 partial for [US-VSST1106](../user-stories/US-VSST1106.md), [US-VSST1107](../user-stories/US-VSST1107.md) -- similar pattern needed for PraCMan URL)
- `settings.d.go` lines 72-76: `EventSettingChange` with `Feature`, `Settings`, `BsnrId` -- enables real-time notification when settings change (matches AC1 partial for [US-VSST1106](../user-stories/US-VSST1106.md))

## Coverage
- Partial Match -- The package provides a generic settings infrastructure (save, get, remove, change notification) that can store the PraCMan-Cockpit URL. The `SelectiveContractsKey` enum already defines selective contract settings keys (ArribaPath, BillingSubmission), demonstrating the pattern. However, a dedicated PraCMan-Cockpit URL setting key is not yet defined, and the specific launching of PraCMan-Cockpit with AKA interface specification parameters is not implemented.
