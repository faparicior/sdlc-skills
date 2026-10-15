# [Flow Name] - Development Plan

* **Date:** YYYY-MM-DD
* **Status:** 📋 Planning | 🔄 In Progress | ✅ Complete
* **Flow File:** `docs/product/bounded-contexts/[context]/flows/[flow-filename].md`
* **Bounded Context:** `[context]`

> **Architecture & Commands Reference**: Consult **`AGENTS.md`** and **`docs/ARCHITECTURE.md`** for exact folder paths, naming rules, test runner commands, and Definition of Done.

---

## 🎯 Overview

**Flow Description:** [Brief summary of the flow and user journey]

### Associated Features (Sequentially Ordered)
| # | Feature | Specification File | Status |
|---|---------|---------------------|--------|
| F1 | [Feature 1] | `features/feature-01-[name1].md` | 📋 Planned |
| F2 | [Feature 2] | `features/feature-02-[name2].md` | 📋 Planned |

---

## 📋 Relevant ADRs
*Referenced from `docs/adr/README.md`:*
- `ADR-[XXX]`: [Decision name] - [Impact on this flow]
- `ADR-[XXX]`: [Decision name] - [Impact on this flow]

---

## 🔗 Cross-Repo Dependencies

Fill this section only if this flow touches more than one repository. Remove it for single-repo flows.

| # | Repo | Role in this flow | Deploy first? |
|---|------|-------------------|:---:|
| 1 | `[repo-name or path]` | [What changes there and why] | ✅ / — |
| 2 | this repo | [What changes here] | — |

> **Deploy order note:** describe any hard ordering constraint (e.g. "repo 1 must deploy before this repo — the new event payload references a contract that must exist in repo 1 first").

---

## 🧠 Agent Design Decisions & Assumptions (Lack of Information Log)
*Explicitly documents all judgment calls, runtime defaults, or tie-breakers made by the LLM due to missing, underspecified, or conflicting information in repository documents.*

| # | Topic / Area | Documentation State / Gap | Decision / Judgment Made | Status |
|---|--------------|---------------------------|--------------------------|--------|
| D1 | [e.g. Runtime Port] | [What docs specified vs what was missing] | [Chosen solution / default] | 📋 Proposed / ✅ Approved |
| D2 | [e.g. Error Codes] | [What docs specified vs what was missing] | [Chosen solution / default] | 📋 Proposed / ✅ Approved |

---

## 📦 Phased Execution Plan

> **Disciplined TDD Micro-Cycle for every phase:**
> 1. **First: Write Test** (Must fail initially)
> 2. **After: Implement Code** (Make test pass)
> 3. **After: Architecture Tests** (Run architecture check from `AGENTS.md`)
> 4. **After: Linter & Typecheck** (Run lint:fix and typecheck from `AGENTS.md`)
> 5. **🛑 User Checkpoint**: Report phase verification results and confirm before advancing to next phase

---

### Phase 0: Define E2E Contract (Outside-In)
- [ ] **0.0 Extract Edge Case Catalogue**: Read the flow spec's "Edge Cases & Invariant Integrity", "Technical Failures", and "Alternative Paths" sections. Produce a numbered list of all edge cases and failure modes. Mark ⚠️ any **Implementation Trap** — a case where a naive implementation would contradict the spec (e.g. an early-return guard that silently skips a required side-effect).
- [ ] **0.1 Write E2E Tests (Happy Path + All Edge Cases)**: Write one failing acceptance test per catalogue item. Tests must assert what the spec says, not what the naive implementation would do. For each ⚠️ Implementation Trap, the test must specifically exercise the contradicting behaviour.
- [ ] **0.2 Run E2E (Must Fail)**: Verify all tests fail due to missing implementation (defining the target outcome)

---

### Phase 1: Domain Core (Inside-Out)

#### 1.1 Tests First (Domain)
- [ ] **Spec cross-check**: Before writing each test, verify it against the flow spec's acceptance criteria and the edge case catalogue from Phase 0. If a test would pass with a naive implementation that contradicts a documented edge case, fix the test to match the spec — **the spec wins, not intuition**. Pay special attention to ⚠️ Implementation Traps.
- [ ] Write Value Object unit tests
- [ ] Write Entity & Aggregate Root unit tests
- [ ] Verify domain tests **FAIL** initially

#### 1.2 Implement Code (Domain)
- [ ] Implement Value Objects (invariants, immutability, factory methods)
- [ ] Implement Entities / Aggregate Roots (business logic, state transitions)
- [ ] Implement Domain Events & Domain Exceptions
- [ ] Define Repository interfaces
- [ ] Verify domain tests **PASS**

#### 1.3 Architecture & Quality Checks (Domain)
- [ ] Run fast architecture check (from `AGENTS.md`) $\rightarrow$ 0 errors
- [ ] Run linter & typecheck (from `AGENTS.md`) $\rightarrow$ 0 errors

---

### Phase 2: Application Layer (Inside-Out)

#### 2.1 Tests First (Application)
- [ ] Write Command & Query handler tests with mocked repositories
- [ ] Verify application tests **FAIL** initially

#### 2.2 Implement Code (Application)
- [ ] Implement Command / Query DTOs and contracts
- [ ] Implement Command & Query Handlers
- [ ] Verify application tests **PASS**

#### 2.3 Architecture & Quality Checks (Application)
- [ ] Run fast architecture check (from `AGENTS.md`) $\rightarrow$ 0 errors
- [ ] Run linter & typecheck (from `AGENTS.md`) $\rightarrow$ 0 errors

---

### Phase 3: Infrastructure & Container Wiring

#### 3.1 Tests First (Infrastructure)
- [ ] Write Repository integration tests
- [ ] Verify integration tests **FAIL** initially

#### 3.2 Implement Code (Infrastructure)
- [ ] Implement database schemas & migrations
- [ ] Implement Repositories (mapping database rows to domain entities)
- [ ] Wire dependencies in the module container / composition root
- [ ] Verify integration tests **PASS**

#### 3.3 Architecture & Quality Checks (Infrastructure)
- [ ] Run fast architecture check (from `AGENTS.md`) $\rightarrow$ 0 errors
- [ ] Run linter & typecheck (from `AGENTS.md`) $\rightarrow$ 0 errors

---

### Phase 4: Interface Layer & API Routes

#### 4.1 Tests First (Interfaces)
- [ ] Write API Controller / Route tests with mocked handlers
- [ ] Verify interface tests **FAIL** initially

#### 4.2 Implement Code (Interfaces)
- [ ] Implement HTTP Controllers (mapping requests to commands/queries, mapping domain errors)
- [ ] Implement API Route handlers / UI entrypoints
- [ ] Verify interface tests **PASS**

#### 4.3 Architecture & Quality Checks (Interfaces)
- [ ] Run fast architecture check (from `AGENTS.md`) $\rightarrow$ 0 errors
- [ ] Run linter & typecheck (from `AGENTS.md`) $\rightarrow$ 0 errors

---

### Phase 5: E2E Validation & Definition of Done

- [ ] **5.1 Execute E2E Suite**: Run flow E2E test (**MUST PASS**)
- [ ] **5.2 Fast Architecture Verification**: Run architecture check from `AGENTS.md` (0 errors)
- [ ] **5.3 Architecture Test Suite**: Run full architecture test suite from `AGENTS.md` (0 errors)
- [ ] **5.4 Unit & Integration Test Suites**: Run all unit and integration tests (0 errors)
- [ ] **5.5 TypeScript Typecheck**: Run typecheck from `AGENTS.md` (0 errors)
- [ ] **5.6 Linting & Formatting**: Run lint from `AGENTS.md` (0 errors)
- [ ] **5.7 Mark Plan Complete**: Update status to `✅ Complete`