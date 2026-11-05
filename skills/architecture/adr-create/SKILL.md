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
CURRENT_STEP          -> REQUIRED_TOOL                      -> REQUIRED_OUTPUT                           -> MANDATORY_HALT
Step 1: Sequence      -> read_file(docs/adr/README.md)      -> Next gapless 3-digit ADR number (`0XX`)   -> Continue to Step 2
Step 2-5: Analyze     -> evaluate drivers, options, AX tax  -> Structured decision analysis              -> Continue to Step 6
Step 6: Write & Sync  -> read_file(templates/TEMPLATE.md)   -> docs/adr/0XX-*.md + updated README.md     -> 🛑 HALT TURN (Present ADR)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: Execute all 6 steps in strict order (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK: Reconstructing the ADR template from memory is strictly forbidden. You MUST call `read_file` on `templates/TEMPLATE.md` before writing `docs/adr/0XX-*.md`.
3. CATALOG SYNC: Every new ADR must be added to `docs/adr/README.md` with sequential 3-digit numbering (`0XX`) and incremented statistics.
</execution_invariants>

<output_contract>
- TARGET_PATH: `docs/adr/0XX-decision-title.md`
- SOURCE_TEMPLATE: `templates/TEMPLATE.md` (MUST call `read_file` before writing)
- SCHEMA_INVARIANCE: Preserve every H1/H2/H3 section heading, metadata field, option pros/cons structure, and mandatory `🤖 AI & Agentic Ergonomics (AX)` section verbatim.
</output_contract>

---

## 📋 Step-by-Step Workflow

### 1. Determine Sequential Number
1. Inspect `docs/adr/README.md` to find the highest existing 3-digit ADR number (e.g., `023`).
2. The new ADR number is `0XX` (e.g., `024`). Never leave sequence gaps.
3. Formulate the filename using kebab-case: `docs/adr/0XX-decision-title.md` (e.g., `docs/adr/024-use-redis-for-caching.md`).

### 2. Gather Metadata, Context & Decision Drivers
Populate the header metadata and `## Context and Problem Statement` section from `templates/TEMPLATE.md`:
- **Header Metadata**: `* **Status:**` (`Proposed` or `Accepted`), `* **Date:**`, `* **Decision Makers:**`, `* **Supersedes:** [ADR-0000](link) | N/A`, `* **Amended By:** [ADR-0000](link) | N/A`.
- **`## Context and Problem Statement`**: What technical, product, or operational problem forces this decision?
- **`**Decision Drivers:**`**: 2–4 bullet points prioritizing constraints (e.g., zero-cost free tier, DDD isolation, developer experience).

### 3. List Considered Options & Decision Outcome
Populate `## Considered Options` and `## Decision Outcome`:
- **`## Considered Options`**: Bulleted list of at least 2–3 viable options (`[Option 1]`, `[Option 2]`, `[Option 3]`).
- **`## Decision Outcome`**:
  - **`**Chosen Option:** "[Option 1]"`** and **`**Justification:**`** explaining why it wins over the alternatives.
  - **`### Consequences`**:
    - `* **Positive:**` What improves or becomes easier.
    - `* **Negative:**` What becomes harder, technical debt incurred, or complexity added.
    - `* **Risks:**` Potential downsides and how they will be handled.

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
- Under `## Pros and Cons of the Options`, create `### [Option N]` subsections using `* Good, because ...` and `* Bad, because ...` bullets.
- Under `## Links`, link related ADRs, inception docs, or tickets.

### 6. Write File & Update Catalog
1. Save the new ADR to `docs/adr/0XX-your-decision-name.md`.
2. Update `docs/adr/README.md`:
   - Add a row to the **Quick Reference** table with number, title link, status, date, and AX tags.
   - Categorize the decision under the appropriate **ADR Categories** section.
   - Increment the total count in the statistics block.

---

<self_validation_gate>
Before ending your turn, verify every item below. If any checkbox is FALSE, DO NOT produce your final response — fix the violation first:
- [ ] `docs/adr/README.md` inspected first to assign the next gapless 3-digit number (`0XX`).
- [ ] **Template Read Verified:** `read_file` was called on `templates/TEMPLATE.md` before writing.
- [ ] **Schema Compliance Verified:** Generated ADR matches `templates/TEMPLATE.md` headings verbatim, includes ≥2–3 options with pros/cons, and includes `🤖 AI & Agentic Ergonomics (AX)`.
- [ ] `docs/adr/README.md` updated with the new ADR entry and incremented count.
</self_validation_gate>
