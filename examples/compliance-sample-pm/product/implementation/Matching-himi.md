# Matching: himi

## File
`backend-core/app/app-core/api/himi/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST623](../user-stories/US-VSST623.md) | Integrate Hilfsmittelkatalog from AKA-Basisdatei | AC1 |
| [US-VSST624](../user-stories/US-VSST624.md) | Multi-criteria Hilfsmittel search | AC1, AC2 |
| [US-VSST625](../user-stories/US-VSST625.md) | Product type (7-digit) vs individual product (10-digit) prioritization | AC1 (partial) |
| [US-VSST626](../user-stories/US-VSST626.md) | Integrate steuerbare Hilfsmittel list | AC1 |
| [US-VSST627](../user-stories/US-VSST627.md) | Check 7-digit Positionsnummer against steuerbare list | AC1 |
| [US-VSST628](../user-stories/US-VSST628.md) | Print Merkblatt Versicherter Hilfsmittel | AC1 (partial) |
| [US-VSST629](../user-stories/US-VSST629.md) | Check FRAGEBOGEN column for questionnaire requirement | AC1 (partial) |
| [US-VSST630](../user-stories/US-VSST630.md) | Validate steuerbare Hilfsmittel questionnaire | (not implemented) |
| [US-VSST631](../user-stories/US-VSST631.md) | Display fax instruction hint for steuerbare Hilfsmittel | (not implemented) |
| [US-VSST633](../user-stories/US-VSST633.md) | Minimum fields for Hilfsmittel prescriptions | AC1 (partial) |
| [US-VSST784](../user-stories/US-VSST784.md) | Display PIM drug labels | (infrastructure only) |
| [US-VSST854](../user-stories/US-VSST854.md) | Priscus-Liste markings in medication recommendations | (infrastructure only) |
| [US-VSST855](../user-stories/US-VSST855.md) | Festbetragskennzeichnung and Zuzahlung display | (infrastructure only) |
| [US-VSST858](../user-stories/US-VSST858.md) | Co-payment (Zuzahlung) display | (infrastructure only) |

## Evidence
- `himi.d.go` lines 94-106: `HimiApp` interface defines `SearchGruppe`, `SearchOrt`, `SearchArt`, `SearchOrtByGruppe`, `SearchUnterByGruppeOrt`, `SearchControllableHimi`, `SearchHimiMatchingTable`, `SearchProductByBaseAndArt`, `Prescribe`, `GetPrescribe`, `Print` -- comprehensive Hilfsmittelkatalog with multi-criteria search (matches AC1 of [US-VSST623](../user-stories/US-VSST623.md), AC1+AC2 of [US-VSST624](../user-stories/US-VSST624.md))
- `himi.d.go` lines 32-36: `BaseHimiSearch` struct with `Gruppe` (int32), `Ort` (int32), `Unter` (int32) -- hierarchical HIMI catalog navigation supporting 7-digit Positionsnummer structure (matches AC1 of [US-VSST625](../user-stories/US-VSST625.md) partially)
- `himi.d.go` lines 53-62: `SearchArtType` enum with values `THESAURUS`, `PRODUCT_GROUP`, `LOCATION`, `PRODUCT_TYPE`, `MANUFACTURER` -- all required search criteria types (matches AC1 of [US-VSST624](../user-stories/US-VSST624.md))
- `himi.d.go` lines 38-41: `SearchArtRequest` with `SearchValue` and `SearchArtType` -- free-text search across all search types
- `himi.d.go` line 100: `SearchControllableHimi` method -- dedicated endpoint for steuerbare Hilfsmittel list lookup (matches AC1 of [US-VSST626](../user-stories/US-VSST626.md))
- `himi.d.go` line 101: `SearchHimiMatchingTable` method -- matching table lookup for steuerbare Hilfsmittel verification (matches AC1 of [US-VSST627](../user-stories/US-VSST627.md))
- `himi.d.go` line 103: `Prescribe` method -- creates Hilfsmittel prescriptions with required data (matches AC1 of [US-VSST633](../user-stories/US-VSST633.md) partially)
- `himi.d.go` lines 43-50: `PrintRequest` with `PrescriptionId`, `DoctorId`, `PrintOption`, `PatientId`, `HasSupportForm907`, `BsnrId` -- prescription printing with support form option (matches AC1 of [US-VSST628](../user-stories/US-VSST628.md) partially)
- `mapper.go` lines 55-88: `SearchArtRequest.ToBaseRequest()` method parses search values into `Gruppe`/`Ort`/`Unter`/`ArtId` components with leading zero normalization -- supports both 7-digit and 10-digit Positionsnummer parsing (matches AC1 of [US-VSST625](../user-stories/US-VSST625.md))

## Coverage
- Partial Match: The himi package implements comprehensive Hilfsmittelkatalog integration with multi-criteria search (THESAURUS, product group, location, product type, manufacturer), steuerbare Hilfsmittel list lookup, matching table verification, prescription creation, and printing. However, the following are not fully verified: workflow step separation between 7-digit and 10-digit prescriptions ([US-VSST625](../user-stories/US-VSST625.md) AC2), specific Merkblatt document template ([US-VSST628](../user-stories/US-VSST628.md)), FRAGEBOGEN column check logic ([US-VSST629](../user-stories/US-VSST629.md)), questionnaire validation rules ([US-VSST630](../user-stories/US-VSST630.md)), fax instruction hint display ([US-VSST631](../user-stories/US-VSST631.md)), minimum field validation with warnings ([US-VSST633](../user-stories/US-VSST633.md) AC2). The PIM/Priscus and Festbetrag/Zuzahlung stories ([US-VSST784](../user-stories/US-VSST784.md), [US-VSST854](../user-stories/US-VSST854.md), [US-VSST855](../user-stories/US-VSST855.md), [US-VSST858](../user-stories/US-VSST858.md)) are HPM-related features not implemented in the himi package directly.
