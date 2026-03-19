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
| **Story ID** | US-{ID} |
| **Obligation** | [{ID}](../compliances/{SOURCE_DIR}/{ID}.md) |
| **Type** | {Mandatory / Conditional Mandatory / Optional} |
| **Source** | {SOURCE_NAME} |
| **Epic** | — |
| **Phase** | — |
| **Status** | Draft |

### User Story

As a **{persona}**, I want **{capability}**,
so that **{justification}**.

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

| Vertical | Match | Confirmed By |
|----------|-------|-------------|
| Design | — | — |
| Engineer | — | — |
| QA | — | — |
```

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

---

## Cross-Reference Rules

- Every compliance ID referenced in the source file's Refer field → link in the AC or Notes
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

For each file:
1. Read the compliance file
2. Identify persona from context
3. Write user story (As a... I want... so that...)
4. Transform acceptance criteria to Gherkin scenarios
5. Write the US-{ID}.md file

Write ALL {N} files.
```

---

## Verification (Final Task)

1. **Count files**: `ls {OUTPUT_DIR}/US-{ID_PREFIX}* | wc -l` — should match input count
2. **Spot-check 3 files**: Read 3 user stories from different sections, verify:
   - Persona assignment is correct
   - User story text captures the obligation's intent (not just a literal translation)
   - Gherkin ACs are testable and match the compliance source
   - Traceability link to compliance file is correct
   - Status is "Draft"
3. **Gap check**: Compare compliance file list vs user story file list, report any missing
