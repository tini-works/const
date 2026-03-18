## VSST518 — The Vertragssoftware must allow transmission of prescription data for prescriptions...

| Field | Value |
|-------|-------|
| **ID** | VSST518 |
| **Type** | Mandatory |
| **Source** | AKA Q1-26-1 |
| **Section** | 3.6 VSST — Practice Software |
| **Status** | TBC |
| **Goals** | BG-1a |
| **Verification Method** | Validator unit test |
| Matched by | [US-VSST518](../../user-stories/US-VSST518.md) |

### Requirement

The Vertragssoftware must allow transmission of prescription data for prescriptions whose documentation date precedes the contract-specific transmission start date, provided the prescriptions were documented after the contract-specific Verordnungsdaten documentation start date

### Acceptance Criteria

1. Given Verordnungen documented after the contract documentation start date but before the transmission start date, when transmission is triggered, then those prescriptions are included
