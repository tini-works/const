# KVDT Datensatzbeschreibung PDF → Markdown — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Parse the KVDT Dataset Description (Datensatzbeschreibung) PDF into structured markdown files — one per record type, one per rule table, one per field table, plus prose sections and a master index.

**Architecture:** 5 parallel agents, each assigned a major chapter of the 203-page PDF. Each agent reads its page range and writes markdown files to the output directory. A final verification pass checks completeness.

**Tech Stack:** Claude PDF reading, Write tool, markdown

---

## Parameters

| Parameter | Value |
|-----------|-------|
| **PDF_PATH** | `examples/compliance-sample-pm/product/compliances/raw/KBV_ITA_VGEX_Datensatzbeschreibung_KVDT.pdf` |
| **PDF_TITLE** | Datensatzbeschreibung KVDT |
| **PDF_VERSION** | v6.03 |
| **PDF_PAGES** | 203 |
| **SOURCE_TAG** | KVDT-DSB v6.03 |
| **OUTPUT_DIR** | `examples/compliance-sample-pm/product/compliances/KVDT-DSB/` |

---

## Document Inventory

This is a **dataset specification** (not a requirement catalog). The atomic output units are:

### Record Types (Satztabellen) — 20 files

| ID | German Name | Section | Pages |
|----|------------|---------|-------|
| con0 | Container-Header | 2.2.1 | 20 |
| con9 | Container-Abschluss | 2.2.2 | 21 |
| besa | Betriebsstättendaten | 2.2.3 | 21-25 |
| rvsa | Ringversuchszertifikate | 2.2.4 | 25 |
| adt0 | ADT-Datenpaket-Header | 3.4.1 | 36-37 |
| adt9 | ADT-Datenpaket-Abschluss | 3.4.2 | 37 |
| 0101 | Ambulante Behandlung | 3.4.3 | 38-46 |
| 0102 | Überweisung | 3.4.4 | 46-55 |
| 0103 | Belegärztliche Behandlung | 3.4.5 | 55-61 |
| 0104 | Notfalldienst/Vertretung/Notfall | 3.4.6 | 61-67 |
| kad0 | KADT-Datenpaket-Header | 4.4.1 | 122-123 |
| kad9 | KADT-Datenpaket-Abschluss | 4.4.2 | 123 |
| 0109 | Kurärztliche Behandlung | 4.4.3 | 123-127 |
| sad0 | SADT-Datenpaket-Header | 5.4.1 | 147-148 |
| sad9 | SADT-Datenpaket-Abschluss | 5.4.2 | 149 |
| sad1 | SADT-ambulante Behandlung | 5.4.3 | 149-150 |
| sad2 | SADT-Überweisung | 5.4.4 | 150-151 |
| sad3 | SADT-belegärztliche Behandlung | 5.4.5 | 151-152 |
| hdrg0 | HDRG-Datenpaket-Header | 6.5.1 | 160-161 |
| hdrg9 | HDRG-Datenpaket-Abschluss | 6.5.2 | 161 |
| hdrg1 | HDRG-Datenpaket | 6.5.3 | 161-165 |

### Field Tables (Feldtabellen) — 4 files

| ID | Table | Pages |
|----|-------|-------|
| ADT-FT | ADT-Feldtabelle | 68-88 |
| KADT-FT | KADT-Feldtabelle | 127-135 |
| SADT-FT | SADT-Feldtabelle | 152-155 |
| HDRG-FT | HDRG-Feldtabelle | 165-172 |

### Rule Tables (Regeltabellen) — 4 files

| ID | Table | Pages |
|----|-------|-------|
| ADT-RT | ADT-Regeltabelle | 88-115 |
| Container-RT | Container-Regeltabelle | 30-34 |
| KADT-RT | KADT-Regeltabelle | 135-145 |
| SADT-RT | SADT-Regeltabelle | 155-159 |
| HDRG-RT | HDRG-Regeltabelle | 172-180 |

### Prose/Reference Sections — 5 files

| ID | Title | Pages |
|----|-------|-------|
| CH1-fundamentals | Grundlagen | 8-19 |
| CH2-container-overview | Container-Sätze overview | 20 |
| CH3-adt-overview | ADT-Datenpaket overview/special notes | 35, 116-120 |
| CH4-kadt-overview | KADT-Datenpaket overview/special notes | 121, 127 |
| CH7-feldverzeichnis | Feldverzeichnis (master field directory) | 181-201 |

### Total files: ~35 content files + 1 index = ~36 files

---

## File Templates

### Record Type File Template

**Filename:** `{satzart-id}.md` (e.g., `con0.md`, `0101.md`, `hdrg1.md`)

```markdown
## {Satzart ID} — {English Title}

| Field | Value |
|-------|-------|
| **Satzart** | {ID} |
| **German Name** | {Original German name} |
| **Source** | KVDT-DSB v6.03 |
| **Section** | {Section number and title} |
| **Data Package** | {Container / ADT / KADT / SADT / HDRG} |
| **Refer** | {links to related records, field tables, rule tables} |

### Purpose

{Brief description of what this record type is used for, translated to English}

### Field Table (Satztabelle)

| FK | Occ | Field Name | Type | Condition | Notes |
|----|-----|-----------|------|-----------|-------|
| {FK code} | {1/n} | {Feldbezeichnung translated} | {M/K/m/k} | {Bedingung} | {Erläuterung translated} |
...

### Ordering Rules

{Any ordering/sequence rules for this record, translated to English}
```

### Field Table File Template

**Filename:** `{package}-feldtabelle.md` (e.g., `adt-feldtabelle.md`)

```markdown
## {Package} Field Table (Feldtabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.03 |
| **Section** | {Section number} |
| **Scope** | Field validation rules for {package} data package |

### Fields

| FK | Field Name | Length | Type | Rule | Allowed Values | Example |
|----|-----------|--------|------|------|---------------|---------|
| {FK} | {Feldbezeichnung} | {Länge} | {Typ} | {Regel} | {Erlaubte Inhalte translated} | {Beispiel} |
...
```

### Rule Table File Template

**Filename:** `{package}-regeltabelle.md` (e.g., `adt-regeltabelle.md`)

```markdown
## {Package} Rule Table (Regeltabelle)

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.03 |
| **Section** | {Section number} |
| **Scope** | Validation rules for {package} data package |

### Rules

| R-Nr | Category | Check | Status | Description |
|------|----------|-------|--------|-------------|
| {R-Nr} | {Kategorie} | {Prüfung} | {Prüfstatus: F/W/I} | {Erläuterung translated} |
...
```

### Prose Section File Template

**Filename:** `{id}.md` (e.g., `CH1-fundamentals.md`)

```markdown
## {Title in English}

| Field | Value |
|-------|-------|
| **Source** | KVDT-DSB v6.03 |
| **Section** | {Section number(s)} |

{Content translated to English, preserving all tables, diagrams, and structure}
```

---

## Translation Rules

Same as the PLAN-pdf-to-compliance-md.md template:
- **Translate** all content to English
- **Preserve as-is**: FK codes, legal references (§ XX SGB V), technical identifiers (BSNR, LANR, NBSNR, IK, PZN), document references, FHIR profile names, form names (Muster 16), field codes (FK XXXX), record type IDs (con0, adt0, etc.)
- **Tables** in the PDF → render as markdown tables
- Preserve Feldart codes as-is: M (Mandatory), K (Conditional), m (mandatory lowercase), k (conditional lowercase)

---

## Agent Assignments (5 Agents)

### Agent 1: Foundations + Container (Pages 1-34) → ~9 files

**Scope:** Chapter 1 (Grundlagen) + Chapter 2 (Container-Sätze)

**Files to create:**
1. `CH1-fundamentals.md` — Grundlagen prose (p8-19): storage structure, record/field definitions, file naming, character sets
2. `con0.md` — Container-Header record (p20)
3. `con9.md` — Container-Abschluss record (p21)
4. `besa.md` — Betriebsstättendaten record (p21-25)
5. `rvsa.md` — Ringversuchszertifikate record (p25)
6. `container-feldtabelle.md` — Container field table (p26-30)
7. `container-regeltabelle.md` — Container rule table (p30-34)

**PDF pages to read:** 1-34

---

### Agent 2: ADT Data Package — Records + Special Notes (Pages 35-67, 116-120) → ~9 files

**Scope:** Chapter 3 record types + overview + special notes (NOT field/rule tables)

**Files to create:**
1. `CH3-adt-overview.md` — ADT overview, ordering, special notes (p35, 116-120)
2. `adt0.md` — ADT-Datenpaket-Header (p36-37)
3. `adt9.md` — ADT-Datenpaket-Abschluss (p37)
4. `0101.md` — Ambulante Behandlung (p38-46) — LARGE, ~8 pages of fields
5. `0102.md` — Überweisung (p46-55) — LARGE
6. `0103.md` — Belegärztliche Behandlung (p55-61)
7. `0104.md` — Notfalldienst/Vertretung/Notfall (p61-67)

**PDF pages to read:** 35-67, 116-120

---

### Agent 3: ADT Field Table + Rule Table (Pages 68-115) → 2 files

**Scope:** The large ADT-Feldtabelle and ADT-Regeltabelle

**Files to create:**
1. `adt-feldtabelle.md` — ADT Field Table (p68-88) — ~60+ field entries with value enumerations
2. `adt-regeltabelle.md` — ADT Rule Table (p88-115) — ~80+ validation rules

**PDF pages to read:** 68-115

**Note:** These are the largest tables in the document. The ADT-Regeltabelle alone spans ~27 pages with complex format rules and value enumerations. Agent must capture ALL rules completely.

---

### Agent 4: KADT + SADT + HDRG (Pages 121-180) → ~16 files

**Scope:** Chapters 4, 5, and 6 complete

**Files to create:**
1. `CH4-kadt-overview.md` — KADT overview + special notes (p121, 127)
2. `kad0.md` — KADT Header (p122-123)
3. `kad9.md` — KADT Abschluss (p123)
4. `0109.md` — Kurärztliche Behandlung (p123-127)
5. `kadt-feldtabelle.md` — KADT Field Table (p127-135)
6. `kadt-regeltabelle.md` — KADT Rule Table (p135-145)
7. `sad0.md` — SADT Header (p147-148)
8. `sad9.md` — SADT Abschluss (p149)
9. `sad1.md` — SADT-ambulante Behandlung (p149-150)
10. `sad2.md` — SADT-Überweisung (p150-151)
11. `sad3.md` — SADT-belegärztliche Behandlung (p151-152)
12. `sadt-feldtabelle.md` — SADT Field Table (p152-155)
13. `sadt-regeltabelle.md` — SADT Rule Table (p155-159)
14. `hdrg0.md` — HDRG Header (p160-161)
15. `hdrg9.md` — HDRG Abschluss (p161)
16. `hdrg1.md` — HDRG record (p161-165)
17. `hdrg-feldtabelle.md` — HDRG Field Table (p165-172)
18. `hdrg-regeltabelle.md` — HDRG Rule Table (p172-180)

**PDF pages to read:** 121-180

---

### Agent 5: Feldverzeichnis + Master Index (Pages 181-203) → 2 files

**Scope:** Chapter 7 (Feldverzeichnis) + Chapter 8 (References) + create master index

**Files to create:**
1. `CH7-feldverzeichnis.md` — Complete master field directory (p181-201): every FK field with name, length, type, record type usage, and full description
2. `00-index.md` — Master index linking all files

**PDF pages to read:** 181-203

**Index file format:**

```markdown
# Datensatzbeschreibung KVDT — Index

> **Source:** Datensatzbeschreibung KVDT v6.03
> **Scope:** Dataset description for KVDT billing data transfer (ADT/KADT/SADT/HDRG)

---

## Fundamentals

| ID | Title |
|----|-------|
| [Fundamentals](CH1-fundamentals.md) | Data structures, storage, field/record definitions |

## Container Records (Chapter 2)

| Satzart | Title | Type |
|---------|-------|------|
| [con0](con0.md) | Container Header | Record |
| [con9](con9.md) | Container Closing | Record |
| [besa](besa.md) | Practice Site Data | Record |
| [rvsa](rvsa.md) | Ring Trial Certificates | Record |
| [Container-FT](container-feldtabelle.md) | Container Field Table | Feldtabelle |
| [Container-RT](container-regeltabelle.md) | Container Rule Table | Regeltabelle |

## ADT Data Package (Chapter 3)

| Satzart | Title | Type |
|---------|-------|------|
| [ADT Overview](CH3-adt-overview.md) | ADT overview and special notes | Prose |
| [adt0](adt0.md) | ADT Header | Record |
| [adt9](adt9.md) | ADT Closing | Record |
| [0101](0101.md) | Outpatient Treatment | Record |
| [0102](0102.md) | Referral | Record |
| [0103](0103.md) | Hospital-based Treatment | Record |
| [0104](0104.md) | Emergency/Substitute Service | Record |
| [ADT-FT](adt-feldtabelle.md) | ADT Field Table | Feldtabelle |
| [ADT-RT](adt-regeltabelle.md) | ADT Rule Table | Regeltabelle |

## KADT Data Package (Chapter 4)

| Satzart | Title | Type |
|---------|-------|------|
| [KADT Overview](CH4-kadt-overview.md) | KADT overview and special notes | Prose |
| [kad0](kad0.md) | KADT Header | Record |
| [kad9](kad9.md) | KADT Closing | Record |
| [0109](0109.md) | Spa Treatment | Record |
| [KADT-FT](kadt-feldtabelle.md) | KADT Field Table | Feldtabelle |
| [KADT-RT](kadt-regeltabelle.md) | KADT Rule Table | Regeltabelle |

## SADT Data Package NRW (Chapter 5)

| Satzart | Title | Type |
|---------|-------|------|
| [sad0](sad0.md) | SADT Header | Record |
| [sad9](sad9.md) | SADT Closing | Record |
| [sad1](sad1.md) | SADT Outpatient Treatment | Record |
| [sad2](sad2.md) | SADT Referral | Record |
| [sad3](sad3.md) | SADT Hospital-based Treatment | Record |
| [SADT-FT](sadt-feldtabelle.md) | SADT Field Table | Feldtabelle |
| [SADT-RT](sadt-regeltabelle.md) | SADT Rule Table | Regeltabelle |

## Hybrid-DRG Data Package (Chapter 6)

| Satzart | Title | Type |
|---------|-------|------|
| [hdrg0](hdrg0.md) | HDRG Header | Record |
| [hdrg9](hdrg9.md) | HDRG Closing | Record |
| [hdrg1](hdrg1.md) | HDRG Record | Record |
| [HDRG-FT](hdrg-feldtabelle.md) | HDRG Field Table | Feldtabelle |
| [HDRG-RT](hdrg-regeltabelle.md) | HDRG Rule Table | Regeltabelle |

## Reference

| ID | Title |
|----|-------|
| [Feldverzeichnis](CH7-feldverzeichnis.md) | Master Field Directory |
```

---

## Execution Plan

### Task 1: Create output directory

```bash
mkdir -p examples/compliance-sample-pm/product/compliances/KVDT-DSB/
```

### Tasks 2-6: Launch 5 parallel agents

Launch all 5 agents simultaneously with `mode: bypassPermissions` and `run_in_background: true`.

Each agent receives:
- PDF path
- Page range to read
- List of files to create with templates
- Translation and formatting rules

---

### Subagent Prompt Template

```
You are processing the KVDT Datensatzbeschreibung (Dataset Description) PDF into individual markdown files.

**PDF path:** examples/compliance-sample-pm/product/compliances/raw/KBV_ITA_VGEX_Datensatzbeschreibung_KVDT.pdf
**Output directory:** examples/compliance-sample-pm/product/compliances/KVDT-DSB/

Read PDF pages {START}-{END} and extract the specified content. Write one markdown file per item.

**Files to create ({N} files):**
{list of files with descriptions}

**Templates:** {paste relevant template}

**Translation rules:**
- Translate ALL prose and descriptions to English
- Preserve as-is: FK codes, legal refs (§ XX SGB V), technical IDs (BSNR, LANR, NBSNR, IK),
  document references, FHIR names, form names (Muster 16), record type IDs (con0, adt0, etc.)
- Preserve Feldart codes: M (Mandatory), K (Conditional), m/k (lowercase variants)
- Tables → markdown tables
- Use final/current text only (ignore tracked changes markup)

**Cross-reference linking:**
- Link to other files in the same output directory: [con0](con0.md), [adt-feldtabelle](adt-feldtabelle.md)
- List all linked files in the Refer field

Read the PDF pages and write each file using the Write tool.
```

---

## Task 7: Verification

After all 5 agents complete:

1. **Count files**: `ls examples/compliance-sample-pm/product/compliances/KVDT-DSB/ | wc -l` — should be ~36
2. **Check completeness**: Verify all expected files exist
3. **Spot-check 3 files** from different agents:
   - 1 record type file (e.g., `0101.md`) — verify field table is complete
   - 1 field table file (e.g., `adt-feldtabelle.md`) — verify all FK entries present
   - 1 rule table file (e.g., `adt-regeltabelle.md`) — verify rules are complete
4. **Verify index**: Check `00-index.md` links all files correctly

---

## Agent Workload Summary

| Agent | Chapter | Pages | Files | Complexity |
|-------|---------|-------|-------|------------|
| 1 | Foundations + Container | 1-34 | 7 | Medium |
| 2 | ADT Records + Notes | 35-67, 116-120 | 7 | High (large record tables) |
| 3 | ADT Field + Rule Tables | 68-115 | 2 | High (47 pages of dense tables) |
| 4 | KADT + SADT + HDRG | 121-180 | 18 | High (3 packages, many files) |
| 5 | Feldverzeichnis + Index | 181-203 | 2 | Medium (master field directory) |
