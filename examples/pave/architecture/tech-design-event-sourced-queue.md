# Tech Design: Event-Sourced Deploy Queue

**ADR:** [ADR-008](adrs.md#adr-008-deploy-queue-resilience--wal-based-recovery)
**Epic:** [E5: Platform Resilience](../product/epics.md#e5-platform-resilience)
**Stories:** [US-011](../product/user-stories.md#us-011-deploy-queue-resilience), [BUG-003](../product/user-stories.md#bug-003-deploy-queue-corruption-during-rbac-migration)
**Verified by:** [TC-502](../quality/test-suites.md#tc-502-queue-recovery--replay-from-events), [TC-503](../quality/test-suites.md#tc-503-queue-state--derived-not-stored), [TC-504](../quality/test-suites.md#tc-504-queue-recovery--no-lost-deploys-after-crash)
**Confirmed by:** Kai Tanaka (Senior Platform Engineer), 2025-09-15

---

## Overview

The deploy queue was originally a mutable `deploy_queue` table. The RBAC migration (Round 6) locked this table for 4 hours, blocking all deploys. The fix: replace the mutable table with an append-only `deploy_events` table. Queue state is derived from events, never stored as mutable state.

---

## Event Types

Each deploy lifecycle transition emits an event:

| Event Type | Payload | Emitted By |
|-----------|---------|-----------|
| `deploy.queued` | `{ position: 1, service: "checkout-api", env: "production" }` | Pave API |
| `deploy.started` | `{}` | Deploy Engine |
| `deploy.building` | `{ image_tag: "abc123f" }` | Deploy Engine |
| `deploy.deploying` | `{ runtime: "kubernetes" }` | Deploy Engine |
| `deploy.completed` | `{ duration_seconds: 125 }` | Deploy Engine |
| `deploy.failed` | `{ error: "Health check timeout", phase: "deploy" }` | Deploy Engine |
| `deploy.cancelled` | `{ reason: "User cancelled", cancelled_by: "uuid" }` | Pave API |
| `deploy.rolled_back` | `{ rollback_of: "uuid", reason: "Auto-rollback from canary" }` | Canary Controller / Pave API |
| `deploy.paused` | `{ reason: "Drift detected" }` | Drift Detector |
| `deploy.resumed` | `{ drift_resolved: "uuid" }` | Drift Detector |

---

## State Derivation

The current queue state is derived by replaying events:

```go
func DeriveQueueState(events []DeployEvent) []QueueEntry {
    deployStates := make(map[uuid.UUID]*DeployState)

    for _, event := range events {
        state, exists := deployStates[event.DeployID]
        if !exists {
            state = &DeployState{DeployID: event.DeployID}
            deployStates[event.DeployID] = state
        }

        switch event.EventType {
        case "deploy.queued":
            state.Status = "queued"
            state.QueuedAt = event.CreatedAt
            state.ServiceName = event.Payload.Service
            state.Environment = event.Payload.Env
        case "deploy.started":
            state.Status = "building"
        case "deploy.building":
            state.Status = "building"
        case "deploy.deploying":
            state.Status = "deploying"
        case "deploy.completed":
            state.Status = "deployed"
            state.CompletedAt = &event.CreatedAt
        case "deploy.failed":
            state.Status = "failed"
            state.CompletedAt = &event.CreatedAt
        case "deploy.cancelled":
            state.Status = "cancelled"
            state.CompletedAt = &event.CreatedAt
        case "deploy.rolled_back":
            state.Status = "rolled_back"
            state.CompletedAt = &event.CreatedAt
        case "deploy.paused":
            state.Paused = true
        case "deploy.resumed":
            state.Paused = false
        }
    }

    // Filter to active (not terminal) deploys, ordered by queue time
    var queue []QueueEntry
    for _, state := range deployStates {
        if !isTerminal(state.Status) {
            queue = append(queue, toQueueEntry(state))
        }
    }
    sort.Slice(queue, func(i, j int) bool {
        return queue[i].QueuedAt.Before(queue[j].QueuedAt)
    })
    return queue
}

func isTerminal(status string) bool {
    return status == "deployed" || status == "failed" ||
           status == "cancelled" || status == "rolled_back"
}
```

---

## Redis Cache Layer

Replaying all events on every queue read is expensive. Redis provides a materialized view of the current queue state:

```
Redis key: pave:queue:state
Redis type: sorted set
    member: deploy_id (UUID)
    score: queued_at (Unix timestamp)

Redis key: pave:queue:deploy:{deploy_id}
Redis type: hash
    service_name, environment, status, deployer, queued_at
```

**Cache invalidation:** Every event write triggers a Redis update:

```go
func EmitEvent(ctx context.Context, event DeployEvent) error {
    // 1. Write to PostgreSQL (source of truth)
    if err := db.InsertDeployEvent(ctx, event); err != nil {
        return err
    }

    // 2. Update Redis cache (hot path optimization)
    if err := updateRedisQueueState(ctx, event); err != nil {
        // Log but don't fail — Redis is a cache, not source of truth
        log.Warnf("Redis cache update failed: %v", err)
    }

    // 3. Update the deploys table status (denormalized for query convenience)
    if err := db.UpdateDeployStatus(ctx, event.DeployID, deriveStatus(event)); err != nil {
        return err
    }

    return nil
}
```

**Why keep the `deploys` table if events are the source of truth?** Convenience. Most queries need the current status of a deploy, not its event history. The `deploys` table is a denormalized projection maintained by the event emitter. If it ever gets out of sync, it can be rebuilt from events.

---

## Recovery Procedure

When Pave starts (or Redis is lost):

```
1. Check Redis: is queue state present?

   If yes → use Redis cache (fast path)

   If no → rebuild from events:
       a. Query: SELECT * FROM deploy_events
                 WHERE deploy_id IN (
                     SELECT id FROM deploys
                     WHERE status NOT IN ('deployed', 'failed', 'cancelled', 'rolled_back')
                 )
                 ORDER BY created_at ASC
       b. Replay events through DeriveQueueState()
       c. Write result to Redis
       d. Log: "Queue state rebuilt from N events, M active deploys found"

2. Compare Redis state with PostgreSQL:
   - For each active deploy in Redis, verify the deploys table agrees
   - On mismatch, trust events (replay from events)
   - Log mismatches as warnings

3. Resume processing queue
```

**Recovery time estimate:** For 500 active events (typical worst case — 100 deploys × 5 events each), rebuild takes < 1 second. For 10,000 events (extreme — weeks of events for in-progress deploys), rebuild takes ~5 seconds.

---

## Migration from Mutable Table

The original `deploy_queue` table migration (Round 6):

```sql
-- Step 1: Create deploy_events table
CREATE TABLE deploy_events (...);

-- Step 2: Backfill events from existing deploys
-- For each deploy in deploys table, create synthetic events
INSERT INTO deploy_events (deploy_id, event_type, payload, created_at)
SELECT
    id,
    CASE status
        WHEN 'queued' THEN 'deploy.queued'
        WHEN 'building' THEN 'deploy.building'
        WHEN 'deploying' THEN 'deploy.deploying'
        WHEN 'deployed' THEN 'deploy.completed'
        WHEN 'failed' THEN 'deploy.failed'
    END,
    '{}',
    COALESCE(completed_at, started_at, queued_at)
FROM deploys
WHERE status IS NOT NULL;

-- Step 3: Switch Pave API to use event-sourced queue
-- (feature flag: use_event_sourced_queue=true)

-- Step 4: Drop old deploy_queue table
-- (after 2 weeks of event-sourced queue running without issues)
DROP TABLE deploy_queue;
```

**Migration was non-blocking.** Unlike the RBAC migration that caused BUG-003, this migration only creates a new table and inserts data — no locks on existing tables. The old `deploy_queue` table was kept as a read-only fallback for 2 weeks before being dropped.

---

## Consistency Model

| Component | Consistency guarantee |
|-----------|---------------------|
| `deploy_events` table | Strong consistency (PostgreSQL transactions) |
| `deploys` table (status) | Eventually consistent with events (updated in same transaction as event insert) |
| Redis queue cache | Eventually consistent (updated after event insert, may lag by milliseconds) |
| Queue API responses | Read from Redis (fast, eventually consistent). If Redis is stale, next event write corrects it. |

**What happens if Redis and PostgreSQL disagree?**
The event emitter writes to PostgreSQL first, then Redis. If Redis update fails, the next event write will correct it. If Redis has stale data, the queue API may briefly show an outdated status — this is acceptable because:
1. CLI polls status every 2 seconds during deploy, so staleness is visible for at most one poll
2. The dashboard auto-refreshes every 5 seconds

---

## Queue Ordering

Deploys are processed in FIFO order per service per environment. Deploys for different services/environments can execute in parallel.

```
Queue state example:
  Position 1: checkout-api/production  (status: building)    ← executing
  Position 2: cart-api/staging         (status: building)    ← executing (different service/env)
  Position 3: checkout-api/production  (status: queued)      ← blocked (same service/env as #1)
  Position 4: payments-api/production  (status: queued)      ← ready to start
```

The queue processor picks the next non-blocked deploy from the queue every 5 seconds.

---

## Known Gaps

1. **Mid-write crash recovery:** TC-504 tests recovery after a clean shutdown. It does NOT test the scenario where Pave crashes between writing a `deploy_events` row and updating the `deploys` table. In theory, PostgreSQL transaction semantics protect against this (both writes are in the same transaction), but the Redis update is outside the transaction. If Pave crashes after PostgreSQL commit but before Redis update, Redis will be stale until the next event or restart triggers a rebuild. This scenario has not been tested.

2. **Event table growth:** Events are never deleted. For 500 deploys/month × 5 events each = 30,000 events/year. This is small enough that partitioning is not needed for years. If it becomes a problem, archive events for completed deploys older than 90 days to S3.

3. **Concurrent event writes:** Two Pave API instances processing different deploys can both write events concurrently. PostgreSQL handles this correctly (each INSERT is independent), but the Redis updates may arrive out of order. The Redis update function is idempotent — it applies the event's effect regardless of order — but there's a theoretical window where the Redis state is inconsistent. This window is sub-millisecond and self-correcting.
