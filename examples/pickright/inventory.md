# PickRight Logistics — Inventory

3PL warehouse, ~15 people, 1 site. Off-the-shelf WMS. 3 clients: A (cosmetics, lot-tracked), B (electronics, high volume), C (specialty food, cold chain — just signed).

---

## PM Inventory

**User Stories**
- US1: User can receive inbound shipment with lot tracking — matched: Ds1, E1
- US2: User can pick order with lot validation — SUSPECT: E3 validates lot identity but not expiry — matched: Ds2, E3
- US3: User can pack and ship with branded label — matched: Ds3, E4
- US4: Client B orders auto-import from SFTP — SUSPECT: CSV format changing, E5 will break — matched: E5
- US4a: Client B SFTP import supports v2 CSV format (new column order, delivery_address, priority, ship_method) — NEW Round 2 — UNMATCHED: needs E5 update, E9, Q7
- US5: User can view order status and tracking — matched: Ds4, E6
- US6: Client C cold chain fulfillment — SUSPECT: was UNMATCHED, now has 14-day audit deadline
- US6a: User can receive inbound cold chain shipment with temperature reading — NEW Round 3 — UNMATCHED: needs Ds6, E10
- US6b: User can pick/pack Client C order with cold chain verification — NEW Round 3 — UNMATCHED: needs Ds7, E12, E13
- US6c: Operator can view cold chain status dashboard — NEW Round 3 — UNMATCHED: needs Ds8, E11, D8
- US7: Client A can pull lot traceability report per shipment — NEW Round 1 — UNMATCHED: needs Ds5, E8

**Compliance**
- C1: Client A lot traceability on every outbound — SUSPECT: E2 returns lots but doesn't attach them to shipments, Q1 tests identity not validity — BROKE: 3 expired lots shipped
- C1a: Every outbound shipment record includes lot IDs + expiry per line item — NEW Round 1 — UNMATCHED: needs DM2 change, E6 change
- C1b: Expired lots must never be pick-eligible — NEW Round 1 — UNMATCHED: needs E3 change, Q5
- C2: Client A label spec v2.3 — matched: E4, Q2
- C3: Cold chain compliance — temp record at receive, continuous storage monitoring, verification at pick/pack, seal on outbound — NEW Round 3 — UNMATCHED: needs E10-E14, Q9-Q14, D8-D10, Ds6-Ds8
- C3a: Cold chain audit evidence package — exportable temperature log per shipment, unbroken chain from receive to ship — NEW Round 3 — UNMATCHED: needs E14, Ds8, Q12

**NFRs**
- N1: WMS available during operating hours — matched: D1
- N2: Client B import completes within 15 min — SUSPECT: parser rewrite may affect throughput — matched: E5, D2
- N3: Cold room temperature logged minimum every 5 minutes with no gaps — NEW Round 3 — UNMATCHED: needs D8, E11

---

## Design Inventory

**Screens**
- Ds1: Receive screen — scan SKU, enter lot/expiry, assign location — matched: US1, E1
- Ds2: Pick screen — shows pick list, scan lot barcode, mismatch warning — SUSPECT: needs expiry status display + block/warn UX from E3 — matched: US2, E3
- Ds3: Pack screen — order contents, label preview, confirm count — matched: US3, E4
- Ds4: Order status screen — order detail, item lots, tracking number — matched: US5, E6
- Ds5: Lot traceability report screen — per-shipment and per-date-range — NEW Round 1 — UNMATCHED: needs US7, E8
- Ds6: Receive screen cold chain variant — adds arrival temperature field, out-of-range warning, block/accept-with-reason — NEW Round 3 — UNMATCHED: needs US6a, E10
- Ds7: Pick/pack screen cold chain variant — shows temp range, current reading, blocks if out of range, seal confirmation — NEW Round 3 — UNMATCHED: needs US6b, E12, E13
- Ds8: Cold chain log view — per-shipment temperature timeline, exportable for audit — NEW Round 3 — UNMATCHED: needs US6c, E14

**Flows**
- F1: Receive → putaway → pick → pack → ship — SUSPECT: no cold chain branch for Client C
- F2: Cold chain flow: receive (with temp) → cold putaway → cold storage (monitored) → cold pick (with temp check) → cold pack (with seal) → ship — NEW Round 3 — UNMATCHED: needs C3, US6a, US6b

---

## Engineer Inventory

**API Endpoints**
- E1: POST /receive — creates inbound record with SKU, qty, lot, expiry, location — matched: US1, Ds1
- E2: GET /lots/{sku} — returns lot records with expiry and location — SUSPECT: should include computed expired boolean — matched: US2, C1
- E3: POST /pick/confirm — validates scanned lot against assigned lot, blocks mismatch — SUSPECT: validates identity only, not expiry. Must add: if expiry < today → block; if expiry < today+7d → warn — matched: US2, Ds2
- E4: POST /label/render — generates ZPL per Client A spec v2.3 — matched: US3, C2, Ds3
- E5: SFTP integration — polls Client B /outbound/orders/ every 15 min, parses CSV, creates WMS orders, alerts on failure — SUSPECT: hardcoded column order + field names, will break on new format — matched: US4, N2
- E9: CSV schema mapping config — externalizes column name mapping and required fields, header-based not positional — NEW Round 2 — UNMATCHED: needs US4a, Q7
- E6: GET /orders/{id} — returns order with items, lots, pick status, tracking — SUSPECT: must include shipped_lots (lot_id + qty per line item) — matched: US5, Ds4
- E7: POST /lots/{lot_id}/quarantine — marks expired or recalled lot as quarantined, prevents pick assignment — NEW Round 1 — UNMATCHED: needs C1b, Q6
- E8: GET /shipments/{id}/lots — returns lot-level detail per outbound shipment — NEW Round 1 — UNMATCHED: needs US7, Ds5
- E10: POST /receive cold chain extension — adds arrival_temp, temp_unit, cold_chain boolean; validates temp against product range — NEW Round 3 — UNMATCHED: needs US6a, Ds6, C3
- E11: Cold room temperature logging service — records sensor readings to temp_readings table every 5 min, accepts sensor API or manual POST fallback — NEW Round 3 — UNMATCHED: needs N3, D8
- E12: POST /pick/confirm cold chain extension — requires product_temp reading, validates against range, blocks if out of range — NEW Round 3 — UNMATCHED: needs US6b, Ds7, C3
- E13: POST /pack/confirm cold chain seal — records pack temp, seal confirmation, packer ID, generates cold chain seal record — NEW Round 3 — UNMATCHED: needs US6b, Ds7, C3
- E14: GET /shipments/{id}/cold-chain — returns full temperature chain of custody: arrival, storage, pick, pack temps — NEW Round 3 — UNMATCHED: needs C3a, Ds8

**Data Model**
- DM1: lots table (lot_id, sku, expiry, received_date, location, qty, status, arrival_temp) — SUSPECT: needs status + arrival_temp fields — matched: C1, E1, E2, E3
- DM2: orders table (order_id, client, status, items, shipped_lots, shipped_at, tracking, priority, ship_method) — SUSPECT: needs shipped_lots + priority + ship_method fields — matched: E5, E6
- DM3: temp_readings table (reading_id, sensor_id, location, temp_c, timestamp, reading_source: sensor|manual) — immutable log — NEW Round 3 — UNMATCHED: needs E11, N3, D8
- DM4: cold_chain_records table (record_id, shipment_id, lot_id, arrival_temp, pick_temp, pack_temp, seal_confirmed, seal_timestamp, packer_id) — NEW Round 3 — UNMATCHED: needs E10, E12, E13, E14, C3

---

## QA Inventory

**Test Scenarios**
- Q1: Pick with wrong lot → blocked — SUSPECT: tests identity only, not expiry — matched: E3, C1
- Q2: Label output matches Client A approved sample — matched: E4, C2
- Q3: SFTP import with malformed CSV → error alert fires — SUSPECT: "malformed" definition changes with new format — matched: E5, N2
- Q7: Client B v2 CSV import → orders created correctly, delivery_address mapped, priority+ship_method stored — NEW Round 2 — UNMATCHED: needs E5 update, E9
- Q8: Client B old-format CSV after cutover → rejected with clear schema mismatch error — NEW Round 2 — UNMATCHED: needs E5 update
- Q4: Order with near-expiry lot (<7 days) → lot skipped in pick — SUSPECT: E3 may not implement this behavior — matched: E3, C1
- Q5: Pick with expired lot (expiry < today) → pick BLOCKED — NEW Round 1 — UNMATCHED: needs E3 fix
- Q6: Quarantined lot cannot be assigned to any pick — NEW Round 1 — UNMATCHED: needs E7
- Q9: Receive cold chain item with temp in range → accepted, arrival_temp recorded — NEW Round 3 — UNMATCHED: needs E10
- Q10: Receive cold chain item with temp OUT of range → blocked or override with reason — NEW Round 3 — UNMATCHED: needs E10, Ds6
- Q11: Pick cold chain order, product temp out of range → pick BLOCKED — NEW Round 3 — UNMATCHED: needs E12
- Q12: GET /shipments/{id}/cold-chain returns complete unbroken temp chain, no gaps >5 min — NEW Round 3 — UNMATCHED: needs E14, C3a
- Q13: Cold room sensor offline >5 min → alert fires AND gap visible in cold chain log — NEW Round 3 — UNMATCHED: needs D8, D9, E11
- Q14: Pack cold chain order without seal confirmation → pack BLOCKED — NEW Round 3 — UNMATCHED: needs E13

---

## DevOps Inventory

**Monitoring**
- D1: WMS uptime check — every 60s, alert on failure — matched: N1
- D2: Client B import health — alert if no successful import in 30 min — SUSPECT: will fire false alerts during format cutover — matched: N2, E5
- D7: Client B CSV schema validation alert — detects unexpected column headers or count mismatch, separate from parse failure — NEW Round 2 — UNMATCHED: needs E9
- D3: Pick block rate — alert if >5% of picks blocked in 1 hour — SUSPECT: will spike when expired lot blocks start firing, needs threshold adjustment or separate metric — matched: E3
- D5: Expired lot shipment alert — query shipped orders where lot expiry < ship date, hourly — NEW Round 1 — UNMATCHED: needs DM1+DM2 join path
- D6: Near-expiry lot assignment alert — query pick assignments where lot expiry < today+7d, every 15 min — NEW Round 1 — UNMATCHED: needs E3 data

**Deploy**
- D8: Cold room temperature monitoring — alert if no reading in 10 min or temp exceeds range, every 5 min — NEW Round 3 — UNMATCHED: needs N3, E11, DM3
- D9: Cold chain logging gap alert — detects gaps >5 min in temp_readings, daily report + real-time — NEW Round 3 — UNMATCHED: needs N3, Q13, E11
- D10: Cold chain seal verification alert — flags Client C shipments with incomplete cold chain records, hourly — NEW Round 3 — UNMATCHED: needs C3, E13, DM4

**Deploy**
- D4: Deploy procedure for custom scripts (label render, SFTP import) — SUSPECT: needs cutover runbook for E5 + cold chain service + DB migrations — matched: E4, E5
- D11: Deploy procedure for cold chain service + sensor integration — migrations DM3+DM4, service deploy, sensor connectivity verification, manual fallback — NEW Round 3 — UNMATCHED: needs E11, DM3, DM4

---

## Round Log

### Round 0 — Bootstrap
All verticals looked inward, claimed items, connected matching points. Hot paths established.

### Round 1 — Client A compliance audit: 3 orders shipped with expired lots
**Origin:** Client A found expired lots in outbound shipments. Demanded lot-level traceability within 30 days.

**What broke:** C1 (lot traceability) was PROVED but the match was wrong — E3 validated lot identity, not lot validity (expiry). Q1 tested identity mismatch, not expiry. The hot path existed but had a hole: the system confirmed you picked the RIGHT lot without checking if that lot was SAFE to ship.

**Cascade:** C1 broke → E3 suspect → E2 suspect → E6 suspect → DM1 suspect → DM2 suspect → Q1 suspect → Q4 suspect → D3 suspect → Ds2 suspect

**Items invented:** PM: C1a, C1b, US7. Engineer: E7, E8. QA: Q5, Q6. DevOps: D5, D6. Design: Ds5.

**Lesson:** A match can be "proven" against the wrong criteria. C1 said "traceability" and E3 provided "lot identity validation." Both looked proven. But traceability requires expiry enforcement, not just identity checking. The four questions would have caught this: "Where's the evidence that C1 is matched?" — the evidence proved identity, not validity.

### Round 2 — Client B changes SFTP CSV format (3 days notice)
**Origin:** Client B migrated to new ERP. CSV column order changed, ship_to renamed to delivery_address, new fields priority and ship_method added.

**What broke:** E5 (SFTP parser) hardcodes column order and field names — will reject all new-format files. The hot path US4→E5→D2 was prepared for failure detection (D2 alerts on missing imports) but not for format evolution.

**Cascade:** E5 suspect → US4 suspect → N2 suspect → Q3 suspect → D2 suspect → D4 suspect → DM2 suspect (new fields)

**Items invented:** PM: US4a. Engineer: E9. QA: Q7, Q8. DevOps: D7.

**Lesson:** Integration contracts are the most fragile hot path. E5 was proven ("it works") but brittle — any format change breaks it. Engineer invented E9 (schema mapping config) to make future format changes a config update instead of a code rewrite. This is the Freedom mechanic in action: Engineer can radically change how E5 works (header-based instead of positional) as long as US4's box still matches.

### Round 3 — State cold chain audit in 14 days
**Origin:** Health inspector announces cold chain audit. Client C contract requires temperature-controlled storage and shipping. Cold room exists but has zero instrumentation in WMS. US6 was always UNMATCHED.

**What broke:** Nothing broke — nothing existed. US6 was an accepted gap since Round 0. The audit turned "future work" into "14-day deadline." This is a fundamentally different failure mode from Rounds 1-2: not a broken match, but an empty hot path that must be built from scratch under pressure.

**Cascade:** US6 suspect → F1 suspect (no cold chain branch) → E1 suspect (no temp field) → DM1 suspect (no arrival_temp) → D1 suspect (doesn't cover cold room) → D4 suspect (new deploy scope)

**Items invented:** PM: US6a, US6b, US6c, C3, C3a, N3. Design: Ds6, Ds7, Ds8, F2. Engineer: E10, E11, E12, E13, E14, DM3, DM4. QA: Q9, Q10, Q11, Q12, Q13, Q14. DevOps: D8, D9, D10, D11. Total: 25 new items.

**Lesson:** An UNMATCHED item is not "future work" — it is an accountability gap with unknown exposure. The Discovery question that would have caught this earlier: "US6 has no downstream matches. Who needs this to move?" The answer was always "the state inspector" — PickRight just hadn't asked yet. The cost of leaving US6 unmatched for 3 rounds: building 25 items in 14 days instead of building them incrementally.

### Round 4 — Sole engineer resigns (2 weeks notice)
**Origin:** The one engineer who built E1-E9, maintains WMS config, and holds all deploy capability (D4, on personal laptop) resigns. No second engineer. No documentation.

**External reaction:** This isn't a feature or compliance change — it's a capability loss. The inventory items don't change, but the ability to prove, progress, and maintain them is threatened. D4 (deploy) is the choke point: if it breaks, nothing new ships, and every UNMATCHED item across all verticals is frozen permanently.

**Cascade:** D4 suspect → every E-item's maintainability suspect → every UNMATCHED item from Rounds 1-3 becomes undeliverable → PM's commitments (C1-C3, US4a-US7) have no path to resolution

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

**Lesson:** The acquisition didn't cause the crisis — it made the pre-existing crisis undeniable. Every vertical had been inventing items they couldn't progress: PM invents requirements nobody builds, Design invents screens nobody implements, QA invents tests nobody runs, DevOps invents monitors nobody responds to. The inventory grew while the ability to prove anything shrank to zero. This is the ultimate stress test of CONST: the framework makes the dysfunction visible — every UNMATCHED item, every SUSPECT item, every broken trace is a signal. Whether the team acts on those signals is not the Constitution's job. That's accountability.
