# Instruction — Generate AKA Compliance Files and User Stories

## Goal

Extract all 305 AKA-sourced compliance items from the master inventory and generate:
- **305 compliance files** in `compliances/SV/`
- **305 user story files** in `user-stories/`

Each compliance file links to its user story. Each user story links back to its compliance file.

---

## Input

**Source file:** `product/compliance-inventory-18032026_1350.md`

**Scope:** All rows in sections 3.1–3.10 where `Ext. Source` contains `AKA Q1-26-1`. These are 305 items across these sections:

| Section | Prefix | Count |
|---------|--------|-------|
| 3.1 ABRD — Billing Documentation | ABRD | 46 |
| 3.2 ABRG — Billing Process | ABRG | 45 |
| 3.3 VERT — Contract Participation | VERT | 43 |
| 3.4 VERE — Patient Enrollment | VERE | 25 |
| 3.5 FORM — Form Management | FORM | 45 |
| 3.6 VSST — Practice Software | VSST | 65 |
| 3.7 ALLG — General Requirements | ALLG | 28 |
| 3.8 ITVE — IT Connectivity | ITVE | 6 |
| 3.9 DETE — Data Exchange | DETE | 1 |
| 3.10 PSDV — Patient Master Data | PSDV | 1 |

---

## Output 1 — Compliance Files

**Path:** `product/compliances/SV/{ID}.md` (e.g., `ABRD456.md`)

**Template:**

```markdown
## {ID} — {Short title derived from Obligation}

| Field | Value |
|-------|-------|
| **ID** | {ID} |
| **Type** | {Requirement Type} |
| **Source** | {Ext. Source} |
| **Section** | {Section number and name} |
| **Status** | {Status} |
| **Goals** | {Goals} |
| **Verification Method** | {Verification Method} |
| Matched by | [{US-ID}](../../user-stories/{US-ID}.md) |

### Requirement

{Full obligation text from the Obligation column.}

### Acceptance Criteria

1. {First Given/When/Then from the AC text.}
2. {Second Given/When/Then, if present.}
```

**Field mapping from inventory row:**

| Template field | Inventory column |
|----------------|-----------------|
| `{ID}` | ID (e.g., `ABRD456`) |
| `{Short title}` | Derive from Obligation — keep it under 10 words, capture the core subject |
| `{Requirement Type}` | Requirement Type (Mandatory / Optional) |
| `{Ext. Source}` | Ext. Source (e.g., `AKA Q1-26-1` or `AKA Q1-26-1, SGB V §295`) |
| `{Section number and name}` | From the section header (e.g., `3.1 ABRD — Billing Documentation`) |
| `{Status}` | Status (e.g., `TBC`) |
| `{Goals}` | Goals (e.g., `BG-1a, BG-2`) |
| `{Verification Method}` | Verification Method (e.g., `Validator unit test`) |
| `{US-ID}` | `US-{ID}` (e.g., `US-ABRD456`) |
| `{Obligation text}` | Obligation column — full text, verbatim |
| `{AC items}` | Extract from User Story & AC column — split on `;` after `**AC:**`, each becomes a numbered item. Clean up `given`/`when`/`then` to start with capital letters |

**Rules:**
- One file per inventory row
- If Obligation is `_(name pending)_`, use `(name pending)` as the short title and leave Requirement as `_(name pending — to be defined from AKA catalog documentation)_`
- If AC text is `—`, write `_(pending — fill after obligation text is resolved)_`
- Preserve German terms exactly as they appear (Quartal, Leistung, Behandlungsfall, etc.)

---

## Output 2 — User Story Files

**Path:** `product/user-stories/{US-ID}.md` (e.g., `US-ABRD456.md`)

**Template:**

```markdown
## {US-ID} — {Same short title as compliance file}

| Field | Value |
|-------|-------|
| **ID** | {US-ID} |
| **Traced from** | [{ID}](../compliances/SV/{ID}.md) |
| **Source** | {Ext. Source} |
| **Status** | {Status} |
| Matched by | — |
| Proven by | — |
| Confirmed by | — |

### User Story

{User story text from the User Story & AC column — everything before **AC:**. Clean up grammar if needed but preserve meaning and German terms.}

### Acceptance Criteria

1. {First Given/When/Then.}
2. {Second Given/When/Then, if present.}
```

**Field mapping from inventory row:**

| Template field | Inventory column |
|----------------|-----------------|
| `{US-ID}` | `US-` + ID (e.g., `US-ABRD456`) |
| `{Short title}` | Same short title used in the compliance file |
| `{ID}` | ID (e.g., `ABRD456`) — for the Traced from link |
| `{Ext. Source}` | Ext. Source |
| `{Status}` | Status |
| `{User story text}` | User Story & AC column — text before `**AC:**` |
| `{AC items}` | Same as compliance file — split on `;` after `**AC:**` |

**Rules:**
- `Matched by` starts as `—` — filled later by Design/Engineering with screen specs, API refs, code paths
- `Proven by` starts as `—` — filled later by QA with test case IDs
- `Confirmed by` starts as `—` — filled later by PM with named verifier and date
- If User Story & AC is `—`, write `_(pending — fill after obligation text is resolved)_` for both sections

---

## Linking

Each compliance file points **forward** to its user story:
```
| Matched by | [US-ABRD456](../../user-stories/US-ABRD456.md) |
```

Each user story points **back** to its compliance file:
```
| **Traced from** | [ABRD456](../compliances/SV/ABRD456.md) |
```

---

## Verification

After generation, verify:
- [ ] 305 files exist in `compliances/SV/` (excluding this INSTRUCTION.md)
- [ ] 305 files exist in `user-stories/`
- [ ] Every compliance file has a `Matched by` link to a user story that exists
- [ ] Every user story has a `Traced from` link to a compliance file that exists
- [ ] No duplicate IDs
- [ ] All German terms preserved verbatim
