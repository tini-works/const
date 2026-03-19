## US-VSST631 — When prescribing a steuerbare Hilfsmittel, the Vertragssoftware must display the...

| Field | Value |
|-------|-------|
| **ID** | US-VSST631 |
| **Traced from** | [VSST631](../compliances/SV/VSST631.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E5: Practice Software Core](../epics/E5-practice-software-core.md) |
| **Data Entity** | VOD, FRM |

### User Story

As a practice staff, I want when prescribing a steuerbare Hilfsmittel, the Vertragssoftware display the hint: 'Please fax the prescription (Muster 16) and any questionnaire to the fax number printed on the Muster 16', so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a steuerbare Hilfsmittel prescription, when the user is prescribing, then the fax instruction hint is displayed

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/himi`

1. **HIMI prescription** -- The `himi` package handles prescription workflows.
2. **Gap: Fax instruction hint** -- The specific hint 'Please fax the prescription (Muster 16) and any questionnaire...' for steuerbare Hilfsmittel is a UI-level requirement not verified in the backend.
