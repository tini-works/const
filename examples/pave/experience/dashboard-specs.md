# Dashboard Specs — Pave Deploy Platform

The web dashboard is the secondary interface — used for oversight, monitoring, and operations that benefit from visual context. Engineers do daily work in the CLI. The dashboard is for when you need to see the big picture, compare metrics visually, or perform operations that require reviewing complex state (canary comparisons, audit trails, approval queues).

**URL:** `https://pave.internal`
**Auth:** SSO via corporate identity provider. Role-based access matches CLI roles.

---

## D1: Deploy Queue

**Purpose:** Live view of all pending, running, and recently completed deploys across all services.

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [GET /deploys](../architecture/api-spec.md#get-deploys), [WebSocket /ws/deploys](../architecture/api-spec.md#websocket-wsdeploys), [Deploy Service](../architecture/architecture.md#deploy-service) |
| Proven by | [TC-105](../quality/test-suites.md#tc-105-status-shows-current-deploy-info), [TC-110](../quality/test-suites.md#tc-110-deploy-queue-real-time-updates) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-20 |

**Layout:**
- Top bar: global navigation (Queue, Services, Canary, Audit, Secrets, Health, Approvals)
- Main content: deploy table with real-time updates

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Header | "Deploy Queue" + environment toggle (staging / production / all) | Default: production |
| Filters | Team, Service, Status, Date range | Pill-style multi-select filters |
| Deploy table | Columns: Position, Service, Version, Deployer, Status, Started, Duration | Sortable by any column |
| Deploy row (expanded) | Commit list, build logs link, canary link (if applicable), approval status | Click row to expand |
| Queue stats bar | Deploys today: N, Avg wait: Nm, Avg duration: Nm, Failure rate: N% | Bottom of table |

**States:**

| State | What the user sees |
|-------|-------------------|
| Empty queue | "No deploys in queue. All services up to date." |
| Deploys running | Active deploy rows have animated progress indicator (build → deploy → verify) |
| Deploy failed | Row turns red. Expand shows error summary with link to full logs. |
| Emergency deploy | Row has orange "EMERGENCY" badge. Sorted to top regardless of queue position. |
| Queue paused (post-Round 6) | Yellow banner: "Deploy queue paused by sasha.petrov. Reason: investigating deploy-queue corruption. Resume: pave queue resume" |

---

## D2: Service Overview

**Purpose:** Per-service view showing deploy history, current health, and configuration.

| Trace | Link |
|-------|------|
| Traced from | [US-001](../product/user-stories.md#us-001-standard-deploy-with-commit-visibility), [US-003](../product/user-stories.md#us-003-drift-detection-after-manual-changes), [E1](../product/epics.md#e1-core-deploy-pipeline) |
| Matched by | [GET /services/{name}/status](../architecture/api-spec.md#get-servicesnamestatus), [GET /services/{name}/deploys](../architecture/api-spec.md#get-servicesnamedeploys), [GET /services/{name}/drift](../architecture/api-spec.md#get-servicesnamedrift) |
| Proven by | [TC-105](../quality/test-suites.md#tc-105-status-shows-current-deploy-info), [TC-701](../quality/test-suites.md#tc-701-drift-detected-after-manual-ssh-change) |
| Confirmed by | Rina Okafor (DX Designer), 2025-06-20 |

**Layout:**
- Service header with name, current version, health badge
- Tabbed content: Deploys, Config, Drift, Access

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Service header | Service name, version badge, health indicator (healthy/degraded/down), environment selector | Sticky top |
| Deploy history tab | Table: Deploy ID, Version, Deployer, Status, Duration, Commits | Most recent 50, paginated |
| Config tab | Current pave.yaml (read-only), environment variables (names only, values masked), resource limits | Edit via CLI only |
| Drift tab | Drift status (clean / drift detected), diff view if drift exists | Links to `pave drift show` docs |
| Access tab | Who has what role on this service | Modify via CLI or admin UI |

**States:**

| State | What the user sees |
|-------|-------------------|
| Healthy | Green badge, all pods running |
| Degraded | Yellow badge, error rate elevated or pods restarting |
| Down | Red badge, no healthy pods |
| Drift detected | Orange "DRIFT" badge on service header, drift tab shows diff |
| Onboarding | Blue "ONBOARDING" badge — service registered but never deployed. Shows setup checklist. |

---

## D3: Canary Monitor

**Purpose:** Real-time canary observation dashboard. Side-by-side comparison of canary vs baseline metrics. This is the screen engineers watch during a canary deploy.

| Trace | Link |
|-------|------|
| Traced from | [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), [E2](../product/epics.md#e2-canary-deploys) |
| Matched by | [GET /canary/{id}](../architecture/api-spec.md#get-canaryid), [GET /canary/{id}/metrics](../architecture/api-spec.md#get-canaryidmetrics), [WebSocket /ws/canary/{id}](../architecture/api-spec.md#websocket-wscanaryid), [Canary Controller](../architecture/architecture.md#canary-controller) |
| Proven by | [TC-202](../quality/test-suites.md#tc-202-canary-metrics-comparison), [TC-205](../quality/test-suites.md#tc-205-canary-dashboard-real-time-metrics) |
| Confirmed by | Rina Okafor (DX Designer), 2025-07-25 |

**Layout:**
- Split view: baseline metrics on the left, canary metrics on the right
- Shared timeline at the bottom
- Action bar at the top

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Action bar | Service name, canary ID, traffic split (editable slider), time remaining, "Promote" / "Abort" buttons | Promote/Abort require confirmation dialog |
| Traffic split visualization | Horizontal bar showing percentage split (e.g., 90% baseline / 10% canary) | Drag slider to adjust in real-time |
| Error rate comparison | Two line charts side by side: baseline error rate vs canary error rate, shared Y axis | Red shading if canary exceeds threshold |
| Latency comparison | Two line charts: p50, p95, p99 latency for baseline vs canary | |
| Request volume | Single chart showing total requests, split by baseline/canary | Confirms traffic split is actually working |
| Recent errors | Table of recent 5xx errors from canary, with stack trace preview | Click to see full error |
| Summary verdict | Auto-calculated: "Canary is performing within thresholds" or "Canary error rate is 3.2x baseline — consider aborting" | Updates every 30 seconds |

**States:**

| State | What the user sees |
|-------|-------------------|
| Observing | Charts updating in real time. Timer counting down. |
| Threshold exceeded | Summary verdict turns red. "Abort" button pulses gently. No auto-abort — decision is human. |
| Promoting | "Promoting..." overlay. Traffic split animating from split to 100% canary. Charts still visible. |
| Promoted | Green success state. "Canary promoted to production." Charts frozen at final state. |
| Aborted | Red state. "Canary aborted. All traffic on baseline." Charts frozen. Reason field shown if provided. |
| No active canary | "No active canary for this service. Start one with: pave canary start" |

**Design note (DD-004):** The side-by-side layout is non-negotiable. Early mocks showed canary metrics alone — useless without a baseline to compare against. You can't decide whether 45ms p99 is good or bad unless you see the baseline's 42ms right next to it.

---

## D4: Audit Log

**Purpose:** Searchable, filterable record of all actions taken through Pave. SOC2 auditors use this screen.

| Trace | Link |
|-------|------|
| Traced from | [US-009](../product/user-stories.md#us-009-rbac-and-audit-trail), [E5](../product/epics.md#e5-soc2-compliance) |
| Matched by | [GET /audit](../architecture/api-spec.md#get-audit), [Audit Service](../architecture/architecture.md#audit-service) |
| Proven by | [TC-501](../quality/test-suites.md#tc-501-audit-log-records-all-deploy-actions), [TC-502](../quality/test-suites.md#tc-502-audit-log-records-access-changes) |
| Confirmed by | Rina Okafor (DX Designer), 2025-08-25 |

**Layout:**
- Full-width table with filter sidebar

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Filter sidebar | Date range picker, User (autocomplete), Service, Action type (multi-select), Environment | Collapsible on mobile |
| Audit table | Columns: Timestamp, User, Action, Service, Environment, Detail, Audit ID | Paginated, 100 per page |
| Export button | "Export CSV" — downloads filtered results | For auditor handoff |
| Entry detail (expanded) | Full action detail: request payload (secrets masked), response, IP address, session ID | Click row to expand |

**States:**

| State | What the user sees |
|-------|-------------------|
| Loading | Skeleton rows (8 placeholder rows with shimmer) |
| Results | Populated table with pagination controls |
| No results | "No audit entries match your filters." |
| Export in progress | "Exporting 2,847 entries..." with progress bar |

**SOC2 note:** Audit entries are immutable. No delete or edit capability exists — by design, not by oversight.

---

## D5: Deploy Health Dashboard

**Purpose:** DORA-like metrics per team and per service. Shows deploy frequency, failure rate, lead time, and recovery time. Introduced in response to Round 7 (KPI gaming) to provide quality metrics alongside quantity.

| Trace | Link |
|-------|------|
| Traced from | [US-011](../product/user-stories.md#us-011-deploy-health-metrics), [E7](../product/epics.md#e7-platform-metrics-and-reporting) |
| Matched by | [GET /metrics/health](../architecture/api-spec.md#get-metricshealth), [Metrics Service](../architecture/architecture.md#metrics-service) |
| Proven by | [TC-901](../quality/test-suites.md#tc-901-health-dashboard-shows-team-metrics), [TC-902](../quality/test-suites.md#tc-902-health-metrics-use-relative-baselines) |
| Confirmed by | Rina Okafor (DX Designer), 2025-09-20 |

**Layout:**
- Team selector at top
- Four metric cards in a 2x2 grid
- Trend chart below

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Team selector | Dropdown: All teams, Team Falcon, Team Kite, Team Atlas, Team Bolt, Team Sentry, Gridline | Default: All teams |
| Time range | 7d / 30d / 90d toggle | Default: 30d |
| Deploy frequency card | Deploys per week, trend arrow (up/down/flat) | Shown against team's own historical baseline, NOT absolute numbers |
| Failure rate card | % of deploys that required rollback or failed, trend arrow | Color: green <5%, yellow 5-15%, red >15% |
| Lead time card | Median time from commit to production deploy | |
| Recovery time card | Median time from failed deploy to successful rollback or fix | |
| Trend chart | Line chart showing all four metrics over selected time range | Per-team or aggregate |
| Deploy classification table | Recent deploys classified: feature, bugfix, config, dependency, README-only | Visibility into what's being deployed, not just how often |

**States:**

| State | What the user sees |
|-------|-------------------|
| Healthy team | All four cards green or neutral |
| Gaming detected (Round 7) | Warning banner: "Deploy frequency increased 3x in 2 weeks but failure rate also increased 2.5x. This pattern suggests PR splitting, not genuine improvement." **Status: suspect** — warning threshold logic needs tuning after first quarter of data. |
| New team (Gridline) | "Insufficient data for trend analysis. Metrics will appear after 10+ deploys." |
| Degraded team | Failure rate card red, recovery time card yellow. No automatic action — this is information, not enforcement. |

**Design note (DD-007):** Metrics use team-relative baselines. A team deploying 3x/week with 0% failure is healthier than a team deploying 20x/week with 30% failure. The dashboard never ranks teams against each other — each team's health is assessed against its own history.

---

## D6: Secrets Dashboard

**Purpose:** Visual overview of secrets across all services. Shows rotation status, upcoming expirations, and recent rotation history.

| Trace | Link |
|-------|------|
| Traced from | [US-008](../product/user-stories.md#us-008-secrets-rotation-without-redeploy), [E4](../product/epics.md#e4-secrets-management) |
| Matched by | [GET /secrets/overview](../architecture/api-spec.md#get-secretsoverview), [Secrets Manager](../architecture/architecture.md#secrets-manager) |
| Proven by | [TC-301](../quality/test-suites.md#tc-301-secrets-list-shows-rotation-status), [TC-305](../quality/test-suites.md#tc-305-secrets-dashboard-expiration-warnings) |
| Confirmed by | Rina Okafor (DX Designer), 2025-09-15 |

**Layout:**
- Summary cards at top
- Service-grouped secrets table below

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Summary cards | Total secrets, Expiring within 7d (count, red if >0), Expiring within 30d (count, yellow if >0), Overdue (count, red badge) | At-a-glance health |
| Secrets table | Grouped by service. Columns: Secret name, Service, Environment, Last rotated, Expires in, Status | Status: current / expiring soon / overdue / static |
| Rotation history | Expandable row detail: who rotated, when, propagation status | |
| Quick actions | "Rotate" button per secret (opens confirmation), "Rotate all expiring" bulk action | Bulk rotate requires secrets-admin role |

**States:**

| State | What the user sees |
|-------|-------------------|
| All current | Summary cards all green. "All secrets are current." |
| Expirations approaching | Yellow "expiring soon" rows. Summary card shows count. |
| Overdue rotations | Red "overdue" rows sorted to top. Banner: "3 secrets are past their rotation policy. Rotate immediately." |
| Rotation in progress | Spinner on affected row. "Rotating... propagating to 3 pods" |
| Rotation failed | Red inline error on affected row. "Rotation failed: 1/3 pods did not pick up new value. See logs." |

---

## D7: Approval Queue

**Purpose:** Dashboard for PCI approval flow. Shows pending deploys awaiting security sign-off, recently approved/rejected deploys.

| Trace | Link |
|-------|------|
| Traced from | [US-010](../product/user-stories.md#us-010-pci-deploy-approval), [E6](../product/epics.md#e6-pci-compliance) |
| Matched by | [GET /approvals](../architecture/api-spec.md#get-approvals), [Approval Service](../architecture/architecture.md#approval-service) |
| Proven by | [TC-601](../quality/test-suites.md#tc-601-approval-request-creates-slack-notification), [TC-603](../quality/test-suites.md#tc-603-approved-deploy-proceeds), [TC-604](../quality/test-suites.md#tc-604-rejected-deploy-blocked) |
| Confirmed by | Rina Okafor (DX Designer), 2025-10-20 |

**Layout:**
- Pending queue prominently at top
- History table below

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Pending queue | Cards for each pending approval: Service, Version, Requester, Time waiting, Commit summary, "Approve" / "Reject" buttons | Sorted by time waiting (oldest first) |
| Waiting time indicator | Per-card: "Waiting 12 min" (green), "Waiting 2h" (yellow), "Waiting 8h" (red) | Color indicates urgency |
| Approval detail (expanded) | Full commit list, diff stats, test results, deploy plan | Everything an approver needs to make a decision |
| History table | Columns: Deploy ID, Service, Requester, Decision, Approver, Time to decision | Last 30 days |
| Self-approval guard | If the logged-in user is the requester, "Approve" button is disabled with tooltip: "PCI requires a different person to approve" | |

**States:**

| State | What the user sees |
|-------|-------------------|
| Empty queue | "No pending approvals. All PCI-scoped deploys are approved." |
| Pending approvals | Cards with approve/reject actions. Badge in nav shows count. |
| Stale approval | Card turns yellow after 4 hours: "This approval has been waiting 4+ hours. The deployer may be blocked." |
| Recently decided | Row in history with green "Approved" or red "Rejected" badge |

**Design note (DD-005):** The primary approval flow happens in Slack (emoji reaction). This dashboard exists for visibility and as a fallback. Most approvers never open this page — they approve via the Slack bot. The dashboard is for tracking, not for primary workflow.

---

## D8: Onboarding Status

**Purpose:** Track onboarding progress for new teams, especially non-standard stacks (Gridline). Shows what's configured, what's missing, what's blocked.

| Trace | Link |
|-------|------|
| Traced from | [US-006](../product/user-stories.md#us-006-new-team-onboarding), [US-007](../product/user-stories.md#us-007-non-kubernetes-stack-onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility) |
| Matched by | [GET /onboarding/{team}](../architecture/api-spec.md#get-onboardingteam), [Onboarding Service](../architecture/architecture.md#onboarding-service) |
| Proven by | [TC-401](../quality/test-suites.md#tc-401-init-generates-valid-pave-yaml), [TC-403](../quality/test-suites.md#tc-403-onboarding-checklist-tracks-progress) |
| Confirmed by | Rina Okafor (DX Designer), 2025-08-10 |

**Layout:**
- Team selector
- Checklist with expandable steps

**Regions:**

| Region | Content | Notes |
|--------|---------|-------|
| Team selector | Dropdown of teams currently onboarding | |
| Progress bar | "4 of 8 steps complete" with visual bar | |
| Checklist | Steps: pave.yaml created, First staging deploy, Health check passing, CI integration, Secrets configured, RBAC configured, First production deploy, Monitoring verified | Each step: complete (green check), in progress (blue), not started (gray), blocked (red) |
| Step detail (expanded) | Instructions, links to docs, common issues for this step, "Mark complete" button (for manual steps) | |
| Compatibility warnings | For non-K8s stacks: "Canary deploys not available in docker-compose mode. See compatibility docs." | Honest about limitations |
| Timeline | Target completion date, actual progress vs plan | Shows if team is on track for SOC2 deadline |

**States:**

| State | What the user sees |
|-------|-------------------|
| On track | Progress bar green. "Gridline is on track — 6 of 8 steps complete, 45 days remaining." |
| Behind schedule | Progress bar yellow. "Gridline is behind — 3 of 8 steps complete, 20 days remaining. Blocked on: CI integration." |
| Blocked | Red blocked step with explanation. "CI integration blocked: Gridline uses Jenkins, Pave integration requires GitHub Actions or GitLab CI. Workaround in progress." |
| Complete | Full green. "Gridline onboarding complete. All steps verified." Team removed from onboarding view after 7 days. |
