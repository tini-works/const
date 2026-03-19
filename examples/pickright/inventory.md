# PickRight Logistics — Inventory

3PL warehouse, ~15 people, 1 site. Off-the-shelf WMS. 5 clients: A (cosmetics, lot-tracked), B (electronics, high volume), C (specialty food, cold chain), D + E (MoveQuick migration — general goods).

---

## PM Inventory

**User Stories**
- US1: User can receive inbound shipment with lot tracking — proven Round 0: Ds1, E1
- US2: User can pick order with lot validation (identity + expiry) — proven Round 7: Ds2, E3, Q1, Q4, Q5
- US3: User can pack and ship with branded label — proven Round 0: Ds3, E4
- US4: Client B orders auto-import from SFTP (v2 CSV format, header-based schema mapping) — proven Round 8: E5, E9, Q7, Q8 — degradation: client hasn't been asked about satisfaction in >quarter
- US5: User can view order status and tracking — proven Round 7: Ds4, E6
- US6: Client C cold chain fulfillment — receive with temp, pick/pack with verification, dashboard, seal — proven Round 11: C3, E10-E14, Ds6-Ds8, Q9-Q14, D8
- US7: Client A can pull lot traceability report per shipment — proven Round 8: Ds5, E8
- US11: MoveQuick Clients D+E onboarded — SKU migration, order import, operator trained — proven Round 14: E20-E22, Ds11, Ds12, Q19-Q21
- US14: Combined inventory view across all 5 clients — proven Round 15: E23, Ds4 — verified under 6000+ SKU load
- US15: Client D/E SLA reporting — order accuracy and ship time — unverified: needs E24, D21

**Compliance**
- C1: Client A lot traceability on every outbound — shipment records include lot IDs + expiry, expired lots blocked from pick — proven Round 7: E2, E3, E6, E7, Q1, Q5, Q6 — degradation: nobody has reviewed compliance evidence in >60 days
- C2: Client A label spec v2.3 — proven Round 0: E4, Q2
- C3: Cold chain compliance — temp record at receive, continuous monitoring, pick/pack verification, seal, exportable audit evidence — proven Round 11: E10-E14, Q9-Q14, D8-D10, Ds6-Ds8
- C5: MoveQuick Clients D+E contractual SLAs imported and matched — proven Round 14: US11, E20, E22

**NFRs**
- N1: WMS available during operating hours — proven Round 0: D1
- N2: Client B import completes within 15 min — proven Round 8: E5, D2 — re-proven after parser rewrite
- N3: Cold room temperature logged minimum every 5 minutes with no gaps — proven Round 10: D8, E11, DM3
- N4: WMS handles combined 6000+ SKU catalog without degradation — proven Round 15: E1, D1 — load time resolved after E23 index fix

---

## Design Inventory

**Screens**
- Ds1: Receive screen — scan SKU, enter lot/expiry, assign location — proven Round 0: US1, E1
- Ds2: Pick screen — shows pick list, scan lot barcode, expiry status, block/warn UX — proven Round 7: US2, E3
- Ds3: Pack screen — order contents, label preview, confirm count — proven Round 0: US3, E4
- Ds4: Order status screen — order detail, item lots, tracking number — proven Round 7: US5, E6
- Ds5: Lot traceability report screen — per-shipment and per-date-range — proven Round 8: US7, E8
- Ds6: Cold chain screens — receive with temp field, pick/pack with temp range + seal, log view with exportable timeline — proven Round 11: US6, E10, E12, E13, E14
- Ds11: MoveQuick WMS training screens — receive, pick, pack adapted for Clients D+E — proven Round 14: US11, E20, E22

**Flows**
- F1: Receive → putaway → pick → pack → ship (includes cold chain branch: temp receive, monitored storage, temp-checked pick, sealed pack) — proven Round 11: C3, US6

---

## Engineer Inventory

**API Endpoints**
- E1: POST /receive — creates inbound record with SKU, qty, lot, expiry, location, arrival_temp (optional) — proven Round 9: US1, Ds1
- E2: GET /lots/{sku} — returns lot records with expiry, location, computed expired boolean — proven Round 7: US2, C1
- E3: POST /pick/confirm — validates lot identity + expiry (block if expired, warn if <7d) — proven Round 7: US2, Ds2, C1b
- E4: POST /label/render — generates ZPL per Client A spec v2.3 — proven Round 0: US3, C2, Ds3
- E5: SFTP integration — polls Client B, parses CSV via schema mapping config, creates WMS orders — proven Round 8: US4, US4a, N2 — degradation: import duration trending up or schema config unchanged >90 days
- E6: GET /orders/{id} — returns order with items, shipped_lots, pick status, tracking — proven Round 7: US5, Ds4, C1a
- E7: POST /lots/{lot_id}/quarantine — marks expired/recalled lot as quarantined, prevents pick — proven Round 7: C1b, Q6
- E8: GET /shipments/{id}/lots — returns lot-level detail per outbound shipment — proven Round 8: US7, Ds5
- E9: CSV schema mapping config — externalizes column name mapping, header-based not positional — proven Round 8: US4a, Q7
- E10: POST /receive cold chain extension — adds arrival_temp, temp_unit, cold_chain boolean; validates temp against product range — proven Round 9: US6a, Ds6, C3
- E11: Cold room temperature logging service — records sensor readings every 5 min, sensor API + manual POST fallback — proven Round 10: N3, D8
- E12: POST /pick/confirm cold chain extension — requires product_temp, validates against range, blocks if out — proven Round 11: US6b, Ds7, C3
- E13: POST /pack/confirm cold chain seal — records pack temp, seal confirmation, packer ID, generates seal record — proven Round 11: US6b, Ds7, C3
- E14: GET /shipments/{id}/cold-chain — returns full temperature chain of custody — proven Round 11: C3a, Ds8
- E20: MoveQuick SKU bulk import endpoint — maps MoveQuick SKU codes to PickRight format, dedup, validates — proven Round 12: US11, US12
- E21: MoveQuick order import adapters — maps Client D+E order formats to WMS orders — proven Round 14: US11
- E23: Combined inventory query — cross-client SKU search with client filter — proven Round 13: US14 — re-proven after index fix
- E24: SLA metrics query — order accuracy + ship time per client — unverified: needs US15

**Data Model**
- DM1: lots table — lot_id, sku, expiry, received_date, location, qty, status, arrival_temp — proven Round 9: C1, E1, E2, E3
- DM2: orders table — order_id, client, status, items, shipped_lots, shipped_at, tracking, priority, ship_method — proven Round 8: E5, E6
- DM3: temp_readings table — reading_id, sensor_id, location, temp_c, timestamp, reading_source — immutable log — proven Round 10: E11, N3, D8
- DM4: cold_chain_records table — record_id, shipment_id, lot_id, arrival_temp, pick_temp, pack_temp, seal_confirmed, seal_timestamp, packer_id — proven Round 11: E10, E12, E13, E14, C3

---

## QA Inventory

**Test Scenarios**
- Q1: Lot pick validation — wrong lot blocked, expired lot blocked, near-expiry skipped — proven Round 7: E3, C1 — degradation: test scenario unchanged while E3 has been modified
- Q2: Label output matches Client A approved sample — proven Round 0: E4, C2
- Q3: SFTP import — malformed CSV alert, v2 format imports correctly, old format rejected — proven Round 8: E5, E9, N2
- Q6: Quarantined lot cannot be assigned to any pick — proven Round 7: E7
- Q9: Cold chain receive — in-range accepted, out-of-range blocked/override, arrival_temp recorded — proven Round 9: E10, Ds6
- Q11: Cold chain pick — product temp out of range → pick BLOCKED — proven Round 11: E12
- Q12: Cold chain integrity — unbroken temp chain from receive to ship, no gaps >5 min — proven Round 11: E14
- Q13: Cold room monitoring — sensor offline >5 min triggers alert, gap visible in log — proven Round 10: D8, E11
- Q14: Cold chain pack — pack without seal confirmation → BLOCKED — proven Round 11: E13
- Q19: MoveQuick SKU import — no duplicates, all SKUs queryable post-import — proven Round 12: E20
- Q20: MoveQuick order import — orders created, items mapped, no data loss — proven Round 14: E21
- Q22: MoveQuick operator can execute receive/pick/pack without assistance — proven Round 13: Ds11, US11

---

## DevOps Inventory

**Monitoring**
- D1: WMS uptime check — every 60s, alert on failure — proven Round 0: N1
- D2: Client B import health — alert if no successful import in 30 min — proven Round 8: N2, E5 — threshold adjusted for v2 cutover
- D3: Pick block rate — alert if >5% of picks blocked in 1 hour, separate metric for expiry blocks — proven Round 7: E3
- D5: Expired lot shipment alert — query shipped orders where lot expiry < ship date, hourly — proven Round 7: DM1, DM2
- D7: Client B CSV schema validation alert — detects unexpected column headers or count mismatch — proven Round 8: E9
- D8: Cold chain monitoring suite — temp out-of-range alert, no-reading alert, logging gap detection — proven Round 10: N3, E11, DM3, Q13
- D10: Cold chain seal verification alert — flags Client C shipments with incomplete cold chain records — proven Round 11: C3, E13, DM4
- D20: Combined monitoring dashboard — all 5 clients visible, alert routing split per client — proven Round 15: routing separated A/B/C ops, D/E migration, cold chain dedicated
- D21: MoveQuick SLA monitoring — order accuracy + ship time alerts for Clients D and E — unverified: needs E24, US15

**Deploy**
- D4: Deploy procedure for all custom services — label render, SFTP import, cold chain, migration — proven Round 10: includes cold chain + sensor deploy — degradation: only one person has run a deploy in the last 30 days
- D18: MoveQuick go-live checklists — Clients D+E cutover verified — proven Round 14: US11

---

## Round Log

### Round 0 — Bootstrap

> Note: the inventory sections above reflect post-Round-15 state. Round 0 established the initial baseline described here.

**Step 1 — Origins gathered:** PM collected Client A contract (lot traceability, label spec), Client B SFTP integration agreement, Client C cold chain clause (noted, not yet instrumented), WMS vendor docs. Operator contributed tribal knowledge on receive/pick/pack flow and known WMS quirks.

**Step 2 — Transformed into controllable items:** PM created user stories (US1-US6) and compliance items (C1-C2). Engineer claimed API endpoints (E1-E6) and data models (DM1-DM2). Design claimed screens (Ds1-Ds4) and the main flow (F1). QA created test scenarios (Q1-Q3). DevOps claimed monitoring (D1) and deploy (D4).

**Step 3 — Connected across verticals:** Matching points agreed. US1↔E1↔Ds1, US2↔E3↔Ds2↔Q1, US3↔E4↔Ds3↔C2↔Q2, US5↔E6↔Ds4, C1↔E2↔E3↔Q1. Each item has at least one cross-vertical match.

**Step 4 — Processes defined:** Each vertical declared its Progress and Invent mechanisms — these are the inventory items themselves. PM progresses by proving user stories against design + engineering evidence. Engineer progresses by deploying and matching against PM requirements + QA tests. QA progresses by running scenarios against engineering endpoints. DevOps progresses by monitoring against NFRs. Design progresses by validating screens against user stories + API contracts.

**Step 5 — Hot paths emerged:** Key item-to-item chains identified: (1) C1→E3→E2→Q1→D3 — Client A lot compliance through pick validation to monitoring. (2) US4→E5→D2→N2 — Client B order import through SFTP integration to health monitoring. (3) US3→E4→C2→Q2→Ds3 — pack and ship through label render to compliance verification.

US6 (Client C cold chain) was noted as unverified — no downstream matches, no engineering items, no timeline. Accepted as a known gap.

### Round 1 — Client A compliance audit: 3 orders shipped with expired lots
**Origin:** Client A found expired lots in outbound shipments. Demanded lot-level traceability within 30 days.

**What broke:** C1 (lot traceability) was PROVED but the match was wrong — E3 validated lot identity, not lot validity (expiry). Q1 tested identity mismatch, not expiry. The hot path existed but had a hole: the system confirmed you picked the RIGHT lot without checking if that lot was SAFE to ship.

**Cascade:** C1 broke → E3 suspect → E2 suspect → E6 suspect → DM1 suspect → DM2 suspect → Q1 suspect → Q4 suspect → D3 suspect → Ds2 suspect

**Items invented:** PM: C1a, C1b, US7. Engineer: E7, E8. QA: Q5, Q6. DevOps: D5, D6. Design: Ds5.

**Lesson:** A match can be "proven" against the wrong criteria. C1 said "traceability" and E3 provided "lot identity validation." Both looked proven. But traceability requires expiry enforcement, not just identity checking. The five questions would have caught this: "Where's the evidence that C1 is matched?" — the evidence proved identity, not validity. And the fifth question — "What would tell you this is weakening?" — was never asked for C1 at all. Had someone defined a degradation signal (e.g., "no one has reviewed whether expiry is actually checked in >30 days"), the gap between identity validation and expiry enforcement would have surfaced before Client A found it in a shipment.

### Round 2 — Client B changes SFTP CSV format (3 days notice)
**Origin:** Client B migrated to new ERP. CSV column order changed, ship_to renamed to delivery_address, new fields priority and ship_method added.

**What broke:** E5 (SFTP parser) hardcodes column order and field names — will reject all new-format files. The hot path US4→E5→D2 was prepared for failure detection (D2 alerts on missing imports) but not for format evolution.

**Cascade:** E5 suspect → US4 suspect → N2 suspect → Q3 suspect → D2 suspect → D4 suspect → DM2 suspect (new fields)

**Items invented:** PM: US4a. Engineer: E9. QA: Q7, Q8. DevOps: D7.

**Lesson:** Integration contracts are the most fragile hot path. E5 was proven ("it works") but brittle — any format change breaks it. Engineer invented E9 (schema mapping config) to make future format changes a config update instead of a code rewrite. This is Freedom in action: Engineer earned autonomy to rewrite E5 because all matches still held. Engineer can radically change how E5 works (header-based instead of positional) as long as US4's box still matches.

### Round 3 — State cold chain audit in 14 days
**Origin:** Health inspector announces cold chain audit. Client C contract requires temperature-controlled storage and shipping. Cold room exists but has zero instrumentation in WMS. US6 was always unverified.

**What broke:** Nothing broke — nothing existed. US6 was an accepted risk since Round 0. The audit turned "future work" into "14-day deadline." This is a fundamentally different failure mode from Rounds 1-2: not a broken match, but an empty hot path that must be built from scratch under pressure.

**Cascade:** US6 suspect → F1 suspect (no cold chain branch) → E1 suspect (no temp field) → DM1 suspect (no arrival_temp) → D1 suspect (doesn't cover cold room) → D4 suspect (new deploy scope)

**Items invented:** PM: US6a, US6b, US6c, C3, C3a, N3. Design: Ds6, Ds7, Ds8, F2. Engineer: E10, E11, E12, E13, E14, DM3, DM4. QA: Q9, Q10, Q11, Q12, Q13, Q14. DevOps: D8, D9, D10, D11. Total: 25 new items.

**Lesson:** An unverified item is not "future work" — it is an accountability gap with unknown exposure. The Discovery question that would have caught this earlier: "US6 has no downstream matches. Who needs this to move?" The answer was always "the state inspector" — PickRight just hadn't asked yet. The cost of leaving US6 unverified for 3 rounds: building 25 items in 14 days instead of building them incrementally.

### Round 4 — Sole engineer resigns (2 weeks notice)
**Origin:** The one engineer who built E1-E9, maintains WMS config, and holds all deploy capability (D4, on personal laptop) resigns. No second engineer. No documentation.

**External reaction:** This isn't a feature or compliance change — it's a capability loss. The inventory items don't change, but the ability to prove, progress, and maintain them is threatened. D4 (deploy) is the choke point: if it breaks, nothing new ships, and every unverified item across all verticals is frozen permanently.

**Cascade:** D4 suspect → every E-item's maintainability suspect → every unverified item from Rounds 1-3 becomes undeliverable → PM's commitments (C1-C3, US4a-US7) have no path to resolution

**Items invented (external reaction):**
- PM: US8 (knowledge transfer documented), US9 (replacement engineer), US10 (scope freeze assessment), C4 (client communication on risk)
- Engineer: E15 (deploy scripts to repo), E16 (credentials inventory), E17 (WMS config docs), E18 (codebase walkthrough), E19 (known bugs register)
- QA: Q15 (deploy verification by non-engineer), Q16 (knowledge transfer completeness check), Q17 (credential access verification), Q18 (regression test inventory)
- DevOps: D12 (deploy capability transfer), D13 (infrastructure access audit), D14 (WMS admin transfer), D15 (alert runbooks), D16 (disaster recovery docs)
- Design: Ds9 (screen-to-API contract docs), Ds10 (WMS config vs custom screens inventory)

**Internal inventory check — origins discovered through reconciliation:**

- **PM discovers:** C4 is actually 3 separate items — each client needs different communication. Client A has unresolved compliance exposure (C1 broke in Round 1, still unfixed). Client B has SFTP migration at risk (Round 2, unfixed). Client C has audit in 14 days with zero backend. PM had been treating these as "engineering will fix it" — but engineering is leaving. Internal origin: PM must now own the client timeline renegotiation.

- **QA discovers:** Q18 (regression test inventory) reveals that ZERO of the proven E-items have automated tests. Q1-Q4 are all manual spot-checks. When the new engineer arrives, they have no safety net — any code change could break something with no way to detect it. Internal origin: QA needs a "minimum test coverage before new engineer starts changing code" gate.

- **DevOps discovers:** D4 wasn't just "on a laptop" — it also depends on SSH keys that expire in 45 days, and the WMS vendor contract renewal is coming up next month. If the engineer leaves and these aren't transferred, the vendor relationship and server access both lapse. Internal origin: DevOps needs a vendor relationship transfer item.

- **Design discovers:** Ds1-Ds4 are all vendor WMS screens. They survive the departure. But Ds2 (pick screen) has a custom overlay for lot scanning that the engineer built — Design didn't know it was custom vs vendor. If that overlay breaks, nobody can fix it. Internal origin: Design needs to inventory which screen elements are custom code.

- **Engineer (departing) discovers in exit review:** E5 (SFTP integration) has a hardcoded credential that rotates every 90 days. The next rotation is in 3 weeks — after departure. If nobody knows how to rotate it, Client B orders stop flowing silently. Internal origin: E16 (credentials) must include rotation schedules, not just current values.

**Lesson:** An origin change doesn't just cascade through matched items — it forces every vertical to reconcile. Reconciliation surfaces internal origins that were invisible before. The engineer's departure didn't break anything today, but the internal inventory check revealed: no automated tests (QA), expiring credentials (Engineer), vendor contract gaps (DevOps), custom vs vendor confusion (Design), and unresolved client exposure (PM). These were always there. The departure made them visible.

### Round 5 — PickRight acquires MoveQuick (2 clients, 4,000 SKUs, 60-day migration)
**Origin:** Owner acquires MoveQuick 3PL. 2 new clients (D, E), 4,000 SKUs, homegrown WMS (spreadsheets + scripts), sole operator staying on. Full migration within 60 days.

**What broke:** Nothing new broke — but the acquisition exposed that NOTHING from Rounds 1-4 was ever fixed. PickRight has been inventing items for 4 rounds while the ability to prove anything has been shrinking to zero.

**External cascade:** E1 suspect (SKU structure), E5 suspect (more integrations onto fragile base), DM1/DM2 suspect (migration data), D1 suspect (capacity), D4 suspect (who deploys migration scripts?)

**Items invented:** PM: US11-US13, C5-C6, N4. Design: Ds11-Ds13, F3. Engineer: E20-E23. QA: Q19-Q22. DevOps: D17-D20. Total: ~20 new items.

**Internal origins discovered through reconciliation:**
- **PM:** Has been inventing requirements for 4 rounds without any being built. Inventory has become a wish list, not a commitment register. C3 (cold chain audit) outcome is unknown — never tracked.
- **Design:** Custom vs vendor screen confusion (Round 4) was never resolved. Training materials (Ds11) can't be accurate without knowing which screens are custom code.
- **Engineer:** 19 items with no owner, 6 suspect items with no one to re-prove. E16 (credentials) is now critical-path — SFTP credential rotation is imminent. MoveQuick's "homegrown WMS" contains business logic, not just data.
- **QA:** The manual tests (Q1-Q4) were actually run BY the departing engineer. With them gone, QA has no one to execute even proven tests. 14 test scenarios invented across Rounds 1-4 have never been run even once.
- **DevOps:** Every monitoring item (D1-D10) detects problems but has no remediation path. Alerts fire into a void. Monitoring without remediation is theater. D12-D16 (Round 4 knowledge transfer) are in unknown state — may have been lost with the engineer.

**Lesson:** The acquisition didn't cause the crisis — it made the pre-existing crisis undeniable. Every vertical had been inventing items they couldn't progress: PM invents requirements nobody builds, Design invents screens nobody implements, QA invents tests nobody runs, DevOps invents monitors nobody responds to. The inventory grew while the ability to prove anything shrank to zero. This is the ultimate stress test of CONST: the framework makes the dysfunction visible — every unverified item, every SUSPECT item, every broken trace is a signal. Whether the team acts on those signals is not the Constitution's job. That's accountability.

### Round 6 — Contractor hired, triage begins
**Origin:** Owner hires a contract engineer. MoveQuick operator stays on as warehouse staff. PM freezes scope: cold chain + lot expiry first, MoveQuick deferred.

PROGRESS:
- US8: unverified → proven — contractor pairs with departing engineer, captures E15-E19
- US9: unverified → proven — contractor onboarded, has deploy access
- US10: unverified → proven — scope freeze documented: cold chain and lot expiry are priority 1
- E15: unverified → proven — deploy scripts committed to repo
- E16: unverified → proven — credentials inventory with rotation schedules documented
- E17-E19: unverified → proven — WMS config docs, codebase walkthrough recorded, known bugs listed
- D12: unverified → proven — deploy tested by contractor independently

PRUNED: C4 (client communication on risk) — PM handled directly, no inventory item needed. D13 (infrastructure access audit), D14 (WMS admin transfer), D15 (alert runbooks), D16 (disaster recovery docs) — merged into D12 as sub-checks, not separate items. Ds9 (screen-to-API contract docs), Ds10 (WMS config vs custom screens inventory) — captured inside E17/E18, not separate design items. Q15 (deploy verification by non-engineer) — folded into D12 evidence. Q16 (knowledge transfer completeness check) — folded into US8 evidence. Total: 9 items pruned.

**Lesson:** When crisis forces triage, ceremony items become visible fast. Nine items from Round 4 looked necessary under panic but were either duplicates or sub-tasks of real items. The Discovery question "who needs this to move?" killed them — nobody downstream was blocked by D13 existing separately from D12.

### Round 7 — Lot expiry fixed end-to-end
**Origin:** Contractor delivers E3 expiry validation, E7 quarantine, E2 expired boolean. Client A compliance chain restored.

PROGRESS:
- E2: SUSPECT → proven — now includes computed expired boolean
- E3: SUSPECT → proven — validates identity + expiry, blocks expired, warns <7d
- E6: SUSPECT → proven — now includes shipped_lots per line item
- E7: unverified → proven — quarantine endpoint working
- US2: SUSPECT → proven — lot validation now covers identity + expiry
- C1: BROKE → proven — re-proven with new evidence: expiry enforcement + traceability
- C1a: unverified → proven — DM2 updated, E6 returns lot IDs + expiry
- C1b: unverified → proven — E3 blocks, E7 quarantines, Q5 confirms
- Ds2: SUSPECT → proven — pick screen shows expiry status, block/warn UX
- US5: matched → proven — E6 now returns complete data
- DM1: SUSPECT → proven — status + arrival_temp fields added
- DM2: SUSPECT → proven — shipped_lots + priority + ship_method fields added
- Q1: SUSPECT → proven — expanded to test identity + expiry
- Q4: SUSPECT → proven — near-expiry skip confirmed
- Q5: unverified → proven — expired lot block confirmed
- Q6: unverified → proven — quarantine block confirmed
- D3: SUSPECT → proven — threshold adjusted, separate expiry block metric
- D5: unverified → proven — expired lot shipment alert live
- D6: unverified → proven — near-expiry assignment alert live

**Lesson:** The entire Client A compliance chain — from C1 broken in Round 1 through 19 items across 5 verticals — was restored in a single focused round. This is what happens when a team stops inventing and starts proving.

### Round 8 — CSV v2 integration complete
**Origin:** Contractor delivers E9 schema mapping config, E5 rewritten to header-based parsing. Client B format cutover executed.

PROGRESS:
- E5: SUSPECT → proven — rewritten with schema mapping, header-based
- E9: unverified → proven — config-driven column mapping live
- US4: SUSPECT → proven — SFTP import works with v2 format
- US4a: unverified → proven — v2 CSV fully supported
- US7: unverified → proven — lot traceability report endpoint working
- E8: unverified → proven — shipment lot detail endpoint live
- Ds5: unverified → proven — lot traceability report screen built
- N2: SUSPECT → proven — import completes in <15 min after rewrite
- Q3: SUSPECT → proven — re-proven against v2 schema definitions
- Q7: unverified → proven — v2 import test passing
- Q8: unverified → proven — old format rejection test passing
- D2: SUSPECT → proven — import health alert threshold adjusted
- D7: unverified → proven — schema validation alert live
- D4: SUSPECT → proven — cutover runbook executed successfully

PRUNED: E19 (known bugs register) — bugs were either fixed or tracked in code. No downstream match needed it as a permanent inventory item.

**Lesson:** E5 was the most fragile hot path in the system. The rewrite from positional to header-based parsing (Freedom mechanic — Engineer changed how, kept the match) means the next Client B format change is a config update, not a code emergency.

### Round 9 — Cold chain receive + deploy pipeline
**Origin:** Contractor and operator build cold chain receive path. Sensor integration connected. Deploy pipeline formalized.

PROGRESS:
- E10: unverified → proven — cold chain receive extension deployed
- E1: proven → re-proven — now accepts arrival_temp for cold chain items
- Ds6: unverified → proven — cold chain receive screen with temp field, warnings
- US6a: unverified → proven — cold chain receive working end-to-end
- Q9: unverified → proven — in-range receive test passing
- Q10: unverified → proven — out-of-range block/override test passing
- Q17: unverified → proven — credential access verified for 2+ people
- D4: proven → re-proven — now covers cold chain service deploy + DB migrations
- DM1: proven → re-proven — arrival_temp field active for cold chain receives

**Lesson:** Cold chain receive was the first link in the chain. Without it proven, nothing downstream (pick, pack, seal, audit) could start. The team sequenced correctly: prove the foundation before building on it.

### Round 10 — Cold chain monitoring + QA baseline
**Origin:** Temperature logging service goes live. QA builds automated regression baseline for core endpoints.

PROGRESS:
- E11: unverified → proven — sensor logging service recording every 5 min
- DM3: unverified → proven — temp_readings table populated, immutable log confirmed
- N3: unverified → proven — 5-minute logging verified, no gaps in 72-hour test
- US6c: unverified → proven — cold chain dashboard shows live readings
- Ds8: unverified → proven — cold chain log view with timeline, export working
- D8: unverified → proven — cold room monitoring alerts live
- D9: unverified → proven — gap detection alert tested and live
- Q13: unverified → proven — sensor offline test passing, gap visible in log
- Q18: unverified → proven — automated regression tests for E1-E9 baseline
- D11: unverified → proven — cold chain service deploy procedure documented and tested

**Lesson:** E11 (temperature logging) unlocked 6 other items across QA, DevOps, PM, and Design. A single engineering item proving out can unblock an entire vertical slice. This is the matching web working as designed — not a chain, but a web where one proof enables many.

### Round 11 — Cold chain pick/pack/seal complete
**Origin:** Cold chain flow fully operational. Pick temp check, pack seal confirmation, and chain-of-custody audit trail all proven.

PROGRESS (items fixed):
- E12: unverified → proven — pick/confirm cold chain extension deployed, validates product temp against range
- E13: unverified → proven — pack/confirm seal endpoint deployed, records pack temp + seal + packer ID
- E14: unverified → proven — cold chain custody endpoint returns full temp chain (arrive → store → pick → pack)
- DM4: unverified → proven — cold_chain_records table populated, tested with 2 weeks of Client C shipments
- Ds7: unverified → proven — pick/pack cold chain screen shows temp range, blocks out-of-range, seal confirmation UX
- Q11: unverified → proven — out-of-range pick block confirmed in test + production
- Q14: unverified → proven — pack without seal → blocked confirmed
- Q12: unverified → proven — chain-of-custody endpoint returns unbroken chain, no gaps >5 min verified
- US6b: unverified → proven — cold chain pick/pack working end-to-end
- C3: unverified → proven — full cold chain compliance: receive, monitor, pick, pack, seal all verified
- C3a: unverified → proven — audit evidence package exportable, unbroken chain confirmed
- D10: unverified → proven — seal verification alert live, catches incomplete cold chain records
- US6: SUSPECT → proven — Client C cold chain fulfillment complete, audit-ready
- F1: SUSPECT → proven — main flow now includes cold chain branch for Client C
- F2: unverified → proven — cold chain flow proven end-to-end with 2 weeks of live shipments

ORIGIN: Internal reconciliation finding — cold chain audit passed, but the evidence package (C3a) revealed that 3 of 47 shipments had manual temperature fallback entries instead of sensor readings. Not a compliance failure (manual fallback is documented), but a signal.

NEW ITEMS:
- US16: Humidity monitoring for Client C cold room — PARKED: raised by operator, not contractually required, deferred

PRUNED: None this round — everything that moved was load-bearing.

RECONCILIATION: QA found that Q12 (chain-of-custody completeness) passes on the happy path but has never been tested during a sensor failover. The manual fallback path exists (E11 accepts manual POST) but Q12 doesn't verify that manual entries produce a valid chain. Filed as internal origin for Round 12.

### Round 12 — MoveQuick migration starts
**Origin:** With cold chain proven and lot expiry stable, contractor + MoveQuick operator begin active migration. Client D goes first (simpler catalog, fewer SKUs).

PROGRESS (items fixed):
- E20: unverified → proven — SKU bulk import endpoint deployed, maps MoveQuick codes to PickRight format, dedup logic tested with 2,400 of Client D's SKUs
- Q19: unverified → proven — import test confirms no duplicates, all SKUs queryable post-import
- D17: unverified → proven — migration runbook documented: extract → map → import → validate → rollback procedure tested
- E23: unverified → proven — combined inventory query works across all clients — SUSPECT: query slow above 5,000 results, needs index
- Ds8: proven → re-proven — cold chain log view confirmed working with manual fallback entries after Q12 reconciliation finding

ORIGIN: MoveQuick operator discovers Client D has 3 SKUs with lot tracking requirements that were not in the original contract. Small scope but must be handled — lot receive path (E1) already supports this, just needs Client D flagged as lot-tracked in config.

NEW ITEMS:
- US14: Combined inventory view across all 5 clients — SUSPECT: E23 deployed but UI not verified under load with 6000+ SKUs — matched: E23, Ds4
- N4: WMS handles combined 6000+ SKU catalog without degradation — SUSPECT: functional but pick screen load time increased 40% — matched: E1, D1

PRUNED: Q18 (regression test inventory) — this was a meta-item ("do we have tests?"). Now that automated tests exist and are running, the inventory of tests is maintained by the test suite itself, not by a separate QA item. The evidence is the CI pipeline, not a checklist. Merged into Q1-Q14 as their proving mechanism.

RECONCILIATION: Engineer flags that E23 (combined inventory query) does a full table scan above 5,000 results. With Client E's 1,600 SKUs still to import, the combined catalog will hit ~6,000. Performance fix needed before Client E go-live but not blocking Client D.

### Round 13 — Migration progresses, QA catches up
**Origin:** Client D live on PickRight WMS. MoveQuick operator cross-training complete. Client E import begins. QA covers migration test scenarios.

PROGRESS (items fixed):
- E21: unverified → proven — Client D order import adapter deployed, mapping verified against 2 weeks of live orders
- Q20: unverified → proven — Client D order import test passing, items mapped correctly, no data loss in 500-order validation
- US13: unverified → proven — MoveQuick operator completes receive/pick/pack cycle unassisted, QA observed
- Ds11: unverified → proven — Client D training screens reviewed with operator, SKU naming adapted
- Ds13: unverified → proven — cross-training guide used during operator certification
- Q22: unverified → proven — operator independently executes full cycle, no assistance needed
- E23: SUSPECT → re-proven — index added, query time under 200ms for 6000 SKUs

ORIGIN: Client D's first week of live operations surfaces 2 orders where ship_method was blank — Client D's order format doesn't include ship_method (unlike Client B). E21 adapter silently drops it. Not a bug (default shipping is correct) but PM adds a note to US11 acceptance criteria.

NEW ITEMS:
- E24: SLA metrics query — order accuracy + ship time per client — unverified: needs US15

PRUNED: Ds9 was already pruned in Round 6. Ds10 was already pruned in Round 6. No additional pruning this round — remaining items are all load-bearing.

RECONCILIATION: PM reviews Client D's first week metrics: 99.2% order accuracy, average ship time 4.1 hours. Meets SLA but there's no automated monitoring (D21 doesn't exist yet). PM creates US15 and notes it's not urgent — manual weekly review is sufficient for 2 clients, but won't scale.

### Round 14 — Migration complete, most items proven
**Origin:** Client E import complete. Both MoveQuick clients operational on PickRight WMS. Migration officially closed.

PROGRESS (items fixed):
- E22: unverified → proven — Client E order import adapter deployed, mapping verified
- Q21: unverified → proven — Client E order import test passing, no data loss in 800-order validation
- US11: unverified → proven — Client D fully onboarded: SKU migration, order import, operator trained, 2 weeks live
- US12: unverified → proven — Client E fully onboarded: SKU migration, order import, 1 week live
- Ds12: unverified → proven — Client E training screens reviewed with operator
- C5: unverified → proven — Client D SLAs imported, matched against US11 evidence
- C6: unverified → proven — Client E SLAs imported, matched against US12 evidence
- D18: unverified → proven — Client D go-live checklist completed and signed off
- D19: unverified → proven — Client E go-live checklist completed and signed off
- F3: unverified → proven — migration flow proven end-to-end for both clients

ORIGIN: Client E go-live reveals that D20 (combined monitoring dashboard) routes all client alerts to the same Slack channel. With 5 clients, alert fatigue is real — 3 false-positive cold chain alerts in Client E's first day because D8 thresholds were tuned for Client C's cold room, and Client E has no cold chain.

NEW ITEMS: None — the D20 alert routing issue is a fix to an existing item, not a new item.

PRUNED: E18 (codebase walkthrough recorded) — served its purpose during contractor onboarding. The recording exists but is not a living inventory item. No one downstream matches against it. Evidence: contractor has been shipping code for 8 rounds without referencing it.

RECONCILIATION: DevOps discovers that D20 (combined monitoring dashboard) has become a single pane of noise instead of a single pane of glass. Five clients with different SLA profiles, different monitoring needs, and different escalation paths all dumping into one channel. The alert routing is technically "working" (all alerts fire) but operationally broken (nobody reads them anymore). This is the degradation signal the Constitution warns about — "a test nobody updates, a deploy procedure only one person can run" — except here it's "an alert channel nobody watches."

### Round 15 — Audit and prune, tighten inventory
**Origin:** Internal reconciliation round. No external change. Team reviews full inventory, prunes ceremony, re-proves suspect items, identifies remaining gaps.

PROGRESS (items fixed):
- N4: SUSPECT → proven — index fix from Round 13 resolved pick screen load time, verified under 6000+ SKU load
- US14: SUSPECT → proven — combined inventory view tested under load with all 5 clients, UI responsive
- D20: SUSPECT → proven — alert routing split per client: A/B/C → ops channel, D/E → migration channel, cold chain → dedicated channel

ORIGIN: Audit reveals that US15 (Client D/E SLA reporting) and its downstream items (E24, D21) are the only remaining unmatched chain. PM confirms this is planned for next sprint, not urgent — manual weekly review covers it for now.

NEW ITEMS: None.

PRUNED (one-time items that served their purpose):
- US8, US9, US10 — knowledge transfer, onboarding, scope freeze. All one-time actions, complete. No downstream item matches against them ongoing.
- US16 — humidity monitoring. PARKED, formally removed. Not contractually required.
- E15, E16 — deploy scripts + credentials inventory. Subsumed by D4 and automated rotation. Evidence lives in repo and rotation logs.
- E17 — WMS config docs. Config is in-repo, self-documenting.
- Q17 — credential access verification. One-time check, rotation now automated.
- D6 — near-expiry alert. Merged into D3 (same signal, two alerts was ceremony).
- D12 — deploy capability transfer. Transfer complete, D4 is the ongoing procedure.
- Ds13 — cross-training guide. Used once for certification. Stale guides are worse than no guides.
- D17 — migration runbook. Migration complete.

MERGED (items that were separate for tracking but share a single provable commitment):
- US12, US13 → merged into US11 (MoveQuick Clients D+E onboarded)
- C6 → merged into C5 (both client SLAs)
- C1a, C1b → merged into C1 (lot traceability includes both sub-commitments)
- US4a → merged into US4 (v2 is now the only format)
- US6a, US6b, US6c → merged into US6 (cold chain fulfillment is one commitment)
- C3a → merged into C3 (audit evidence is part of compliance)
- Ds7, Ds8 → merged into Ds6 (cold chain screens)
- Ds12 → merged into Ds11 (MoveQuick training screens)
- F2, F3 → F2 merged into F1 (cold chain is a branch), F3 pruned (migration complete)
- E22 → merged into E21 (MoveQuick order import adapters)
- Q4, Q5 → merged into Q1 (lot validation suite)
- Q7, Q8 → merged into Q3 (SFTP integration tests)
- Q10 → merged into Q9 (cold chain receive tests)
- Q21 → merged into Q20 (MoveQuick order import tests)
- D9 → merged into D8 (cold chain monitoring)
- D11 → merged into D4 (deploy procedures)
- D19 → merged into D18 (go-live checklists)

RECONCILIATION: Full inventory audit. The team traces every item against Discovery questions:

1. **"What's the origin?"** — every remaining item traces to a contract, a regulation, a system requirement, or an internal finding. Nothing is floating.
2. **"What does this match?"** — every item has at least one cross-vertical match. US15/E24/D21 chain is acknowledged as unmatched but has a clear path.
3. **"Who needs this to move?"** — the 12 pruned items all failed this question. Nobody downstream is blocked by US8 or D12 existing as separate items. One-time actions that succeeded do not earn permanent inventory slots.
4. **"Where's the evidence?"** — 45 of 71 items have formally recorded evidence (test results, production data, sign-offs). 23 more are proven by operational history. 3 are unmatched.
5. **"What would tell you this is weakening?"** — the team assessed degradation signals for each proven item. Items with formal evidence have observable signals (test pass rates, monitoring alerts, audit trails). The 23 items proven only by operational history have no defined degradation signal — "it hasn't broken" is not a signal, it's an absence. This is the root cause of the 96% vs 63% health gap: without a degradation signal, you can't tell the difference between "working" and "working until it isn't." The team flagged 5 items for immediate signal definition (E5 import duration, D4 deploy bus factor, Q1 test staleness, C1 evidence review cadence, US4 client satisfaction check).

**Final health calculation:**
- Total items after pruning + merging: 71
- Proven with formal evidence: 45
- Proven by operational history only (works, but evidence not formally recorded): 23
- Unmatched: 3 (US15, E24, D21 — planned, not urgent)
- Suspect: 0
- Broken: 0
- **Health by status formula: (71 - 3) / 71 = 96%** — almost everything is operationally working
- **Health by evidence formula: 45 / 71 = 63%** — only items with formally recorded proof count
- **Conservative health (the one that matters): 63%**

The Constitution says "proof requires evidence, not assertion." Twenty-three items work in production but their evidence is informal — operational history, "it hasn't broken," somebody saw it work once. That's not zero evidence, but it's not the kind of evidence that survives the next departure, audit, or crisis.

**Lesson:** The audit round is where Discovery earns its keep. Twelve items pruned in a single round — more than any crisis round invented — because every one of them failed the question "who needs this to move?" One-time actions (knowledge transfer, scope freeze, migration runbook, operator certification) are necessary when they happen but do not earn permanent inventory slots. The Constitution says "every item must earn its place" — earning it once is not enough. If no downstream item currently matches against it, prune it. It can always be re-invented if a change demands it.

The gap between 96% (operational) and 63% (formally evidenced) is healthy tension. Twenty-three items work in production but have informal evidence. The team's next improvement cycle is not building new features — it's formalizing evidence for what already works. That's the mark of a maturing team: the hard work is behind them, and what remains is discipline.
