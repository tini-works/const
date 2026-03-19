## US-VSST855 — The Pruef- und Abrechnungsmodul returns Festbetragskennzeichnung (reference price indicator) and...

| Field | Value |
|-------|-------|
| **ID** | US-VSST855 |
| **Traced from** | [VSST855](../compliances/SV/VSST855.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | MED, PM, KT |

### User Story

As a practice staff, I want the Pruef- und Abrechnungsmodul returns Festbetragskennzeichnung (reference price indicator) and co-payment (Zuzahlung) for insurance-specific medication recommendations, which is displayed in column form, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given insurance-specific medication recommendations, when displayed, then Festbetragskennzeichnung and Zuzahlung columns are shown

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/hpm_check_history`, `api/medicine`

1. **HPM integration** -- The `hpm_check_history` package exists.
2. **Gap: Festbetragskennzeichnung and Zuzahlung columns** -- The specific display of reference price indicator and co-payment columns in insurance-specific medication recommendations is not verified.
