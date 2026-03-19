# Product — Compliance Sample (PVS)

Product vertical for the VSST592 Medical Practice Management System, focused on German selective healthcare contract compliance (HZV/FAV).

**Owner:** PM

## What's here

| Document | Purpose |
|----------|---------|
| [compliance-inventory-18032026_1350.md](compliance-inventory-18032026_1350.md) | Master compliance inventory — 604 obligations across 10 compliance sources, with status dashboard, business goals, quarterly reconciliation, drift detection, and decision log |

## Context

This is a compliance-driven product vertical. Unlike feature-driven product folders, the primary artifact here is a **compliance inventory** — a single document that serves as the matchable checklist for downstream verticals (Design, Engineering, QA).

The inventory tracks obligations from German healthcare regulations and certification requirements:

- **AKA** (Anforderungskatalog) — HZV/FAV selective contract certification (305 items)
- **KBV EBM / GOÄ / TSS / ICD-10-GM** — statutory and private billing rules (17 items)
- **KVDT** — patient data, service documentation, billing file formats (158 items)
- **ICD-10-GM** — diagnosis coding and validation (57 items)
- **Crucial Workflows** — E-Rezept, eAU, eArztbrief, ePA, eDMP (56 items)

Every obligation traces to an external compliance source and is matched by Design, Engineering, and QA verticals before it can be marked Confirmed.

## Finding what you need

- **"How many obligations are there and what's the status?"** — Section 1 (Inventory Status dashboard)
- **"What business goals drive this?"** — Section 2 (Business Goals + RACI matrix)
- **"What must the system do for billing?"** — Sections 3.1–3.2 (ABRD + ABRG)
- **"What are the enrollment requirements?"** — Sections 3.3–3.4 (VERT + VERE)
- **"What are the KVDT format requirements?"** — Sections 3.15–3.18
- **"What's not covered yet?"** — Section 4.1 (Known Gaps)
- **"Which customers need which rules?"** — Section 5 (Customer & Deployment Context)
- **"What changed and when?"** — Section 7 (Change Log)
- **"Is anything out of sync?"** — Section 8 (Drift Register)
- **"Why was that decision made?"** — Section 8.1 (Decision Log)

## How verification works

Every inventory item carries a verification status:

- **Confirmed** (= Proven per the Constitution) — all match columns filled + evidence recorded + named human verifier and date. Audit-ready.
- **TBC** — at least one downstream match is missing. Not proven.
- **Suspect** — was Confirmed but a drift or source change was detected. Not proven until PM reviews.

An item reaches Confirmed only when it has: (1) an external source, (2) a Design match, (3) an Engineering match, (4) a QA match, and (5) a `Confirmed By` entry. The Track column (`_`, `D`, `E`, `Q`, `DE`, `DQ`, `EQ`, `DEQ`) shows progress at a glance.

## How tracing works

Every obligation traces in two directions:

- **Where it came from**: the Ext. Source column links to AKA catalog IDs, KBV rules, KVDT specs, or federal law references
- **What matches it downstream**: Design Match (screen/flow), Engineer Ref (code path), QA Ref (test case with execution metadata)

The inventory is reconciled quarterly when compliance sources update (Section 6). Changes are logged in Section 7 with impact chain IDs for cascading effects. Unplanned discrepancies are tracked in Section 8 (Drift Register).
