# Matching: service/contract

## File
`backend-core/service/contract/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST539](../user-stories/US-VSST539.md) | Display 'rabattiert' for Gruen/Blau medications | AC1 (partial) |

## Evidence
- `contract/service.go` lines 30-35: `Service` struct holds `repo`, `aka` (AKA model), `contractMapWithEnrollmentFormId`, and `icdCsv` -- manages contract definitions including Selektivvertragsdefinition metadata (matches AC1 partial for [US-VSST539](../user-stories/US-VSST539.md))
- `contract/service.go` lines 107-113: `GetContractDetailById()` and `GetContractByIds()` retrieve contract definitions -- enables contract-specific medication category lookup (matches AC1 partial for [US-VSST539](../user-stories/US-VSST539.md))
- `contract/service.go` lines 126-130: `GetSupportedContracts()` filters contracts by `contractIds`, `ikNumber`, and `contractType` -- enables IK-based contract filtering (matches AC1 partial for [US-VSST539](../user-stories/US-VSST539.md))
- `contract/service.go` lines 132-152: `GetAllHints()` retrieves hint attachments from contract definitions -- supports contract-level hint configuration (matches AC1 partial for [US-VSST539](../user-stories/US-VSST539.md))
- Contract directory contains `Selektivvertragsdefinition_V18.xsd`, `V20.xsd`, `V21.xsd`, `V22.xsd` and `AKA-Basisdatei.xsd` -- XSD schemas for parsing contract definitions that define medication categories per contract (matches AC1 partial for [US-VSST539](../user-stories/US-VSST539.md))

## Coverage
- Partial Match -- The package manages Selektivvertragsdefinition data and contract metadata, providing the contract-level configuration that determines which medication categories (Gruen, Blau) apply. However, the specific 'rabattiert' price replacement display logic for medications in categories Gruen and Blau is a frontend/HPM integration feature not directly implemented in the contract service.
