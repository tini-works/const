#!/usr/bin/env bash
set -euo pipefail

# Evaluates PickRight inventory health after a round of changes
# Counts: total items, matched, unmatched, suspect, new items, broken hot paths

INV="examples/pickright/inventory.md"

echo "=== PickRight Inventory Health ==="

# Total items across all verticals
total=$(grep -c '^\- ' "$INV" || true)
echo "Total items: $total"

# Matched items (have "matched:" without UNMATCHED/SUSPECT)
matched=$(grep -c 'matched:' "$INV" | head -1 || true)
unmatched=$(grep -ci 'UNMATCHED\|unmatched' "$INV" || true)
suspect=$(grep -ci 'SUSPECT\|suspect' "$INV" || true)
broken=$(grep -ci 'BROKE\|broke' "$INV" || true)
new_items=$(grep -ci 'NEW\|new.*round' "$INV" || true)

# Net matched = total matched references minus unmatched/suspect/broken
functional=$((matched - unmatched - suspect - broken))

echo "Matched references: $matched"
echo "Unmatched items: $unmatched"
echo "Suspect items: $suspect"
echo "Broken items: $broken"
echo "New items added: $new_items"

# Count rounds completed
rounds=$(grep -c '### Round' "$INV" || true)
echo "Rounds completed: $rounds"

# Health score: percentage of items that are functional (not unmatched/suspect/broken)
if [ "$total" -gt 0 ]; then
  health=$(( (total - unmatched - suspect - broken) * 100 / total ))
else
  health=0
fi

echo ""
echo "=== RESULTS ==="
echo "METRIC total_items=$total"
echo "METRIC matched=$matched"
echo "METRIC unmatched=$unmatched"
echo "METRIC suspect=$suspect"
echo "METRIC broken=$broken"
echo "METRIC health_pct=$health"
echo "METRIC rounds=$rounds"
