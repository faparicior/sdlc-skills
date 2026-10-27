# sdlc-skills

## 0.3.0

### Minor Changes

- Expand `audit-docs` skill with comprehensive claim verification, mechanical checks, and planning scripts:
  - Introduce **Plan mode** for audit execution on large documentations or smaller models via structured slices.
  - Add audit planning and execution scripts: `make-plan.sh`, `next-slice.sh`, `check-worksheet.sh`, `merge.sh`, `claim-inventory.sh`, and `claim-sweep.sh`.
  - Add automated mechanical validation scripts: `check-links.sh`, `check-reciprocity.sh`, and `check-mermaid.mjs`.
  - Add references for claim classification (`claim-kinds.md`) and subagent prompts (`slice-prompt.md`).

## 0.2.0

### Minor Changes

- Add instructions to honor `.sdlc/config.json` path overrides across specification, implementation, and evolution skills:
  - `create-features`
  - `create-flow-documentation`
  - `create-entity-lifecycle`
  - `implement-flow`
  - `modify-flow`
