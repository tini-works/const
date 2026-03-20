# Matching: form

## File
`backend-core/app/app-core/api/form/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST1212](../user-stories/US-VSST1212.md) | OTC on Kassenrezept for ages 12-17 | AC1 (partial), AC2 (partial) |
| [US-VSST599](../user-stories/US-VSST599.md) | Display hint for empty/outdated employment data on AU/eAU | (infrastructure only) |
| [US-VSST677](../user-stories/US-VSST677.md) | eDMP Koronare Herzkrankheit integration | (infrastructure only) |

## Evidence
- `form.d.go` lines 192-204: `FormAPP` interface defines `GetForm`, `GetForms`, `GetIcdForm`, `GetPrescribe`, `Print`, `PrintPlainPdf`, `GetAllForms`, `GetFileUrl`, `BuildBundleAndValidation`, `PrescribeV2`, `GetIndicatorActiveIngredients` -- comprehensive form management for prescriptions and medical documents
- `form.d.go` lines 34-43: `GetFormRequest` includes `OKV`, `IkNumber`, `ContractId` -- supports contract-specific form retrieval, which is needed for insurance-specific form selection including Muster 16 (matches AC1 of [US-VSST1212](../user-stories/US-VSST1212.md))
- `form.d.go` lines 45-55: `PrescribeRequest` with `Prescribe`, `PrintOption`, `EAUSetting` -- supports prescription and eAU form generation; the `EAUSetting` integration connects form generation to AU/eAU workflows (relates to [US-VSST599](../user-stories/US-VSST599.md))
- `form.d.go` lines 57-64: `BuildBundleAndValidationRequest`/`BuildBundleAndValidationResponse` with `EAUValidation` -- validation logic for eAU forms before printing
- `form.d.go` lines 92-99: `GetFormsRequest` includes `OKV`, `IkNumber`, `ContractId`, `ChargeSystemId`, `ScheinMainGroup` -- supports retrieving forms by charge system and Schein context
- `form.d.go` lines 126-145: `GetIndicatorActiveIngredientsRequest`/`GetIndicatorActiveIngredientsResponse` with `AtcDiagnoseCode`, and `GetIcdFormRequest`/`GetIcdFormResponse` -- supports indicator-based form lookups and ICD form retrieval
- `form.d.go` lines 148-160: KBV_PRF_NR and EHIC_PRF_NR constants -- KBV and EHIC form number references for compliance

## Coverage
- Partial Match: The form package provides comprehensive form management including prescription forms (Kassenrezept/Muster 16), eAU form building with validation, and contract-specific form retrieval. However, the specific automatic placement of OTC medications on Muster 16 for ages 12-17 ([US-VSST1212](../user-stories/US-VSST1212.md)) is not explicitly implemented in this API layer. The employment data validation hint ([US-VSST599](../user-stories/US-VSST599.md)) is handled elsewhere (eau package). The DMP form support ([US-VSST677](../user-stories/US-VSST677.md)) is primarily in the edmp package.
