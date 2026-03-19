# Compliance Files → User Stories — Reusable Plan Template

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Transform individual compliance requirement markdown files into user story markdown files, one per obligation.

---

## How to Use This Template

1. Copy this plan into your prompt
2. Fill in the **Parameters** section below with the specific source details
3. Execute via the executing-plans skill

---

## Parameters (fill per source)

| Parameter | Value |
|-----------|-------|
| **COMPLIANCE_DIR** | e.g., `compliances/Heilmittel/` |
| **SOURCE_NAME** | e.g., "Heilmittel v2.7" |
| **OUTPUT_DIR** | `user-stories/` |
| **TOTAL_FILES** | Estimated file count (from Stage 1) |
| **ID_PREFIX** | Prefix pattern for story files, e.g., `US-P3` or `US-P1` |

---

## Phase 1: Discovery

1. List all `.md` files in COMPLIANCE_DIR (excluding `00-index.md`)
2. For each file, note: **ID**, **Title**, **Type** (from metadata table)
3. Group into batches of 10-15 for parallel processing

---

## Phase 2: Execution

### Task 1: Process files in parallel batches

Split the compliance files into batches of **10-15 files**. Launch each batch as a **parallel subagent** with `mode: bypassPermissions` and `run_in_background: true`.

Each subagent receives:
- List of compliance file paths to read
- The user story template (below)
- Persona mapping rules
- AC transformation rules

---

## User Story File Template

**Filename:** `US-{ID}.md` (e.g., `US-P3-18.md`, `US-P2-010.md`)

```markdown
## US-{ID} — {Title from compliance file}

| Field | Value |
|-------|-------|
| **ID** | US-{ID} |
| **Traced from** | [{ID}](../compliances/{SOURCE_DIR}/{ID}.md) |
| **Source** | {SOURCE_NAME} |
| **Status** | Draft |
| **Matched by** | — |
| **Proven by** | — |
| **Confirmed by** | — |
| **Epic** | — |
| **Data Entity** | {domain objects affected, e.g., "Verordnung, Diagnosegruppe". Use — if unclear.} |

### User Story

As a **{persona}**, I want **{capability}**,
so that **{justification}**.

### Compliance Context

{1-3 sentences explaining WHY this obligation exists — the regulatory driver, the patient safety concern, or the business risk if not implemented. Derived from the Rationale section of the compliance file. If the compliance file has no Rationale, derive from the legal basis (e.g., "Required by § 73 SGB V to ensure..."). This section should help a developer or designer understand the stakes without reading the full regulation.}

### Acceptance Criteria

**Scenario 1: {short description}**
Given {precondition}
When {action}
Then {expected outcome}

**Scenario 2: {short description}**
Given {precondition}
When {action}
Then {expected outcome}
...

### Traceability

- **Traced from:** [{ID}](../compliances/{SOURCE_DIR}/{ID}.md)
- **Matched by:**
  - Design: —
  - Engineer: —
  - API: —
- **Proven by:** —
- **Verification:** **unverified** — no test cases defined yet.
- **Confirmed by:** —
```

### Template Field Descriptions

| Field | Purpose | Filled by |
|-------|---------|-----------|
| **Traced from** | Link to the source compliance obligation | Stage 2 (auto) |
| **Source** | Catalog name and version | Stage 2 (auto) |
| **Status** | Draft → TBC → Confirmed → Suspect → Stale | PM lifecycle |
| **Matched by** | Links to screens, flows, APIs, ADRs, code paths | Design/Dev fill later |
| **Proven by** | Test case IDs with execution metadata (TC-xxx) | QA fills later |
| **Confirmed by** | Name + date of person who verified the match chain | PM/QA fills later |
| **Epic** | E1-E8 assignment | Stage 3 (auto) |
| **Data Entity** | Domain objects this story touches | Stage 2 (auto, best-effort) |
| **Compliance Context** | Why this regulation exists — stakes and driver | Stage 2 (auto) |
| **Traceability block** | Inline matched-by detail with vertical breakdown | Design/Dev/QA fill later |
| **Verification** | Narrative summary of proof status | QA fills later |

---

## Persona Mapping Rules

Assign persona based on the requirement's context:

| Context Signals | Persona |
|---|---|
| Prescribing, Verordnung, clinical workflow, diagnosis, Heilmittel selection | **Vertragsarzt** (contract physician) |
| Billing, Abrechnung, KVDT, submission, KV-facing, Pruefmodul | **Abrechnungsverantwortliche** (billing manager) |
| Patient-facing output: receipts, Patientenquittung, forms, printouts | **Patient** |
| Software admin, master data, Stammdatei, TI config, Konnektor, BSNR/LANR setup | **Praxisadministrator** (practice administrator) |
| System-level: validation, format enforcement, crypto, data integrity, auto-calculation | **System** (use "The system must..." instead of "As a...") |

When a requirement spans multiple personas, use the **primary actor** — the person who initiates the action.

---

## AC Transformation Rules

### From compliance acceptance criteria → Gherkin scenarios

1. Each **numbered acceptance criterion** (1), (2), (3) → one **Scenario**
2. **Sub-items** (a, b, c) within a criterion → **AND** clauses within that scenario
3. **Deeply nested sub-items** (i, ii, iii) → bullet points under the AND clause
4. **XML element paths** (SDHM, SDICD, SDHMA paths) → preserve as-is in the Then clause
5. **FK field references** (FK 0225, FK 3103) → preserve as-is
6. **Legal references** (§ 73 SGB V, § 13 HeilM-RL) → preserve as-is
7. **Document references** ([KBV_ITA_VGEX_...]) → preserve as-is

### When NO acceptance criteria exist in the compliance file

- Derive 1-2 scenarios from the Requirement text
- Mark each derived scenario with `[derived]` at the end of the scenario title

### User Story text derivation

- **Capability** (I want...): Extract from the Requirement section — what the software must enable
- **Justification** (so that...): Extract from the Rationale section — why this matters
- If no Rationale section exists, derive justification from the requirement context (compliance, patient safety, data quality)

### Compliance Context derivation

Write 1-3 sentences that answer: **"Why does this regulation exist, and what happens if we don't comply?"**

Sources (in priority order):
1. **Rationale** section of the compliance file — translate and condense
2. **Legal basis** referenced in the compliance file (§ XX SGB V, HeilM-RL, BMV-Ä) — explain the regulatory driver
3. **Notes** section — may contain implementation context or risk information
4. If none of the above, derive from the requirement type and domain (e.g., "Mandatory data integrity requirement to prevent billing rejections by the KV")

**Tone:** Direct, practical. Written for a developer or designer who needs to understand *why they should care*, not just *what to build*.

**Examples:**
- "Per § 73 Abs. 10 SGB V, physicians must have access to special prescribing needs (BVB) alongside the Heilmittel-Richtlinie. Without this data, physicians cannot identify when a diagnosis qualifies for extended treatment duration, risking under-treatment and KV audit findings."
- "The KBV certification process requires immutable master data files. If the software allows user modification of SDHM content, the certification will be revoked and the software cannot be used for statutory billing."
- "This is a data quality safeguard. Incorrect date entries propagate into the KVDT billing file and cause systematic rejections during KV processing, requiring manual correction of potentially thousands of records."

### Data Entity derivation

Identify the primary domain objects the story touches. Use the following entity vocabulary:

| Entity | German | Use when the story involves... |
|--------|--------|-------------------------------|
| Patient | Versichertenstammdaten | Patient demographics, insurance card, identification |
| Schein | Behandlungsfall | Treatment case, quarter assignment, case lifecycle |
| Leistung | Leistung/GOP | Service entry, billing codes, EBM procedures |
| Diagnose | Diagnose/ICD-10 | Diagnosis coding, ICD-10 selection, Diagnosekategorie |
| Verordnung | Verordnung | Prescriptions (Heilmittel, Arzneimittel, DiGA) |
| Ueberweisung | Überweisung | Referrals |
| Abrechnung | KVDT-Datensatz | Billing file generation, ADT/KADT/SADT submission |
| Vertrag | Vertrag (HZV/FAV) | Selective contract configuration |
| Einschreibung | Teilnahmeerklärung | Patient enrollment in selective contracts |
| Formular | Formulare/BFB | Form printing, Muster 13/16/etc. |
| Praxis | Praxis/BSNR | Practice config, Betriebsstätte, user management |
| Stammdaten | Katalog (EBM, ICD, OPS, SDHM) | Master data files, catalogs, Stammdateien |
| Konnektor | TI-Komponente | TI connector, eHBA, SMC-B, KIM |

Assign 1-3 entities. If a story is purely about master data validation, use "Stammdaten". If unclear, use "—".

---

## Cross-Reference Rules

- Every compliance ID referenced in the source file's Refer field → link in the AC or Compliance Context
- Use format `[{ID}](../compliances/{SOURCE_DIR}/{ID}.md)` for compliance refs
- Use format `[US-{ID}](US-{ID}.md)` for sibling user story refs

---

## Subagent Prompt Template

```
You are transforming compliance requirement files into user story files.

**Source directory:** {COMPLIANCE_DIR}
**Output directory:** {OUTPUT_DIR}
**Source name:** {SOURCE_NAME}

Read each compliance file listed below, then write a corresponding user story file.

**Files to process ({N}):**
- {COMPLIANCE_DIR}/{ID}.md → {OUTPUT_DIR}/US-{ID}.md
...

**Template:** [paste User Story File Template]
**Persona mapping:** [paste Persona Mapping Rules]
**AC transformation:** [paste AC Transformation Rules]
**Compliance Context rules:** [paste Compliance Context derivation]
**Data Entity rules:** [paste Data Entity derivation]

For each file:
1. Read the compliance file
2. Identify persona from context
3. Write user story (As a... I want... so that...)
4. Write Compliance Context (1-3 sentences: why it exists, what's at stake)
5. Transform acceptance criteria to Gherkin scenarios
6. Identify Data Entity (1-3 from the entity vocabulary)
7. Write the Traceability block with Traced from link and placeholder dashes for matches
8. Write the US-{ID}.md file

Write ALL {N} files.
```

---

## Verification (Final Task)

1. **Count files**: `ls {OUTPUT_DIR}/US-{ID_PREFIX}* | wc -l` — should match input count
2. **Spot-check 3 files**: Read 3 user stories from different sections, verify:
   - Persona assignment is correct
   - User story text captures the obligation's intent (not just a literal translation)
   - Compliance Context explains the "why" and stakes (not just restating the requirement)
   - Gherkin ACs are testable and match the compliance source
   - Data Entity assignment is reasonable
   - Traceability block has correct Traced from link
   - Status is "Draft"
3. **Gap check**: Compare compliance file list vs user story file list, report any missing
