# UnMatching: report

## File
`backend-core/app/app-core/api/report/`

## Analysis
- **What this code does**: Provides a reporting API with endpoints to get report definitions, execute reports with pagination, list saved queries by report type, and export reports. Supports custom queries, report headers, and additional data. Used for generating practice management reports (patient lists, EBM service reports, etc.).
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-REPORT — Practice Management Reporting and Export

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-REPORT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E5 Practice Software Core |
| **Data Entity** | ReportDefinition, ReportRow, ReportHeader, Query, AdditionalData |

### User Story
As a practice staff member, I want to define, execute, save, and export reports on practice data such as patient lists and EBM service summaries, so that I can analyze practice performance and meet reporting obligations.

### Acceptance Criteria
1. Given a report ID, when the user requests the report definition, then the column definitions and default query parameters are returned
2. Given a report ID and query parameters, when the user executes the report, then paginated report rows, headers, and additional data are returned
3. Given existing saved queries, when the user lists queries filtered by report type and search string with pagination, then matching saved queries are returned
4. Given a report ID and query, when the user requests an export, then the report is exported for download

### Technical Notes
- Source: `backend-core/app/app-core/api/report/`
- Key functions: GetReportDefinition, ExecuteReport, ListQuery, ExportReport
- Integration points: `service/report` (Column, Query, ReportHeader, ReportRow, ReportType, QueryViewModel, AdditionalData), `service/domains/api/common` (PaginationRequest, PaginationResponse)
- All endpoints require CARE_PROVIDER_MEMBER role
