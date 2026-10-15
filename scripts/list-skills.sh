#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== SDLC Skills Catalog ==="
printf "%-26s | %-15s | %s\n" "Skill Name" "Category" "Description"
echo "-----------------------------------------------------------------------------------------------------"

find "$REPO/skills" -type f -name "SKILL.md" | sort | while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"
  category="$(basename "$(dirname "$skill_dir")")"

  # Extract description using python or sed
  desc=$(python3 -c '
import sys, re
with open(sys.argv[1], "r", encoding="utf-8") as f:
    content = f.read()
# match YAML frontmatter
match = re.search(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
if match:
    fm = match.group(1)
    desc_match = re.search(r"description:\s*(?:>-\s*|\s*)(.*?)(?:\n[a-z_-]+:|\Z)", fm, re.DOTALL)
    if desc_match:
        lines = [line.strip() for line in desc_match.group(1).split("\n") if line.strip()]
        first_line = lines[0] if lines else ""
        print(first_line[:65])
        sys.exit(0)
print("(No description)")
' "$skill_md" 2>/dev/null || echo "(No description)")

  printf "%-26s | %-15s | %s\n" "$skill_name" "$category" "$desc"
done
