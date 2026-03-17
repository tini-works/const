# Runbook: Check-In Sync Failure

**Severity:** P1 -- Notify During Business Hours
**Impact:** Patients complete check-in on kiosk but receptionist dashboard doesn't update. Patients get a yellow warning instead of green checkmark. Receptionist may ask patients to fill out paper forms.

### Traceability

| Link | Reference |
|------|-----------|
| **Triggered by:** | Alert: [Sync Failure Rate High](./monitoring-alerting.md#p1----notify-during-business-hours), Alert: [WebSocket Connections drop](./monitoring-alerting.md#p1----notify-during-business-hours) |
| **Caused by:** | [BUG-001: Kiosk confirmation not syncing](../quality/bug-reports.md#bug-001-kiosk-confirmation-shows-green-checkmark-but-receptionist-sees-nothing) — the original incident that created this runbook |
| **Fixed by:** | [ADR-001: WebSocket with Polling Fallback](../architecture/adrs.md#adr-001-websocket-with-polling-fallback-for-real-time-dashboard-updates) — ack mechanism + polling fallback |
| **Watches:** | [Notification Service](../architecture/architecture.md#notification-service), [WebSocket /ws/dashboard](../architecture/api-spec.md#websocket-wsdashboardlocation_id), [POST /checkins/{id}/complete](../architecture/api-spec.md#post-checkinsidcomplete) |
| **Proves:** | [US-002: Receptionist sees confirmed data](../product/user-stories.md#us-002-receptionist-sees-confirmed-check-in-data) — data within 5 seconds |
| **Detects:** | [TC-202: Sync timeout](../quality/test-suites.md#tc-202-sync-timeout--yellow-warning-on-kiosk), [TC-203: Sync failure/retry](../quality/test-suites.md#tc-203-sync-failure--dashboard-retry) failing in production |

---

## Detection

How you'll know:
- Alert: `checkin_sync_timeout_total` rate > 10% of check-ins over 10 minutes
- Alert: `ws_connections_active` drops to 0 for a location
- Receptionist report: "I'm not seeing check-ins come through"
- Patient report: "The kiosk showed a yellow warning instead of green"

---

## Diagnosis

### Step 1: Determine Which Layer Is Broken

The sync chain has 5 links. Find the broken one.

```
Kiosk → Check-In Service → Redis Pub/Sub → Notification Service → WebSocket → Dashboard
```

```bash
# 1. Is the Check-In Service saving check-ins to the database?
psql $DB_REPLICA_URL -c "
  SELECT id, status, sync_status, completed_at, synced_at
  FROM check_ins
  WHERE completed_at > NOW() - INTERVAL '30 minutes'
  ORDER BY completed_at DESC
  LIMIT 10;
"
# If rows show status=completed but sync_status=pending/failed → problem is downstream

# 2. Is Redis Pub/Sub working?
redis-cli -h $REDIS_HOST -p 6379 --tls PING
# Should return PONG

redis-cli -h $REDIS_HOST -p 6379 --tls PUBSUB CHANNELS 'checkin:*'
# Should show channels for each active location

# 3. Is the Notification Service running?
curl -s https://api.clinic-checkin.example.com/notification/health | jq .

# 4. Are WebSocket connections active?
curl -s https://api.clinic-checkin.example.com/metrics | grep ws_connections_active
# Should show > 0 for locations with open dashboards

# 5. Is the Dashboard connected?
# Check browser dev tools on a receptionist workstation:
# Network tab → WS → verify connection to /ws/dashboard/{location_id}
```

### Step 2: Fix Based on Root Cause

#### Root Cause: Notification Service Down

```bash
# Check service health
curl -s https://api.clinic-checkin.example.com/notification/health

# Check logs
# In Loki/Grafana:
{service="notification-service"} | json | level="error" | last 15 minutes

# Restart the service
kubectl rollout restart deployment/notification-service
# Or for ECS:
aws ecs update-service --cluster clinic-prod --service notification-service --force-new-deployment

# Wait for restart (30-60 seconds)
# Dashboards will auto-reconnect via WebSocket with exponential backoff

# Verify recovery
curl -s https://api.clinic-checkin.example.com/metrics | grep ws_connections_active
```

#### Root Cause: Redis Down or Unreachable

```bash
# Check Redis connectivity
redis-cli -h $REDIS_HOST -p 6379 --tls INFO server
redis-cli -h $REDIS_HOST -p 6379 --tls INFO memory

# If Redis is down, restart it
# (depends on hosting: ElastiCache reboot, container restart, etc.)

# Check if Redis ran out of memory
redis-cli -h $REDIS_HOST -p 6379 --tls INFO memory | grep used_memory_human
redis-cli -h $REDIS_HOST -p 6379 --tls INFO memory | grep maxmemory_human

# If memory is full, flush caches (pub/sub is stateless, no data loss)
redis-cli -h $REDIS_HOST -p 6379 --tls FLUSHDB
# WARNING: This clears all cached data. Caches will rebuild from DB on next access.
```

#### Root Cause: WebSocket Connection Dropped (Dashboard Side)

```bash
# Verify the dashboard is configured with correct WebSocket URL
# Check browser console on receptionist workstation for WebSocket errors

# Common issues:
# - Load balancer not configured for WebSocket upgrade on /ws/*
# - Firewall blocking WebSocket connections
# - Proxy (corporate/clinic network) stripping Upgrade header

# Test WebSocket connectivity from the clinic network:
# (Use wscat or similar from a machine on the clinic network)
npx wscat -c wss://api.clinic-checkin.example.com/ws/dashboard/<location_id>
# Should connect and receive heartbeat pings every 30s
```

#### Root Cause: Load Balancer Not Forwarding WebSocket

```bash
# Check ALB/nginx configuration
# Verify WebSocket upgrade is enabled for /ws/* paths

# nginx example check:
# location /ws/ {
#     proxy_pass http://notification-service:3001;
#     proxy_http_version 1.1;
#     proxy_set_header Upgrade $http_upgrade;
#     proxy_set_header Connection "upgrade";
#     proxy_read_timeout 86400;
# }

# ALB: verify target group has stickiness enabled for WebSocket
# and idle timeout is set to at least 3600 seconds (1 hour)
```

---

## Mitigation While Investigating

Even if the root cause isn't found immediately, dashboards have a fallback:

1. The receptionist dashboard automatically falls back to polling `GET /dashboard/queue` every 5 seconds when the WebSocket connection drops
2. Verify polling is working by checking access logs for `/dashboard/queue` requests
3. If polling is also failing, the database is likely the issue (see [Runbook: Database Failure](./runbook-database-failure.md))

Tell receptionist staff:
> **"Real-time updates are delayed. Your dashboard will refresh automatically every 5 seconds. You'll see check-ins appear, just not instantly."**

---

## Recovery Verification

After fixing the issue:

```bash
# 1. Verify Notification Service is healthy
curl -s https://api.clinic-checkin.example.com/notification/health | jq .

# 2. Verify WebSocket connections are re-established
curl -s https://api.clinic-checkin.example.com/metrics | grep ws_connections_active
# Should show connections for each location with an open dashboard

# 3. Do a test check-in (staging or test patient in production)
# Trigger a check-in and verify:
# - Kiosk shows green checkmark (sync confirmed)
# - Dashboard updates within 2 seconds

# 4. Check that any check-ins completed during the outage are visible
psql $DB_REPLICA_URL -c "
  SELECT id, status, sync_status, completed_at
  FROM check_ins
  WHERE completed_at > NOW() - INTERVAL '1 hour'
    AND sync_status != 'confirmed'
  ORDER BY completed_at;
"
# These records are in the DB and will show on dashboard via polling.
# The sync_status will remain 'timeout' or 'failed' (historical -- not retroactively fixed).
```

---

## Post-Incident

If the outage lasted > 15 minutes during business hours:
- Check how many check-ins had sync_status = 'timeout' or 'failed' during the window
- Notify clinic managers that real-time updates were delayed
- No patient data was lost (all check-ins are saved to DB regardless of sync status)
- Document the incident and root cause

---

## Prevention

- Monitor `ws_connections_active` per location -- if it drops to 0 during business hours, something is wrong
- Monitor Redis memory and connection count
- Ensure Notification Service is included in deployment smoke tests
- Consider running 2 instances of Notification Service for HA (requires sticky WebSocket connections via load balancer)
