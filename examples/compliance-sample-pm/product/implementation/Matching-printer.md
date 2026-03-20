# Matching: printer

## File
`backend-core/app/app-core/api/printer/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST599](../user-stories/US-VSST599.md) | Employment data hint during AU/eAU issuance | AC1 (partial) |

## Evidence
- `printer.d.go` lines 69-75: `FindPrinterProfileGroupsByFormIdRequest/Response` retrieves printer profile groups by form ID -- relevant to AU/eAU form printing workflow (matches AC1 partial for [US-VSST599](../user-stories/US-VSST599.md))
- `printer.d.go` lines 77-83: `GetPrinterSettingByFormIdRequest/Response` retrieves printer settings by form ID, returning a `Form` object -- supports form-specific print configuration for AU certificates (matches AC1 partial for [US-VSST599](../user-stories/US-VSST599.md))
- `printer.d.go` lines 109-117: `PrinterApp` interface provides `AddPrinterProfile`, `UpdatePrinterProfile`, `FindPrinterProfiles`, `SignQz`, `FindPrinterProfileGroupsByFormId`, `GetPrinterSettingByFormId` -- comprehensive printer profile management (matches AC1 partial for [US-VSST599](../user-stories/US-VSST599.md))
- `printer.d.go` lines 50-55: `FindPrinterProfilesRequest` supports filtering by `OKV`, `IkNumber`, `ContractId` -- contract-aware printer profile lookup (matches AC1 partial for [US-VSST599](../user-stories/US-VSST599.md))

## Coverage
- Partial Match -- The package provides printer profile management and form-specific printer settings needed for AU/eAU printing. However, the specific employment data validation hint (empty or older than 1 year) before AU issuance is not implemented in the printer package -- that logic belongs to the eAU workflow layer.
