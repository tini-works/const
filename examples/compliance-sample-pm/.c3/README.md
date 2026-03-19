---
id: c3-0
title: Pvs - Medical Practice Management System
goal: Comprehensive medical practice management for German healthcare providers (MVZ), enabling patient records, appointments, prescriptions, billing, and clinical workflows
summary: Microservices-based medical practice management system with Go backend, Next.js frontend, NATS messaging, and native desktop/terminal clients
c3-version: 4
---

# ${PROJECT}
## Goal

Pvs (Praxisverwaltungssystem) is a comprehensive medical practice management system for German healthcare providers, enabling MVZ practices to manage patient records, appointments, prescriptions, billing, and clinical workflows.

## Abstract Constraints

| Constraint | Rationale | Affected Containers |
|------------|-----------|---------------------|
| All inter-service communication via NATS | Decoupled services, unified messaging protocol | c3-1, c3-3, c3-4 |
| Type safety across Go/TypeScript via GOFF codegen | Single proto source of truth prevents drift | c3-1, c3-2 |
| Authentication via Zitadel OIDC | Standards-compliant, self-hosted for German data sovereignty | c3-1, c3-2, c3-3 |
| MongoDB as primary document store | Flexible schema fits healthcare domain | c3-1, c3-4 |
| Dependency injection via submodule.go | Compile-time DI ensures type safety and testability | c3-1, c3-3 |

## Containers

| ID | Name | Boundary | Status | Responsibilities | Goal Contribution |
|----|------|----------|--------|------------------|-------------------|
| c3-1 | Backend Services | service | active | Core business logic, API services | Implements medical practice workflows |
| c3-2 | Web Frontends | app | active | Browser-based applications | Provides UI for all user roles |
| c3-3 | Native Clients | app | active | Desktop and terminal apps | Power-user and hardware integration |
| c3-4 | Platform | service | active | Infrastructure and runtime | Provides infrastructure for all containers |

