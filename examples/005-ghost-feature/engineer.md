# Engineer — Discovery and Removal

## The discovery sequence

This wasn't a bug report. It was a routine sanity reconciliation that caught a ghost.

### 1. Staleness: when was this last touched?

Daily inventory walk. FLW-99 (Export to PDF — monthly report generation) was last modified 14 months ago. Nothing else in the inventory is older than 3 months. FLW-99 stands out.

**Verify:** Check git log for the export endpoint, controller, and service files. Last meaningful commit: 14 months ago. Everything since is dependency bumps that didn't touch the actual code.

### 2. Correctness: does it still work?

Ran the flow manually. Called the export endpoint. Got HTTP 200 with an empty response body. No error. No log entry. No exception.

**Root cause:** The PDF library (the external dependency that renders reports to PDF) was deprecated 8 months ago. Its hosted API still responds, but returns empty payloads. The endpoint wraps this in a 200 because the HTTP call itself "succeeds" — there's no content validation on the response.

**Verify:** Call `POST /api/reports/export { "report_id": "any-valid-id", "format": "pdf" }` in staging. Response is 200 with Content-Length: 0. The PDF library's status page confirms end-of-life 8 months ago.

### 3. Coverage: does anyone use it?

Before deciding to fix or remove, checked usage analytics.

- 3 invocations in the last 90 days
- All from the same user (an intern exploring the system)
- All resulted in 0-byte file downloads
- All were abandoned (no retry, no support ticket)

Nobody depends on this. The 3 attempts were someone discovering it's broken and moving on.

**Verify:** Query the analytics/event system for `export_pdf` events in the last 90 days. Three results, one user, zero successful completions.

## What was removed

| Layer | Removed | Verify |
|-------|---------|--------|
| Endpoint | `POST /api/reports/export` | 404 after deployment in staging |
| Controller | `ReportExportController` | File deleted, no import references remain |
| Service | `PdfExportService` | File deleted, no import references remain |
| Dependency | PDF library in package manifest | `package.json` (or equivalent) no longer lists it. `node_modules` clean after install. |
| Tests | Mocked test suite for PDF export | Test files deleted, test runner finds zero references to export |

**Verify:** After removal, run the full test suite. It passes. No test references the export flow. No import statement references the deleted files. `grep -r "PdfExport\|ReportExport\|export.*pdf" src/` returns zero results.

## The lesson about mocked tests

The test for FLW-99 mocked the PDF library. The mock returns a valid-looking PDF buffer regardless of what the real library does. When the real library died 8 months ago, the mock kept passing. The test proved nothing about the real system — it proved the mock works.

This is the failure mode: a test that can never fail is not a test. A mock that doesn't reflect reality is a lie the test suite tells itself.

**New rule — 6-month staleness trigger:**

Any flow untouched for >6 months gets a manual correctness check during sanity reconciliation. The sequence is always: staleness first (is it old?), then correctness (does it still work?), then coverage (does anyone use it?). This is how FLW-99 was caught. This sequence is now standard.

**Verify:** The staleness rule is documented in the team's reconciliation checklist. Next sanity reconciliation applies it to all flows. Any flow older than 6 months gets the three-step check.
