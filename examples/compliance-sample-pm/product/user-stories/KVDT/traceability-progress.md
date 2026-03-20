# KVDT User Story Traceability Progress

**Goal:** Map each KVDT user story to actual code files in the codebase.
**Total stories:** 234
**Started:** 2026-03-19

## Batch Status

| Batch | Stories | Status | Code Files Found |
|-------|---------|--------|-----------------|
| 1 | US-K2-276 → US-K2-969 (14) | **done** | 36 entries (3 US had no match: K2-506, K2-855, K2-860) |
| 2 | US-K20-061 → US-K8-06 (23) | **done** | 43 entries (1 US had no match: K8-06) |
| 3 | US-KP2-100 → US-KP2-195 (8) | **done** | 25 entries (1 US had no match: KP2-195) |
| 4 | US-KP2-300 → US-KP2-514 (15) | **done** | 38 entries (2 US had no match: KP2-507, KP2-509) |
| 5 | US-KP2-557 → US-KP2-625 (18) | **done** | 37 entries (all 18 US matched code) |
| 6 | US-KP2-651 → US-KP2-972 (23) | **done** | 45 entries (all 23 US matched code) |
| 7 | US-KP20-030 → US-KP8-08 (15) | **done** | 25 entries (8 US no match: KP6-872, KP8-01/02/03/04/05/07/08 — Hybrid-DRG not implemented) |
| 8 | US-P2-05 → US-P2-180 (12) | **done** | 41 entries (all 12 US matched code) |
| 9 | US-P2-20 → US-P2-325 (13) | **done** | 33 entries (1 US no match: P2-20 — by design, system uses OS date) |
| 10 | US-P2-40 → US-P2-470 (12) | **done** | 34 entries (all 12 US matched code, all partial coverage) |
| 11 | US-P2-501 → US-P2-558 (12) | **done** | 36 entries (all 12 US matched code, all partial) |
| 12 | US-P2-600 → US-P2-71 (11) | **done** | 21 entries (all 11 US matched code) |
| 13 | US-P2-790 → US-P2-99 (14) | **done** | 42 entries (all 14 US matched code) |
| 14 | US-P2.6-10 → US-P21-015 (15) | **done** | 28 entries (2 US no match: P2.6-10, P2.6-20 — spa physician features not implemented) |
| 15 | US-P5-10 → US-P6-160 (11) | **done** | 21 entries (all 11 US matched code) |
| 16 | US-P6-20 → US-P6-420 (6) | **done** | 21 entries (all 6 US matched code) |
| 17 | US-P6-45 → US-P6-830 (12) | **done** | 40 entries (all 12 US matched code) |

## Summary

**Completed:** 2026-03-19
**Total stories processed:** 234
**Stories with code matches:** 216 (92%)
**Stories with NO code match:** 18 (8%)

### User Stories with No Code Match (Not Yet Implemented)

| US ID | Topic | Reason |
|-------|-------|--------|
| K2-506 | Kollegensuche webservice | Not implemented |
| K2-855 | Patient receipt text editing | Not implemented |
| K2-860 | Day-based patient receipt | Not implemented |
| K8-06 | Hybrid-DRG/SDHDRG | Not implemented |
| KP2-195 | Inpatient/Outpatient separation | Not implemented |
| KP2-507 | Kollegensuche webservice for TSS | Not implemented |
| KP2-509 | Kollegensuche Favoritenliste | Not implemented |
| KP6-872 | OPS 5-622.5 special case | Not implemented |
| KP8-01 | Hybrid-DRG HDRG record type | Not implemented |
| KP8-02 | Hybrid-DRG ICD catalog | Not implemented |
| KP8-03 | Hybrid-DRG surgery catalog | Not implemented |
| KP8-04 | Hybrid-DRG billing encryption | Not implemented |
| KP8-05 | Hybrid-DRG 1Click billing | Not implemented |
| KP8-07 | Hybrid-DRG validation | Not implemented |
| KP8-08 | Hybrid-DRG overview | Not implemented |
| P2-20 | System date (no override) | By design — system uses OS date |
| P2.6-10 | KADT exclusion for spa physicians | Not implemented |
| P2.6-20 | Pseudo code 00001U for spa | Not implemented |

## Phase 2: Remaining Functionality Analysis

**Goal:** For each partial-match code file (status "no"), identify what functionality exists beyond what the linked user stories describe.
**Completed:** 2026-03-20
**Output:** [`code-index-extended.md`](code-index-extended.md)

### Analysis Summary

| Metric | Count |
|--------|-------|
| Total "no" entries analyzed | 211 |
| Unique files analyzed | 185 |
| Files with significant remaining functionality | 166 |
| Files with no/minimal remaining functionality | 7 |
| Files marked "mirrors backend / auto-generated" | 25 |
| Test-only files | 1 |

### Analysis Batches

| Batch | Domain | Files | Status |
|-------|--------|-------|--------|
| A | Billing KV & CON file | 16 | **done** |
| B | Card reading & insurance | 23 | **done** |
| C | Schein & field validation | 14 | **done** |
| D | Timeline validation & EBM | 15 | **done** |
| E | Master data catalogs | 29 | **done** |
| F | Forms, mail, TI, referral | 30 | **done** |
| G | Patient profile & billing patient | 18 | **done** |
| H | BSNR, employee, RVSA, misc | 27 | **done** |
| I | Frontend components & BFF | 27 | **done** |

### Key Findings

Files with the **most remaining functionality** (candidates for new user stories):
1. `ares/service/domains/timeline/timeline_service/timeline_service.go` — massive: full CRUD, GOA pricing, psychotherapy lifecycle, auto-actions, EHIC, BG/private invoices, audit restore, eVDGA, EAB
2. `ares/service/schein/schein_service.go` — SV/Private/BG schein CRUD, settings, referral, diagnosis takeover, order lists
3. `ares/service/billing_kv/service.go` — SV hints, XKM encryption, psychotherapy suggestions, TI info
4. `ares/service/mail/mail_service.go` — mail deletion, archive, MDN notifications, patient assignment, sync jobs
5. `ares/service/domains/edmp/service/edmp_service.go` — full DMP lifecycle: enrollment, termination, documentation, billing, data centers
6. `ares/service/bdt/bdt_service.go` — full BDT import pipeline: practice, scheins, patients, treatment data
7. `ares/service/domains/card_raw/service/card_raw_service.go` — mobile card import, patient matching, bulk operations
8. `ares/app/admin/internal/app/ti_connector_service.go` — full CRUD, SDS status, certificate expiry, error reporting

## Code-Map Reference

Key codebase directories for search:
- `ares/app/mvz/api/` — Backend API implementations
- `ares/app/admin/api/` — Admin API implementations
- `ares/service/domains/` — Domain services
- `ares/proto/app/mvz/` — Proto definitions
- `pkgs/pvs-hermes/bff/` — BFF TypeScript (auto-generated)
- `pkgs/app_mvz/` — MVZ frontend app

## Search Strategy

For each user story:
1. Extract XML traits / hints / field keys (FK xxxx) from acceptance criteria
2. Search across ALL codebase directories (not just c3-mapped ones)
3. Match on: XML element names, field key constants, domain terms, function names
4. Update Traceability section with code file links
5. Record findings in code-index.md
