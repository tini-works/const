## US-ALLG483 — Audit module version hint must be shown

| Field | Value |
|-------|-------|
| **ID** | US-ALLG483 |
| **Traced from** | [ALLG483](../compliances/SV/ALLG483.md) |
| **Source** | AKA Q1-26-1 |
| **Status** | TBC |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | [E6: General & Documentation](../epics/E6-general-and-documentation.md) |
| **Data Entity** | PM |

### User Story

As a practice owner, I want audit module version hint is shown, so that general compliance requirements are met.

### Acceptance Criteria

1. Given the Prüfmodul is loaded, when the user opens version info, then the current Prüfmodul version is displayed

### Actual Acceptance Criteria

| Status | **Partially Implemented** |
|--------|--------------------------|

1. A `VersionInforApp` exists at `backend-core/app/app-core/internal/version_infor/application.go` that retrieves version information including HPM version (described as "HAVG-Prufmodul"), master data versions, medication versions, XPM and XKM versions.
2. The HPM version is fetched via `hpmRestService.GetVersionInformation()` and displayed with description "HAVG-Prufmodul".
3. **Gap**: There is no dedicated Prufmodul version field separate from the HPM version. The acceptance criterion calls for showing the "current Prufmodul version" when the user opens version info. The HPM version is shown, but there is no independent Prufmodul component whose version is tracked and displayed separately.
