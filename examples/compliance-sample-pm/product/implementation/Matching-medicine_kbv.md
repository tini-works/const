# Matching: medicine_kbv

## File
`backend-core/app/app-core/api/medicine_kbv/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST510](../user-stories/US-VSST510.md) | Medication database updates at least every 14 days | AC1 (partial) |
| [US-VSST1543](../user-stories/US-VSST1543.md) | AVWG including ARV | AC1 (partial) |
| [US-VSST541](../user-stories/US-VSST541.md) | Insurance-specific recommendations for Rot/Orange/keine | AC1 (partial) |
| [US-VSST545](../user-stories/US-VSST545.md) | Display HPM recommendations in tabular ATC-grouped form | (infrastructure only) |
| [US-VSST863](../user-stories/US-VSST863.md) | Repeat prescription insurance-specific recommendations | AC1 (partial) |
| [US-VSST870](../user-stories/US-VSST870.md) | Automatic display of insurance-specific categories | (infrastructure only) |
| [US-VSST923](../user-stories/US-VSST923.md) | High-volume prescription control warning | (infrastructure only) |

## Evidence
- `medicine.kbv.d.go` lines 567-587: `MedicineKbvApp` interface defines `FindByID`, `FindByPZN`, `Search`, `GetANL`, `GetPriceComparison`, `HasSubstitution`, `GetAMR`, `GetGBADocument`, `GetTechInformation`, `GetARV`, `GetAlternativeDetails`, `GetIWWListeDetails`, `GetARVDocumentLink`, `CheckARVIndicationTreeExist`, `GetARVIndicationTree`, `GetIndicationDocumentLink`, `GetMoleculeDocumentLink`, `GetPackageSizes`, `GetMedicationByPzn`, `GetMedicationsByPackageSizeForPriceComparison` -- comprehensive KBV-compliant medication service
- `medicine.kbv.d.go` line 577: `GetARV` method -- specifically implements ARV (Arzneiverordnungs-Richtlinie) rule retrieval (matches AC1 of [US-VSST1543](../user-stories/US-VSST1543.md))
- `medicine.kbv.d.go` lines 581-583: `CheckARVIndicationTreeExist`, `GetARVIndicationTree` methods -- ARV indication tree navigation for checking prescription rules per ARV
- `medicine.kbv.d.go` line 574: `GetAMR` method -- AMR (Arzneimittelrichtlinie) document retrieval for AVWG compliance
- `medicine.kbv.d.go` line 573: `HasSubstitution` method -- checks whether a medication has substitution options (relates to [US-VSST541](../user-stories/US-VSST541.md), [US-VSST863](../user-stories/US-VSST863.md))
- `medicine.kbv.d.go` lines 30-41: `FindByIdRequest` with `Pzn`, `IkNumber`, `ReferenceDate`, `ContractId`, `IsSvPatient`, `Bsnr`, `Lanr`, `PatientId`, `IsPrivateSchein`, `DoctorId` -- medication lookup with full contract and insurance context for Selektivvertrag patients (matches AC1 of [US-VSST510](../user-stories/US-VSST510.md) partially)
- `medicine.kbv.d.go` lines 49-71: `SearchMedicineRequest` with `Type`, `Value`, `IsDiscount`, `IkNumber`, `IsSV`, `ContractId`, `ReferenceDate`, `Bsnr`, `Lanr`, `SearchModes` (TradeName, ActiveSubstanceName, Manufacturer), `IsMonoSearch`, `MoleculeIds`, `IsFavourite`, `PackageSizes` -- comprehensive medication search supporting insurance-specific and contract-specific filtering
- `medicine.kbv.d.go` lines 95-100: `HasSubstitutionRequest` with `Pzn`, `IkNumber`, `ContractId`, `ReferenceDate` -- substitution check with insurance context (relates to [US-VSST863](../user-stories/US-VSST863.md))
- `medicine.kbv.d.go` line 572: `GetPriceComparison` method -- price comparison for medication alternatives
- `medicine.kb.extend.go` lines 3-9: `IsSortAsc` method -- sorting support for medication search results

## Coverage
- Partial Match: The medicine_kbv package implements KBV-compliant medication search, lookup, and rule checking including ARV rules, AMR documents, substitution checking, price comparison, and ARV indication trees. It provides the AVWG foundation ([US-VSST1543](../user-stories/US-VSST1543.md)) and supports insurance-specific medication data retrieval with contract context. However, the full AVWG catalog enforcement completeness ([US-VSST527](../user-stories/US-VSST527.md)), the automated update scheduling ([US-VSST510](../user-stories/US-VSST510.md)), and the high-volume prescription threshold warnings ([US-VSST923](../user-stories/US-VSST923.md)) are not fully verified in this package alone.
