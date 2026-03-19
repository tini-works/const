---
id: c3-3
title: Native Clients
type: container
parent: c3-0
goal: Desktop and terminal applications with direct backend connectivity
summary: Go-based TUI (Bubble Tea) and Companion (Wails) applications connecting directly to NATS
boundary: app
c3-version: 4
---

# clients
## Goal

Non-browser applications connecting directly to the Pvs backend via NATS. The TUI provides keyboard-driven terminal access; the Companion app provides local system integration.
## Responsibilities

TUI: terminal-based practice management using Bubble Tea. Companion: desktop application via Wails (Go + React). TI integration: Telematik Infrastructure connector, health card reading. Direct NATS connectivity: bypasses HTTP gateway. OIDC authentication: shared Zitadel integration.
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
