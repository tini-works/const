# Matching: service/insurance

## File
`backend-core/service/insurance/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST538](../user-stories/US-VSST538.md) | Contract-specific prescription data requirements | AC1 (partial) |

## Evidence
- `insurance_common.d.go` lines 32-58: `InsuranceInfo` struct defines comprehensive insurance data including `InsuranceCompanyId`, `InsuranceCompanyName`, `IkNumber`, `InsuranceNumber`, `InsuranceStatus` (Mitglied/Familienmitglied/Rentner), `SpecialGroup`, `DMPLabeling`, `HaveCoPaymentExemptionTill`, `FeeSchedule`, `FeeCatalogue`, `Wop`, `ReadCardDatas` -- provides the insurance context needed for contract-specific prescription data (matches AC1 partial for [US-VSST538](../user-stories/US-VSST538.md))
- `insurance_common.d.go` lines 88-105: Insurance enums define `SpecialGroupDescription` (00, 04, 06, 07, 08, 09) and `InsuranceStatus` (Mitglied, Familienmitglied, Rentner) -- supports insurance-type-based prescription rules (matches AC1 partial for [US-VSST538](../user-stories/US-VSST538.md))
- `insurance_common.d.go` lines 75-85: `LHM` struct with `FirstICDCode`, `SecondICDCode`, `DiagnosisGroupCode`, `PrimaryRemediesPosition`, `ComplementaryRemediesPosition` -- Langfristige Heilmittelbehandlung data relevant to prescription requirements (matches AC1 partial for [US-VSST538](../user-stories/US-VSST538.md))
- `insurance_common.d.go` lines 60-73: `ReadCardModel` and `ProofOfInsurance` structs for card-based insurance verification data (matches AC1 partial for [US-VSST538](../user-stories/US-VSST538.md))

## Coverage
- Partial Match -- The package provides insurance data models (InsuranceInfo, LHM, insurance status/types) that supply the insurance context needed for contract-specific prescription data requirements. However, the specific enforcement of contract-dependent prescription data fields per Selektivvertrag is not directly implemented in this common data package.
