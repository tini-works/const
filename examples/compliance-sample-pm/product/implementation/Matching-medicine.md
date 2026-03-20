# Matching: medicine

## File
`backend-core/app/app-core/api/medicine/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST510](../user-stories/US-VSST510.md) | Medication database updates at least every 14 days | AC1 (partial) |
| [US-VSST515](../user-stories/US-VSST515.md) | Prescription data transmission prerequisites | AC1 (partial) |
| [US-VSST516](../user-stories/US-VSST516.md) | Block prescription data transmission, support retroactive | AC1, AC2 (partial) |
| [US-VSST1212](../user-stories/US-VSST1212.md) | OTC on Kassenrezept for ages 12-17 | AC1 (partial) |
| [US-VSST522](../user-stories/US-VSST522.md) | arriba target path | (infrastructure only) |
| [US-VSST523](../user-stories/US-VSST523.md) | arriba invocation | (infrastructure only) |
| [US-VSST527](../user-stories/US-VSST527.md) | KBV AVWG prescription catalog enforcement | AC1 (partial) |
| [US-VSST530](../user-stories/US-VSST530.md) | Prevent transmission of Hilfsmittelverordnungen | AC1 (partial) |
| [US-VSST532](../user-stories/US-VSST532.md) | Prescription data structure | AC1 |
| [US-VSST537](../user-stories/US-VSST537.md) | Insurance-specific drug categories display | AC1 (partial) |
| [US-VSST540](../user-stories/US-VSST540.md) | Display 'rabattiert' for Gruen medications | (not implemented) |
| [US-VSST541](../user-stories/US-VSST541.md) | Retrieve insurance-specific recommendations for Rot/Orange/keine | AC1 (partial) |
| [US-VSST543](../user-stories/US-VSST543.md) | HPM endpoints with Hauptkassen-IK | (infrastructure only) |
| [US-VSST545](../user-stories/US-VSST545.md) | Display HPM recommendations in tabular ATC-grouped form | (infrastructure only) |
| [US-VSST548](../user-stories/US-VSST548.md) | Sort medications by Gruen/Blau categories | (not implemented) |
| [US-VSST550](../user-stories/US-VSST550.md) | Display substitution feasibility hint | (not implemented) |
| [US-VSST551](../user-stories/US-VSST551.md) | Display Pruef- und Abrechnungsmodul messages for Gruen/Blau | (infrastructure only) |
| [US-VSST590](../user-stories/US-VSST590.md) | Insurance contact data for care coordination | (infrastructure only) |
| [US-VSST593](../user-stories/US-VSST593.md) | Document employment data | (infrastructure only) |
| [US-VSST594](../user-stories/US-VSST594.md) | Display employment status during AU issuance | (infrastructure only) |
| [US-VSST848](../user-stories/US-VSST848.md) | F32.9/F33.9 depression follow-up AU hint | (infrastructure only) |
| [US-VSST863](../user-stories/US-VSST863.md) | Repeat prescription insurance-specific recommendations | AC1 (partial) |
| [US-VSST870](../user-stories/US-VSST870.md) | Automatic display of insurance-specific categories | (not implemented) |

## Evidence
- `medicine.d.go` lines 89-102: `Medicine` struct with `ProductInformation`, `HintsAndWarnings`, `DrugInformation`, `PackagingInformation`, `PriceInformation`, `TextInformation`, `ColorCategory`, `MedicationPlanInformation`, `PackageExtend` -- comprehensive medication data model (matches AC1 of [US-VSST532](../user-stories/US-VSST532.md))
- `medicine.d.go` lines 104-108: `ColorCategory` struct with `Sorting` (int32), `DrugCategory` (string), `IsInPriscusList` (*bool) -- supports insurance-specific drug categories (Gruen/Blau/Rot/Orange) and PRISCUS list marking (matches AC1 of [US-VSST537](../user-stories/US-VSST537.md) partially, provides data for [US-VSST784](../user-stories/US-VSST784.md))
- `medicine.d.go` lines 668-680: `FormType` enum with `KREZ` (Kassenrezept), `GREZ`, `BTM`, `TPrescription`, `Private`, `AOKNordwet`, `AOKBremen`, `Muster16aBay`, `EVDGA` -- supports multiple prescription form types including Kassenrezept (matches AC1 of [US-VSST1212](../user-stories/US-VSST1212.md) partially)
- `medicine.d.go` lines 682-688: `MedicineType` enum with `FreeText`, `HPM`, `KBV` -- differentiates medication sources including HPM integration (relates to [US-VSST541](../user-stories/US-VSST541.md), [US-VSST543](../user-stories/US-VSST543.md))
- `medicine.d.go` lines 800-822: `MedicineApp` interface with `GetShoppingBag`, `AddToShoppingBag`, `CheckMissingDiagnose`, `UpdateShoppingBagQuantity`, `UpdateShoppingBagInformation`, `RemoveFromShoppingBag`, `UpdateForm`, `Prescribe`, `GetMedicationPrescribe`, `DeleteMedicationPrescribe`, `CheckMissingDiagnoses`, `CreateMedicationPlan`, `DeleteMedicationPlan`, `PrintForm` -- full medication prescription workflow
- `medicine.d.go` lines 416-427: `PrescribeRequest` with `PatientId`, `DoctorId`, `FormInfos`, `ContractId`, `TreatmentDoctorId`, `EncounterCase`, `MedicineAutIdemIds`, `ScheinId`, `HasSupportForm907`, `AssignedToBsnrId` -- prescription with contract context supporting Selektivvertrag-specific prescriptions (matches AC1 of [US-VSST515](../user-stories/US-VSST515.md) partially)
- `medicine.d.go` lines 805-806: `CheckMissingDiagnose` and `CheckMissingDiagnoses` methods -- diagnosis validation before prescription (relates to [US-VSST527](../user-stories/US-VSST527.md))
- `medicine.d.go` lines 296-318: `ShoppingBagItem` struct includes `ColorCategory`, `CurrentFormType`, `SubstitutionPrescription`, `SpecialExceedings`, `KBVMedicineId`, `IsEPrescription` -- shopping bag items track drug categories and form types

## Coverage
- Partial Match: The medicine package implements the core medication prescription workflow with comprehensive drug data structures including insurance-specific color categories (Gruen/Blau/Rot/Orange), PRISCUS list flagging, multiple form types (Kassenrezept, etc.), and shopping bag management. It provides the data model foundation for many user stories. However, several requirements remain unimplemented: automated 14-day update scheduling ([US-VSST510](../user-stories/US-VSST510.md)), 'rabattiert' price replacement for Gruen ([US-VSST540](../user-stories/US-VSST540.md)), Gruen/Blau sorting ([US-VSST548](../user-stories/US-VSST548.md)), substitution hint text ([US-VSST550](../user-stories/US-VSST550.md)), and automatic category display without user interaction ([US-VSST870](../user-stories/US-VSST870.md)). These are largely UI-level or scheduling concerns.
