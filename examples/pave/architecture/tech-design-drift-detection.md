# Tech Design: Drift Detection

**ADR:** [ADR-002](adrs.md#adr-002-drift-detection-via-state-fingerprinting)
**Epic:** [E1: Deploy Safety & Traceability](../product/epics.md#e1-deploy-safety--traceability)
**Stories:** [US-003](../product/user-stories.md#us-003-drift-detection), [BUG-002](../product/user-stories.md#bug-002-bypass-overwrite--pave-reverts-manual-hotfix)
**Verified by:** [TC-105](../quality/test-suites.md#tc-105-drift-detection--image-mismatch), [TC-106](../quality/test-suites.md#tc-106-drift-detection--ssh-mutation)
**Confirmed by:** Sasha Petrov (DevOps/SRE), 2025-07-15

---

## Overview

The Drift Detector runs a reconciliation loop every 5 minutes. It compares what Pave thinks is deployed (expected state, from the last successful deploy) against what's actually running in the cluster (actual state, from the Kubernetes API). On mismatch, it creates a drift event, alerts the team, and pauses the next deploy for that service.

This is NOT GitOps. We do not auto-remediate. The human decides whether the drift is intentional (accept) or accidental (revert).

---

## Reconciliation Loop

```
Every 5 minutes:
    services = get_all_tracked_services(runtime='kubernetes')

    for each service in services:
        for each environment in service.environments:
            expected = get_expected_state(service, environment)
            actual = get_actual_state(service, environment)

            if expected is None:
                continue  # no deploy recorded for this service/env yet

            if actual is None:
                create_drift_event(
                    service, environment,
                    expected, actual=None,
                    diff="Service not found in cluster"
                )
                continue

            if fingerprint(expected) != fingerprint(actual):
                create_drift_event(service, environment, expected, actual)
                notify_team(service.team)
                pause_deploys(service, environment)
```

---

## State Fingerprinting

The fingerprint is a deterministic hash of the service's observable state. Two states are "equal" if and only if their fingerprints match.

**Fingerprint inputs:**

| Component | Source (expected) | Source (actual) | Notes |
|-----------|------------------|----------------|-------|
| Container image | `deploys.commit_sha` → registry lookup → digest | K8s Deployment `.spec.containers[0].image` → registry lookup → digest | Compare digests, not tags. Tags are mutable. |
| Environment variables | Stored in `pave.yaml` + Vault paths | K8s Deployment `.spec.containers[0].env` | Hashed, not stored in plain text. Only hash comparison. |
| Replica count | `pave.yaml` `deploy.replicas` | K8s Deployment `.spec.replicas` | |
| Resource limits | `pave.yaml` `deploy.resources` | K8s Deployment `.spec.containers[0].resources.limits` | |

**What is NOT fingerprinted:**
- Pod restart count (operational noise)
- Pod scheduling (node assignment is K8s's concern)
- Istio sidecar version (managed separately)
- Labels and annotations not set by Pave

**Fingerprint computation:**

```go
func Fingerprint(state ServiceState) string {
    h := sha256.New()
    h.Write([]byte(state.ImageDigest))
    h.Write([]byte(state.EnvHash))
    h.Write([]byte(fmt.Sprintf("%d", state.Replicas)))
    h.Write([]byte(state.ResourceLimits.CPU))
    h.Write([]byte(state.ResourceLimits.Memory))
    return hex.EncodeToString(h.Sum(nil))
}
```

---

## Expected State Storage

Expected state is derived from the last successful deploy for each service/environment:

```sql
SELECT
    d.commit_sha,
    s.pave_yaml_hash
FROM deploys d
JOIN services s ON s.name = d.service_name
WHERE d.service_name = $service
  AND d.environment = $environment
  AND d.status = 'deployed'
ORDER BY d.completed_at DESC
LIMIT 1;
```

The `commit_sha` is resolved to an image digest via the container registry API. The `pave_yaml_hash` is used to retrieve the `pave.yaml` from the services table, which contains replicas, resource limits, and environment variable definitions.

**After drift acceptance:** When an engineer accepts drift (`POST /drift/{id}/resolve?action=accept`), Pave updates its expected state:
1. Create a synthetic deploy record with `is_bypass: true` and the actual state's commit SHA
2. Update the expected state to match the actual state
3. Resume deploys for this service/environment

---

## Actual State Retrieval

Actual state is retrieved from the Kubernetes API:

```go
func GetActualState(ctx context.Context, service, namespace string) (*ServiceState, error) {
    deployment, err := k8sClient.AppsV1().Deployments(namespace).Get(ctx, service, metav1.GetOptions{})
    if err != nil {
        if errors.IsNotFound(err) {
            return nil, nil // service not found in cluster
        }
        return nil, err
    }

    container := deployment.Spec.Template.Spec.Containers[0]

    // Resolve image to digest (tags are mutable)
    digest, err := registry.ResolveDigest(container.Image)
    if err != nil {
        return nil, fmt.Errorf("failed to resolve image digest: %w", err)
    }

    return &ServiceState{
        ImageDigest:    digest,
        EnvHash:        hashEnvVars(container.Env),
        Replicas:       int(*deployment.Spec.Replicas),
        ResourceLimits: ResourceLimits{
            CPU:    container.Resources.Limits.Cpu().String(),
            Memory: container.Resources.Limits.Memory().String(),
        },
    }, nil
}
```

---

## Drift Event Creation

When drift is detected:

```sql
INSERT INTO drift_events (service_name, environment, expected_state, actual_state, diff_summary)
VALUES (
    'payments-api',
    'production',
    '{"image_digest": "sha256:abc...", "env_hash": "sha256:def...", "replicas": 3, ...}',
    '{"image_digest": "sha256:xyz...", "env_hash": "sha256:def...", "replicas": 3, ...}',
    'Image digest mismatch. Expected sha256:abc..., found sha256:xyz...'
);
```

**Diff summary generation:** The Drift Detector compares each fingerprint component individually and generates a human-readable summary. Examples:
- "Image digest mismatch. Expected sha256:abc..., found sha256:xyz..."
- "Replica count mismatch. Expected 3, found 5."
- "Environment variable hash mismatch. One or more env vars were changed outside Pave."
- "Multiple drifts: image digest mismatch + replica count mismatch."

---

## Deploy Pause Logic

When drift is detected for a service/environment:

1. Set a pause flag in Redis: `drift:pause:{service}:{environment} = {drift_event_id}`
2. Before any deploy starts, the Pave API checks Redis for a pause flag
3. If paused, the deploy is held in `queued` status with a `paused_reason`
4. When drift is resolved, the pause flag is removed and queued deploys proceed

**Why Redis instead of a database flag?** The pause check happens on every deploy start — it needs to be fast. Redis lookup is O(1). The drift event in PostgreSQL is the source of truth; Redis is the hot-path cache.

---

## Drift Resolution Workflow

```
Drift detected → Slack notification to team:
    "⚠️ Drift detected: payments-api/production
     Image digest mismatch — someone changed the running image outside Pave.
     Deploys paused until resolved.

     Accept (update Pave's state): pave drift resolve {id} --accept
     Revert (redeploy expected state): pave drift resolve {id} --revert"

Team investigates → chooses:

Option A: Accept
    → POST /drift/{id}/resolve?action=accept
    → Pave updates expected state to match actual
    → Creates bypass deploy record for audit trail
    → Resumes deploys

Option B: Revert
    → POST /drift/{id}/resolve?action=revert
    → Creates a new deploy with the expected commit SHA
    → Deploy Engine redeploys expected state
    → On success, drift resolved, deploys resume
```

---

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| K8s API unreachable | Skip this check cycle. After 3 consecutive failures, alert SRE: "Drift Detector cannot reach K8s API" |
| Service in the middle of a deploy | Skip drift check while deploy status is `building` or `deploying` — false positive otherwise |
| Canary in progress | Only check the baseline deployment, not the canary |
| HPA scaled replicas | Replica count drift is detected. This is a known noise source — teams using HPA should set `drift.ignore_replicas: true` in `pave.yaml` |
| Multiple drifts on the same service | Each detection creates a new drift event. Only one pause flag per service/environment. |
| Registry unreachable (can't resolve digest) | Skip image comparison for this cycle. Alert after 3 consecutive failures. |

---

## Known Gaps

1. **Docker Compose workloads:** No drift detection. The compose adapter doesn't have an equivalent of the K8s API to query actual state. Gridline's services are blind to drift.
2. **Config drift granularity:** Env var comparison is hash-based — we know *something* changed but not *what*. Improving this requires storing expected env vars in plain text, which has security implications.
3. **HPA false positives:** HPA-managed services trigger replica count drift on every scale event. The `drift.ignore_replicas` flag mitigates but is opt-in. Teams who forget will get noisy alerts.
4. **5-minute detection window:** Drift can exist for up to 5 minutes before detection. For BUG-002's scenario (cert update at 2 AM), this is fine. For a malicious actor, 5 minutes is a long window.
