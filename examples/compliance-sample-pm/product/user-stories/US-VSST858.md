## US-VSST858 — The Pruef- und Abrechnungsmodul returns co-payment (Zuzahlung) information for insurance-specific...

| Field | Value |
|-------|-------|
| **ID** | US-VSST858 |
| **Traced from** | [VSST858](../compliances/SV/VSST858.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | MED, PM, KT |

### User Story

As a practice staff, I want the Pruef- und Abrechnungsmodul returns co-payment (Zuzahlung) information for insurance-specific medication recommendations, which is displayed in column form, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given insurance-specific medication recommendations, when displayed, then a Zuzahlung column is shown

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/hpm_check_history`, `api/medicine`

1. **HPM integration** -- Same infrastructure as VSST855.
2. **Gap: Zuzahlung column display** -- The specific co-payment column display in recommendations is not verified.
