# Matching: hpm_check_history

## File
`backend-core/app/app-core/api/hpm_check_history/`

## Matched User Stories
| Story ID | Story Title | Matched Criteria |
|----------|-------------|------------------|
| [US-VSST621](../user-stories/US-VSST621.md) | Prevent AU/eAU without current employment data | (infrastructure only) |
| [US-VSST622](../user-stories/US-VSST622.md) | Employment status confirmation with timestamp | (infrastructure only) |
| [US-VSST623](../user-stories/US-VSST623.md) | Integrate Hilfsmittelkatalog | (infrastructure only) |
| [US-VSST624](../user-stories/US-VSST624.md) | Multi-criteria Hilfsmittel search | (infrastructure only) |
| [US-VSST625](../user-stories/US-VSST625.md) | Product type vs individual product prioritization | (infrastructure only) |
| [US-VSST626](../user-stories/US-VSST626.md) | Steuerbare Hilfsmittel list integration | (infrastructure only) |
| [US-VSST627](../user-stories/US-VSST627.md) | Check against steuerbare Hilfsmittel list | (infrastructure only) |
| [US-VSST628](../user-stories/US-VSST628.md) | Print Merkblatt for steuerbare Hilfsmittel | (infrastructure only) |
| [US-VSST629](../user-stories/US-VSST629.md) | Check FRAGEBOGEN for questionnaire requirement | (infrastructure only) |
| [US-VSST630](../user-stories/US-VSST630.md) | Validate steuerbare Hilfsmittel questionnaire | (infrastructure only) |
| [US-VSST631](../user-stories/US-VSST631.md) | Display fax instruction hint | (infrastructure only) |
| [US-VSST633](../user-stories/US-VSST633.md) | Minimum Hilfsmittel prescription fields | (infrastructure only) |
| [US-VSST784](../user-stories/US-VSST784.md) | Display PIM drug labels | AC1 (partial) |

## Evidence
- `hpm_check_history.d.go` lines 87-89: `HpmCheckHistoryApp` interface with single method `GetHpmCheckHistory` -- provides HPM check history retrieval for tracking HPM interactions including medication checks (matches AC1 of [US-VSST784](../user-stories/US-VSST784.md) partially as infrastructure)
- `hpm_check_history.d.go` lines 38-47: `HpmCheckHistoryItem` struct with `ContractIds`, `ContractType`, `Status`, `HpmCode`, `HpmMessage`, `CreatedBy`, `CreatedAt`, `DeputyContractIds` -- tracks individual HPM interaction results including status codes and messages from the Pruef- und Abrechnungsmodul
- `hpm_check_history.d.go` lines 49-59: `GetHpmCheckHistoryRequest` with `PatientId`, `ContractIds`, `ContractType`, `PaginationRequest` -- supports querying HPM check history by patient and contract context
- `hpm_check_history.d.go` lines 62-75: `HpmCheckStatus` enum with values `OK`, `NO_INFORMATION`, `FAILED`, `TECHNICAL_VIOLATION`, `NO_AUTHORIZATION_WEB_SERVICE`, `MAINTENANCE`, `INTERNAL_ERROR`, `INVALID_MASTER_DATA`, `UNKNOWN`, `PARTIALLY_PROCESSED` -- comprehensive HPM status tracking for error handling and audit
- `hpm_check_history.d.go` lines 30-36: `CreatedBy` struct with `IsSystem`, `Id`, `Initial`, `FirstName`, `LastName` -- audit trail for who initiated each HPM check

## Coverage
- Partial Match: The hpm_check_history package provides the infrastructure for tracking HPM (Pruef- und Abrechnungsmodul) interactions with status codes and messages. It stores the history of HPM checks per patient and contract, which is foundational for the medication recommendation features ([US-VSST784](../user-stories/US-VSST784.md), [US-VSST854](../user-stories/US-VSST854.md), [US-VSST855](../user-stories/US-VSST855.md), [US-VSST858](../user-stories/US-VSST858.md)) and Hilfsmittel-related HPM checks. However, the package itself is a history/audit service and does not implement the specific display logic for PIM labels, Priscus-Liste columns, Festbetragskennzeichnung, Zuzahlung, or the employment/Hilfsmittel features. Those are handled in other packages (medicine, himi, patient_profile) or at the UI layer.
