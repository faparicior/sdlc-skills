# Feature [01]: [Feature Name] - Feature Specification

* **Feature ID:** `F[01]`
* **Specification File:** `docs/product/bounded-contexts/[context]/flows/features/[journey-id]/feature-[01]-[feature-name].md`
* **Parent Flow:** [Flow filename] (e.g., `../../journey-01-setup-conference.md`)
* **Bounded Context:** [Context Name] (e.g., `conference`)
* **Status:** 📋 Planned | 🔄 In Progress | ✅ Complete
* **Priority:** High | Medium | Low

> **Architecture Reference**: See `AGENTS.md` (or `CLAUDE.md`) and `docs/ARCHITECTURE.md` for project folder layout, layer conventions, and verification commands.

---

## 🎯 Overview

**Feature Description:** [Brief description of what this feature does]

**User Value:** [How this feature benefits users in the flow]

**Flow Step:** [Which step(s) of the parent flow this feature implements]

**Current state of the code:** [Describe the state of relevant code BEFORE this feature is implemented — which files/methods/columns exist, which are absent, what the current behaviour is. Anchors the implementation and prevents stale-spec drift.]

---

## 📋 Requirements

### Functional Requirements
- [ ] [Requirement 1]
- [ ] [Requirement 2]
- [ ] [Requirement 3]

### Non-Functional Requirements
- [ ] Performance: [e.g., API response <200ms]
- [ ] Security: [e.g., authentication & authorization rules]
- [ ] Architecture: [DDD layer rules from docs/ARCHITECTURE.md]

---

## 🧠 Agent Design Decisions & Assumptions (Lack of Information Log)
*Documents all judgment calls, assumptions, and tie-breakers made by the LLM for this feature.*

| # | Topic / Area | Documentation State / Gap | Decision / Judgment Made | Status |
|---|--------------|---------------------------|--------------------------|--------|
| D1 | [e.g. Error Mapping] | [What docs specified vs what was missing] | [Chosen solution / default] | 📋 Proposed / ✅ Approved |

---

## 🏗️ Domain Model

### Entities Affected
| Entity | Role | Changes |
|--------|------|---------|
| [Entity1] | Aggregate Root | [Create/Update/Read] |
| [ChildEntity] | Entity | [Create/Update/Read] |

### Value Objects
- `[ValueObjectName]` - [validation rules & purpose]
- `[ValueObjectName]` - [validation rules & purpose]

### Domain Events
- `[EventName]` - [when triggered, payload]

### Domain Exceptions
- `[ErrorName]` - [when thrown, error type]

---

## 🛡️ Concurrency, TOCTOU & Invariant Integrity Analysis
*Evaluate race conditions, check-then-act vulnerabilities, and data consistency safeguards.*

> [!IMPORTANT]
> **Active Invariant Cross-Check**: Before filling this table, search the full `invariants/` tree across all bounded contexts (`docs/product/bounded-contexts/**/invariants/INV-*.md`) for INVs that apply to any operation this feature performs. Do NOT rely solely on the parent flow document's "Enforced Invariants" section, which may lag behind the codebase or omit cross-context invariants.

| Concurrency & Invariant Vector | Risk in This Feature | Guard / Mitigation Strategy | Enforcement Mechanism |
|--------------------------------|----------------------|-----------------------------|-----------------------|
| **Active INV Cross-Check** | List every INV-XXX across all bounded contexts whose statement applies to an operation this feature performs. Does this code path enforce it? | e.g. Exclude restricted roles (INV-003); guard state with domain exception (INV-004) | Confirmed in unit/integration test asserting condition is checked |
| **Uniqueness (TOCTOU)** | e.g. Concurrent inserts with duplicate slug | Database UNIQUE index + Domain Error translation | `UNIQUE INDEX` $\rightarrow$ `[DuplicateKeyError]` $\rightarrow$ `409` |
| **Quotas & Limits** | e.g. Concurrent creations exceeding free tier quota | Atomic count check within transaction / lock / constraint | DB constraint / Isolation level |
| **State Machine Race** | e.g. Concurrent transitions on same aggregate | Optimistic locking / conditional update | `version` column / `WHERE status = ...` |
| **Time-Drift Invariants** | e.g. Historical dates vs creation validation | Separation of `create()` (validates) vs `fromData()` (reconstitutes) | Factory method separation |
| **Dual-Write Consistency** | e.g. DB updated but event dispatch drops | Transactional Outbox / Atomic unit of work | Outbox table in same DB transaction |
| **Idempotency & Replays** | e.g. Duplicate webhook payload or repeated client submission | Deduplication key / idempotency table / status idempotency | Return existing success response without side effects |

---

## 📦 Implementation Scope by Layer
*(Consult `AGENTS.md` / `docs/ARCHITECTURE.md` for exact paths)*

- **Contracts / Schemas Layer**: [Data schemas / validation DTOs]
- **Domain Layer**: [Entities, Value Objects, Domain Events, Repository Interfaces]
- **Application Layer**: [Commands / Queries and their Handlers]
- **Infrastructure Layer**: [Repository implementations, Database schemas, Container wiring]
- **Interface Layer**: [HTTP Controllers, UI components, API route handlers]

---

## 🧪 TDD Execution Checklist

Follow the 4-step cycle: **1. First Test $\rightarrow$ 2. After Code $\rightarrow$ 3. After Architecture Tests $\rightarrow$ 4. Linter & Types**

- [ ] **1. Test First (Domain)**: Write unit tests for domain models (Expect FAIL)
- [ ] **2. Implement Code (Domain)**: Implement VOs & Entities to make tests PASS
- [ ] **3. Test First (Application)**: Write Command/Query handler tests with mocked dependencies
- [ ] **4. Implement Code (Application)**: Implement handlers & DTOs to make tests PASS
- [ ] **5. Architecture Check**: Run architecture verification from `AGENTS.md` (Must pass 0 errors)
- [ ] **6. Infrastructure & Container**: Implement repositories, database mappings, and container wiring
- [ ] **7. Interfaces**: Implement controllers and route handlers
- [ ] **8. Linter & Types**: Run project lint and typecheck commands from `AGENTS.md`

---

## ✅ Acceptance Criteria

**Scenario 1: Happy Path**
- **Given** [initial state]
- **When** [action taken]
- **Then** [expected result & state change]

**Scenario 2: Validation / Error Case**
- **Given** [invalid state or input]
- **When** [action taken]
- **Then** [expected domain error / rejection]

**Scenario 3: Idempotent Execution / Replay**
- **Given** [operation has already completed successfully]
- **When** [same payload / idempotency key is submitted again]
- **Then** [system returns previous successful result without duplicate state mutations or duplicate event dispatches]

---

## 🔗 HTTP Error Contract

| Condition | Domain Exception | Error Code | HTTP | User-visible message |
|-----------|------------------|------------|------|----------------------|
| [condition that triggers rejection] | `[DomainException]` | `[ERROR_CODE]` | [4xx] | `[message shown to caller]` |

---

## 📊 Progress Tracking

| Layer | Status | Notes |
|-------|--------|-------|
| Domain Models & Tests | 📋 | Tests pass, invariants enforced |
| Application Handlers | 📋 | CQRS handlers implemented |
| Architecture Verification | 📋 | Arch checks pass |
| Infrastructure & Wiring | 📋 | Repositories & container wired |
| Interface & Routes | 📋 | Route handlers connected |
| Lint & Typecheck | 📋 | 0 errors |