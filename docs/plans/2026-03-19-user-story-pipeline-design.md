# User Story Pipeline — Design Document

> **Date:** 2026-03-19
> **Author:** PM + Claude
> **Status:** Draft
> **Problem:** Story creation overhead — transforming 600+ compliance obligations into user stories is the #1 bottleneck for a 2-person team

---

## Context

We manage a German healthcare practice management system (PVS) with compliance requirements from multiple KBV/GKV catalogs (KVDT, AVWG, Heilmittel, VDGA, ICD-10, Formularbedruckung, etc.). Requirements live as markdown in two git repos:

- **const** — compliance truth + proof tracking (604+ obligations, 297 user stories, 8 epics)
- **requirement-documents** — roadmap sequencing (1,046 requirements across 7 phases)

Stage 1 (PDF → compliance files) already works via `PLAN-pdf-to-compliance-md.md`. Stages 2-4 don't exist yet.

## Pipeline Architecture

```
PDF ──→ Stage 1: Parse ──→ Stage 2: Stories ──→ Stage 3: Assign ──→ Stage 4: Reconcile
         compliance files     user stories       epic + phase        inventory update
         (per requirement)    (per obligation)    (link to E1-E8)    (dashboard refresh)
```

Each stage produces durable markdown files committed to git. If a stage fails, fix that stage's output and re-run from there.

---

## Stage 1: PDF → Compliance Files (EXISTS)

**Template:** `PLAN-pdf-to-compliance-md.md`
**Input:** Raw PDF from KBV/GKV catalog
**Output:** Individual `{ID}.md` files + `00-index.md` in `compliances/{SOURCE}/`
**Method:** Phase 1 discovery (read PDF, build inventory), then parallel subagent batches

Already proven with KVDT (230+ files), AVWG (67 files), Heilmittel (39 files).

---

## Stage 2: Compliance Files → User Stories

**Template:** `PLAN-compliance-to-user-stories.md` (to be created)
**Input:** Directory of compliance `.md` files from Stage 1
**Output:** `US-{ID}.md` files in `user-stories/`

### User Story File Template

```markdown
## US-{ID} — {English title}

| Field | Value |
|-------|-------|
| **Story ID** | US-{ID} |
| **Obligation** | [{ID}]({ID}.md) |
| **Type** | {Mandatory / Conditional Mandatory / Optional} |
| **Source** | {catalog name and version} |
| **Epic** | — |
| **Phase** | — |
| **Status** | Draft |

### User Story

As a **{persona}**, I want **{capability derived from requirement}**,
so that **{business justification from rationale}**.

### Acceptance Criteria

Given {precondition}
When {action}
Then {expected outcome}
...

### Traceability

| Vertical | Match | Confirmed By |
|----------|-------|-------------|
| Design | — | — |
| Engineer | — | — |
| QA | — | — |
```

### Persona Mapping

| Compliance Context | Persona |
|---|---|
| Prescribing, ordering, clinical workflow | Vertragsarzt (contract physician) |
| Billing, submission, KV-facing | Abrechnungsverantwortliche (billing manager) |
| Patient-facing output (receipts, forms) | Patient |
| Software admin, master data, TI config | Praxisadministrator (practice administrator) |
| System-level (validation, crypto, format) | System (no persona — "The system must...") |

### AC Transformation Rules

- Each numbered acceptance criterion → one Gherkin scenario (Given/When/Then)
- Sub-items (a, b, c) → AND clauses within a scenario
- XML element paths, FK references, legal refs → preserved as-is in Then clauses
- Large multi-point ACs → multiple scenarios, numbered to match source
- If no acceptance criteria in compliance file → derive from requirement text, mark with `[derived]`

### Execution Method

- Read all compliance files from the source directory
- Split into batches of 10-15 files
- Launch parallel subagents (mode: bypassPermissions, run_in_background: true)
- Each subagent reads the compliance files (not the PDF) and writes user story files
- Verify: file count matches, spot-check 3 stories

---

## Stage 3: Epic & Phase Assignment

**Template:** `PLAN-assign-epics.md` (to be created)
**Input:** New `US-{ID}.md` files from Stage 2
**Output:** Updated `US-{ID}.md` files with Epic and Phase fields filled + updated epic files

### Assignment Rules

| Section / Source Pattern | Epic | Default Phase |
|---|---|---|
| Billing documentation, Leistungsdokumentation, GNR, GOP | E1 | Phase 2B |
| Abrechnung, KVDT-Datei, Verschluesselung, Pruefmodul | E2 | Phase 3 |
| HZV, FAV, Selektivvertrag, Teilnahme | E3 | Phase 1.7-1.9, 3.5-3.8 |
| Formularbedruckung, Muster, Bedruckung | E4 | Phase 5 |
| Stammdatei, Betriebsstaette, LANR, Konnektor, TI | E5 | Phase 7 |
| Patientenquittung, Dokumentation, allgemein | E6 | Phase 2A |
| KIM, 1Click, eRezept, eAU, ePA, eArztbrief | E7 | Phase 4-5 |
| Arzneimittel, AVWG, Heilmittel, DiGA, Verordnung | E8 | Phase 4 |

### Ambiguity Handling

When a story could belong to multiple epics:
- Assign to the **primary** epic (closest match to the requirement's core function)
- Add secondary epic(s) in a `Related Epics` field
- If genuinely ambiguous → set `Epic: TBD` for human review

### Epic File Updates

After assignment, append new story IDs to the relevant epic file's story list.

### Execution Method

- Single agent pass (not parallelized — needs global view of all stories)
- Reads all new US-*.md files, applies assignment rules
- Writes updated files with Epic/Phase filled
- Produces summary: count per epic, list of TBD items for human review

---

## Stage 4: Inventory Reconciliation

**Template:** `PLAN-reconcile-inventory.md` (to be created)
**Input:** Current state of `compliances/`, `user-stories/`, `epics/`
**Output:** Updated `compliance-inventory-*.md` + reconciliation report

### What It Does

1. **Count** compliance files per source directory
2. **Count** user stories per source
3. **Gap analysis:** obligations without stories, stories without epic assignment
4. **Status summary:** Draft / TBC / Confirmed counts
5. **Update** master inventory markdown with fresh numbers
6. **Report** what changed since last reconciliation

### Execution Method

- Single agent with file system access
- Reads directories, counts files, cross-references IDs
- Produces a dated reconciliation report in `docs/plans/`

---

## The Orchestrator

A single invocation that chains all 4 stages:

```
"Run the full pipeline on {PDF_FILENAME}"
```

### Orchestrator Flow

1. **Stage 1:** Run PLAN-pdf-to-compliance-md.md
   - Discovery → inventory → parallel subagent batches → verify file count
2. **Stage 2:** Run PLAN-compliance-to-user-stories.md
   - Read compliance dir → batch into groups → parallel subagents → verify
3. **Stage 3:** Run PLAN-assign-epics.md
   - Single pass over new stories → assign epics/phases → update epic files
4. **Stage 4:** Run PLAN-reconcile-inventory.md
   - Count everything → gap analysis → update dashboard → report

### Estimated Duration

| Catalog Size | Requirements | Pipeline Time |
|---|---|---|
| Small (VDGA, ~25 reqs) | ~25 | ~5 min |
| Medium (Heilmittel, ~30 reqs) | ~30 | ~8 min |
| Large (KVDT, ~300 reqs) | ~300 | ~25 min |

### Entry Points

The pipeline can be entered at any stage:
- `Stage 1` — new PDF, no compliance files exist yet
- `Stage 2` — compliance files exist (e.g., from manual creation), need stories
- `Stage 3` — stories exist, need epic/phase assignment
- `Stage 4` — everything exists, just need inventory refresh

---

## Implementation Plan

### Phase A: Build Stage 2 template (highest value)
- Create `PLAN-compliance-to-user-stories.md`
- Test on Heilmittel (39 compliance files → 39 user stories)
- Validate output quality against existing US-ABRD* stories for format consistency

### Phase B: Build Stage 3 template
- Create `PLAN-assign-epics.md`
- Test on Heilmittel stories from Phase A
- Validate epic assignments against manual expectations

### Phase C: Build Stage 4 template
- Create `PLAN-reconcile-inventory.md`
- Run full reconciliation across all existing files
- Validate counts against known inventory (604 obligations, 297 stories)

### Phase D: Build orchestrator
- Create `PLAN-full-pipeline.md` that chains Stages 1-4
- Test end-to-end on VDGA PDF (smallest catalog)
- Validate full chain produces correct, committed output

---

## Research Backing

This design aligns with several validated industry patterns:

1. **GitHub Spec Kit (2025)** — formalizes specs-as-code in markdown, living docs in git
2. **FDA/IEC 62304 git traceability** — regulated industries moving to git-based traceability as ALM replacement
3. **AI-native PM pattern** — AI generates first drafts, humans refine; batch processing + quality rubrics
4. **Context engineering** — structured context files (CLAUDE.md, plan templates) eliminate re-prompting
5. **Continuous backlog optimization** — AI audits traceability gaps rather than manual periodic grooming

Sources: GitHub Blog (spec-driven development), O'Reilly (AI-native PM), Mountain Goat Software (AI user stories), Intuition Labs (git FDA compliance), Dean Peters (Product-Manager-Skills framework).
