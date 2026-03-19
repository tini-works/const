# NeoLedger — Inventory

Series A core banking platform. 25 people. Provides deposit accounts, card programs, and payments as a service to fintechs via REST API. Sponsor bank holds the charter. 3 fintech clients live (neobank "FinFlow", crypto on-ramp "CoinBridge", crypto on-ramp "PayCircle"). SOC 2 Type II audit in 4 months. PCI-DSS required for card program. BSA/AML obligations through sponsor bank.

Tech: PostgreSQL + event sourcing for ledger. 2 engineers (lead departed Round 5), 1 PM/compliance, 1 part-time designer. No dedicated QA or DevOps. CI/CD exists, deploys require 2-person approval. Datadog basics + PagerDuty on-call. KYC/AML via Alloy vendor integration. Senior engineer hire in progress.

---

## Origins

These are facts — inputs, not inventory. Each vertical matches against these.

**Regulatory**
- O-REG-1: OCC/FDIC regulations via sponsor bank — capital requirements, BSA/AML, consumer protection (Reg E, Reg DD, TILA), EFTA
- O-REG-2: BSA/AML — CIP, CDD, SAR filing, CTR filing, OFAC screening, beneficial ownership requirements
- O-REG-3: PCI-DSS v4.0 — required for card issuance program, 12 requirement domains, annual assessment
- O-REG-4: SOC 2 Type II audit — due in 4 months, trust service criteria: security, availability, processing integrity, confidentiality
- O-REG-5: NACHA Operating Rules — ACH origination and receipt, return handling, same-day ACH requirements
- O-REG-6: Reg E — error resolution procedures, unauthorized transaction liability, disclosure requirements for electronic fund transfers
- O-REG-7: State money transmitter licensing — varies by state, sponsor bank relationship covers most but program-level obligations exist

**Contracts**
- O-CON-1: Sponsor bank agreement — transaction limits, settlement windows, daily reconciliation requirements, regulatory exam cooperation, BIN sponsorship for card program
- O-CON-2: FinFlow (neobank) API agreement — 99.9% uptime SLA, sub-200ms p95 latency, Reg E error resolution SLA passthrough
- O-CON-3: CoinBridge (crypto on-ramp) API agreement — 99.9% uptime, enhanced KYC/AML requirements (crypto-specific risk), transaction monitoring, real-time balance checks
- O-CON-4: PayCircle onboarding agreement — integration timeline, sandbox environment, compliance documentation requirements
- O-CON-5: Alloy vendor contract — KYC/AML identity verification, watchlist screening, ongoing monitoring, SLA on verification response time
- O-CON-6: Card processor/network agreements (Visa/Mastercard) — BIN management, transaction authorization, settlement, chargeback procedures
- O-CON-7: ACH processor agreement (via sponsor bank) — origination windows, return handling, prefunding requirements

**System reality**
- O-SYS-1: Platform is live — account creation, balance management, ACH transfers, card issuance all operational for 2 clients
- O-SYS-2: Ledger uses PostgreSQL + event sourcing — append-only event log, materialized balances, double-entry bookkeeping
- O-SYS-3: 2 engineers (lead departed Round 5), no dedicated QA or DevOps — deploy approval is 2-person (either remaining engineer), on-call is 3-person rotation (2 engineers + PM for business-logic escalation)
- O-SYS-4: CI/CD pipeline exists, deploys require 2-person approval (updated Round 5)
- O-SYS-5: Monitoring is Datadog basics + PagerDuty — no custom dashboards, no business-metric alerts, no ledger reconciliation monitoring
- O-SYS-6: SOC 2 readiness documentation is 60% complete
- O-SYS-7: PCI-DSS self-assessment started but not complete
- O-SYS-8: KYC/AML is partially manual — Alloy handles identity verification, SAR filing is manual
- O-SYS-9: No automated testing — all verification is manual or implicit ("it works in production")
- O-SYS-10: PayCircle live in production (Round 4) — 10x transaction volume, platform scaled to handle load

---

## PM Inventory

**User Stories / Features**

- US1: Fintech client can create a deposit account for their end user via API — proven Round 0 — operational for FinFlow and CoinBridge since launch — matched: [E1, E2, DM1, Ds1]
- US2: Fintech client can query account balance (real-time, reflecting all settled and pending transactions) — proven Round 0 — matched: [E3, DM2, Ds2]
- US3: End user can initiate ACH transfer (push/pull) via fintech client API — proven Round 0 — 2 clients processing live ACH — matched: [E4, E5, DM3, Ds3]
- US4: Fintech client can issue virtual debit card to end user — proven Round 0 — FinFlow card program live — matched: [E6, E7, DM4, Ds4]
- US5: Fintech client can issue physical debit card to end user — SUSPECT Round 5 — API exists but fulfillment flow untested end-to-end, nobody remaining understands manufacturer integration after lead departure, deferred until new hire — matched: [E8]
- US6: Fintech client receives real-time webhook notifications for account events (transactions, status changes, KYC decisions) — proven Round 0 — FinFlow and CoinBridge consuming webhooks — matched: [E9, Ds5]
- US7: End user identity verified via KYC before account opening — proven Round 0 — Alloy integration live — matched: [E10, DM5]
- US9: Fintech client can onboard to production (includes sandbox access, integration testing, production cutover) — proven Round 4 — PayCircle onboarded, sandbox parity verified during onboarding, US8 merged in (sandbox is part of onboarding, not separate) — matched: [E11, Ds6]
- US10: Fintech client can initiate and manage disputes / Reg E error resolution — proven Round 1 — dispute API built, Reg E timelines enforced, provisional credit logic implemented — matched: [E12, C5, F4]
- US11: Fintech client can view and export transaction history for end users — proven Round 0 — FinFlow and CoinBridge using this — matched: [E13, Ds7]

**Compliance Commitments**

- C1: BSA/AML program — CIP completed before account opening, CDD collected, ongoing monitoring via Alloy, OFAC screening on every transaction — proven Round 0 (CIP/CDD/screening via Alloy) — partially unverified (ongoing monitoring completeness, beneficial ownership for business accounts) — matched: [E10, E14, DM5, Q1]
- C2: SAR filing — suspicious activity identified and SAR filed within 30 days per FinCEN requirements — proven Round 3 — case management system deployed, automated detection-to-filing pipeline with full audit trail — matched: [E14]
- C3: CTR filing — merged into C2 Round 3 — same compliance workflow handles CTR and SAR filing, structuring detection included in transaction monitoring rules — matched: [E14]
- C4: OFAC screening — every transaction and account opening screened against SDN list — proven Round 0 — Alloy handles screening, blocks on match — matched: [E10, E14, Q2]
- C5: Reg E compliance — error resolution procedures, provisional credit timelines, unauthorized transaction liability limits, required disclosures — proven Round 1 — dispute API enforces 10-business-day provisional credit and 45-day resolution, audit trail for every step — matched: [US10, E12, F4]
- C6: Reg DD compliance — truth-in-savings disclosures, rate/fee change notifications — unverified — disclosures drafted but delivery mechanism not verified — matched: [Ds8]
- C7: SOC 2 Type II — security, availability, processing integrity, confidentiality controls documented, tested, and evidenced over observation period — proven Round 2 — controls documented, evidence collection automated weekly (Q12), all downstream DevOps items proven — matched: [Q3, Q12, D1, D2, D3, D8, D9, D10, D11]
- C8: PCI-DSS compliance — cardholder data environment scoped, 12 requirement domains assessed, compensating controls documented — proven Round 5 — pen test executed, scope defined, all requirement domains assessed, knowledge transferred before lead departure — matched: [E7, D4, Q4]
- C9: Sponsor bank daily reconciliation — NeoLedger's ledger balances reconciled with sponsor bank's records in real-time, discrepancies alerted within minutes — proven Round 5 — E15 automated from manual 4-hour script to real-time service, discrepancy alerting configured — matched: [E15, D5]
- C10: Card network compliance — Visa/Mastercard operating regulations, chargeback handling, fraud monitoring — unverified — card processor handles most, but NeoLedger's obligations for dispute response and fraud rules not systematically tracked — matched: [E6, E12]
- C11: Data retention — transaction records retained per BSA (5 years), SOC 2, and sponsor bank requirements — unverified — events are append-only (natural retention) but no verified retention policy, no tested retrieval, no archival process — matched: [DM2, DM3]

**NFRs**

- N1: API availability 99.9% uptime per client SLAs — proven Round 4 — SUSPECT under 10x projected load, re-proven after load testing and infrastructure scaling — matched: [D1, D6]
- N2: API p95 latency under 200ms per FinFlow SLA — proven Round 4 — SUSPECT under 10x projected load, re-proven after hot path optimization and load testing — matched: [D6]
- N3: Ledger consistency — double-entry invariant holds (sum of all debits = sum of all credits) at all times — proven Round 0 — event sourcing architecture enforces this, but no automated verification — matched: [E2, DM2, Q5]
- N4: Transaction processing — ACH and card transactions settle within sponsor bank's required windows — proven Round 4 — SUSPECT under 10x projected load, re-proven after load testing confirmed settlement windows hold at scale — matched: [E4, E6, D5]
- N5: Disaster recovery — RPO < 1 hour, RTO < 4 hours per sponsor bank agreement — proven Round 5 — DR test finally executed, RPO 45min confirmed — matched: [D7, Q11]
- N6: Encryption at rest and in transit — all PII and financial data encrypted — proven Round 5 — verified against PCI-DSS requirements during pen test, encryption at rest confirmed — matched: [D4, Q4]

---

## Design Inventory

**Screens**

- Ds1: Account creation flow — fintech client dashboard showing API-initiated account, KYC status, account state (pending/active/frozen/closed) — proven Round 0 — FinFlow dashboard integration live — matched: [US1, E1]
- Ds2: Balance & ledger view — real-time balance display, pending vs available, transaction ledger with event details — proven Round 0 — matched: [US2, E3]
- Ds3: ACH transfer initiation — transfer form (push/pull), amount, routing/account, scheduling, status tracking — proven Round 0 — matched: [US3, E4]
- Ds4: Card management — virtual card display (PAN, CVV, expiry), freeze/unfreeze, spending limits, PIN set — proven Round 0 — matched: [US4, E6]
- Ds5: Webhook configuration — event subscription management, delivery log, retry status, payload examples — proven Round 0 — matched: [US6, E9]
- Ds6: Client onboarding portal — sandbox credentials, API key management, integration checklist, go-live readiness — proven Round 4 — PayCircle completed full onboarding flow through portal — matched: [US9, E11]
- Ds7: Transaction history — searchable/filterable transaction list, export (CSV/PDF), date range, type filter — proven Round 0 — matched: [US11, E13]
- Ds8: Disclosure delivery — Reg DD disclosures, fee schedules, terms presented to end user during account opening — unverified — templates exist but delivery tracking not verified — matched: [C6]

**Flows**

- F1: Account opening → KYC verification → account activation (or rejection) → funding → transacting — proven Round 0 — 2 clients live — matched: [US1, US7, E1, E10]
- F2: ACH origination → sponsor bank submission → settlement → balance update → webhook notification — proven Round 0 — matched: [US3, E4, E5, E9]
- F3: Card issuance → activation → transaction authorization → settlement → balance update — proven Round 0 (virtual) — unverified (physical card fulfillment) — matched: [US4, US5, E6, E7, E8]
- F4: Dispute initiation → investigation → provisional credit → resolution → final credit/debit — proven Round 1 — system-tracked flow with Reg E timelines enforced, audit trail at every state transition — matched: [US10, E12, C5]

**Interaction States**

- IS1: KYC pending / KYC failed / KYC manual review — proven Round 0 — Alloy webhook states mapped — matched: [E10, Ds1]
- IS2: Account frozen (compliance hold, fraud, user request) — proven Round 0 — matched: [E1, Ds1]
- IS3: ACH return handling — return received, balance adjusted, user notified — proven Round 0 — matched: [E5, Ds3]
- IS4: Card declined states — insufficient funds, frozen account, merchant category block — proven Round 0 — matched: [E6, Ds4]

---

## Engineer Inventory

**API Endpoints**

- E1: POST /v1/accounts — creates deposit account, triggers KYC, returns account_id and status — proven Round 0 — matched: [US1, Ds1, DM1, C1]
- E2: GET /v1/accounts/{id}/balance — returns available_balance, pending_balance, ledger_balance from materialized view — proven Round 0 — matched: [US2, Ds2, DM2]
- E3: GET /v1/accounts/{id}/ledger — returns paginated event history with running balance — proven Round 0 — matched: [US2, Ds2, DM2]
- E4: POST /v1/transfers/ach — initiates ACH push or pull, validates against balance and limits, submits to ACH processor — proven Round 0 — matched: [US3, Ds3, DM3, C9]
- E5: POST /v1/transfers/ach/return — processes inbound ACH returns, adjusts balance, emits webhook — proven Round 0 — matched: [US3, IS3, DM3]
- E6: POST /v1/cards — issues virtual debit card, provisions to card network, returns card details (tokenized PAN) — proven Round 0 — matched: [US4, Ds4, DM4, C8, C10]
- E7: POST /v1/cards/{id}/activate — activates card, sets PIN (encrypted), applies spending limits — proven Round 0 — matched: [US4, Ds4, DM4, C8]
- E8: POST /v1/cards/physical — initiates physical card fulfillment order to card manufacturer — SUSPECT Round 5 — endpoint exists, manufacturer integration not tested end-to-end, nobody remaining understands manufacturer integration after lead departure — matched: [US5, F3]
- E9: POST /v1/webhooks — configures webhook subscriptions, manages retry logic, delivers signed payloads — proven Round 0 — matched: [US6, Ds5]
- E10: POST /v1/kyc/verify — submits identity data to Alloy, receives decision (approved/declined/manual_review), stores result — proven Round 0 — matched: [US7, C1, C4, DM5, F1]
- E11: Sandbox environment — mirrors production API surface, synthetic data, no real transactions — proven Round 4 — sandbox parity verified during PayCircle onboarding, test data seeding validated — matched: [US9, Ds6]
- E12: POST /v1/disputes — creates dispute case, tracks Reg E timelines, provisional credit logic — proven Round 1 — full implementation: dispute creation, timeline tracking, provisional credit within 10 business days, resolution within 45 days, card network integration, audit trail — matched: [US10, C5, C10, F4]
- E13: GET /v1/accounts/{id}/transactions — returns paginated, filterable transaction history with metadata — proven Round 0 — matched: [US11, Ds7]
- E14: Transaction monitoring service — screens transactions against rules (velocity, amount thresholds, OFAC, pattern detection), flags for SAR review — proven Round 3 — upgraded with velocity rules, pattern detection, automated flagging, per-client risk profile calibration — matched: [C1, C2, C4]
- E15: Ledger reconciliation service — compares NeoLedger event-sourced balances against sponsor bank settlement files — proven Round 5 — Round 4 reconciliation revealed daily manual script takes 4 hours at 10x volume, automated to real-time during Round 5 knowledge transfer period — matched: [C9, D5, N3]

**Services**

- S1: Event sourcing engine — append-only event log, event replay, materialized balance projections, idempotent command handling — proven Round 0 — core of the ledger, operational since launch — matched: [DM2, N3]
- S2: ACH processing service — batch origination, NACHA file generation, return processing, same-day ACH support — proven Round 0 — matched: [E4, E5, DM3]
- S3: Card processing service — authorization, settlement, BIN management, card lifecycle (issue, activate, freeze, close) — proven Round 0 (virtual cards) — matched: [E6, E7, E8, DM4]
- S4: KYC/AML orchestration service — Alloy integration, decision routing, manual review queue, watchlist screening — proven Round 0 — matched: [E10, E14, DM5]
- S5: Webhook delivery service — event fan-out, per-client subscriptions, retry with exponential backoff, delivery log — proven Round 0 — matched: [E9]

**Data Models**

- DM1: accounts table — account_id, client_id, user_id, status (pending/active/frozen/closed), type, created_at, kyc_status, freeze_reason — proven Round 0 — matched: [E1, US1]
- DM2: events table (event store) — event_id, account_id, type, amount, currency, balance_after, metadata, created_at — append-only, immutable — proven Round 0 — matched: [S1, E2, E3, N3, C11]
- DM3: transfers table — transfer_id, account_id, type (ach_push/ach_pull), amount, status (pending/submitted/settled/returned/failed), nacha_trace, submitted_at, settled_at — proven Round 0 — matched: [E4, E5, S2, C11]
- DM4: cards table — card_id, account_id, type (virtual/physical), status (pending/active/frozen/closed), last_four, network_token, expiry, spending_limit — proven Round 0 — matched: [E6, E7, E8, S3, C8]
- DM5: kyc_records table — kyc_id, account_id, alloy_entity_id, decision (approved/declined/manual_review), risk_score, documents, completed_at — proven Round 0 — matched: [E10, S4, C1]
- DM6: webhook_deliveries table — delivery_id, subscription_id, event_type, payload_hash, status (pending/delivered/failed), attempts, last_attempt_at — proven Round 0 — matched: [E9, S5]

---

## QA Inventory

**Test Scenarios**

- Q1: KYC decision routing — approved → account active, declined → account rejected, manual_review → account pending + ops notification — unverified — believed correct from operational history, no automated test, no systematic manual test protocol — matched: [E10, C1, DM5]
- Q2: OFAC screening — transaction against SDN-listed entity blocked, account opening against SDN-listed name blocked, false positive handled via manual review — proven Round 3 — end-to-end test: SDN match blocked, non-match passed, false positive routed to manual review queue — matched: [C4, E14]
- Q3: SOC 2 control testing — access controls, change management, incident response, availability monitoring — all controls documented and evidence collected for observation period — proven Round 2 — controls documented, evidence collected, auditor reviewed — matched: [C7, D1, D2, D3]
- Q4: PCI-DSS validation — cardholder data environment boundaries, encryption verification, access control testing, penetration testing — proven Round 5 — pen test executed before lead engineer departure, scope defined, all 12 requirement domains assessed — matched: [C8, D4, N6]
- Q5: Ledger integrity — double-entry invariant holds after concurrent transactions, event replay produces same balances, no phantom balances — proven Round 4 — verified under 10x concurrent load during PayCircle load testing — matched: [N3, S1, DM2]
- Q6: ACH lifecycle — origination succeeds, return processed correctly (all R-codes handled), balance adjusted, webhook fired, same-day ACH within window — proven Round 4 — all R-codes systematically tested under load — matched: [E4, E5, S2]
- Q7: Card authorization — sufficient funds approved, insufficient funds declined, frozen card declined, spending limit enforced, merchant category block works — proven Round 4 — balance check integration independently verified under 10x load — matched: [E6, S3, IS4]
- Q8: Webhook delivery — events delivered in order, retry on failure, payload signature valid, subscription filtering correct — proven Round 4 — failure/retry paths tested under 10x load, delivery guarantees verified — matched: [E9, S5]
- Q9: Account lifecycle — create → verify → activate → transact → freeze → unfreeze → close, each state transition valid, invalid transitions rejected — proven Round 4 — edge cases (close with pending transactions, freeze during ACH) tested during load testing — matched: [E1, DM1, IS2]
- Q10: Multi-client isolation — FinFlow cannot access CoinBridge accounts, API keys scoped to client, ledger entries isolated — proven Round 2 — isolation test executed, cross-client access denied, API key scoping verified — matched: [E1, E2, DM1, C7]
- Q11: Disaster recovery test — backup restoration, data integrity post-recovery, RPO/RTO measurement — proven Round 5 — DR test executed, backup restored, data integrity verified, RPO 45min confirmed — matched: [N5, D7]
- Q-new: Dispute flow — dispute creation triggers provisional credit within 10 business days, resolution tracked within 45-day window, final credit/debit applied, full audit trail — proven Round 1 — end-to-end test on Reg E unauthorized ACH scenario — matched: [E12, C5, F4, US10]
- Q12: SOC 2 evidence collection — automated weekly collection of control evidence (access logs, change records, deploy approvals, incident responses) — proven Round 2 — runs weekly, feeds auditor evidence package — matched: [C7, Q3]

---

## DevOps Inventory

**Monitoring**

- D1: API uptime monitoring — health check endpoint, Datadog synthetic check every 60s, PagerDuty alert on failure — proven Round 4 — re-proven under 10x load after infrastructure scaling — matched: [N1, C7]
- D2: Error rate monitoring — 5xx rate tracked in Datadog, alert threshold at 1% over 5 minutes — proven Round 0 — matched: [N1, C7]
- D3: On-call rotation — PagerDuty schedule, escalation policy, runbooks for common incidents — proven Round 5 — SUSPECT when lead departed (was still primary despite formalized rotation), re-proven with genuine 3-person rotation (2 engineers + PM for business-logic escalation), rotation playbooks documented — matched: [C7, N1]
- D4: PCI-DSS environment controls — network segmentation for cardholder data environment, access logging, encryption verification — proven Round 5 — verified during PCI-DSS pen test, scope documented before lead departure — matched: [C8, Q4, N6]
- D5: Sponsor bank reconciliation monitoring — reconciliation job status, discrepancy alerts, settlement file processing — proven Round 5 — E15 automated to real-time, monitoring dashboards and discrepancy alerting configured — matched: [C9, E15]
- D6: API latency monitoring — p50/p95/p99 latency tracked per endpoint — proven Round 4 — dashboards and alerts configured during load testing, latency SLA compliance verified at 10x volume — matched: [N1, N2]

**Deploy Procedures**

- D7: Database backup and recovery — PostgreSQL automated backups, backup verification, documented recovery procedure — proven Round 5 — recovery tested during DR test, procedure documented, RPO 45min confirmed — matched: [N5, Q11]
- D8: Production deploy procedure — CI/CD pipeline runs tests and builds, deploy requires 2-person approval, rollback procedure documented — proven Round 5 — SUSPECT when lead departed (was single-person approval in practice), re-proven with 2-person approval by either remaining engineer, deploy runbooks documented during knowledge transfer — matched: [C7]
- D9: Infrastructure as code — infrastructure defined in Terraform/CloudFormation, changes reviewed and applied through pipeline — proven Round 2 — IaC audit completed, all manually provisioned resources imported, drift resolved — matched: [C7]
- D10: Secret management — API keys, database credentials, Alloy credentials, card processor credentials stored and rotated — proven Round 2 — rotation schedule documented and enforced, automated rotation for database credentials — matched: [C7, C8]
- D11: Log aggregation and retention — application logs, audit logs, access logs centralized, retained per compliance requirements — proven Round 2 — retention mapped to BSA (5 years) and SOC 2 requirements, Datadog retention policy configured — matched: [C7, C11]

---

## Round Log

### Round 0 — Bootstrap

**What we did:** All five verticals looked inward. Origins gathered from regulations, contracts, and system reality. Each vertical claimed items they actually control and can prove. Cross-vertical matching points established.

**Who holds what:**
- PM: 1 person (also compliance officer) — holds PM and partial QA accountability
- Design: 1 part-time designer — holds Design vertical
- Engineer: 3 engineers (lead + 2) — holds Engineer vertical and de facto DevOps
- QA: no dedicated person — vertical exists but every item is unverified
- DevOps: no dedicated person — lead engineer holds this by default

**What's proven (evidence: operational history):**
Core platform works — account creation, balances, ACH, virtual cards, webhooks, KYC via Alloy. Two clients live and transacting. 18 Engineer items proven by production operations. 8 Design items proven by live client integrations. 6 PM user stories proven by live client usage. 2 DevOps items proven by existing Datadog/PagerDuty. Zero QA items proven — no automated tests, no formal test protocols.

**What's unverified (known gaps):**
- Compliance: SOC 2 readiness 60% (C7), PCI-DSS self-assessment incomplete (C8), SAR filing manual with no audit trail (C2), Reg E dispute handling not built (C5), sponsor bank reconciliation manual (C9)
- Platform: Physical card fulfillment untested (US5/E8), sandbox parity unknown (US8/E11), dispute API stubbed not implemented (US10/E12)
- Operations: DR never tested (N5/D7), deploy depends on one person (D8), no runbooks (D3), secret rotation undocumented (D10), log retention not mapped to compliance (D11)
- Quality: Zero automated tests across entire platform (Q1-Q11 all unverified), multi-client isolation not verified (Q10)

**Hot paths identified:**
1. **Compliance hot path:** O-REG-4 (SOC 2) → C7 → Q3 → D1/D2/D3/D8/D9/D10/D11 — audit in 4 months, many downstream items unverified
2. **Card compliance hot path:** O-REG-3 (PCI-DSS) → C8 → Q4 → D4 → N6 — required for card program, self-assessment incomplete
3. **AML hot path:** O-REG-2 (BSA/AML) → C1/C2/C3/C4 → E14 → Q1/Q2 — transaction monitoring basic, SAR filing manual, CTR filing manual
4. **Client onboarding hot path:** O-CON-4 (PayCircle) → US9 → E11 → Ds6 — sandbox parity unknown, onboarding blocked
5. **Single-point-of-failure hot path:** O-SYS-3/O-SYS-4 → D8 → every unverified item — lead engineer is sole deploy approver, sole on-call, sole runbook holder

**Accountability gaps visible:**
- QA vertical has no owner. Every QA item is unverified. The platform has zero automated tests. When the SOC 2 auditor asks "how do you know your controls work?" — there is no answer.
- DevOps vertical has no owner. Lead engineer holds it by default alongside engineering work. Deploy procedure, DR, secret rotation, log retention all depend on one person's knowledge.
- Compliance is held by the PM, who is also the only PM. SOC 2 readiness, PCI-DSS assessment, SAR filing, Reg E compliance, and sponsor bank reconciliation all funnel through one person. The compliance hot path has zero redundancy.

**Health:**
- Total items: 74 (PM: 22, Design: 12, Engineer: 21, QA: 11, DevOps: 11)
- Proven: 39 (all by operational history — no formal evidence recorded)
- Unverified: 35
- Health: 39/74 = 53%

53% is honest for a 25-person Series A startup that has been building, not documenting. The system works — two clients are live and transacting. But the distance between "it works" and "we can prove it works" is the distance between surviving the SOC 2 audit and failing it.

**What Round 1 should be:**
The SOC 2 audit in 4 months is the most time-constrained origin. The hot path C7 → Q3 → D1-D11 has the most unverified items blocking it. Round 1 should focus on: which SOC 2 controls already exist informally that can be documented and evidenced (cheap wins), and which controls are genuinely missing and must be built (real work). The Discovery question: "C7 is unverified — what specifically does the auditor need to see, and which of our existing items already provide it?"

---

### Round 1 — Reg E dispute: unauthorized ACH debit

**Origin change:** FinFlow end-user reports $500 unauthorized ACH debit. O-REG-6 (Reg E) requires provisional credit within 10 business days and resolution within 45 days. E12 is stubbed, C5 is unverified, F4 is unverified.

**Cascade:**
- E12: SUSPECT — dispute API is stubbed, no business logic, cannot process the claim
- C5: SUSPECT — Reg E compliance depends on E12 which doesn't work, no timeline tracking
- F4: SUSPECT — dispute flow is manual-only, no system tracking of state transitions

**Progress:**
- Engineer builds E12 properly — dispute creation, provisional credit logic, Reg E timeline enforcement (10-day provisional, 45-day resolution), card network dispute integration, full audit trail at every state transition
- E12: proven Round 1 — full implementation with audit trail — matched: [US10, C5, C10, F4]
- C5: proven Round 1 — Reg E timelines enforced by E12, every step auditable — matched: [US10, E12, F4]
- F4: proven Round 1 — system-tracked flow, state machine with audit trail — matched: [US10, E12, C5]
- US10: proven Round 1 — dispute API live, FinFlow can initiate and manage disputes — matched: [E12, C5, F4]

**New items:**
- Q-new: Dispute flow end-to-end test — proven Round 1 — tested against the actual unauthorized ACH scenario — matched: [E12, C5, F4, US10]

**Pruning:** None.

**Reconciliation:** PM discovers C2 (SAR filing) has the same "manual with no audit trail" problem that C5 had before this round. The dispute work exposed the pattern: any compliance process without system tracking is a liability. C2 stays unverified — flagged for future work.

**Health:**
- Items: 75 (+1 Q-new)
- Proven: 44 (+5: E12, C5, F4, US10, Q-new)
- Unverified: 28
- SUSPECT resolved: 3 (E12, C5, F4 — all proven)
- Health: 44/75 = 59% (was 53%)

---

### Round 2 — SOC 2 auditor preliminary review

**Origin change:** Auditor arrives 2 months early for preliminary review. Asks for evidence of controls. O-REG-4 (SOC 2 Type II) hits the inventory. Q3 (SOC 2 control testing) is unverified. D3, D8, D9, D10, D11 all unverified — these are the controls the auditor wants evidence for.

**Cascade:**
- Q3: SUSPECT — auditor found no formal evidence collection process, controls exist informally but nothing is documented as testable evidence

**Progress:**
- Team documents all controls against SOC 2 trust service criteria, sets up evidence collection pipeline
- D3: proven Round 2 — on-call rotation formalized across 3 engineers, runbooks written, escalation policy defined — matched: [C7, N1]
- D8: proven Round 2 — deploy procedure documented with 2-person approval requirement, rollback steps formalized — matched: [C7]
- D9: proven Round 2 — IaC audit completed, all manually provisioned resources imported into Terraform, drift resolved — matched: [C7]
- D10: proven Round 2 — secret rotation schedule documented, automated rotation for database credentials, manual rotation tracked for vendor keys — matched: [C7, C8]
- D11: proven Round 2 — log retention mapped to BSA 5-year and SOC 2 requirements, Datadog retention policy configured accordingly — matched: [C7, C11]
- Q3: proven Round 2 — controls documented, evidence collected, auditor reviewed preliminary evidence package — matched: [C7, D1, D2, D3]
- C7: proven Round 2 — all downstream controls proven, evidence collection automated — matched: [Q3, Q12, D1, D2, D3, D8, D9, D10, D11]

**New items:**
- Q12: SOC 2 evidence collection — automated weekly collection of control evidence — proven Round 2 — runs on schedule, feeds auditor evidence package — matched: [C7, Q3]

**Reconciliation:** Auditor's questions surface that Q10 (multi-client isolation) is a critical SOC 2 control under the security trust service criterion. Must be proven, not just believed. Team runs isolation test: cross-client API access denied, API key scoping verified, ledger entry isolation confirmed.
- Q10: proven Round 2 — isolation test executed, cross-client access denied, API key scoping verified — matched: [E1, E2, DM1, C7]

**Pruning:** None.

**Health:**
- Items: 76 (+1 Q12)
- Proven: 53 (+9: D3, D8, D9, D10, D11, Q3, C7, Q12, Q10)
- Unverified: 23
- SUSPECT resolved: 1 (Q3 — proven)
- Health: 53/76 = 70% (was 59%)

---

### Round 3 — Sponsor bank mandates real-time transaction monitoring

**Origin change:** Sponsor bank (O-CON-1) says basic threshold rules are not sufficient. They require real-time pattern detection, velocity monitoring, and automated SAR pre-filing. E14 (transaction monitoring) is partially proven. C2 (SAR filing) is unverified.

**Cascade:**
- E14: SUSPECT — current rules are amount-threshold-only, no velocity, no pattern detection, does not meet sponsor bank's new requirements
- C2: SUSPECT — SAR filing is still manual with no audit trail (flagged in Round 1 reconciliation), sponsor bank now requires automated pre-filing

**Progress:**
- Engineer upgrades E14 with velocity rules, pattern detection, automated flagging, per-client risk profile calibration
- E14: proven Round 3 — velocity monitoring, pattern detection, automated flagging, risk profile calibration per client — matched: [C1, C2, C4]
- C2: proven Round 3 — case management system deployed, automated detection-to-filing pipeline with full audit trail, CTR filing integrated into same workflow — matched: [E14]
- Q2: proven Round 3 — OFAC screening tested end-to-end: SDN match blocked, non-match passed, false positive routed to manual review — matched: [C4, E14]

**Pruning:**
- C3 (CTR filing) merged into C2 — same compliance workflow handles both CTR and SAR filing, structuring detection is now part of the transaction monitoring rules in E14. Separate item no longer needed.

**Reconciliation:** The monitoring upgrade reveals that CoinBridge (crypto client) has 3x the flagging rate of FinFlow. Expected for crypto, but the rules need tuning — generic rules over-flag crypto transactions. Internal origin surfaced: transaction monitoring rules must be calibrated per client risk profile. Engineer adds per-client risk profile configuration to E14. This is already reflected in E14's proven status.

**Health:**
- Items: 75 (76 - 1 pruned C3 + 0 new)
- Proven: 56 (+3: E14, C2, Q2)
- Unverified: 19
- SUSPECT resolved: 2 (E14, C2 — both proven)
- Health: 56/75 = 75% (was 70%)

**Remaining unverified after 3 rounds:** US5, US8, US9, C6, C8, C9, C10, C11, N2, N5, N6, Ds6, Ds8, E8, E11, E15, Q1, Q4, Q5, Q6, Q7, Q8, Q9, Q11, D4, D5, D6, D7 — but count shows 19 proven delta is correct when accounting for the C3 merge reducing total items.

---

### Round 4 — PayCircle goes live, 10x transaction volume

**Origin change:** Third client PayCircle (crypto on-ramp, O-CON-4) is ready for production. Projected volume is 10x current platform load. This stresses everything — SLAs, settlement windows, infrastructure, monitoring.

**Cascade:**
- N1 (API uptime SLA): SUSPECT — 99.9% uptime never tested at 10x volume
- N2 (API latency SLA): SUSPECT — p95 latency under 200ms never measured at scale
- N4 (settlement windows): SUSPECT — settlement timing never validated at 10x throughput

**Progress:**
- Engineer runs load tests, optimizes hot paths, proves platform handles 10x volume
- DevOps scales infrastructure, configures latency dashboards and alerts
- N1: proven Round 4 — load testing confirms uptime SLA holds at 10x — matched: [D1, D6]
- N2: proven Round 4 — hot path optimization, p95 latency verified under load — matched: [D6]
- N4: proven Round 4 — settlement windows hold at 10x throughput — matched: [E4, E6, D5]
- D1: re-proven Round 4 — uptime monitoring verified under 10x load — matched: [N1, C7]
- D6: proven Round 4 — latency dashboards and SLA alerts configured — matched: [N1, N2]
- US9: proven Round 4 — PayCircle onboarded to production — matched: [E11, Ds6]
- E11: proven Round 4 — sandbox parity verified during PayCircle onboarding — matched: [US9, Ds6]
- Ds6: proven Round 4 — onboarding portal flow completed by PayCircle — matched: [US9, E11]
- Q5: proven Round 4 — ledger integrity verified under concurrent 10x load — matched: [N3, S1, DM2]
- Q6: proven Round 4 — all ACH R-codes systematically tested under load — matched: [E4, E5, S2]
- Q7: proven Round 4 — card authorization balance checks independently verified — matched: [E6, S3, IS4]
- Q8: proven Round 4 — webhook delivery and retry paths verified under load — matched: [E9, S5]
- Q9: proven Round 4 — account lifecycle edge cases tested during load testing — matched: [E1, DM1, IS2]

**Pruning:**
- US8 (sandbox access) merged into US9 — sandbox is part of onboarding, not a separate user story. Total items: -1.

**Reconciliation:** Load testing reveals E15 (ledger reconciliation) cannot keep up at 10x volume — daily manual script takes 4 hours. Internal origin surfaced: reconciliation must be automated and real-time. Flagged for immediate Round 5 work.

**Health:**
- Items: 74 (75 - 1 pruned US8)
- Proven: 66 (+10 net new: N2, D6, US9, E11, Ds6, Q5, Q6, Q7, Q8, Q9; N1 and N4 re-proven with stronger evidence but were already counted)
- SUSPECT resolved: 3 (N1, N2, N4 — all re-proven under load)
- SUSPECT remaining: 0
- Health: 66/74 = 89% (was 75%)

89% looks strong but hides two things. First, E15 (ledger reconciliation) can't keep up at 10x volume — the daily manual script takes 4 hours. Three live clients with real money flowing through a process that's breaking. Second, the remaining unverified items (C8, C9, N5, N6, D4, D5, D7, Q4, Q11 plus the low-risk C6, C10, C11, Ds8, Q1) include the entire PCI-DSS hot path and DR — neither has been tested. The percentage is up, but the remaining gaps are concentrated in compliance and operational resilience.

---

### Round 5 — Lead engineer gets poached

**Origin change:** Lead engineer — single point of failure for deploys, on-call, PCI-DSS knowledge, and manufacturer integration — accepts competing offer. 3 weeks notice. 2 remaining engineers. This is a people-origin, not a system-origin. The inventory doesn't change because of code — it changes because of who knows what.

**Cascade:**
- D8 (deploy procedure): SUSPECT — 2-person approval was formalized in Round 2 but lead was in practice the sole approver
- D3 (on-call rotation): SUSPECT — rotation was formalized in Round 2 but lead was still primary responder
- US5 (physical card fulfillment): SUSPECT — nobody remaining understands manufacturer integration
- E8 (physical card endpoint): SUSPECT — same manufacturer integration knowledge gap

**Progress (3 weeks of knowledge transfer):**
- Deploy approval becomes genuine 2-person (either remaining engineer can approve), deploy runbooks documented
- On-call rotation becomes genuine 3-person (2 engineers + PM for business-logic escalation), rotation playbooks documented
- E15 automated from 4-hour daily manual script to real-time reconciliation service (from Round 4 reconciliation finding)
- PCI-DSS pen test executed before lead leaves — scope documented, all 12 requirement domains assessed
- DR test finally executed — backup restored, data integrity verified, RPO 45min confirmed
- PCI-DSS scope and compliance knowledge documented for remaining team
- D8: proven Round 5 — 2-person approval by either remaining engineer, runbooks documented — matched: [C7]
- D3: proven Round 5 — genuine 3-person rotation, playbooks documented — matched: [C7, N1]
- D4: proven Round 5 — PCI-DSS environment verified during pen test — matched: [C8, Q4, N6]
- D5: proven Round 5 — reconciliation monitoring configured with E15 automation — matched: [C9, E15]
- D7: proven Round 5 — DR test executed, recovery procedure documented — matched: [N5, Q11]
- E15: proven Round 5 — automated real-time reconciliation service — matched: [C9, D5, N3]
- N5: proven Round 5 — RPO 45min confirmed via DR test — matched: [D7, Q11]
- N6: proven Round 5 — encryption verified against PCI-DSS during pen test — matched: [D4, Q4]
- C8: proven Round 5 — PCI-DSS validated, pen test passed, scope documented — matched: [E7, D4, Q4]
- C9: proven Round 5 — reconciliation automated and monitored — matched: [E15, D5]
- Q4: proven Round 5 — PCI-DSS pen test executed — matched: [C8, D4, N6]
- Q11: proven Round 5 — DR test executed, RPO confirmed — matched: [N5, D7]

**New items:**
- PM-new: Senior engineer hire plan — engineer with compliance experience, must cover PCI-DSS scope and manufacturer integration knowledge — unverified — job req drafted, no candidates yet

**Pruning:**
- Deploy runbooks and rotation playbooks now documented — items that were knowledge-in-head are now in systems. No items removed but the "single point of failure" origin (O-SYS-3, O-SYS-4) updated to reflect new reality.

**Reconciliation:** With lead leaving, team does honest assessment of what they actually understand. US5 (physical card fulfillment) and E8 (physical card endpoint) have NEVER been tested end-to-end and nobody remaining understands the manufacturer integration. Marked SUSPECT, deferred until new hire. This is the Constitution working — the inventory forces you to be honest about what you don't know, especially when people change.

**Health:**
- Items: 75 (74 + 1 PM-new)
- Proven: 67 (+10 net new: D4, D5, D7, E15, N5, N6, C8, C9, Q4, Q11; D3 and D8 re-proven after SUSPECT but were already counted; US5 and E8 were already unverified, now SUSPECT)
- SUSPECT: 2 (US5, E8 — deferred until new hire)
- Unverified: 6 (C6, C10, C11, Ds8, Q1, PM-new)
- SUSPECT resolved: 2 (D8, D3 — both re-proven after knowledge transfer)
- Health: 67/75 = 89% (was 89%)

89% with the right shape. Both compliance hot paths are now closed: SOC 2 (Round 2) and PCI-DSS (Round 5). All 11 DevOps items proven. All 6 NFRs proven. The remaining gaps are low-ceremony items (Reg DD disclosures, data retention policy, card network compliance tracking, KYC routing test) plus the honest SUSPECT on physical cards. The biggest risk is no longer the inventory — it's the team. Two engineers running a 3-client core banking platform with 10x volume. PM-new (senior engineer hire) is the most important unverified item on the board.

**Remaining not-proven after 5 rounds:**
- SUSPECT: US5 (physical card fulfillment), E8 (physical card endpoint) — knowledge gap, deferred until new hire
- Unverified: C6 (Reg DD disclosures), C10 (card network compliance), C11 (data retention), Ds8 (disclosure delivery), Q1 (KYC decision routing test), PM-new (senior engineer hire plan)

**Hot paths resolved:**
1. ~~Compliance hot path~~ — SOC 2 closed Round 2, all controls proven
2. ~~Card compliance hot path~~ — PCI-DSS closed Round 5, pen test passed, environment verified
3. ~~AML hot path~~ — transaction monitoring upgraded Round 3, SAR filing automated
4. ~~Client onboarding hot path~~ — PayCircle live Round 4, onboarding proven
5. ~~Single-point-of-failure hot path~~ — lead departed Round 5, knowledge transferred, processes de-risked

**New hot path:**
6. **Team capacity hot path:** O-SYS-3 (2 engineers) → PM-new (hire plan) → US5/E8 (physical cards blocked) — 3 clients, 10x volume, 2 engineers. The inventory is healthy; the humans running it are stretched thin.

