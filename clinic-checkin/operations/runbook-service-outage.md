# Runbook: Service Outage

**Severity:** P0 -- Page Immediately
**Impact:** Kiosks down, check-in flow unavailable, patients cannot self-service.
**Last tested:** 2026-03-17 — Killed Check-In Service in staging, verified detection (alert within 90s), recovery (container restart < 2 min), and kiosk auto-reconnect.
**Last triggered:** Never in production.

---

## Detection

- Alert: `up{job="checkin"} == 0` for > 1 minute
- External uptime monitor: `api.clinic-checkin.example.com/health` returning non-200
- Clinic staff: "The kiosks all say system unavailable"

---

## Immediate Response (First 5 Minutes)

### 1. Identify Which Service(s) Are Down

```bash
# Check all health endpoints
curl -s -o /dev/null -w "%{http_code}" https://api.clinic-checkin.example.com/health
curl -s -o /dev/null -w "%{http_code}" https://api.clinic-checkin.example.com/notification/health
curl -s -o /dev/null -w "%{http_code}" https://api.clinic-checkin.example.com/ocr/health

# Check container status
kubectl get pods -l app=checkin-service
kubectl get pods -l app=notification-service
kubectl get pods -l app=migration-service
kubectl get pods -l app=ocr-service

# Or for ECS:
aws ecs describe-services --cluster clinic-prod \
  --services checkin-service notification-service migration-service ocr-service \
  | jq '.services[] | {serviceName, runningCount, desiredCount, status}'
```

### 2. Check Dependencies

```bash
# Database
psql $DB_PRIMARY_URL -c "SELECT 1;" 2>&1

# PgBouncer
psql -h $PGBOUNCER_HOST -p 6432 -U pgbouncer pgbouncer -c "SHOW POOLS;" 2>&1

# Redis
redis-cli -h $REDIS_HOST -p 6379 --tls PING 2>&1

# Load balancer targets
aws elbv2 describe-target-health --target-group-arn $TARGET_GROUP_ARN \
  | jq '.TargetHealthDescriptions[] | {target: .Target.Id, health: .TargetHealth.State}'
```

### 3. Check Logs for Crash Reason

```bash
kubectl logs -l app=checkin-service --tail=100 --previous
# --previous shows logs from the crashed container

# Or from log aggregation (Loki):
# {service="checkin-service"} | json | level="fatal" OR level="error" | last 10 minutes
```

---

## Response by Root Cause

### Service Crash Loop (OOM, Unhandled Exception)

```bash
# Check restart count
kubectl get pods -l app=checkin-service -o wide
# Look for RESTARTS column > 0

kubectl describe pod <pod-name>
# Look for OOMKilled, Error, CrashLoopBackOff

# For OOM: increase memory limit
kubectl set resources deployment/checkin-service --limits=memory=8Gi

# For unhandled exception: rollback to previous version
kubectl set image deployment/checkin-service \
  checkin-service=registry.example.com/checkin-service:<previous-sha>
```

### Database Down

See [Runbook: Database Failure](./runbook-database-failure.md).

```bash
# Quick: is it DB or pooler?
psql -h $DB_PRIMARY_HOST -p 5432 -U app_user -d clinic_checkin -c "SELECT 1;"
# If works but PgBouncer fails:
sudo systemctl restart pgbouncer
```

### Load Balancer Issue

```bash
aws elbv2 describe-target-health --target-group-arn $TARGET_GROUP_ARN
# If all targets "unhealthy" but services running: health check misconfiguration
# Check security group rules
# Check if rate limiting is incorrectly blocking all traffic
```

### DNS / Certificate Issue

```bash
dig api.clinic-checkin.example.com

openssl s_client -connect api.clinic-checkin.example.com:443 < /dev/null 2>/dev/null \
  | openssl x509 -noout -dates -subject
# Check "notAfter" -- is the cert expired?
```

### Network / VPC Issue

```bash
# Can services reach the database from inside the VPC?
kubectl exec -it <checkin-service-pod> -- nc -zv $DB_PRIMARY_HOST 5432

# Check security group rules
aws ec2 describe-security-groups --group-ids $APP_SG_ID \
  | jq '.SecurityGroups[0].IpPermissions'
```

---

## Impact Assessment

| Service Down | Impact |
|-------------|--------|
| Check-In Service | Kiosks unavailable. Mobile check-in fails. Dashboard stale. |
| Notification Service | Kiosk check-ins work but dashboard does not update real-time. Falls back to polling. |
| OCR Service | Insurance card photo capture fails. Manual entry still works. |
| Migration Service | No impact on live operations. Migration paused. |
| Database | Everything down. No check-ins, no dashboard, no data access. |
| Redis | Degraded performance (cache cold). All operations still work. |

For Check-In Service outage, tell clinic staff immediately:
> "The check-in kiosks are temporarily down. Please check in patients manually using paper forms. We are working to restore the system. Patient data is safe -- this is an availability issue, not a data issue."

---

## Recovery Verification

```bash
# 1. Health check returns OK
curl -s https://api.clinic-checkin.example.com/health | jq .

# 2. Core function works
curl -s -X POST https://api.clinic-checkin.example.com/v1/patients/identify \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{"method":"card_scan","card_id":"TEST-CARD-001","location_id":"<location_id>"}' \
  | jq .status

# 3. WebSocket connections re-established
curl -s https://api.clinic-checkin.example.com/metrics | grep ws_connections_active

# 4. No error spike
curl -s https://api.clinic-checkin.example.com/metrics \
  | grep 'http_requests_total{.*status="5' | tail -5

# 5. Kiosks auto-recover (they retry on connection failure)
# If not, remote-restart the browser via MDM
```

---

## Post-Incident

Required for any outage > 5 minutes during clinic hours:

1. Incident postmortem within 48 hours
2. Include: duration, root cause, blast radius (patients affected), timeline, remediation, prevention
3. Review with team
4. Update monitoring/alerting if the incident was not detected fast enough
5. Update this runbook if the response was missing steps
