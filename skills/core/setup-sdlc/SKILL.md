---
name: setup-sdlc
description: >-
  Interactive onboarding skill to configure a repository for the SDLC workflow.
  LOAD THIS SKILL when user mentions: setup sdlc, init sdlc, configure sdlc,
  install sdlc skills, or bootstrap sdlc.
disable-model-invocation: true
---

# PROTOCOL: SETUP-SDLC (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                                        -> REQUIRED_OUTPUT                                         -> MANDATORY_HALT
Step 1: Detect Env    -> ls / read_file (workspace layout, existing docs)     -> Detected directory defaults                             -> Continue to Step 2
Step 2: Configure     -> ask_question / prompt developer                      -> Confirmed paths for `.sdlc/config.json`                 -> 🛑 HALT TURN (Wait for user answers)
Step 3-5: Initialize  -> write_file / mkdir / cp guidelines                   -> `.sdlc/config.json` + directory tree + guidelines       -> END
</state_machine>

<execution_invariants>
1. INTERACTIVE CONFIRMATION: Confirm the 5 directory paths with the developer before writing `.sdlc/config.json`.
2. GUIDELINE COPY RULE: Copy `business-rules-vs-invariants.md`, `flow-documentation-structure.md`, and `adr-naming-conventions.md` into the target `guidelinesDir`, but NEVER copy `traceability.md` or `execution-protocol.md` (they remain in the skills pack).
</execution_invariants>

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
