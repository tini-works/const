# Matching: catalog_sdebm

## File
`backend-core/app/app-core/api/catalog_sdebm/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST540](../user-stories/US-VSST540.md) | Display 'rabattiert' instead of price for Gruen medications | AC1 |

## Evidence
- `catalog_sdebm.d.go` lines 171-182: `SdebmCatalogApp` interface defines `GetSdebmCatalogs`, `GetSdebmCatalogByCode`, `CreateSdebmCatalogItem`, `UpdateSdebmCatalogItem`, `DeleteEbmCatalogById`, `GetRecommandedOpsByCode`, `GetRecommandedGnrByCode`, `GetBillingIcdByCode`, and `GetActionChainServiceCodes` providing comprehensive EBM catalog management (matches AC1 infrastructure of [US-VSST540](../user-stories/US-VSST540.md))
- `catalog_sdebm.d.go` lines 51-62: `GetSdebmCatalogsRequest` with `SelectedDate`, `Value`, `IsOnlySelfCreated`, `Pagination`, `RegionalKv` and response with `Items` and `Total` provides catalog search infrastructure (matches AC1 of [US-VSST540](../user-stories/US-VSST540.md))
- `catalog_sdebm.d.go` lines 72-76: `GetInfoByCodeRequest` with `Code`, `EncounterDate`, `OrganizationId` enables code-based catalog lookups used in medication/service displays (matches AC1 of [US-VSST540](../user-stories/US-VSST540.md))
- `catalog_sdebm.d.go` lines 107-119: `GetActionChainServiceCodesRequest` with `ServiceCodes`, `GoaServiceCodes`, `RegionalKv`, `ScheinMainGroup`, `Year`, `Quarter` validates service code combinations (supports [US-VSST540](../user-stories/US-VSST540.md) catalog search infrastructure)

## Coverage
- Partial Match: The catalog_sdebm package provides the EBM service catalog search and management infrastructure that underlies medication and service displays. However, the specific requirement to display 'rabattiert' instead of price for Gruen category medications is a frontend/HPM display concern not directly implemented in this backend catalog package. The catalog provides the data layer; the price suppression logic for Gruen medications must be applied at the presentation layer.
