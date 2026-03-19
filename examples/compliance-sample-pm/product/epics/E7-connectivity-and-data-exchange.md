## E7: Connectivity & Data Exchange

**Goal:** Enable external connectivity — TI connectors, secure messaging, and data exchange interfaces — so that the system can communicate with gematik infrastructure, external partners, and support digital referral workflows.

**Origin:** AKA Q1-26-1 catalog sections 3.8 (ITVE) and 3.9 (DETE) — 7 obligations covering eArztbrief, TeleScan, connector interfaces, and external data exchange; KVDT v6.06 section 2.7 — 8 obligations covering digital Muster 6 referral via KIM doctor-to-doctor communication.

**Scope:**
- TI connector integration for gematik services
- eArztbrief (electronic referral letter) send and receive
- KIM (Kommunikation im Medizinwesen) secure messaging
- External data exchange interfaces
- Connector handshake testing and error resilience
- **Digital Muster 6 referral** — scope of implementation, automated form population, creation per BMV-Ä Anlage 2b and technical handbook DiMus, sending via secure KIM channel, receiving and reading incoming digital referrals, data extraction and processing into billing system (KVDT 2.7)

**Compliance impact:** BG-1c (gematik TI Approval), BG-6 (Competitive Advantage)

**Note:** AKA connectivity items are currently Optional (see DEC-001, DEC-002). KVDT digital Muster 6 items (K26-01 through K26-08) are all Optional — implementation at software vendor discretion.

**Traceability:**

| Link type | References |
|-----------|------------|
| Catalog sections | AKA 3.8 ITVE, 3.9 DETE; KVDT 2.7 |
| KVDT Requirements | [K26-01](../compliances/KVDT/K26-01.md), [K26-02](../compliances/KVDT/K26-02.md), [K26-03](../compliances/KVDT/K26-03.md), [K26-04](../compliances/KVDT/K26-04.md), [K26-05](../compliances/KVDT/K26-05.md), [K26-06](../compliances/KVDT/K26-06.md), [K26-07](../compliances/KVDT/K26-07.md), [K26-08](../compliances/KVDT/K26-08.md) |
| AVWG Requirements | — |
| AKA Requirements | 7 user stories from ITVE/DETE sections |
| Decisions | DEC-001, DEC-002 (AKA connectivity deferred) |
| Confirmed by | — |

**Verification:** 0/~15 requirements confirmed — all TBC. All items Optional.
