# sdlc-skills

## 0.4.0

### Minor Changes

- Upgrade all 19 SDLC skills to the Level 3 XML Execution Protocol and align all templates and validators 1-by-1:

  - **Level 3 XML Control-Plane Protocol (`guidelines/execution-protocol.md`)**: Added `<state_machine>`, `<execution_invariants>`, `<output_contract>`, and `<self_validation_gate>` blocks across all 19 skills, enforcing `workflow structure = immutable | step reasoning = flexible`.
  - **Evidence-Based Self-Validation Gates**: Replaced passive boolean checkboxes in `<self_validation_gate>` with concrete evidence slots (`<path>`, tool call citations, section/rubric counts, and command exit codes).
  - **Contextual Escape Hatches & Fast-Track Overrides**: Added skill-specific `ESCAPE HATCH` rules in `<execution_invariants>` and `<output_contract>` (`"N/A — [1-line rationale]"` or declare deviation and ask; never silently omit or force-fit) plus explicit `Light`-tier and user batch overrides on `🛑 HALT TURN` gates.
  - **1-by-1 Skill, Template & Validator Alignment**: Synchronized headings, step numbers (Lean Inception Step 5 User Journey vs. Step 6 Brainstorming), 7-criteria weighted ADR validation rubric, Value Object & Entity `Implementation Source Path` and `Enforcement & tests` tables, brownfield `BR`/`INV` `Traceability` schemas, and wrapped AI-only instructions inside `<!-- ... -->` HTML comments across templates.

## 0.3.1

### Patch Changes

- Decouple claim inventory patterns from proprietary tools and expand domain coverage:
  - Replace product-specific mentions (`kafka`, `datadog`, `unleash`) with stack-agnostic patterns in `claim-inventory.sh`.
  - Expand domain event past-tense verb allowlist across lifecycle, financial, and messaging domains.
  - Document pattern tuning guidelines and extension points in `claim-kinds.md`.

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
