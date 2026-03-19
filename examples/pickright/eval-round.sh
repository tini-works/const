#!/usr/bin/env bash
set -euo pipefail

# Evaluates PickRight inventory health after a round of changes
# Only counts items in the inventory sections (before Round Log)

INV="examples/pickright/inventory.md"

echo "=== PickRight Inventory Health ==="

# Extract only the inventory sections (everything before "## Round Log")
inv_section=$(sed '/^## Round Log/,$d' "$INV")

# Total items across all verticals (lines starting with "- ")
total=$(echo "$inv_section" | grep -c '^\- ' || true)
echo "Total items: $total"

# Count items by state (only in inventory sections)
matched=$(echo "$inv_section" | grep -c 'matched:' || true)
unmatched=$(echo "$inv_section" | grep -ci 'UNMATCHED' || true)
suspect=$(echo "$inv_section" | grep -ci 'SUSPECT' || true)
broken=$(echo "$inv_section" | grep -ci 'BROKE' || true)

echo "Matched references: $matched"
echo "Unmatched items: $unmatched"
echo "Suspect items: $suspect"
echo "Broken items: $broken"

# Count rounds completed (in the full file)
rounds=$(grep -c '### Round' "$INV" || true)
echo "Rounds completed: $rounds"

# Health score: percentage of items that are NOT unmatched/suspect/broken
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
