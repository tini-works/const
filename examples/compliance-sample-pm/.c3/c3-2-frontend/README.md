---
id: c3-2
title: Web Frontends
type: container
parent: c3-0
goal: Browser-based applications for medical practice users
summary: Next.js applications with shared design system and auto-generated TypeScript types
boundary: app
c3-version: 4
---

# frontend
## Goal

Browser-based applications built with Next.js and React, providing the primary user interface for doctors, medical staff, administrators, and system admins.
## Responsibilities

MVZ app: main practice management UI (51 feature modules). Admin app: administrative functions, billing, reports. Sysadmin app: system configuration, user management. Design system: shared React component library. Hermes BFF: auto-generated TypeScript types from proto. Infrastructure: shared utilities, hooks, validation.
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
