# Engineering Diagrams — Clinic Check-In System

Visual references for architecture, data model, and key system flows.

---

## System Architecture
Full system decomposition: clients, services, data stores, infrastructure.

https://diashort.apps.quickable.co/d/17eba3ea

---

## Data Model (ER Diagram)
Core entities, relationships, and key fields across all rounds.

https://diashort.apps.quickable.co/d/280207f2

---

## Kiosk-to-Receptionist Sync (BUG-001 Fix)
Sequence diagram: end-to-end sync confirmation via WebSocket ack, including timeout and fallback paths.

https://diashort.apps.quickable.co/d/64120fa4

---

## Optimistic Concurrency Control (BUG-003 Fix)
Sequence diagram: two receptionists editing the same patient record simultaneously, version conflict detection and resolution.

https://diashort.apps.quickable.co/d/d1e238bc

---

## Riverside Migration Pipeline
Data flow from EMR export and paper records through validation, dedup, staff review, and import.

https://diashort.apps.quickable.co/d/342376ce
