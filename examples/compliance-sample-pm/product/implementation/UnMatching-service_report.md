# UnMatching: service_report

## File
`backend-core/service/report/`

## Analysis
- **What this code does**: Provides the report service backend for generating, executing, and exporting practice management reports. Supports patient list reports, EBM service code reports, custom queries, CSV/PDF export via Gotenberg, and report storage in MinIO. Includes a report repository for MongoDB-based data aggregation, query storage for saved report definitions, and hook notifications for report events.
- **Why no match**: No user story with Actual Acceptance Criteria references this package

## Recommendation
- [x] Create new User Story for this functionality
- [ ] This is infrastructure/utility code (no story needed)
- [ ] This is dead code (consider removal)

## Classification
- [x] E1=Billing Documentation

---

## PROPOSED USER STORY
(Following format from product/user-stories/)

## US-PROPOSED-REPORT — Practice Management Report Generation and Export

| Field | Value |
|-------|-------|
| **ID** | US-PROPOSED-REPORT |
| **Traced from** | — |
| **Source** | Reverse-engineered from code |
| **Status** | Proposed |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |
| **Epic** | E1=Billing Documentation |
| **Data Entity** | QueryEntity, ReportData, Column |

### User Story
As a practice manager, I want to create, execute, and export custom reports (patient lists, EBM service codes, diagnoses, and custom queries), so that I can analyze practice performance and generate documentation for billing and compliance purposes.

### Acceptance Criteria
1. Given a report type, when I call `GetReportTableColumn`, then the available columns for that report are returned with excluded system fields filtered out
2. Given a saved query, when I call `ExecuteReport`, then the query is built and executed against the Postgres-based report repository with pagination
3. Given an executed report, when I call `ExportReport`, then the data is exported as CSV and converted to PDF via Gotenberg, uploaded to MinIO, and a socket notification is sent
4. Given report definitions, when I call `CreateQuery`, `UpdateQuery`, `DeleteQuery`, or `DuplicateQuery`, then saved report queries are managed in the query storage repository
5. Given a search request, when I call `ListQuery` with pagination and optional report type filter, then matching saved queries are returned
6. Given extended report fields, when generating reports, then FAV contract, HZV contract, and schein creation time columns are included

### Technical Notes
- Source: `backend-core/service/report/`
- Key functions: ExecuteReport, ExportReport, CreateQuery, ListQuery, GetReportTableColumn, ExecuteReportWithCallback (streaming)
- Integration points: Postgres (ReportRepo, QueryStorageRepo), Gotenberg (HTML-to-PDF), MinIO (file storage), WebSocket notifications, hook_api
