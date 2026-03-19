## US-VSST630 — The Vertragssoftware must validate the completed steuerbare Hilfsmittel questionnaire against...

| Field | Value |
|-------|-------|
| **ID** | US-VSST630 |
| **Traced from** | [VSST630](../compliances/SV/VSST630.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want the Vertragssoftware validate the completed steuerbare Hilfsmittel questionnaire against its rules and warn the user if the questionnaire is not properly filled, with validation occurring at latest before saving or printing, so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given a completed steuerbare Hilfsmittel questionnaire, when validation runs before save/print, then non-compliant answers are flagged with a warning

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/himi`

1. **HIMI prescription validation** -- The `himi` package supports prescription creation.
2. **Gap: Questionnaire validation** -- The specific validation of steuerbare Hilfsmittel questionnaire answers against rules, with warnings before save/print, is not verified in the backend.
