# Matching: service/himi

## File
`backend-core/service/himi/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST858](../user-stories/US-VSST858.md) | Zuzahlung column for insurance-specific medication recommendations | AC1 (partial) |

## Evidence
- `api/service.d.go` lines 40-48: `SearchGruppeRequest/Response` provides Produktgruppe search (matches AC1 partial for [US-VSST858](../user-stories/US-VSST858.md) -- Hilfsmittel infrastructure)
- `api/service.d.go` lines 88-98: `SearchUnterByGruppeOrtRequest/Response` returns Untergruppe data with Gruppe and Ort context (matches AC1 partial for [US-VSST858](../user-stories/US-VSST858.md) -- hierarchical catalog)
- `api/service.d.go` lines 110-120: `SearchHimiMatchingTableRequest/Response` includes `ContractId` for contract-specific Hilfsmittel matching tables including `HilfsmittelMatchingtabelle` and `SteuerbareHilfsmittel` (matches AC1 partial for [US-VSST858](../user-stories/US-VSST858.md) -- contract-specific matching)
- `api/service.d.go` lines 146-164: `PrescribeRequest` includes `ContractType`, `ContractId`, `FormInfo`, `ScheinId` -- Hilfsmittel prescription with contract context (matches AC1 partial for [US-VSST858](../user-stories/US-VSST858.md))
- `api/service.d.go` lines 221-233: `HimiApp` interface provides `SearchGruppe`, `SearchOrt`, `SearchArt`, `SearchOrtByGruppe`, `SearchUnterByGruppeOrt`, `SearchControllableHimi`, `SearchHimiMatchingTable`, `SearchProductByBaseAndArt`, `Prescribe`, `GetPrescribe` (matches AC1 partial for [US-VSST858](../user-stories/US-VSST858.md))
- `app/application.go` lines 23-29: `NewHimirepo` initializes with `PostgresUrl`, `MMILicenseKey`, `MMIUsername`, and `PharmindexProServiceMod` -- MMI Pharmindex integration for medication data (matches AC1 partial for [US-VSST858](../user-stories/US-VSST858.md))

## Coverage
- Partial Match -- The package provides comprehensive Hilfsmittel (medical device) catalog search, contract-specific matching tables, and prescription workflows with MMI Pharmindex integration. However, the specific Zuzahlung (co-payment) column display for insurance-specific medication recommendations is not verified as a distinct feature in this package. The co-payment information from the Pruef- und Abrechnungsmodul requires HPM integration not directly present in the himi service.
