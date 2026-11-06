# SDLC Skills Guidelines for Agents

Welcome! You are working on the `sdlc-skills` repository, which houses the universal Spec-Driven, DDD & TDD Software Development Life Cycle agent skills.

## Architecture & Conventions

- Each skill lives in `skills/<category>/<skill-name>/` with a `SKILL.md` entry point.
- `SKILL.md` MUST contain standard YAML frontmatter:
  ```yaml
  ---
  name: <skill-name>
  description: >-
    <Short description and trigger phrases>
  disable-model-invocation: true # or false for router skills
  ---
  ```
- Subdirectories inside a skill can include `templates/`, `references/`, and `scripts/`.
- Shared guidelines reside in `guidelines/` and are symlinked into categories.
- Skills must remain modular, decoupled from any single proprietary codebase, and configurable via `.sdlc/config.json`.
- **Level 3 Execution Protocol (`guidelines/execution-protocol.md`)**:
  - Every workflow/template-producing skill MUST open with XML control-plane blocks (`<state_machine>`, `<execution_invariants>`, `<output_contract>`) that enforce `workflow structure = immutable | step reasoning = flexible`.
  - Every reference to a file in `templates/*.md` MUST be locked inside `<output_contract>` requiring an explicit `read_file` tool call on the template before generating output (never reconstructing templates from prose or memory), plus an explicit `ESCAPE_HATCH` (`"N/A — [1-line rationale]"` or ask the user; never silently omit or invent sections).
  - Multi-stage skills MUST enforce explicit `🛑 HALT TURN` boundaries (with an explicit fast-track override when the user requests batch/Light execution) and end with an **evidence-based** `<self_validation_gate>` block that requires citing exact tool calls, file paths, and section counts rather than passive boolean checkboxes.

## Verifying Skills

Run:
```bash
bash scripts/list-skills.sh
```

## Versioning, Changelog & Releases

This repository uses [Changesets](https://github.com/changesets/changesets) for Semantic Versioning and automated changelog generation:

1. **Documenting changes**: Run `npm run changeset` when adding or modifying skills, choose the bump level (`patch`, `minor`, `major`), and write a summary.
2. **Bumping version & changelog**: Run `npm run version`. This will:
   - Consume pending changesets.
   - Update `package.json` version.
   - Update `CHANGELOG.md`.
   - Automatically sync the version into `.claude-plugin/plugin.json` and marketplace manifests (`.claude-plugin/marketplace.json`, `.agents/plugins/marketplace.json`) via `scripts/sync-versions.js`.
3. **Commit, Tag & Publish**:
   ```bash
   git add .
   git commit -m "chore(release): vX.Y.Z"
   git tag vX.Y.Z
   git push origin main --tags
   ```

### How Different Agents Consume Updates

- **Claude Code**: Reads `.claude-plugin/plugin.json` (auto-synced) when users run `claude plugin update sdlc-skills`.
- **GitHub Copilot & Codex**: Track the repository and git tags directly via their respective plugin marketplace settings.
- **Universal / Antigravity / Cursor / Windsurf**: Installers like `npx skills@latest add faparicior/sdlc-skills` pull the latest git release/tag.
- **Local setups**: Run `bash scripts/link-skills.sh` after a `git pull` to refresh symlinks in `~/.claude/skills` and `~/.agents/skills`.

