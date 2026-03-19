## US-PSDV654 — KT master data file (ehd) must be supported

| Field | Value |
|-------|-------|
| **ID** | US-PSDV654 |
| **Traced from** | [PSDV654](../compliances/SV/PSDV654.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff (MFA), I want kT master data file (ehd) is supported, so that patient master data is pseudonymized correctly.

### Acceptance Criteria

1. Given a KT-Stammdatei (ehd), when imported, then all Kostenträger records are parsed and stored correctly

### Actual Acceptance Criteria

| Status | **Partially Implemented** |
|--------|--------------------------|

1. A `catalog_sdkt` service exists at `backend-core/app/app-core/internal/catalog_sdkt/application.go` with `SdktCatalogApp` providing methods: `SearchSdkt`, `SearchSdktByIKNumber`, `UniqCompanyByAccquiredCostUnit`, `GetSdktCatalogByVknr`, `CreateSdktCatalogItem`, and validation methods.
2. The SDKT catalog handles Kostentrager (KT) master data with search and CRUD operations.
3. Schema definitions for ehd format exist at `backend-core/tools/sdkrw/schema/ehd_root_V1.40.xsd` and related XSD files, plus generated models at `backend-core/tools/sdebm/model/ehd_root_v1.40.xsd__001.go`.
4. **Gap**: While the SDKT catalog service exists for managing KT data, no specific ehd file import pipeline was found. The ehd schema definitions and models exist in the tools directory, but an end-to-end import flow for KT-Stammdatei (ehd) files into the catalog_sdkt service is not clearly implemented.
