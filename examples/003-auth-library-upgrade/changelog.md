# 003 — Platform Team: Shared Auth Library Upgrade

**Trigger:** Security team mandates migration from JWT v1 to v2 (new signing algorithm, token format change). Deadline: 30 days.

**Why this matters:** Auth is infrastructure. Every service depends on it. Temptation: "just update the library, run tests, ship it." But shortcuts corrupt downstream proofs.

> Customer story (from downstream service teams): "I don't want my service to break. I don't want to rewrite auth code. I don't want a flag day."

---

### Step 1: PM discovers boxes — downstream teams are the customer

**Boxes created:**
- `B1` Migration must be backward-compatible during a transition window
- `B2` No service requires code changes beyond a version bump
- `B3` Rollback is possible at the individual service level

#### Inventory

```
PM
  Requirements
    + [REQ-301] Backward-compatible migration            → source: security mandate + team safety
    + [REQ-302] No code changes for consumers            → source: downstream team expectation
    + [REQ-303] Per-service rollback                     → source: risk mitigation
  Boxes sent
    + B1 → Engineer
    + B2 → Engineer
    + B3 → Engineer

Design        (N/A — no UI change in this scenario)
Engineer      (empty)
QA            (empty)
DevOps        (empty)
```

---

### Step 2: Engineer receives and discovers implementation boxes

Engineer analyzes the v1→v2 change. Backward compatibility isn't free — it requires dual-mode validation.

**New boxes surfaced:**
- `B4` Token validation must accept both v1 and v2 during transition
- `B5` Token issuance switches to v2 on a per-service opt-in basis
- `B6` A service running old library version must still work (v1 tokens remain valid for 30 days)

#### Inventory

```
PM
  Requirements
    [REQ-301..303]
    + [REQ-304] Dual-mode validation window              → source: Engineer
    + [REQ-305] Per-service opt-in for v2 issuance       → source: Engineer
    + [REQ-306] 30-day v1 token validity grace period    → source: Engineer
  Boxes
    B1-B3 → Engineer
    + B4, B5, B6 (from Engineer, accepted)

Design        (N/A)

Engineer
  Flows
    + [FLW-30] Token validation: try v2 → fallback v1 → reject
    + [FLW-31] Token issuance: check service config → issue v2 if opted-in, else v1
    + [FLW-32] Grace period: v1 tokens valid until 30 days post-migration-start
  System design
    + Auth library v2.0: dual-mode validator
    + Service config flag: `auth.token_version = v1 | v2`
    + v1 signing key retention for grace period
  Boxes matched
    + B1 ← FLW-30, FLW-32 (dual-mode + grace period)
    + B2 ← library API unchanged, config flag only
    + B3 ← FLW-31 (per-service config, revert flag to v1)
    + B4 ← FLW-30
    + B5 ← FLW-31
    + B6 ← FLW-32

QA            (empty)
DevOps        (empty)
```

---

### Step 3: Transition mechanic fires — all dependent services flagged SUSPECT

The auth library is in Engineer's inventory. When it changes, every service depending on it gets flagged.

This is automatic. No spreadsheet. No Slack message. Inventory dependency tracking.

#### Inventory

```
PM             (unchanged)
Design         (N/A)
Engineer       (unchanged — library published)

QA
  Proof registry — service verification status
    + Service A — SUSPECT (depends on auth library)
    + Service B — SUSPECT (depends on auth library)
    + Service C — SUSPECT (depends on auth library)
    + Service D — SUSPECT (depends on auth library)
  Note: all services marked suspect automatically by transition mechanic

DevOps        (empty)
```

---

### Step 4: Services begin re-verification — mixed results

Each service team runs auth integration tests against the new library. Results trickle in.

#### Inventory

```
PM             (unchanged)
Design         (N/A)
Engineer       (unchanged)

QA
  Proof registry — service verification status
    ~ Service A — PROVEN ✓ (v2 tokens, backward compat confirmed)
    ~ Service B — PROVEN ✓ (v1 tokens, grace period confirmed)
    Service C — SUSPECT (no re-verification yet, 18 days remaining)
    ~ Service D — SUSPECT → BLOCKED (test suite broken, unrelated cause)

  Discovery
    + Service D's tests were already broken BEFORE the migration.
      The migration didn't break them — it exposed pre-existing rot.
      This is sanity reconciliation catching a correctness gap.

DevOps        (empty)
```

---

### Step 5: DevOps adds operational boxes and deployment strategy

#### Inventory

```
PM             (unchanged)
Design         (N/A)
Engineer       (unchanged)
QA             (unchanged — still tracking Service C and D)

DevOps
  Deployment strategy
    + [DEP-30] Canary: v2 token issuance at 5% traffic, monitor error rates
    + [DEP-31] Circuit breaker: if v2 validation fails, fall back to v1
    + [DEP-32] Rollback: per-service config flag revert, no redeployment needed
  Observability
    + [OBS-30] Dashboard: v1 vs v2 token ratio across all services (live)
    + [OBS-31] Alert: v2 validation failure rate >0.1%
    + [OBS-32] Alert: v1 token usage after grace period expiry (should be zero)
  Environment parity
    + Staging: both v1 and v2 signing keys available
    + Load test: mixed v1/v2 token traffic at production scale
  Boxes matched
    + B1 operational ← DEP-31 (circuit breaker ensures compat)
    + B3 operational ← DEP-32 (per-service rollback without deploy)
    + B6 production ← OBS-32 (alert if grace period violated)
```

---

### Step 6: Service C verifies, Service D's pre-existing issue resolved

Day 20. Service C finally runs re-verification. Service D fixes their unrelated test breakage and re-verifies.

#### Inventory

```
PM             (unchanged)
Design         (N/A)
Engineer       (unchanged)

QA
  Proof registry — service verification status
    Service A — PROVEN ✓ (v2 tokens)
    Service B — PROVEN ✓ (v1 tokens, grace period)
    ~ Service C — PROVEN ✓ (v2 tokens, opted-in day 20)
    ~ Service D — PROVEN ✓ (v1 tokens, pre-existing test issue fixed)

  All services PROVEN. Migration proof is complete.

  Bonus finding
    + Service D's broken tests were a correctness gap that predated the migration.
      Filed as independent issue [REQ-307] for Service D team's backlog.

DevOps
  Observability update
    + [OBS-30] v2 token ratio: 62% (Services A, C on v2; B, D on v1)
    + Grace period: 10 days remaining for v1 holdouts
```

---

### Step 7: Grace period expires — v1 decommissioned

Day 30. Grace period ends.

#### Inventory

```
PM
  Requirements
    [REQ-301..306] — all PROVEN
    + [REQ-307] Service D test suite repair              → discovered during migration
  Status: migration complete

Design         (N/A)

Engineer
  Flows
    ~ [FLW-30] Token validation: v2 only (v1 fallback removed)
    ~ [FLW-31] Token issuance: v2 only (config flag deprecated)
    [FLW-32] archived — grace period expired
  System design
    ~ Auth library v2.1: single-mode validator (v1 code removed)
    ~ v1 signing key decommissioned

QA
  Proof registry
    All services PROVEN on v2
    ~ Verification paths updated: v1-specific paths archived
    + [VP-30] Regression: no service accepts v1 tokens post-grace

DevOps
  Observability
    ~ [OBS-30] v2 token ratio: 100%
    ~ [OBS-32] v1 token alert: active, should never fire
    + v1 signing key removed from all environments
```

---

### Final inventory snapshot

```
PM (6 requirements, 6 boxes, 1 bonus finding)
  REQ-301..307, B1..B6 — all PROVEN

Engineer (3 flows active, 1 archived, clean v2-only library)
  FLW-30..31 updated, FLW-32 archived

QA (all services PROVEN, v1 paths archived, regression path added)
  VP-30 guards against v1 resurrection

DevOps (canary complete, circuit breaker removed, v1 keys decommissioned)
  OBS-30..32 in steady state
```

**What this showed:**
- Unidirectional quality prevented "just bump the version"
- Transition mechanics gave automatic visibility without manual tracking
- Sanity reconciliation caught Service D's pre-existing rot
- Freedom: Service A adopted v2 day 1, Service B stayed on v1 until day 28. Both valid — boxes matched either way.
