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
1. WORKFLOW IMMUTABILITY: You may reason freely INSIDE each step to inspect the repository's real workspace layout (monorepo vs single-app, existing doc folders, architecture style), but you must execute the onboarding steps in order (`workflow structure = immutable | step reasoning = flexible`).
2. INTERACTIVE CONFIRMATION: Confirm the 5 directory paths with the developer before writing `.sdlc/config.json` (unless the user explicitly requested default/unattended initialization in their prompt).
3. GUIDELINE COPY RULE: Copy `business-rules-vs-invariants.md`, `flow-documentation-structure.md`, and `adr-naming-conventions.md` into the target `guidelinesDir`, but NEVER copy `traceability.md` or `execution-protocol.md` (they remain in the skills pack).
4. ESCAPE HATCH: If the repository's structure does not fit the standard SDLC layout, do not silently improvise and do not force-fit: declare the deviation in one line and ask.
</execution_invariants>

<output_contract>
- TARGET_CONFIG: `.sdlc/config.json` conforming to `schemas/sdlc-config.schema.json`
- TARGET_DIRECTORIES: `docs/inception/`, `docs/user-story-mapping/`, `docs/product/bounded-contexts/`, `docs/product/guidelines/`, `docs/product/working-on/active/`, `docs/product/working-on/grace-period/`, `docs/adr/` (or user-configured equivalents)
- ESCAPE_HATCH: If any target directory already exists with files, preserve existing files untouched and report them in the summary.
</output_contract>

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

---

<self_validation_gate>
Before ending your turn, verify every item below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final response — fix the violation first:
- [ ] **User Confirmation Evidence:** Confirm developer approved the 5 paths (or halted at Step 2 waiting for answers): `<status>`
- [ ] **Config & Directories Evidence:** Exact `.sdlc/config.json` path written and list of directories created: `<paths>`
- [ ] **Guideline Copy Evidence:** List the 3 guideline files copied to `guidelinesDir` and confirm `traceability.md` & `execution-protocol.md` were excluded: `<3 files copied>`
</self_validation_gate>
