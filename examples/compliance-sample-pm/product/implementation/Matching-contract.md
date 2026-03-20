# Matching: contract

## File
`backend-core/app/app-core/api/contract/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST518](../user-stories/US-VSST518.md) | Allow transmission for prescriptions before transmission start date | AC1 |
| [US-VSST1548](../user-stories/US-VSST1548.md) | Retroactive transmission from GueltigAbReferenzdatum | AC1, AC2 |
| [US-VSST538](../user-stories/US-VSST538.md) | Contract-specific prescription data requirements | AC1 |
| [US-VSST539](../user-stories/US-VSST539.md) | Display 'rabattiert' for Gruen/Blau medications per contract | AC1 |

## Evidence
- `contract.d.go` lines 222-226: `ContractApp` interface defines `GetContracts`, `GetContractById`, and `GetContractsHasFunctions` providing contract metadata access (matches AC1 of [US-VSST518](../user-stories/US-VSST518.md), [US-VSST1548](../user-stories/US-VSST1548.md), [US-VSST538](../user-stories/US-VSST538.md), [US-VSST539](../user-stories/US-VSST539.md))
- `contract.d.go` lines 30-37: `ContractMetaData` struct with `ContractId`, `ContractName`, `ContractType`, `ChargeSystems`, `KvRegion`, and `ModuleChargeSystems` provides contract identification and metadata (matches AC1 of [US-VSST538](../user-stories/US-VSST538.md))
- `contract.d.go` lines 47-54: `ContractDetails` struct with `Identification`, `ChargeSystems`, `ModuleChargeSystems`, `Functions`, and `HpmFunctions` provides detailed contract configuration including HPM function types (matches AC1 of [US-VSST518](../user-stories/US-VSST518.md))
- `contract.d.go` lines 63-70: `ContractData` struct with `Code`, `Description`, `ValidFrom`, `ValidTo`, `Rules`, and `Conditions` defines service-level contract rules with date-based validity (matches AC1 of [US-VSST518](../user-stories/US-VSST518.md), AC1 of [US-VSST1548](../user-stories/US-VSST1548.md))
- `contract.d.go` lines 102-107: `ContractRules` struct with `ExcludedServices`, `IncludedDiagnose`, `RequiredInformation`, and `DoctorFunctionTypes` defines the contract-specific validation rules (matches AC1 of [US-VSST538](../user-stories/US-VSST538.md))
- `contract.d.go` lines 114-130: `ContractConditions` with `KvRegionInclusions` and `IKGroupInclusion` defines geographic and IK-based conditions per contract (matches AC1 of [US-VSST539](../user-stories/US-VSST539.md))
- `contract.d.go` lines 137-139: `GetContractsRequest` with `SelectedDate` enables date-based contract retrieval supporting the GueltigAbReferenzdatum lookup (matches AC1 of [US-VSST1548](../user-stories/US-VSST1548.md))
- `contract.d.go` lines 145-148: `GetContractByIdRequest` with `SelectedDate` and `ContractId` enables specific contract detail retrieval (matches AC2 of [US-VSST1548](../user-stories/US-VSST1548.md))
- `contract.d.go` lines 150-156: `GetContractsHasFunctionsRequest` with `FunctionIds` enables querying contracts by supported functions (matches AC1 of [US-VSST518](../user-stories/US-VSST518.md))
- `contract.d.go` lines 172-206: `HpmFunctionType` enum constants including `StarteVerordnungsdatenUebermittlung`, `StarteAbrechnung`, `LiefereArzneimittelInformationen`, and `LiefereArzneimittelListe` define the HPM functions available per contract (matches AC1 of [US-VSST518](../user-stories/US-VSST518.md), AC1 of [US-VSST539](../user-stories/US-VSST539.md))

## Coverage
- Partial Match: The contract package provides the authoritative source for Selektivvertragsdefinition data including date-based validity, charge systems, service rules, conditions, and HPM function types. This is the foundation for enforcing contract-specific prescription data requirements ([US-VSST538](../user-stories/US-VSST538.md)), date-based transmission rules ([US-VSST518](../user-stories/US-VSST518.md), [US-VSST1548](../user-stories/US-VSST1548.md)), and contract-specific medication display rules ([US-VSST539](../user-stories/US-VSST539.md)). However, the actual enforcement of GueltigAbReferenzdatum/GueltigBisReferenzdatum boundaries and the 'rabattiert' display logic are implemented in consuming packages (billing, frontend) rather than in this package directly.
