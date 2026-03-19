## US-VSST551 — When prescribing medications of categories 'Gruen', 'GruenBerechnet', or 'Blau', the...

| Field | Value |
|-------|-------|
| **ID** | US-VSST551 |
| **Traced from** | [VSST551](../compliances/SV/VSST551.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | MED, PM |

### User Story

As a practice staff, I want when prescribing medications of categories 'Gruen', 'GruenBerechnet', or 'Blau', the Vertragssoftware retrieve and display any messages from the Pruef- und Abrechnungsmodul via the substitution and list endpoints, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a medication of category Gruen, GruenBerechnet, or Blau being prescribed, when the Pruef- und Abrechnungsmodul returns messages, then those messages are displayed to the user

### Actual Acceptance Criteria

**Implementation Status:** Partially Implemented

**Relevant Codebase Packages:** `api/hpm_check_history`, `api/medicine`

1. **HPM message handling** -- The `hpm_check_history` package tracks HPM interactions.
2. **Gap: Display of Pruef- und Abrechnungsmodul messages** -- The specific retrieval and display of HPM messages for Gruen/GruenBerechnet/Blau medications via substitution and list endpoints needs verification.
