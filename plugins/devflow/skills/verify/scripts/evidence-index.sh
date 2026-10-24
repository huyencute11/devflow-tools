#!/usr/bin/env bash
# List evidence files grouped by acceptance criterion as a markdown table.
# Usage: evidence-index.sh <evidence-dir>
set -euo pipefail
dir="${1:-docs/devflow/evidence}"
if [ ! -d "$dir" ]; then
  echo "No evidence directory at $dir" >&2
  exit 1
fi
echo "| AC | Evidence file |"
echo "|----|---------------|"
find "$dir" -maxdepth 1 -type f \( -name '*.png' -o -name '*.txt' -o -name '*.json' \) | sort | while read -r f; do
  name="$(basename "$f")"
  ac="$(echo "$name" | grep -oE '^AC-[0-9]+' || echo '-')"
  echo "| $ac | $name |"
done
