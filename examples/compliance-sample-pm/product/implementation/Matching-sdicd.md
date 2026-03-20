# Matching: sdicd

## File
`backend-core/app/app-core/api/sdicd/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST540](../user-stories/US-VSST540.md) | Display 'rabattiert' for Gruen category medications | AC1 (partial) |

## Evidence
- `sdicd.d.go` lines 30-39: `GetSdicdRequest` takes `SelectedDate`, `Limit`, `Skip`; `GetSdicdResponse` returns `IcdItems` list with `HasMore` pagination -- provides ICD-based catalog data access (matches AC1 partial for [US-VSST540](../user-stories/US-VSST540.md))
- `sdicd.d.go` lines 53-55: `SdicdApp` interface with `GetSdicd` method -- provides selective-contract ICD data lookup (matches AC1 partial for [US-VSST540](../user-stories/US-VSST540.md))
- `sdicd.d.go` line 13: Imports `common "github.com/silentium-labs/pvs/backend-core/service/domains/sdicd/common"` -- uses SDICD domain model with `IcdItem` type (matches AC1 partial for [US-VSST540](../user-stories/US-VSST540.md))

## Coverage
- Partial Match -- The package provides selective-contract ICD (SDICD) catalog data. While it supports the ICD code infrastructure that underpins medication category lookups, the specific 'rabattiert' price replacement for Gruen category medications in medication lists is a frontend/HPM integration feature not directly implemented in this package.
