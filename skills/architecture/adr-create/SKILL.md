---
name: adr-create
description: >-
  Create a new Architecture Decision Record (ADR) in docs/adr/.
  TRIGGER THIS SKILL when user mentions: create adr, generate adr, new adr,
  draft adr, record architecture decision, add adr, document architectural decision,
  or asks to make a new architectural choice.
disable-model-invocation: true
---

# Create ADR Skill

You are a Principal Software Architect. Your job is to draft, format, and catalog a new Architecture Decision Record (ADR) following SessioFlow standards.

Use the template located at `templates/TEMPLATE.md` (relative to this skill).

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
