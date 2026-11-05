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

### 2. Gather Context & Architecture Drivers
Extract or prompt for:
- **Status**: Default to `Proposed` (or `Accepted` if already agreed upon).
- **Context & Problem Statement**: What technical, product, or operational problem forces this decision?
- **Decision Drivers**: 2–4 bullet points prioritizing constraints (e.g., zero-cost free tier, DDD isolation, developer experience).

### 3. Evaluate Options (Minimum 2–3)
Document at least 2 viable options with concrete trade-offs:
- **Option 1**: Selected choice.
- **Option 2**: Primary alternative considered.
- **Option 3**: Secondary alternative considered.
Include:
- ✅ **Pros / Advantages**
- ❌ **Cons / Drawbacks**

### 4. Decision Outcome & Consequences
- State the chosen option clearly and justify why it wins over the alternatives.
- Document consequences:
  - **Positive consequences**: What improves or becomes easier.
  - **Negative consequences**: What becomes harder, technical debt incurred, or complexity added.
  - **Risks & Mitigations**: How potential downsides will be handled.

### 5. Mandatory 🤖 AI & Agentic Ergonomics (AX)
Every ADR in SessioFlow must document AI friction to keep autonomous agents on-plan:
- **LLM Corpus Alignment**:
  - `High (>80%)`: Ubiquitous pattern well-represented in LLM pretraining (e.g., RESTful endpoints, Tailwind, Docker Compose).
  - `Medium (30-80%)`: Known pattern but with significant ecosystem variance (e.g., Supabase, Drizzle ORM).
  - `Atypical (<30%)`: Patterns counter to internet CRUD defaults (e.g., pure DDD Value Objects without Zod in domain, CQRS separation in Next.js, ts-archunit guardrails).
- **Guardrail Tax**:
  - `Low`: Standard TypeScript compiler or simple linter catches violations.
  - `Medium`: Requires custom lint rules or integration tests.
  - `High`: Requires custom architectural AST tests (`check:arch`, `ts-archunit`) to prevent agent deviation.
- **Drift Risks**: Where LLMs are likely to hallucinate or regress to generic patterns.

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
