#!/usr/bin/env bash
set -euo pipefail

# Links all skills in the repository into the local skill directories used by
# each agent harness:
#   - ~/.claude/skills: Claude Code
#   - ~/.agents/skills: Codex, Antigravity, and other Agent Skills-compatible harnesses
# Each entry is a symlink into this repo, so a `git pull` is all that's needed
# to keep installed skills up to date.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

for dest in "${DESTS[@]}"; do
  mkdir -p "$dest"
done

count=0
# Find all skill directories containing SKILL.md
while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"

  for dest in "${DESTS[@]}"; do
    target="$dest/$skill_name"
    if [ -L "$target" ] || [ -e "$target" ]; then
      rm -rf "$target"
    fi
    ln -s "$skill_dir" "$target"
  done
  count=$((count + 1))
  echo "Linked skill: $skill_name"
done < <(find "$REPO/skills" -type f -name "SKILL.md" | sort)

echo "Successfully linked $count skills to ~/.claude/skills and ~/.agents/skills"
