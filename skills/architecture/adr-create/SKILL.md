---
name: adr-create
description: >-
  Create a new Architecture Decision Record (ADR) in docs/adr/.
  TRIGGER THIS SKILL when user mentions: create adr, generate adr, new adr,
  draft adr, record architecture decision, add adr, document architectural decision,
  or asks to make a new architectural choice.
disable-model-invocation: true
---

# PROTOCOL: ADR-CREATE (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                      -> REQUIRED_OUTPUT                                         -> MANDATORY_HALT
Step 1: Sequence+Type -> read_file(docs/adr/README.md)      -> Next gapless 3-digit ADR number (`0XX`) + ADR type      -> 🛑 HALT only if the type is ambiguous
Step 2-5: Analyze     -> evaluate drivers, options, AX tax  -> Structured decision analysis                            -> Continue to Step 6
Step 6: Write & Sync  -> read_file(template for the type)   -> docs/adr/0XX-*.md + updated README.md                   -> 🛑 HALT TURN (Present ADR)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: Execute all 6 steps in strict order (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK: Reconstructing the ADR template from memory is strictly forbidden. You MUST call `read_file` on the template that matches the ADR type (`templates/TEMPLATE-STRUCTURAL.md` or `templates/TEMPLATE-PROBLEM-DRIVEN.md`) before writing `docs/adr/0XX-*.md`.
3. CATALOG SYNC: Every new ADR must be added to `docs/adr/README.md` with sequential 3-digit numbering (`0XX`) and incremented statistics.
4. ESCAPE HATCH: If the situation does not fit the contract, do not silently improvise and do not force-fit: declare the deviation in one line and ask.
5. ONE TYPE, ONE TEMPLATE: Never mix sections from the two templates, and never skip a section proactively because it looks redundant or optional.
</execution_invariants>

<output_contract>
- TARGET_PATH: `docs/adr/0XX-decision-title.md`
- SOURCE_TEMPLATE: exactly one of `templates/TEMPLATE-STRUCTURAL.md` or `templates/TEMPLATE-PROBLEM-DRIVEN.md` (MUST call `read_file` before writing)
- SCHEMA_INVARIANCE: Preserve every H1/H2/H3 section heading, metadata field, table header, option pros/cons structure, and mandatory `🤖 AI & Agentic Ergonomics (AX)` section of the chosen template verbatim.
- ESCAPE_HATCH: Never silently omit or invent template sections. If a section genuinely does not apply, preserve the heading and write `"N/A — [1-line rationale]"`, or halt and ask the user before deviating. Exception: `### Measurements` in the problem-driven template and `### Enforceable Rules` in the structural template can never be `N/A`.
</output_contract>

---

## 📋 Step-by-Step Workflow

### 1. Determine Sequential Number and ADR Type
1. Inspect `docs/adr/README.md` to find the highest existing 3-digit ADR number (e.g., `023`).
2. The new ADR number is `0XX` (e.g., `024`). Never leave sequence gaps.
3. Formulate the filename using kebab-case: `docs/adr/0XX-decision-title.md` (e.g., `docs/adr/024-use-redis-for-caching.md`).
4. Choose the ADR type. The type decides the template:

| Type | Choose it when | Template |
| :--- | :--- | :--- |
| Structural | The decision defines structure, technology, or a convention that other code must follow, and its rules should become architecture tests (e.g., hexagonal layers, language, framework, naming) | `templates/TEMPLATE-STRUCTURAL.md` |
| Problem-driven | The decision responds to an observed problem and you can cite measured data about it (logs, metrics, incidents, costs) | `templates/TEMPLATE-PROBLEM-DRIVEN.md` |

If the request fits both or neither, or if a problem-driven decision has no measured data, halt and ask the user which type applies. Never pick a template to avoid a section.

### 2. Gather Metadata, Context & Decision Drivers
Populate the `## Summary` table (written last, once Steps 3 to 5 are done), the header metadata and the `## Context and Problem Statement` section from the chosen template:
- **Header Metadata**: `* **Status:**` (`Proposed` or `Accepted`), `* **Date:**`, `* **Decision Makers:**`, `* **Supersedes:** [ADR-0000](link) | N/A`, `* **Amended By:** [ADR-0000](link) | N/A`.
- **`## Context and Problem Statement`**: What technical, product, or operational problem forces this decision?
- **`**Decision Drivers:**`**: 2–4 bullet points prioritizing constraints (e.g., zero-cost free tier, DDD isolation, developer experience).
- **Problem-driven only**: `### Why the Current Setup Falls Short`, `### Measurements` (source, period and date for every figure), and `### Assumptions Confirmed` (what the decision maker confirmed, with name and date).

### 3. List Considered Options & Decision Outcome
Populate `## Considered Options` and `## Decision Outcome`:
- **`## Considered Options`**: Bulleted list of at least 2–3 viable options (`[Option 1]`, `[Option 2]`, `[Option 3]`).
- **`## Decision Outcome`**:
  - **`**Chosen Option:** "[Option 1]"`** and **`**Justification:**`** explaining why it wins over the alternatives.
  - **`### Consequences`**:
    - `* **Positive:**` What improves or becomes easier.
    - `* **Negative:**` What becomes harder, technical debt incurred, or complexity added.
    - `* **Risks:**` Point to the risk table (`| Risk | Impact | Mitigation |`): one row per risk, each with a concrete mitigation or an explicit "accepted".
  - **Problem-driven only**: `### How It Works` (a Mermaid diagram of the flow) and `### Design` (a table of components and behaviour), before `### Consequences`.
  - **Structural only**: `### Principles and Scope` and `### Enforceable Rules` (each rule with the test or tool that verifies it, or `— manual review` with the reason), before `### Consequences`.

### 4. Mandatory `### 🤖 AI & Agentic Ergonomics (AX)`
Every ADR must document AI friction under `## Decision Outcome` -> `### 🤖 AI & Agentic Ergonomics (AX)` to keep autonomous agents on-plan:
- **`* **LLM Corpus Alignment:**`**:
  - `High (>80%)`: Ubiquitous pattern well-represented in LLM pretraining (e.g., RESTful endpoints, Tailwind, Docker Compose).
  - `Medium (30-80%)`: Known pattern but with significant ecosystem variance (e.g., Supabase, Drizzle ORM).
  - `Atypical/Exotic (<30%)`: Patterns counter to internet CRUD defaults (e.g., pure DDD Value Objects without Zod in domain, CQRS separation, `ts-archunit` guardrails).
- **`| Expected Agent Bias | Automated Guardrail |` Table**: Pair each expected LLM deviation with a named automated countermeasure (or justify `—` as an accepted manual-review risk).
- **`* **Supervision & Guardrail Tax:**`**:
  - `Low`: Standard TypeScript/language compiler or simple linter catches violations.
  - `Medium`: Requires custom lint rules or integration tests.
  - `High`: Requires custom architectural AST tests (`check:arch`, `ts-archunit`) to prevent agent deviation.

### 5. Document `## Pros and Cons of the Options` & `## Links`
- Under `## Pros and Cons of the Options`, start with `### Comparison at a Glance` (one column per option, one row per decision driver, plus effort), then create `### [Option N]` subsections using `* Good, because ...` and `* Bad, because ...` bullets. The list in `## Considered Options` and the `### [Option N]` subsections must have the same names in the same order.
- Under `## Links`, link related ADRs, inception docs, or tickets.

### 6. Write File & Update Catalog
1. Save the new ADR to `docs/adr/0XX-your-decision-name.md`.
2. Update `docs/adr/README.md`:
   - Add a row to the **Quick Reference** table with number, title link, status, date, and AX tags.
   - Categorize the decision under the appropriate **ADR Categories** section.
   - Increment the total count in the statistics block.

---

<self_validation_gate>
Before ending your turn, verify every item below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final response — fix the violation first:
- [ ] **Sequence Evidence:** Highest existing ADR in `docs/adr/README.md` (`0XX`) and new gapless number assigned: `<0XX -> 0YY>`
- [ ] **Type Evidence:** ADR type chosen (`structural` or `problem-driven`) and the one-line reason: `<type, reason>`
- [ ] **Template Read Evidence:** Exact path passed to `read_file` (`templates/TEMPLATE-STRUCTURAL.md` or `templates/TEMPLATE-PROBLEM-DRIVEN.md`): `<path>`
- [ ] **Output & Schema Evidence:** Exact ADR file written (`docs/adr/0YY-*.md`), number of options analyzed (`≥2–3`), and `🤖 AI & Agentic Ergonomics (AX)` table populated: `<path, N options>`
- [ ] **Section Parity Evidence:** Count of H2/H3 headings in the written ADR versus the chosen template (equal, or each difference listed as `N/A — reason`): `<N vs N>`
- [ ] **Catalog Sync Evidence:** `docs/adr/README.md` updated with new row and incremented total count: `<old count -> new count>`
</self_validation_gate>
