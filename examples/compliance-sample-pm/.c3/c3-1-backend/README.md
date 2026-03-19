---
id: c3-1
title: Backend Services
type: container
parent: c3-0
goal: Core business logic microservices for medical practice management
summary: Go microservices using GOFF/Titan framework communicating via NATS
boundary: service
c3-version: 4
---

# backend
## Goal

All Go microservices providing core business logic, API endpoints, and data management. Services communicate via NATS messaging and share common patterns through the Titan framework.
## Responsibilities

Patient management, appointments, prescriptions, clinical documentation. Authentication, session management, authorization. Billing (KV, GOA, BG, EDMP, PVS export). Contract management (HZV/FAV). Secure messaging via KIM and KV-Connect. External system integration (HPM, TI, FHIR). Code generation pipeline (proto to Go + TypeScript).
## Complexity Assessment

**Level:** <!-- [trivial|simple|moderate|complex|critical] -->
**Why:** <!-- signals observed from code analysis -->
## Components

## Layer Constraints

This container operates within these boundaries:

**MUST:**
- Coordinate components within its boundary
- Define how context linkages are fulfilled internally
- Own its technology stack decisions

**MUST NOT:**
- Define system-wide policies (context responsibility)
- Implement business logic directly (component responsibility)
- Bypass refs for cross-cutting concerns
- Orchestrate other containers (context responsibility)
