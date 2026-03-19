---
id: c3-4
title: Platform
type: container
parent: c3-0
goal: Infrastructure and runtime services for all containers
summary: NATS messaging, MongoDB, MinIO, HTTP/WebSocket proxies, and Kubernetes orchestration
boundary: service
c3-version: 4
---

# platform
## Goal

Infrastructure components required to run the Pvs system: messaging, databases, storage, proxies, orchestration, and supporting backend tools.
## Responsibilities

NATS: messaging backbone for all inter-service communication. MongoDB: primary document database. MinIO: S3-compatible object storage. HTTP Gateway: HTTP to NATS translation. Socket Service: WebSocket to NATS bridge for real-time updates. HAProxy: reverse proxy and TLS. PostgreSQL: master data (HIMI) and ETL. Kubernetes: production orchestration.
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
