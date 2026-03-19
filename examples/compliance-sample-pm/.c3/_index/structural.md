# C3 Structural Index
<!-- hash: sha256:48a8e412da4dfb048a1527aca2056162e0ae9cccee88aaa086cea2607ff495d6 -->

## adr-00000000-c3-adoption — C3 Architecture Documentation Adoption (adr)
blocks: Goal ○

## adr-20260319-bubbletea-tui — Bubble Tea for Terminal User Interface (adr)
blocks: Goal ○

## adr-20260319-goff-codegen — GOFF Code Generation for Type Safety (adr)
blocks: Goal ○

## adr-20260319-mongodb-datastore — MongoDB as Primary Data Store (adr)
blocks: Goal ○

## adr-20260319-nats-messaging — NATS-Based Messaging Architecture (adr)
blocks: Goal ○

## adr-20260319-submodule-di — Dependency Injection with submodule.go (adr)
blocks: Goal ○

## adr-20260319-zitadel-identity — Zitadel for Identity Management (adr)
blocks: Goal ○

## c3-0 — Pvs - Medical Practice Management System (context)
reverse deps: adr-00000000-c3-adoption, c3-1, c3-2, c3-3, c3-4
blocks: Abstract Constraints ✓, Containers ✓, Goal ✓

## c3-1 — Backend Services (container)
context: c3-0
reverse deps: c3-101, c3-102, c3-103, c3-104, c3-105, c3-106, c3-107, c3-108, c3-109, c3-110, c3-111, c3-112, c3-113, c3-114, c3-115, c3-116
constraints from: c3-0
blocks: Complexity Assessment ✓, Components ○, Goal ✓, Responsibilities ✓

## c3-101 — MVZ Core Service (component)
container: c3-1 | context: c3-0
files: ares/app/mvz/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-102 — Auth Service (component)
container: c3-1 | context: c3-0
files: ares/app/auth/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-103 — Titan Framework (component)
container: c3-1 | context: c3-0
files: ext/titan/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-104 — Billing System (component)
container: c3-1 | context: c3-0
files: ares/app/mvz/api/billing/**, ares/app/mvz/api/billing_kv/**, ares/app/mvz/api/billing_patient/**, ares/app/mvz/api/billing_history/**, ares/app/mvz/api/bg_billing/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-105 — Contract System (component)
container: c3-1 | context: c3-0
files: ares/app/admin/api/contract/**, ares/app/mvz/api/contract/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-106 — EDMP (Disease Management Programs) (component)
container: c3-1 | context: c3-0
files: ares/app/mvz/api/edmp/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-107 — Mail System (component)
container: c3-1 | context: c3-0
files: ares/app/admin/api/mail/**, ares/app/admin/api/kv_connect/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-108 — Billing, Contract & Mail Integration (component)
container: c3-1 | context: c3-0
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-109 — Billing Subsystems (component)
container: c3-1 | context: c3-0
files: ares/app/mvz/api/billing_edoku/**, ares/app/mvz/api/billing_patient/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-110 — Titan & GOFF Deep Dive (component)
container: c3-1 | context: c3-0
files: ext/goff/**, ares/proto/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-111 — Authentication & Authorization Deep Dive (component)
container: c3-1 | context: c3-0
files: ares/app/auth/api/auth_app/**, ares/app/auth/api/auth_e2e/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-112 — HPM Integration (component)
container: c3-1 | context: c3-0
files: ares/pkg/hpm_rest/**, ares/pkg/hpm_service/**, ares/app/mvz/api/hpm_check_history/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-113 — Repository Layer (component)
container: c3-1 | context: c3-0
files: ares/pkg/repo/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-114 — Domain Services Architecture (component)
container: c3-1 | context: c3-0
files: ares/service/domains/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-115 — Event System (component)
container: c3-1 | context: c3-0
files: ares/pkg/event/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-116 — Medical Catalogs (Master Data) (component)
container: c3-1 | context: c3-0
files: ares/app/mvz/api/catalog_sdkt/**, ares/app/mvz/api/catalog_sdik/**, ares/app/mvz/api/catalog_sdebm/**, ares/app/mvz/api/catalog_goa/**, ares/app/mvz/api/catalog_sdav/**, ares/app/mvz/api/catalog_omimg_chain/**, ares/app/mvz/api/catalog_hgnc_chain/**, ares/app/mvz/api/catalog_bg_insurance/**, ares/app/mvz/api/catalog_material_cost/**, ares/app/mvz/api/catalog_uv_goa/**
constraints from: c3-0, c3-1
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-2 — Web Frontends (container)
context: c3-0
reverse deps: c3-201, c3-202, c3-203, c3-210, c3-211
constraints from: c3-0
blocks: Complexity Assessment ✓, Components ○, Goal ✓, Responsibilities ✓

## c3-201 — Design System (component)
container: c3-2 | context: c3-0
files: pkgs/pvs-design-system/**
constraints from: c3-0, c3-2
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-202 — Hermes BFF (Backend-For-Frontend) (component)
container: c3-2 | context: c3-0
files: pkgs/pvs-hermes/**
constraints from: c3-0, c3-2
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-203 — Infrastructure Package (component)
container: c3-2 | context: c3-0
files: pkgs/pvs-infrastructure/**
constraints from: c3-0, c3-2
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-210 — MVZ Application (component)
container: c3-2 | context: c3-0
files: pkgs/app_mvz/**
constraints from: c3-0, c3-2
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-211 — State Management (component)
container: c3-2 | context: c3-0
constraints from: c3-0, c3-2
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-3 — Native Clients (container)
context: c3-0
reverse deps: c3-301, c3-302, c3-310, c3-311, c3-312
constraints from: c3-0
blocks: Complexity Assessment ✓, Components ○, Goal ✓, Responsibilities ✓

## c3-301 — TUI Application (component)
container: c3-3 | context: c3-0
files: ext/tui/**
constraints from: c3-0, c3-3
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-302 — Companion Desktop Application (component)
container: c3-3 | context: c3-0
files: ext/companion/**
constraints from: c3-0, c3-3
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-310 — TUI Architecture Deep Dive (component)
container: c3-3 | context: c3-0
files: ext/tui/app/**, ext/tui/pages/**, ext/tui/layout/**
constraints from: c3-0, c3-3
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-311 — Companion TI Service (component)
container: c3-3 | context: c3-0
files: ext/companion/internal/ti_service/**, ext/companion/internal/api_telematik/**, ext/companion/internal/api_telematik_service/**, ext/companion/internal/api_telematik_soap/**
constraints from: c3-0, c3-3
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-312 — Companion Integrations (component)
container: c3-3 | context: c3-0
files: ext/companion/internal/mail/**, ext/companion/internal/arriba/**, ext/companion/internal/uploader/**, ext/companion/internal/cetp/**, ext/companion/internal/eprescription/**
constraints from: c3-0, c3-3
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-4 — Platform (container)
context: c3-0
reverse deps: c3-401, c3-402, c3-403, c3-404
constraints from: c3-0
blocks: Complexity Assessment ✓, Components ○, Goal ✓, Responsibilities ✓

## c3-401 — NATS Messaging Infrastructure (component)
container: c3-4 | context: c3-0
files: hera/dev/docker-compose*.yml
constraints from: c3-0, c3-4
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-402 — MongoDB Database (component)
container: c3-4 | context: c3-0
files: ares/db/**
constraints from: c3-0, c3-4
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-403 — HTTP Gateway (component)
container: c3-4 | context: c3-0
files: ares/proxy/gateway/**
constraints from: c3-0, c3-4
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## c3-404 — Socket Service (component)
container: c3-4 | context: c3-0
files: ares/proxy/socket/**
constraints from: c3-0, c3-4
blocks: Container Connection ✓, Dependencies ✓, Goal ✓, Related Refs ○

## File Map
ares/app/admin/api/contract/** → c3-105
ares/app/admin/api/kv_connect/** → c3-107
ares/app/admin/api/mail/** → c3-107
ares/app/auth/** → c3-102
ares/app/auth/api/auth_app/** → c3-111
ares/app/auth/api/auth_e2e/** → c3-111
ares/app/mvz/** → c3-101
ares/app/mvz/api/bg_billing/** → c3-104
ares/app/mvz/api/billing/** → c3-104
ares/app/mvz/api/billing_edoku/** → c3-109
ares/app/mvz/api/billing_history/** → c3-104
ares/app/mvz/api/billing_kv/** → c3-104
ares/app/mvz/api/billing_patient/** → c3-104, c3-109
ares/app/mvz/api/catalog_bg_insurance/** → c3-116
ares/app/mvz/api/catalog_goa/** → c3-116
ares/app/mvz/api/catalog_hgnc_chain/** → c3-116
ares/app/mvz/api/catalog_material_cost/** → c3-116
ares/app/mvz/api/catalog_omimg_chain/** → c3-116
ares/app/mvz/api/catalog_sdav/** → c3-116
ares/app/mvz/api/catalog_sdebm/** → c3-116
ares/app/mvz/api/catalog_sdik/** → c3-116
ares/app/mvz/api/catalog_sdkt/** → c3-116
ares/app/mvz/api/catalog_uv_goa/** → c3-116
ares/app/mvz/api/contract/** → c3-105
ares/app/mvz/api/edmp/** → c3-106
ares/app/mvz/api/hpm_check_history/** → c3-112
ares/db/** → c3-402
ares/pkg/event/** → c3-115
ares/pkg/hpm_rest/** → c3-112
ares/pkg/hpm_service/** → c3-112
ares/pkg/repo/** → c3-113
ares/proto/** → c3-110
ares/proxy/gateway/** → c3-403
ares/proxy/socket/** → c3-404
ares/service/domains/** → c3-114
ext/companion/** → c3-302
ext/companion/internal/api_telematik/** → c3-311
ext/companion/internal/api_telematik_service/** → c3-311
ext/companion/internal/api_telematik_soap/** → c3-311
ext/companion/internal/arriba/** → c3-312
ext/companion/internal/cetp/** → c3-312
ext/companion/internal/eprescription/** → c3-312
ext/companion/internal/mail/** → c3-312
ext/companion/internal/ti_service/** → c3-311
ext/companion/internal/uploader/** → c3-312
ext/goff/** → c3-110
ext/titan/** → c3-103
ext/tui/** → c3-301
ext/tui/app/** → c3-310
ext/tui/layout/** → c3-310
ext/tui/pages/** → c3-310
hera/dev/docker-compose*.yml → c3-401
pkgs/app_mvz/** → c3-210
pkgs/pvs-design-system/** → c3-201
pkgs/pvs-hermes/** → c3-202
pkgs/pvs-infrastructure/** → c3-203

