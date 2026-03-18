# PM Framework Adoption Plan — PVS Compliance

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Adopt the Constitution framework for PM's compliance inventory — split the monolith into individual files, add structured tags, build AI tooling, and establish matching boundaries with Design/Dev/QA one vertical at a time.

**Context:** German practice management web app (PVS). 593+ compliance obligations across AKA, KVDT, ICD-10-GM, KBV EBM, GOÄ, and workflow sources. Updated quarterly. Team: PM, Designer, Dev, QA. No client yet — this is preparation work.

**Architecture:** Individual compliance files (one per obligation) organized by source subdirectory. AI generates dashboard, diffs quarterly catalogs, and checks link integrity. Each vertical fills their own match column. PM owns the files and monitors proof status via Track column.

**Current state:**
- `product/compliance-inventory-18032026_1350.md` — 1,270-line monolith with 593 rows
- `product/compliances/KVDT/[KVDT]KP2-121.md` — one example individual file
- `product/compliances/raw/KBV_ITA_VGEX_Anforderungskatalog_KVDT.pdf` — source PDF
- `product/user stories 01.md` — one example user story with traceability links

**Target state:**
```
product/
  epics.md                          ← 13 epic definitions
  data-entities.md                  ← 12-15 entity definitions
  compliance-dashboard.md           ← Auto-generated status summary
  compliance/
    ABRD/ABRD456.md ... (46 files)
    ABRG/ABRG001.md ...
    VERT/VERT001.md ...
    VERE/VERE001.md ...
    KVDT/KP2-121.md ... (158 files)
    ICD10/ICD-001.md ... (57 files)
    EBM/EBM-001.md ...
    GOA/GOA-001.md ...
    TSS/TSS-001.md ...
    workflows/EREZ-001.md ... (56 files)
    PSDV/PSDV-001.md ...
    FORM/FORM-001.md ...
    INFRA/INFRA-001.md ...
  compliances/raw/                  ← Source PDFs and catalogs
  reconciliation-log.md
  decision-log.md
```

**Principles:**
- Build AI tooling BEFORE splitting the monolith (guardrail from brainstorming)
- Start with one vertical boundary, expand when habitual (from ADOPT.md)
- PM owns compliance files. Other verticals fill their match columns in their own inventories. AI cross-references to populate PM's Match section.
- Dashboard is generated, never hand-maintained
- Deterministic tag-based lookup for impact analysis, not probabilistic AI search

---

## Phase 0: Foundations (Week 1)

### Task 0.1: Define Epics

**Files:**
- Create: `examples/compliance-sample-pm/product/epics.md`

**What PM does:**

Define the epic list. Each epic groups compliance obligations by the feature area a developer/designer would recognize as "one part of the app."

**Content to write:**

```markdown
# Epics

Compliance obligations grouped by feature area. Each obligation links
to at least one epic. An obligation can link to multiple epics when
it crosses feature boundaries.

| Epic ID | Name (DE) | Name (EN) | Compliance Sections | Description |
|---------|-----------|-----------|--------------------:|-------------|
| E-ABRD | Abrechnungsdokumentation | Billing Documentation | 3.1 | Service documentation, diagnosis rules, referral forms, audit trail |
| E-ABRG | Abrechnungserstellung | Billing Generation | 3.2 | Billing file creation, submission, correction deliveries |
| E-VERT | Vertragsverwaltung | Contract Management | 3.3 | HZV/FAV contract config, service catalogs, IK assignment |
| E-VERE | Einschreibung | Enrollment Lifecycle | 3.4 | Patient enrollment, status management, termination |
| E-DIAG | Diagnoseverwaltung | Diagnosis Management | 3.16, parts of 3.1 | ICD-10 entry, validation, carry-over, coding rules |
| E-PSDV | Versichertenstammdaten | Patient Data / eGK | 3.15 | eGK read, KVK handling, Stammdaten update |
| E-FORM | Formulare | Forms & Print | 3.20 (forms subset) | BFB forms, print templates, field compliance |
| E-KVDT | KVDT-Datenaustausch | Billing File & Data Exchange | 3.17, 3.18 | KVDT file format, Satzarten, Feldkennungen, infrastructure |
| E-EBM | EBM/GOÄ/TSS | Statutory Billing Rules | 3.11, 3.12, 3.13, 3.14 | EBM validation, GOÄ rules, TSS surcharges, ICD catalog checks |
| E-EREZ | E-Rezept | E-Prescription & Drug Safety | 3.19 (E-Rezept subset) | E-Rezept workflow, drug safety, Heilmittel, BMP |
| E-EDMP | eDMP/eHKS | Disease Management Programs | 3.21 | eDMP documentation, transmission, scoring, audit |
| E-KOMM | Digitale Kommunikation | Digital Communication | 3.20 (comms subset) | eAU, eArztbrief, ePA, KIM |
| E-INFRA | Praxisinfrastruktur | Practice Infrastructure | 3.18, cross-cutting | TI connector, practice config, BSNR/KV-Region |
```

**Verification:** Each compliance section (3.1–3.21) maps to at least one epic. No orphan sections.

**Step 1:** Draft the table above, adjusting names/groupings to match how your team actually talks about the app.

**Step 2:** For each epic, write 2-3 sentences describing what "this area of the app" does. This helps Designer and Dev understand the scope.

**Step 3:** Review with Dev: "Does this grouping match how the codebase is organized?" Adjust if Dev says "we never touch ABRD and ABRG separately, they're one module."

**Step 4:** Commit.

---

### Task 0.2: Define Data Entities

**Files:**
- Create: `examples/compliance-sample-pm/product/data-entities.md`

**What PM does:**

Define the data entity list — the core objects in the PVS that compliance items constrain. This is the cross-cutting dimension that epics don't capture.

**Content to write:**

```markdown
# Data Entities

Core data objects in the PVS. Each compliance obligation is tagged
with the entities it constrains. Used for cross-epic impact analysis:
"we're changing the Patient data model — which obligations are affected?"

| Entity ID | Name (DE) | Name (EN) | Description | Example constraints |
|-----------|-----------|-----------|-------------|-------------------|
| Patient | Versichertenstammdaten | Patient Record | Demographics, VKNR, insurance data from eGK/KVK | eGK read rules, data format, DSGVO |
| Diagnose | Diagnose | Diagnosis | ICD-10 codes, certainty markers (G/V/Z/A), Dauerdiagnosen | Terminal codes, validity, carry-over, §295 |
| Leistung | Leistung | Service/Procedure | Documented medical services, EBM/GOÄ codes | Contract filtering, OPS, specialty restrictions |
| Schein | Behandlungsfall/Schein | Treatment Case | Billing case per quarter, Scheinart | Quartal rules, contract assignment |
| Überweisung | Überweisung | Referral | Referral forms, LANR/BSNR, clinical context | Form fields, hint text, FAV extensions |
| Abrechnung | Abrechnung | Billing Submission | KVDT billing file, Korrekturlieferung | File format, Satzarten, Feldkennungen |
| Vertrag | Vertrag | Insurance Contract | HZV/FAV/EKV contract configuration | Participation status, IK assignment, activation |
| Medikament | Medikament/Verordnung | Medication/Prescription | E-Rezept, drug data, BMP | E-Rezept workflow, drug safety checks |
| Formular | Formular | Form/Template | BFB forms, eAU, eArztbrief | Template field compliance, print rules |
| DMP-Doku | DMP-Dokumentation | DMP Documentation | eDMP records, scoring, transmission | eDMP certification, audit trail |
| Praxis | Praxis | Practice Config | BSNR, KV-Region, TI connector | Location scoping, infrastructure |
| Katalog | Katalog/Stammdaten | Master Data | EBM, ICD, OPS, GOÄ catalogs | Version validity, update cycles |
```

**Verification:** Every compliance obligation can be tagged with at least one entity from this list. If PM finds obligations that don't fit any entity, the list needs expanding.

**Step 1:** Draft the table.

**Step 2:** Spot-check against 10 random compliance items from different sections. Can each be tagged? Adjust list if not.

**Step 3:** Commit.

---

### Task 0.3: Define Individual Compliance File Template

**Files:**
- Create: `examples/compliance-sample-pm/product/compliance/TEMPLATE.md`

**What PM does:**

Define the standard template every compliance file follows. This is the contract — every file has the same structure so AI tooling can parse them reliably.

**Content to write:**

```markdown
# {ID} — {Title}

| Field | Value |
|-------|-------|
| **ID** | {ID} |
| **Type** | {Mandatory / Optional / N/A} |
| **Source** | {External source reference — AKA catalog ID, KBV rule, KVDT spec} |
| **Epic(s)** | {E-ABRD, E-DIAG, ...} |
| **Data Entity** | {Patient, Diagnose, Leistung, ...} |
| **Status** | {TBC / Confirmed / Suspect / Stale / N/A} |
| **Track** | {_ / D / E / Q / DE / DQ / EQ / DEQ} |

## Requirement

{Original compliance text. Copy from source catalog.
Include section/paragraph reference for audit traceability.}

## User Story & AC

As a {persona}, I want {obligation expressed as desire}, so that {business justification}.

**AC:**
- Given {precondition}, when {action}, then {expected result}
- Given {precondition}, when {action}, then {expected result}

## Matches

| Vertical | Match | Confirmed By |
|----------|-------|--------------|
| Design | {Screen/flow link — filled by Designer or auto-generated from screen specs} | {Name, date} |
| Engineer | {Code path — filled by Dev or auto-generated from code refs} | {Name, date} |
| QA | {TC-ID (environment, date, result) — filled by QA or auto-generated from test refs} | {Name, date} |

## Related Items

- [{ID}]({relative-path}) — {why related}

## Change History

| Date | Change | Assessed By |
|------|--------|-------------|
| {YYYY-MM-DD} | {What changed and why} | {Name (role)} |
```

**Key rules embedded in the template:**
- Status values are fixed vocabulary (TBC/Confirmed/Suspect/Stale/N/A)
- Track values are fixed vocabulary (_/D/E/Q/DE/DQ/EQ/DEQ)
- QA Ref MUST include execution metadata (environment, date, result) — a TC-ID alone is a claim, not proof
- Confirmed By requires a named human and date — no "team reviewed"
- Change History records every modification for audit trail

**Verification:** The template can be parsed by AI — fixed field names, consistent structure, no free-form sections that break parsing.

**Step 1:** Write the template.

**Step 2:** Verify the existing `[KVDT]KP2-121.md` file can be migrated to this template without losing information.

**Step 3:** Commit.

---

## Phase 1: Split the Monolith (Week 2-3)

### Task 1.1: AI Extracts Individual Files from Monolith

**Files:**
- Read: `examples/compliance-sample-pm/product/compliance-inventory-18032026_1350.md`
- Create: `examples/compliance-sample-pm/product/compliance/{SOURCE}/{ID}.md` × 593 files

**What PM does:**

PM instructs AI to read the monolith inventory and generate individual files using the template from Task 0.3.

**AI processing per row:**
1. Read the row's columns: ID, Obligation, Requirement Type, Ext. Source, Status, User Story & AC, Design Match, Engineer Ref, QA Ref, Track, etc.
2. Map to template fields
3. Determine the subdirectory from the section (3.1 ABRD → `compliance/ABRD/`)
4. Write the file

**What AI proposes for Epic(s) and Data Entity tags:**
- Epic: mapped from the section the item belongs to (ABRD → E-ABRD) + any cross-epic links inferred from the obligation text
- Data Entity: inferred from keywords in obligation text (mentions "Diagnose" → entity:Diagnose, mentions "Überweisung" → entity:Überweisung)
- AI marks confidence: HIGH (section mapping) / MEDIUM (keyword inference) / LOW (ambiguous)

**Step 1:** AI generates all 593 files in a single batch. Files are created but NOT yet reviewed.

**Step 2:** AI generates a summary report:
```
Generated: 593 files
  ABRD/: 46 files
  ABRG/: XX files
  KVDT/: 158 files
  ICD10/: 57 files
  ...
Tag confidence:
  HIGH: 478 (80%)
  MEDIUM: 89 (15%)
  LOW: 26 (5%)
```

**Step 3:** Commit all generated files with message: "feat: split monolith into 593 individual compliance files (AI-generated, pending PM review)"

**Verification:** File count matches row count in monolith. No duplicate IDs. Every file parses against the template structure.

---

### Task 1.2: PM Reviews Tags — Section by Section

**Files:**
- Review and edit: `examples/compliance-sample-pm/product/compliance/{SOURCE}/*.md`

**What PM does:**

Review AI-proposed Epic(s) and Data Entity tags. Work section by section — one subdirectory at a time. Focus on MEDIUM and LOW confidence items.

**Review order (start with the densest sections):**

| # | Section | Files | Estimated time | Focus |
|---|---------|-------|---------------|-------|
| 1 | ABRD | 46 | 1 hour | Cross-epic links to E-DIAG — many billing items touch diagnosis |
| 2 | KVDT | 158 | 2-3 hours | Data Entity assignment — KVDT items touch many entities |
| 3 | ICD10 | 57 | 1 hour | Mostly E-DIAG, check for cross-links to E-ABRD and E-EBM |
| 4 | Workflows | 56 | 1 hour | E-EREZ / E-EDMP / E-KOMM split — verify grouping |
| 5 | Remaining | ~276 | 2-3 hours | ABRG, VERT, VERE, EBM, GOÄ, TSS, FORM, PSDV, INFRA |

**Per-file review checklist:**
- [ ] Epic(s): Is this in the right epic? Should it cross-link to another epic?
- [ ] Data Entity: Does this item constrain the tagged entities? Missing any?
- [ ] User Story: Does the "As a... I want... so that..." make sense? (Fix mechanical AI rewrites)
- [ ] Requirement: Does it match the source catalog text?

**Step 1:** Review ABRD section (46 files). Correct tags. Commit: "review: PM reviewed ABRD tags"

**Step 2:** Review KVDT section (158 files). Correct tags. Commit: "review: PM reviewed KVDT tags"

**Step 3-5:** Continue through remaining sections. One commit per section.

**Verification:** After all sections reviewed, no files remain with LOW confidence tags. AI regenerates the confidence report — all items should be HIGH.

---

### Task 1.3: AI Cross-Link Review

**Files:**
- Read: all `compliance/{SOURCE}/*.md` files
- Edit: files needing additional epic cross-links

**What PM does:**

PM asks AI to find items that share Data Entity tags but are in different epics — potential cross-links that PM missed.

**AI query:**
> "Find all compliance files where Data Entity includes 'Diagnose' but Epic does NOT include E-DIAG. These might need an E-DIAG cross-link."

Repeat for each entity × epic combination that makes sense:
- Entity:Abrechnung but not in E-ABRG
- Entity:Patient but not in E-PSDV
- Entity:Vertrag but not in E-VERT

**PM reviews each suggestion:** "Yes, this billing item does affect diagnosis management" → add E-DIAG to Epic(s). Or "No, this just mentions diagnosis in passing" → leave as-is.

**Step 1:** AI generates cross-link candidates.

**Step 2:** PM reviews and accepts/rejects each. ~30 minutes.

**Step 3:** Commit: "review: PM cross-link review — added N epic cross-links"

**Verification:** Run the AI query again — no new candidates should appear (all were reviewed).

---

## Phase 2: AI Tooling (Week 3-4)

### Task 2.1: Dashboard Generation

**Files:**
- Create: `examples/compliance-sample-pm/product/compliance-dashboard.md`

**What PM needs AI to do:**

Read all 593 compliance files and generate a dashboard with:

```markdown
# Compliance Dashboard
Generated: {timestamp}

## Summary
| Metric | Count |
|--------|-------|
| Total obligations | 593 |
| Confirmed (DEQ) | 0 |
| Partial match | 0 |
| TBC (no matches) | 593 |
| Suspect | 0 |
| Stale | 0 |

## By Epic
| Epic | Total | Confirmed | TBC | Suspect | Coverage |
|------|-------|-----------|-----|---------|----------|
| E-ABRD | 46 | 0 | 46 | 0 | 0% |
| E-DIAG | 72 | 0 | 72 | 0 | 0% |
| ... | | | | | |

## By Data Entity
| Entity | Total items referencing | Confirmed | Coverage |
|--------|----------------------|-----------|----------|
| Diagnose | 89 | 0 | 0% |
| Leistung | 67 | 0 | 0% |
| ... | | | | |

## Uncovered Items (no Design, Engineer, or QA match)
| ID | Obligation (truncated) | Epic | Entity |
|----|----------------------|------|--------|
| ABRD456 | code 0000 must be prompted | E-ABRD | Leistung, Schein |
| ... | | | |

## Dead Links
{List of compliance files referencing Related Items that don't exist}
```

**Step 1:** PM asks AI to generate the dashboard by reading all files. AI writes `compliance-dashboard.md`.

**Step 2:** PM verifies the counts match: total should be 593, sum of all statuses should be 593.

**Step 3:** Commit: "feat: add auto-generated compliance dashboard"

**Ongoing:** PM regenerates the dashboard after any batch of changes. This replaces the manual Section 1 status table in the monolith.

---

### Task 2.2: Quarterly Catalog Diff Workflow

**Files:**
- Read: new catalog PDF/source in `compliances/raw/`
- Read: existing compliance files in `compliance/{SOURCE}/`
- Output: diff report

**What PM needs AI to do:**

When a new quarterly catalog arrives (e.g., updated AKA Anforderungskatalog):

1. AI reads the new catalog source
2. AI reads all existing files in the affected subdirectory
3. AI produces a diff report:

```markdown
# Quarterly Reconciliation — AKA Q2-2026

## New items (not in current inventory)
| Proposed ID | Obligation | Proposed Epic | Proposed Entity |
|-------------|-----------|---------------|-----------------|
| ABRD1070 | {new obligation text} | E-ABRD | Leistung |

## Modified items (obligation text changed)
| ID | What changed | Current file |
|----|-------------|-------------|
| ABRD456 | Wording changed from "must prompt" to "must block" | [ABRD456.md](compliance/ABRD/ABRD456.md) |

## Removed items (no longer in catalog)
| ID | Previous obligation | Current file |
|----|-------------------|-------------|
| ABRD999 | {removed text} | [ABRD999.md](compliance/ABRD/ABRD999.md) |

## Unchanged: 295/305 items
```

**PM's work:** Review the diff (typically 5-20 items), not the full catalog.

**Step 1:** Place new catalog in `compliances/raw/`.

**Step 2:** Ask AI to diff against current files. AI produces the report.

**Step 3:** PM reviews:
- New items → AI generates files from template, PM reviews tags
- Modified items → PM updates Requirement section, sets Status → Suspect, adds Change History entry
- Removed items → PM sets Status → Stale, assesses impact

**Step 4:** Commit: "reconcile: AKA Q2-2026 — N new, N modified, N removed"

**Step 5:** Regenerate dashboard (Task 2.1).

---

### Task 2.3: Impact Analysis Query

**What PM needs AI to do:**

When a change request arrives, PM decomposes it into epics + entities and asks AI:

> "Show all compliance files where Epic contains E-ABRD or E-DIAG AND Data Entity contains Diagnose or Abrechnung"

AI reads the metadata section of each file (fast — just the front table, not the full content) and returns the filtered list.

**This is a deterministic query, not a search.** It reads structured tags, not free text. The result is a bounded superset PM can review.

**PM's work:**
1. Decompose the change request: which epics? which entities?
2. Run the query
3. Review the superset (~30-60 items)
4. Narrow to actually affected items (~10-20)
5. Mark those Suspect
6. Notify affected verticals using Track column

**No new files to create.** This is a workflow PM runs with AI whenever a change arrives.

---

## Phase 3: First Boundary — PM ↔ Dev (Week 5-6)

Per ADOPT.md: start with one boundary. PM ↔ Dev is recommended because Dev knows the system's real state.

### Task 3.1: Dev Fills Engineer Status and Ref

**Files:**
- Edit: `compliance/{SOURCE}/*.md` — Engineer Status and Engineer Ref in the Matches table

**What PM does:**

PM asks Dev to review compliance files by epic — starting with the epic Dev works on most.

**PM provides Dev with:**
1. One epic's worth of compliance files (e.g., all E-ABRD files — 46 items)
2. Clear instructions: "For each file, fill the Engineer row in the Matches table:
   - Match: code path that implements this obligation (e.g., `service/billing.ValidateCode0000`)
   - If not implemented: write `Not implemented`
   - If partially implemented: write `Partial — {what's missing}`"

**Dev's work per file:** Open file → read Requirement → check if code exists → fill Engineer row. ~2-3 minutes per file.

**PM does NOT fill this column.** Dev owns their match.

**Step 1:** PM selects the first epic for Dev to review. Pick the one with highest business risk or most items.

**Step 2:** Dev reviews and fills Engineer matches. One commit per section: "match: Dev reviewed E-ABRD engineer refs"

**Step 3:** AI updates Track column for each file: `_` → `E` (if only Engineer matched).

**Step 4:** Regenerate dashboard — coverage should increase.

**Step 5:** Repeat for next epic. PM and Dev establish a cadence: one epic per week.

**Verification:** After Dev reviews an epic, no files in that epic should have Engineer Status = `—`.

---

### Task 3.2: First Negotiation on a T3 Item

**What PM does:**

During Dev's review, Dev will find items where the obligation doesn't match the code. This is the first real negotiation.

Example: Dev reviews ABRD607 ("services submitted for billing must be protected from deletion") and says: "We have soft-delete, but there's no explicit audit entry when deletion is blocked. The AC says 'audit entry is preserved' but our code just returns a 403."

**PM's response (per the framework):**
1. This is independent discovery — Dev found something PM's AC didn't fully capture
2. PM and Dev negotiate: Is the 403 sufficient? Or does the AC need to require an explicit audit log entry?
3. If the AC changes → update ABRD607.md User Story & AC section
4. Record the negotiation in Change History: "2026-04-XX — AC refined: audit entry required on blocked deletion. Negotiated with Dev."

**This is matching in action.** Dev didn't blindly implement PM's AC. Dev challenged it. The box changed.

---

## Phase 4: Second Boundary — PM ↔ Designer (Week 7-8)

### Task 4.1: Designer Fills Design Match

**Files:**
- Edit: `compliance/{SOURCE}/*.md` — Design Match in the Matches table
- Designer also creates/updates their own screen specs with links back to compliance files

**What PM does:**

Same pattern as Dev. PM gives Designer one epic's worth of compliance files. Designer reviews each and fills the Design Match.

**Key difference from Dev:** Designer's match is bidirectional.
- In the compliance file: Design Match → `Screen: Billing Validation > Code 0000 Prompt`
- In Designer's screen spec: Compliance Coverage → `[ABRD456.md](../../product/compliance/ABRD/ABRD456.md)`

**This bidirectional linking enables the coverage query:**
- Forward: "Which screens cover ABRD456?" → read ABRD456.md Design Match
- Reverse: "Which compliance does the Billing Validation screen cover?" → read screen spec's Compliance Coverage section

**Step 1:** PM selects the first epic for Designer. Ideally the same epic Dev already reviewed — so PM can see the full picture for one area.

**Step 2:** Designer reviews and fills Design matches. Commit per section.

**Step 3:** AI updates Track column: `E` → `DE` (if both Engineer and Design matched).

**Step 4:** Regenerate dashboard.

**Verification:** Designer's screen specs should link back to every compliance file they filled a Design Match for. AI cross-checks: "compliance files with Design Match filled but NOT linked from any screen spec" = inconsistency.

---

### Task 4.2: Designer Pushback and Negotiation

**What PM expects:**

Designer will find obligations where the AC doesn't specify the UX clearly enough, or where the current screen design doesn't fully satisfy the obligation.

Examples:
- "ABRD611 says 'inform users when a more specific ICD-10 code is available' — inform how? Inline hint? Modal? Toast notification? The AC doesn't say."
- "ABRD970 says 'care facility name and location must be required for home visit services' — but the current form doesn't have these fields at all."

**PM's response:**
1. For UX ambiguity: negotiate with Designer. Designer proposes the interaction pattern, PM confirms it satisfies the compliance intent. Update AC if needed.
2. For missing functionality: this is a coverage gap. File it in known-gaps or create a backlog item. Update the compliance file's Status → TBC with a note.

---

## Phase 5: Third Boundary — PM ↔ QA (Week 9-10)

### Task 5.1: QA Fills QA Match

**Same pattern.** PM gives QA one epic. QA reviews each file and fills:
- QA Match: `TC-ABRD-001 (staging, 2026-04-15, pass)` — with execution metadata
- If no test exists: `Not covered`
- If test exists but fails: `TC-ABRD-001 (staging, 2026-04-15, fail)`

**Step 1-4:** Same as Dev and Designer flow.

**Step 5:** When Track = DEQ for a file, PM adds Confirmed By: `{PM name}, {date}` — the item is now Confirmed/Proven.

**Verification:** No file should reach Confirmed without QA Ref including execution metadata (environment, date, result). A TC-ID alone is a claim, not proof.

---

## Phase 6: First Quarterly Reconciliation (Week 11-12)

### Task 6.1: Run the Full Quarterly Cycle

**This is the validation that the whole system works.**

**Step 1:** New catalog arrives. Place in `compliances/raw/`.

**Step 2:** Run catalog diff (Task 2.2). AI produces the reconciliation report.

**Step 3:** PM reviews changes. Update affected files.

**Step 4:** Mark affected items Suspect. Track column tells PM who to notify.

**Step 5:** Notify Dev (for items with Track containing E), Designer (D), QA (Q).

**Step 6:** Each vertical re-verifies their match. Updates the compliance file.

**Step 7:** PM confirms re-verification. Suspect → Confirmed (or remains Suspect with explanation).

**Step 8:** Write reconciliation log entry.

**Step 9:** Regenerate dashboard.

**Step 10:** Commit everything: "reconcile: Q2-2026 quarterly update — N items affected, N re-verified"

**Verification:** After reconciliation, no items should remain Suspect without an explanation. Dashboard accurately reflects the new state.

---

## Ongoing: PM's Weekly Routine

| Day | Activity | Time | Tool |
|-----|----------|------|------|
| Monday | Regenerate dashboard, check for stale items | 15 min | AI |
| Monday | Review any drift notifications from verticals | 15 min | Manual |
| As needed | Impact analysis for change requests | 30 min per request | AI query |
| Friday | Review week's commits to compliance files | 15 min | git log |
| Quarterly | Full reconciliation cycle (Phase 6) | 2-3 days | AI + manual review |

---

## Success Criteria

| Milestone | Metric | Target |
|-----------|--------|--------|
| Phase 0 complete | Epics + Entities defined, template created | 13 epics, 12 entities, 1 template |
| Phase 1 complete | Monolith split into individual files | 593 files, all tags reviewed by PM |
| Phase 2 complete | Dashboard generates, diff workflow tested | Dashboard matches monolith counts |
| Phase 3 complete | Dev has reviewed at least 2 epics | Track column shows `E` for reviewed items |
| Phase 4 complete | Designer has reviewed at least 2 epics | Track column shows `DE` for reviewed items |
| Phase 5 complete | QA has reviewed at least 1 epic | First items reach `DEQ` / Confirmed |
| Phase 6 complete | First quarterly cycle runs end-to-end | Reconciliation log entry exists with evidence |

## Risk Register

| Risk | Impact | Mitigation |
|------|--------|-----------|
| AI tooling breaks or generates wrong dashboard | PM has no overview of 593 items | Keep monolith as read-only archive until dashboard is proven reliable (2 quarters) |
| Dev/Designer/QA don't fill their matches | Track column stays `_` forever | Start with one epic, make it a visible team goal. Don't boil the ocean. |
| Quarterly diff misses a catalog change | Compliance item drifts from source | PM spot-checks 10 random items per quarter against the source catalog |
| Tags are wrong, impact analysis returns wrong set | Missed compliance item during change request | QA cross-checks Designer's links against filtered list (second pair of eyes) |
| Team abandons the process after initial enthusiasm | Inventory rots silently | PM tracks dashboard trend weekly. If coverage stops increasing, investigate. |
