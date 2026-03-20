# Matching: etl

## File
`backend-core/service/etl/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST510](../user-stories/US-VSST510.md) | Regular medication database updates at least every 14 days | AC1 (partial) |

## Evidence
- `main.go` lines 20-27: ETL `main()` resolves `ETLBuilderMod` and calls `m.Process(titanCtx)` -- runs the ETL pipeline to synchronize data from MongoDB to PostgreSQL (matches AC1 partial for [US-VSST510](../user-stories/US-VSST510.md))
- `share/share.go` lines 31-59: `ETLBuilderMod` constructs the ETL manager with multiple data processors including `NewPatientETL`, `NewScheinETL`, `NewTimelineETL`, `NewHimiPrescriptionETL`, `NewPrescribedHeimiETL`, `NewPatientBillETL`, `NewBillingHistoryETL`, and a global process `NewSdebmCatalogsETL` for catalog synchronization (matches AC1 partial for [US-VSST510](../user-stories/US-VSST510.md))
- `share/share.go` line 56: `builder.NewSdebmCatalogsETL(postgresDb, share.CatalogSdebmServiceMod.Resolve())` -- catalog ETL supports importing updated catalog data including medication catalogs (matches AC1 partial for [US-VSST510](../user-stories/US-VSST510.md))

## Coverage
- Partial Match -- The ETL service provides data migration and synchronization infrastructure, including catalog ETL (`SdebmCatalogsETL`) that can import updated medication data. However, the automated scheduling of medication database updates every 14 days (or quarterly minimum) per AVWG P2-130 is a deployment/operations concern not implemented as a scheduled task within the codebase.
