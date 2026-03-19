#!/usr/bin/env bash
set -euo pipefail

# Autoresearch benchmark for CONST vertical self-evidence
# Measures: can a reader derive inventory contents from vertical descriptions alone?

CONST="CONST.md"
COMPANION="companion/skills/const-companion/SKILL.md"
score=0
max_score=10

echo "=== CONST Vertical Self-Evidence Benchmark ==="
echo ""

# --- Criterion 1: No explicit example lists in vertical descriptions (0-2 points) ---
# Parenthetical (e.g. ...) in the Verticals section is prescriptive
verticals_section=$(sed -n '/^## Verticals/,/^## /p' "$CONST" | head -n -1)
eg_count=$(echo "$verticals_section" | grep -c "(e\.g\." || true)
if [ "$eg_count" -eq 0 ]; then
  c1=2; echo "PASS [2/2] No prescriptive examples in vertical descriptions"
elif [ "$eg_count" -le 2 ]; then
  c1=1; echo "PARTIAL [1/2] $eg_count prescriptive example(s) remain in verticals"
else
  c1=0; echo "FAIL [0/2] $eg_count prescriptive examples in verticals"
fi
score=$((score + c1))

# --- Criterion 2: Each vertical has accountability signal (0-2 points) ---
# "faces X" + "every/each" pattern = accountability is clear
# Check all 5 verticals have facing direction + commitment language
facing_count=$(echo "$verticals_section" | grep -c "faces" || true)
commitment_count=$(echo "$verticals_section" | grep -ci "every\|each\|all\|must\|proven\|proves\|maintains" || true)
if [ "$facing_count" -ge 5 ] && [ "$commitment_count" -ge 5 ]; then
  c2=2; echo "PASS [2/2] All verticals have facing + accountability language ($facing_count faces, $commitment_count commitments)"
elif [ "$facing_count" -ge 3 ]; then
  c2=1; echo "PARTIAL [1/2] $facing_count/5 verticals have clear facing direction"
else
  c2=0; echo "FAIL [0/2] Only $facing_count/5 verticals have facing direction"
fi
score=$((score + c2))

# --- Criterion 3: Origin/inventory distinction is concrete (0-2 points) ---
# Needs: clear definition + at least 2 examples + negative examples
origin_section=$(sed -n '/### 2\. Start from the Source/,/### 3\./p' "$CONST")
positive_examples=$(echo "$origin_section" | grep -c "Origin:.*→.*Inventory:\|→ Inventory:" || true)
negative_examples=$(echo "$origin_section" | grep -c "Not inventory:" || true)
if [ "$positive_examples" -ge 2 ] && [ "$negative_examples" -ge 1 ]; then
  c3=2; echo "PASS [2/2] Origin/inventory has $positive_examples positive + $negative_examples negative examples"
elif [ "$positive_examples" -ge 1 ]; then
  c3=1; echo "PARTIAL [1/2] $positive_examples positive example(s), $negative_examples negative"
else
  c3=0; echo "FAIL [0/2] Origin/inventory distinction lacks concrete examples"
fi
score=$((score + c3))

# --- Criterion 4: Vertical descriptions imply workflow (0-2 points) ---
# Each vertical should reference what it PRODUCES or MAINTAINS, not just what it checks
produce_signals=0
for word in "traces" "screen" "transition" "flow" "code" "implements" "verification" "deployment" "reproducible" "observability"; do
  if echo "$verticals_section" | grep -qi "$word"; then
    produce_signals=$((produce_signals + 1))
  fi
done
if [ "$produce_signals" -ge 8 ]; then
  c4=2; echo "PASS [2/2] Verticals contain $produce_signals/10 workflow-implying signals"
elif [ "$produce_signals" -ge 5 ]; then
  c4=1; echo "PARTIAL [1/2] Verticals contain $produce_signals/10 workflow-implying signals"
else
  c4=0; echo "FAIL [0/2] Only $produce_signals/10 workflow signals found"
fi
score=$((score + c4))

# --- Criterion 5: Companion mirrors CONST without drift (0-2 points) ---
# Check key concepts present in both
drift=0
# Bootstrap as mechanic
if ! grep -q "Bootstrap.*mechanic\|mechanic.*Bootstrap\|Four Mechanics" "$COMPANION" 2>/dev/null; then
  drift=$((drift + 1)); echo "  DRIFT: Companion doesn't treat Bootstrap as a mechanic"
fi
# Broke state
if ! grep -q "broke" "$COMPANION" 2>/dev/null; then
  drift=$((drift + 1)); echo "  DRIFT: Companion missing 'broke' lifecycle state"
fi
# Web not chain
if ! grep -q "web\|chain" "$COMPANION" 2>/dev/null; then
  drift=$((drift + 1)); echo "  DRIFT: Companion missing 'web not chain' principle"
fi
# Binary boxes
if ! grep -q "binary\|Binary" "$COMPANION" 2>/dev/null; then
  drift=$((drift + 1)); echo "  DRIFT: Companion missing 'boxes are binary'"
fi
# Missing verticals guidance
if ! grep -qi "missing\|doesn't exist\|no owner\|not staffed\|one person.*multiple" "$COMPANION" 2>/dev/null; then
  drift=$((drift + 1)); echo "  DRIFT: Companion has no guidance for missing/merged verticals"
fi
if [ "$drift" -eq 0 ]; then
  c5=2; echo "PASS [2/2] Companion aligned with CONST, no drift"
elif [ "$drift" -le 2 ]; then
  c5=1; echo "PARTIAL [1/2] $drift drift point(s) between companion and CONST"
else
  c5=0; echo "FAIL [0/2] $drift drift points between companion and CONST"
fi
score=$((score + c5))

echo ""
echo "=== RESULTS ==="
echo "METRIC self_evidence_score=$score/$max_score"
echo "METRIC prescriptiveness=$eg_count"
echo "METRIC drift_count=$drift"
echo "METRIC workflow_signals=$produce_signals"
