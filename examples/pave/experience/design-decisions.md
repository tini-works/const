# Design Decisions — Pave Developer Experience

Where I pushed back on PM, added requirements PM didn't specify, or made DX trade-offs. Each decision has a rationale and traces to the triggering event.

— Rina Okafor, Developer Experience Designer

---

## DD-001: CLI-First, Dashboard-Second

**Triggered by:** Initial platform design discussions, [E1](../product/epics.md#e1-core-deploy-pipeline)
**Matched by:** [All CLI endpoints](../architecture/api-spec.md), [All dashboard endpoints](../architecture/api-spec.md)
**Confirmed by:** Rina Okafor (DX Designer), 2025-06-01

**PM said:** Build a dashboard for deploy management. CLI is a nice-to-have for power users.

**DX pushed back:** Inverted the priority. CLI is primary, dashboard is secondary.

**Rationale:** Our users are ~300 engineers. They live in terminals. Their workflow is: write code, commit, deploy. Adding a browser tab to that flow is context-switching. A `pave deploy` command in the same terminal where they just ran `git push` is zero context-switch.

The dashboard is for things that benefit from visual context: canary metric comparisons (side-by-side charts), audit log browsing (table with filters), onboarding progress tracking (checklist). These are occasional, oversight-oriented tasks — not daily workflow.

**Evidence:** In the first month after launch, CLI usage was 94% of all Pave interactions. Dashboard usage was mostly canary monitoring and audit log exports.

**Trade-off:** The dashboard doesn't support every operation the CLI does. You can't grant access, rotate secrets, or run emergency deploys from the dashboard. This is intentional — those are precise, auditable operations that belong in a terminal with clear command history, not behind a "Submit" button.

---

## DD-002: Error Messages Must Include Remediation Steps

**Triggered by:** Round 1 post-mortem (engineers couldn't find rollback command during incident), Round 2 (unclear error when drift detected)
**Matched by:** [All CLI error responses](../architecture/api-spec.md#error-response-format)
**Confirmed by:** Rina Okafor (DX Designer), 2025-06-15

**PM said:** Error messages should clearly state what went wrong.

**DX added:** Every error message must include three things:
1. What happened (the error)
2. Why it happened (the cause, if determinable)
3. What to do next (the remediation command or action)

**Examples of what I rejected:**
- `Error: deploy failed` — useless
- `Error: image not found` — slightly better but still leaves the engineer guessing

**What we ship:**
```
Error: Deploy failed — image checkout-service:v2.14.3 not found in registry.
Cause: Build step did not complete. Check build logs.
Fix: Run 'pave log dep-20250615-0847 --phase build' to see build output.
     If the build didn't run, check your pave.yaml 'build' section.
```

**Rationale:** During an incident at 2 AM, engineers are stressed, tired, and context-switching between 5 terminal tabs. They don't have time to search documentation. The error message IS the documentation — it should tell them exactly what command to run next.

**Cost:** More engineering effort per error path. Every new error requires writing a remediation message. Worth it.

---

## DD-003: Interactive Onboarding Wizard, Not Just Docs

**Triggered by:** [US-006](../product/user-stories.md#us-006-new-team-onboarding), [US-007](../product/user-stories.md#us-007-non-kubernetes-stack-onboarding), Round 4 (Gridline onboarding), [E3](../product/epics.md#e3-onboarding-and-compatibility)
**Matched by:** [POST /services](../architecture/api-spec.md#post-services), [Onboarding Service](../architecture/architecture.md#onboarding-service)
**Confirmed by:** Rina Okafor (DX Designer), 2025-08-05

**PM said:** Provide documentation for new teams to create their `pave.yaml` configuration.

**DX pushed back:** Documentation alone won't work for Gridline. They don't know Kubernetes, don't know our conventions, and have 90 days to onboard for SOC2. Asking them to read docs and hand-write a config file is setting them up to fail.

**DX solution:** `pave init` — an interactive wizard that:
1. Detects the existing stack (Dockerfile, docker-compose, K8s manifests, CI config)
2. Asks targeted questions with sensible defaults
3. Generates a valid `pave.yaml`
4. Tells you honestly what features are and aren't available for your stack

**What makes this different from `npm init`:**
- It detects your stack and adapts questions accordingly. A docker-compose team doesn't get asked about K8s namespace configuration.
- It flags compatibility limitations upfront: "Canary deploys are not available in docker-compose mode."
- It generates a working config, not a template with `TODO` comments.

**PM's concern:** "What if the wizard generates a bad config?" The wizard generates a valid config based on detection + answers. The first `pave deploy --env staging` validates it end-to-end. If something is wrong, the deploy error tells you what to fix.

---

## DD-004: Canary Dashboard Shows Comparison Metrics, Not Just Canary

**Triggered by:** [US-005](../product/user-stories.md#us-005-canary-deploy-with-traffic-splitting), Round 3 (Team Atlas canary request), [E2](../product/epics.md#e2-canary-deploys)
**Matched by:** [GET /canary/{id}/metrics](../architecture/api-spec.md#get-canaryidmetrics), [Canary Controller](../architecture/architecture.md#canary-controller)
**Confirmed by:** Rina Okafor (DX Designer), 2025-07-25

**Early mock:** Canary dashboard showed canary metrics only — error rate, latency, request count for the new version.

**DX rejected this.** A canary error rate of 0.15% means nothing without context. Is the baseline 0.14% (canary is fine) or 0.01% (canary is 15x worse)?

**DX solution:** Side-by-side layout with shared axes. Baseline on the left, canary on the right. Same time range, same Y axis. The engineer's eye naturally compares the two lines.

**Added features PM didn't specify:**
- Auto-calculated verdict: "Canary error rate is 3.2x baseline — consider aborting." This is advisory, not action-triggering. The engineer decides.
- Request volume chart confirming the traffic split is actually working (not just configured).
- Recent 5xx errors from canary with stack trace preview — you don't want to wait for logs when the canary is failing.

**What I explicitly rejected:** Auto-abort and auto-promote. The data informs; the human decides. Auto-abort sounds safe until it kills a canary at 4:59 AM because of a one-second latency spike from a GC pause.

---

## DD-005: Approval Flow via Slack Bot, Not Dashboard-Only

**Triggered by:** [US-010](../product/user-stories.md#us-010-pci-deploy-approval), Round 9 (PCI DSS v4.0), [E6](../product/epics.md#e6-pci-compliance)
**Matched by:** [POST /approvals](../architecture/api-spec.md#post-approvals), [Approval Service](../architecture/architecture.md#approval-service)
**Confirmed by:** Rina Okafor (DX Designer), 2025-10-15

**PM said:** PCI approval flow — deploy requires security team sign-off before production.

**Architecture proposed:** Approval via the dashboard (D7 Approval Queue).

**DX pushed back:** Security team members are in Slack. They're not monitoring a dashboard. Making them open a browser to approve a deploy adds 3-5 minutes of friction to every PCI deploy. Over time, that friction causes people to find workarounds.

**DX solution:** Slack bot is the primary approval channel. When a PCI deploy is requested:
1. Bot posts to #pci-approvals with deploy summary
2. Approver reacts with emoji or clicks "Approve" / "Reject" buttons
3. Deploy proceeds or is blocked based on reaction
4. Dashboard (D7) exists for visibility and as a fallback

**Self-approval guard:** The bot checks the requester. If the person approving is the same person who requested the deploy, it blocks with: "PCI requires a different person to approve."

**Dashboard role:** D7 is for tracking (what's pending, what was approved when, response time metrics). It's not the primary workflow.

---

## DD-006: Emergency Bypass Is Possible But Uncomfortable

**Triggered by:** [US-004](../product/user-stories.md#us-004-emergency-deploy-bypass), Round 2 (bypass and overwrite), Round 6 (Pave self-outage)
**Matched by:** [POST /deploys/emergency](../architecture/api-spec.md#post-deploysemergency), [Deploy Service](../architecture/architecture.md#deploy-service)
**Confirmed by:** Rina Okafor (DX Designer), 2025-07-01

**The problem:** Round 2 showed that engineers WILL bypass Pave when they need to (SSH to prod, manual cert update). Round 6 showed that Pave itself can go down. We need an official escape hatch.

**The design challenge:** Make the escape hatch accessible enough for real emergencies but uncomfortable enough to prevent casual use.

**DX solution:**
- `pave emergency deploy --acknowledge-audit` — the `--acknowledge-audit` flag is required (not optional, not a prompt default). You have to type it.
- Confirmation prompt explicitly lists what you're bypassing: queue, approvals, canary.
- Output reminds you that a post-incident review is required within 48 hours.
- Audit log flags the deploy as "emergency" with high visibility.

**What I rejected:**
- Making emergency deploy require two-person approval (too slow for a real emergency at 2 AM)
- Making emergency deploy easy (just `pave deploy --emergency` with a y/N prompt) — too casual
- Removing the escape hatch entirely ("all deploys go through the queue") — Round 6 proved this is dangerous

**The balance:** Possible but uncomfortable. Like breaking a fire alarm glass — you can do it, but you won't do it for fun.

---

## DD-007: Deploy Health Uses Team-Relative Baselines

**Triggered by:** [US-011](../product/user-stories.md#us-011-deploy-health-metrics), Round 7 (KPI gaming — VP mandated 10 deploys/week, teams split PRs to game the number), [E7](../product/epics.md#e7-platform-metrics-and-reporting)
**Matched by:** [GET /metrics/health](../architecture/api-spec.md#get-metricshealth), [Metrics Service](../architecture/architecture.md#metrics-service)
**Confirmed by:** Rina Okafor (DX Designer), 2025-09-20

**PM said:** Show DORA-like metrics per team. Deploy frequency, failure rate, lead time, recovery time.

**The problem with absolute metrics:** After the VP's announcement, Team Falcon split every PR into 3 and went from 5 deploys/week to 18. Their failure rate also went from 2% to 12%. By absolute deploy frequency, they looked great. By any quality metric, they were worse.

**DX solution:** Metrics are relative to each team's own baseline.
- A team deploying 3x/week with 0% failure shows as "healthy."
- A team deploying 20x/week with 30% failure shows as "degraded."
- A sudden 3x increase in deploy frequency with a corresponding increase in failure rate triggers a warning: "Deploy frequency increased 3x in 2 weeks but failure rate also increased 2.5x."

**What I explicitly did NOT build:**
- Team leaderboards or rankings. Teams deploying to different services with different risk profiles are not comparable.
- Enforcement actions based on metrics. The dashboard informs. Management decides.
- "Gaming detection" as a punitive feature. The warning is informational, not accusatory: "This pattern suggests PR splitting" — it doesn't say "this team is gaming."

**Deploy classification (added later):** Each deploy is tagged: feature, bugfix, config change, dependency update, README-only. This gives visibility into what's being deployed, which is more useful than raw frequency. A team deploying 20 bugfixes is in a very different situation than a team deploying 20 README updates.

**Status: suspect** — The gaming detection warning threshold ("3x increase") was set based on the Round 7 data. After a full quarter of data, we should recalibrate the thresholds. The current threshold may be too sensitive (flagging legitimate increases) or not sensitive enough (missing subtler gaming patterns).
