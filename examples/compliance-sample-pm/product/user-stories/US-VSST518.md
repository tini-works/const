## US-VSST518 — The Vertragssoftware must allow transmission of prescription data for prescriptions...

| Field | Value |
|-------|-------|
| **ID** | US-VSST518 |
| **Traced from** | [VSST518](../compliances/SV/VSST518.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware allow transmission of prescription data for prescriptions whose documentation date precedes the contract-specific transmission start date, provided the prescriptions were documented after the contract-specific Verordnungsdaten documentation start date, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given Verordnungen documented after the contract documentation start date but before the transmission start date, when transmission is triggered, then those prescriptions are included
