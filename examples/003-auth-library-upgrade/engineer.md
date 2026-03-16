# Engineer Inventory — Auth Library Migration (JWT v1 → v2)

## Auth Library Lifecycle

| Version | Mode | What it does |
|---------|------|-------------|
| v2.0 (migration) | Dual-mode | Validates v2 first, falls back to v1. Issues v1 or v2 per service config. |
| v2.1 (post-grace) | v2-only | v1 validation code removed. v1 fallback path deleted. |

## Validation Flow (v2.0 — during migration)

```
Token in → try v2 validation
  ├── valid → accept
  └── fail → try v1 validation
        ├── valid → accept (log as v1-fallback)
        └── fail → reject 401
```

## Issuance Flow (v2.0 — during migration)

```
Service requests token → check service config flag
  ├── auth.token_version = v2 → issue v2 token
  └── auth.token_version = v1 → issue v1 token (default)
```

Opt-in is per-service. Each team flips their own flag when ready.

## System State

| Component | During migration | After day 30 |
|-----------|-----------------|-------------|
| Auth library | v2.0 dual-mode | v2.1 v2-only |
| Service config flag | `auth.token_version = v1 | v2` | Removed (always v2) |
| v1 signing key | Retained | Decommissioned from all envs |
| v1 validation code | Active (fallback path) | Deleted |

## Service Re-verification

| Service | Day | Outcome |
|---------|-----|---------|
| Service A | 3 | Opted into v2 issuance |
| Service B | 5 | Stayed on v1, verified grace period works |
| Service C | 20 | Opted into v2 (late) |
| Service D | 22 | Blocked by pre-existing broken tests — fixed, then verified |
