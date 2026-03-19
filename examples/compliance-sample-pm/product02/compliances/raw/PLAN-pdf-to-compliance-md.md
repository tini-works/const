# Compliance PDF → Markdown Files — Reusable Plan Template

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Parse every compliance requirement from a KBV/EXT PDF requirement catalog into individual markdown files, one per requirement.

---

## How to Use This Template

1. Copy this plan into your prompt
2. Fill in the **Parameters** section below with the specific PDF details
3. Execute via the executing-plans skill

---

## Parameters (fill per PDF)

| Parameter | Value |
|-----------|-------|
| **PDF_PATH** | `docs/KVDT/{filename}.pdf` |
| **PDF_TITLE** | e.g., "Anforderungskatalog AVWG" |
| **PDF_VERSION** | e.g., "v5.8" |
| **PDF_PAGES** | e.g., 72 |
| **SOURCE_TAG** | Short name for Source field, e.g., "AVWG v5.8" |
| **OUTPUT_DIR** | `docs/KVDT/{SHORT_NAME}/` |
| **TOTAL_REQS** | Estimated requirement count |

---

## Phase 1: Discovery (Manual — before running the plan)

Read the PDF in page batches to build the **Requirement Inventory**:

1. Read pages 1-5 for table of contents, version info, document structure
2. Read remaining pages in batches of 15-20 to identify every requirement block
3. For each requirement, note: **ID**, **Title**, **Type** (from header), **Section**, **Page range**
4. Compile the inventory into the table format shown below

### Requirement Inventory Template

```markdown
### Section X.Y — [Section Name] (pN-M)
- [ID] — [German Title]
```

### Type Detection

Each requirement has a colored/styled header box. Map as follows:

| PDF Header Keyword | Type Value |
|---|---|
| PFLICHTFUNKTION | Mandatory |
| KONDITIONALE PFLICHTFUNKTION | Conditional Mandatory |
| OPTIONALE FUNKTION | Optional |

---

## Phase 2: Execution

### Task 1: Create output directory

```bash
mkdir -p {OUTPUT_DIR}
```

### Task 2: Create index file `00-index.md`

```markdown
# {PDF_TITLE} — Index

> **Source:** {PDF_TITLE} {PDF_VERSION}
> **Scope:** [One-line description of what these requirements cover]

---

## Section X.Y — [Section Name]

| ID | Title | Type |
|----|-------|------|
| [{ID}]({ID}.md) | [English Title] | [Type] |
...
```

### Tasks 3-N: Process requirements in parallel batches

Split the requirement inventory into batches of **8-18 requirements** by section/page range. Launch each batch as a **parallel subagent** with `mode: bypassPermissions` and `run_in_background: true`.

Each subagent receives:
- PDF path and page range to read
- List of requirement IDs to extract
- The file template (below)
- Translation and formatting rules

---

## File Template (per requirement)

**Filename:** `{ID}.md` (e.g., `P3-625.md`, `K4-200.md`)

```markdown
## {ID} — {Title translated to English}

| Field | Value |
|-------|-------|
| **ID** | {ID} |
| **Type** | {Mandatory / Conditional Mandatory / Optional} |
| **Source** | {SOURCE_TAG} |
| **Section** | {Section number and German name from PDF} |
| **Status** | TBC |
| **Goals** | — |
| **Verification Method** | — |
| **Matched by** | — |
| **Refer** | {comma-separated links to all compliance IDs referenced in this requirement's content, e.g., [P3-120](P3-120.md), [O3-622](O3-622.md). Use — if none.} |

### Requirement

{Main description text translated to English}

### Rationale

{Begründung text translated to English. OMIT this entire section if not present in PDF.}

### Acceptance Criteria

1. {Akzeptanzkriterium (1) translated to English}
2. {Akzeptanzkriterium (2) translated to English}
...

{OMIT this entire section if no acceptance criteria in PDF.}

### Notes

{Hinweis text translated to English. OMIT this entire section if not present in PDF.}
```

---

## Cross-Reference Linking Rules

Every compliance ID referenced in the **content** of a requirement file (Requirement, Rationale, Acceptance Criteria, Notes sections) must be:

1. **Linked inline** — replace plain `**P3-120**` or `P3-120` with `[P3-120](P3-120.md)` or `[**P3-120**](P3-120.md)`
2. **Listed in the Refer field** — all linked IDs collected as comma-separated links in the metadata table

This applies to:
- IDs from the **same** catalog (e.g., `P3-624` referencing `P3-120`)
- IDs from **other** catalogs (e.g., `O2-145`) — still link to `{ID}.md` even if the file doesn't exist yet; it will be created when that catalog is processed

---

## Translation Rules

- **Translate** all content (titles, descriptions, acceptance criteria, rationale, notes) to English
- **Preserve as-is** (do not translate):
  - Merkmal IDs and numbers (e.g., "Merkmal 011")
  - Legal references (e.g., "§ 73 SGB V", "§ 84 Absatz 1 SGB V")
  - Field codes (e.g., "FK 0225", "FK 3101")
  - Document/standard references (e.g., "AM-RL Anlage III", "EAMIV", "BMV-Ae")
  - FHIR profile names and paths (e.g., "KBV_PR_ERP_Prescription")
  - Form names (e.g., "Muster 16", "BtM-Rezept")
  - Technical identifiers (PZN, BSNR, LANR, NBSNR)
  - German terms that are domain-standard and have no clean English equivalent (e.g., "Hausapotheke", "aut idem", "Rote-Hand-Brief")
- **Use final/current text only** — ignore tracked changes, strikethrough, or highlighted markup

---

## Formatting Rules

- **Tables** in the PDF → render as markdown tables
- **Numbered acceptance criteria** using `(1)`, `(2)` → render as `1.`, `2.`
- **Sub-items** under acceptance criteria → render as indented markdown sub-lists
- **Large requirements** (e.g., spanning multiple pages with Merkmal tables): include FULL content, do not summarize
- **Condition text** (for K-prefix conditional requirements): include in the Notes section as "Condition: ..."

---

## Verification (Final Task)

1. **Count files**: `ls {OUTPUT_DIR} | wc -l` — should equal (requirement count + 1 index)
2. **Check completeness**: Loop through all expected IDs, verify each `.md` file exists
3. **Spot-check 3 files**: Read 3 files from different sections, verify:
   - Template structure is correct
   - Content matches PDF
   - Cross-reference links are present
   - Type mapping is correct

---

## Subagent Prompt Template

Use this prompt structure when dispatching each batch subagent:

```
You are processing compliance requirements from a PDF into individual markdown files.

**PDF path:** {PDF_PATH}
**Output directory:** {OUTPUT_DIR}

Read PDF pages {START}-{END} and extract ALL requirement blocks. Write one markdown file per requirement.

**Requirements to extract ({N} files):**
- {ID} — {German Title} (Section X.Y)
...

**Template:** [paste the File Template section above]

**Type mapping:** [paste the Type Detection table]

**Translation rules:**
- Translate ALL content to English
- Preserve German technical terms: Merkmal IDs, legal refs (§ XX SGB V), field codes (FK XXXX), document references, FHIR profile names
- Tables → markdown tables
- Use final/current text only (ignore tracked changes markup)

**Cross-reference linking:**
- Every compliance ID referenced in content must be linked as [ID](ID.md)
- Collect all referenced IDs into the Refer field in the metadata table

Read the PDF pages and write each file using the Write tool.
```

---

## Example Application: Formularbedruckung

To apply this plan to `KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung.pdf` (v1.37, 16 pages):

| Parameter | Value |
|-----------|-------|
| **PDF_PATH** | `docs/KVDT/KBV_ITA_VGEX_Anforderungskatalog_Formularbedruckung.pdf` |
| **PDF_TITLE** | Anforderungskatalog Formularbedruckung |
| **PDF_VERSION** | v1.37 |
| **PDF_PAGES** | 16 |
| **SOURCE_TAG** | Formularbedruckung v1.37 |
| **OUTPUT_DIR** | `docs/KVDT/Formularbedruckung/` |
| **TOTAL_REQS** | TBD (run Phase 1 discovery first) |

Phase 1 discovery steps:
1. Read pages 1-3 → TOC shows sections 2.1-2.10 covering form printing requirements
2. Read pages 4-14 → identify all requirement blocks (likely P7-xxx and KP7-xxx IDs based on change log)
3. Build inventory, then execute Phase 2
