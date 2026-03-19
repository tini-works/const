## US-VSST848 — When ICD-10 codes F32.9 or F33.9 (unspecified depressive episodes) are...

| Field | Value |
|-------|-------|
| **ID** | US-VSST848 |
| **Traced from** | [VSST848](../compliances/SV/VSST848.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

As a practice staff, I want when ICD-10 codes F32.9 or F33.9 (unspecified depressive episodes) are documented, from the first follow-up AU certificate onward, the system display: 'Please check whether targeted diagnostic and therapeutic measures could improve the disease course in continued AU due to unspecific depression.', so that the software meets regulatory requirements.

### Acceptance Criteria

1. Given ICD-10 F32.9 or F33.9 documented, when a Folge-AU is issued, then the hint about considering targeted diagnostic/therapeutic measures for unspecific depression is displayed

### Actual Acceptance Criteria

**Implementation Status:** Not Yet Implemented

**Relevant Codebase Packages:** `api/eau`, `api/sdicd`

1. **eAU creation with ICD codes** -- The `eau` package creates eAU documents with form data that includes ICD codes.
2. **Gap: F32.9/F33.9 follow-up AU hint** -- The specific detection of ICD-10 codes F32.9 or F33.9 and the display of the depression-specific hint from the first follow-up AU onward is not verified in the eAU creation logic.
