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

## Verifying Skills

Run:
```bash
bash scripts/list-skills.sh
```
