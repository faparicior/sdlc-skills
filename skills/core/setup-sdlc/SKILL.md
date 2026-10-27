---
name: setup-sdlc
description: >-
  Interactive onboarding skill to configure a repository for the SDLC workflow.
  LOAD THIS SKILL when user mentions: setup sdlc, init sdlc, configure sdlc,
  install sdlc skills, or bootstrap sdlc.
disable-model-invocation: true
---

# Setup SDLC Skills

Configure your repository to use the full Spec-Driven, DDD & TDD Software Development Life Cycle (SDLC).

## Workflow

1. **Detect Project Environment**:
   - Check if the repository is a Monorepo (pnpm/turborepo/npm workspaces) or Single App.
   - Inspect existing documentation directories (`docs/`, `doc/`, etc.).
   - Check for existing ADRs (`docs/adr/`) and architecture guidelines.

2. **Interactive Configuration**:
   Ask the developer:
   - **Documentation root**: Default is `docs/`.
   - **Bounded Contexts / Modules location**: e.g., `packages/modules/` (Monorepo), `src/modules/`, or `apps/`.
   - **ADR directory**: Default is `docs/adr/`.
   - **Product Specifications directory**: Default is `docs/product/bounded-contexts/`.
   - **Working Proposals directory**: Default is `docs/product/working-on/`.

3. **Generate Configuration**:
   Save settings to `.sdlc/config.json`:
   ```json
   {
     "$schema": "https://raw.githubusercontent.com/faparicior/sdlc-skills/main/schemas/sdlc-config.schema.json",
     "version": "1.0.0",
     "docsRoot": "docs",
     "adrDir": "docs/adr",
     "productDocsDir": "docs/product",
     "modulesDir": "packages/modules",
     "guidelinesDir": "docs/product/guidelines",
     "architectureStyle": "ddd"
   }
   ```

4. **Initialize Directory Structure & Guidelines**:
   - Create directories if they do not exist:
     - `docs/inception/`
     - `docs/user-story-mapping/`
     - `docs/product/bounded-contexts/`
     - `docs/product/guidelines/`
     - `docs/product/working-on/active/`
     - `docs/product/working-on/grace-period/`
     - `docs/adr/`
   - Copy canonical guidelines from this skill package into `docs/product/guidelines/`:
     - `business-rules-vs-invariants.md`
     - `flow-documentation-structure.md`
     - `adr-naming-conventions.md`
   - **Do not copy `traceability.md`**: it stays in the skills pack (`../guidelines/traceability.md`) as the single source of the convention; product docs carry the sections it defines but never link to it.

5. **Confirm Ready**:
   Provide the developer with a summary and suggest the next step:
   - For a brand new project: Run `/inception-workshop` or `/user-story-mapping`.
   - For an existing project needing documentation: Run `/reverse-engineer-domain`.
   - For a general overview: Run `/sdlc-guide`.
