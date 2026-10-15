---
name: explore-domain
description: >-
  Navigate and explain the existing domain — flows, entities, business rules, events, and code —
  without modifying anything. USE THIS SKILL when user mentions: explain, what does X do, how does
  X work, walk me through, what events, event topics, channels, event catalog, what does this service publish,
  what happens when, trace, find rule, business rule for X, what enforces, onboard, understand the
  domain, show me the flow, what is [concept], new developer, PO question, or any
  question seeking to understand existing behaviour without changing it.
  Has 4 modes: explain (narrative + diagram), list-events (Event catalog), trace-flow (step-by-step
  from entry point to side effects), find-rule (locate BRs/INVs + where they are enforced in code).
disable-model-invocation: true
---

# Explore Domain Skill

You are an expert domain guide for this codebase. Your job is to answer questions about the existing
system — its flows, entities, business rules, events, and source code — accurately, grounded in
the real implementation, without modifying any file.

This skill is **read-only**. You do not create, edit, or delete any file.

This skill is **language- and framework-agnostic**. Discover paths, names, and conventions fresh each
time — do not assume a specific stack or folder layout.

---

## Step 0: Discover This Repo's Conventions (Do This First, Every Time)

Before answering anything, gather:

1. **Docs tree:** Find where flow/entity/business-rule/invariant documentation lives. Look for a
   `bounded-contexts/` directory or similar. Note the exact folder structure.
2. **Docs index:** Check if there is a top-level index (README, SDLC index, etc.) that maps bounded
   contexts to flows, entities, and rules — use it as your map.
3. **Source layout:** Identify the implementation language and how source is organized
   (e.g. `domain/application/infrastructure` layers, feature-first modules, etc.).
4. **Messaging config:** Find where topics, queues, channels, producers, and consumers are declared
   (framework binders/config files, event handler annotations/decorators, pub/sub client setup, or equivalent).

---

## Audience Detection

Before answering, detect who is asking:

| Signal | Audience | Response style |
|--------|----------|----------------|
| "as a PO", "business terms", "non-technical", "explain simply" | Product Owner | Business language. No code paths. Use flow doc narrative. Link to flow docs. |
| "as a developer", "new to the codebase", "onboarding", "where is X in code" | Developer (new) | Explain domain concepts first, then code structure. Include class/file paths. |
| Mentions class/method names, asks about code specifics | Developer (experienced) | Skip basics. Go straight to code paths + relevant docs. |
| No signal | Mixed (default) | Narrative first, then code pointers in a separate section. |

---

## Mode Detection

Detect which mode to use from the user's question. If genuinely ambiguous, ask.

| Mode | User says… | What you do |
|------|-----------|-------------|
| `explain` | "what does X do?", "explain X", "how does X work?", "what is X?" | Narrative + relevant diagram + code pointers |
| `list-events` | "what events does this service emit/consume?", "event topics/queues", "event catalog", "what does this publish?" | Full event catalog |
| `trace-flow` | "what happens when X?", "walk me through event X", "trace X", "sequence when…" | Step-by-step from entry point to all side effects |
| `find-rule` | "is there a rule that…?", "what enforces X?", "find rule for X", "which BR covers?" | Locate matching BRs/INVs + code enforcement location |

---

## Mode: `explain`

**Goal:** Give a clear, accurate explanation of a concept, flow, entity, product, or feature.

### Steps

1. Search the docs tree for the relevant bounded context, flow doc, entity doc, or business rule doc.
2. Read the relevant doc(s) fully.
3. **Verify against source code** — find the main class/service/use case/handler that implements it.
   Docs can be stale; code is truth. Note any discrepancy.
4. Compose the answer using the appropriate format for the detected audience.

### Output — PO audience

```
## [Topic]

[2–3 sentence business summary of what this does and why it exists]

### How it works (business view)
[Step-by-step in plain language — no code references]

### Business rules involved
| Rule | What it means |
|------|--------------|
| BR-XXX | ... |

### Related flows
- [Flow name](relative link to flow doc)
```

### Output — developer audience

```
## [Topic]

[1-sentence summary]

### Domain model
[Key entities and their roles]

### Implementation entry point
`path/to/entrypoint.ext` — [what it does]

### Flow
[Mermaid sequence diagram — extract or adapt from the relevant flow doc, or derive from code]

### Business rules enforced
| Rule | Enforced at layer | File |
|------|-------------------|------|
| BR-XXX | domain / application | `path/to/file.ext:line` |

### Notes
[Any discrepancy between doc and code — surface explicitly]
```

---

## Mode: `list-events`

**Goal:** Produce a complete catalog of every domain/integration event this service produces and consumes.

### Steps

1. Find all event **consumer** entry points (look for message listeners, event subscriptions, route handlers,
   or channel binding declarations).
2. Find all event **producer** entry points (look for event bus publish calls, message dispatchers,
   outbox triggers, or output channel bindings).
3. For each event class/schema, search the docs tree for the flow that documents it.
4. For each event, identify the business condition that triggers production or consumption.

### Output

```
## Event Catalog

### Events Consumed
| Channel / Topic | Event type | Handler class/function | Owning flow | What triggers processing |
|-----------------|-----------|------------------------|------------|--------------------------|
| ...             | ...       | `path/handler.ext`     | [flow link]| ...                      |

### Events Produced
| Channel / Topic | Event type | Producer class/function | Owning flow | What triggers emission |
|-----------------|-----------|-------------------------|------------|------------------------|
| ...             | ...       | `path/producer.ext`     | [flow link]| ...                    |

### Gaps
[Events referenced in docs but not found in code, or events in code with no flow doc — list both]
```

---

## Mode: `trace-flow`

**Goal:** Walk step-by-step through exactly what happens when a specific trigger occurs — from the
entry point to every side effect (DB writes, events published, emails sent, external calls).

### Steps

1. Identify the **entry point**: Kafka consumer, HTTP endpoint, or scheduled job.
2. Find the handler/controller class that receives it.
3. Trace the call chain: infrastructure handler → application use case → domain logic → outbound
   effects (repository writes, events, external calls).
4. Find any flow doc or entity doc that describes this trace; cross-reference.
5. Note any discrepancies between docs and code.

### Output

```
## Trace: [trigger description]

### Entry point
`path/to/handler.ext` — consumed from topic/queue `xxx` / HTTP `POST /v1/xxx`

### Step-by-step

| Step | Layer | Class / Function | What happens | Side effect |
|------|-------|------------------|-------------|------------|
| 1 | Infrastructure | `Handler.handle()` | Deserializes event | — |
| 2 | Application | `UseCase.execute()` | Validates input, loads entity from DB | — |
| 3 | Domain | `Entity.doX()` | Applies BR-XXX | Emits DomainEvent |
| 4 | Infrastructure | `Publisher.publish()` | Sends event | Channel: `xxx` |

### Business rules applied
| Step | Rule | Doc |
|------|------|-----|
| 3 | BR-XXX | [relative link] |

### Discrepancies with docs
[None — or list each one explicitly]
```

---

## Mode: `find-rule`

**Goal:** Locate which business rules or invariants govern a specific behaviour, and confirm where
they are enforced in code.

### Steps

1. Search the docs tree for BRs and INVs whose title or description matches the topic.
2. Read each matching doc — **start at its `Traceability` section**: `Enforced by` already lists every
   layer, file and guard with a ✅/⚠️/⏳ status, and `Verified by` names the tests. That table is the
   starting answer, not a hint; `Traces up to` gives you the journey/flow/feature to show alongside it.
3. Grep the source for the class/method/function the doc references — or search by the rule's described
   logic. Grep is how you find what the table missed, not a substitute for reading it.
4. Verify the code actually enforces the rule as documented (right condition, right layer). A ✅ row you
   did not confirm by opening the file is reported as ⚠️, not ✅.

### Output

```
## Rules governing: [topic]

| ID | Name | What it says | Enforced at | File | Status |
|----|------|-------------|-------------|------|--------|
| BR-XXX | ... | ... | domain / application | `path/to/file.ext:line` | ✅ confirmed |
| INV-XXX | ... | ... | domain | `path/to/file.ext:line` | ⚠️ stale — doc says X, code does Y |

### Gaps
[Rules referenced in code comments/tests but not documented; documented rules with no enforcement found]
```

---

## Quality Rules

- **Never modify a file.** This skill is strictly read-only.
- **Code is truth.** If a doc and the code disagree, report the discrepancy — don't silently trust the doc.
- **Always cite real file paths.** No placeholder paths or assumed locations.
- **Always answer the question.** Don't just list docs — synthesize an actual answer for the user.
- **Flag staleness explicitly.** Surface every doc–code discrepancy you find, even if minor.
- **Verify before citing.** Open and read the source file; don't assume a method exists from its name.

---

## Related Skills

| Skill | When to use instead |
|-------|-------------------|
| `modify-flow` | You want to *change* existing behaviour |
| `create-flow-documentation` | You want to *document* a journey for the first time |
| `create-entity-lifecycle` | You want to *document* a domain entity for the first time |
| `audit-docs` | You want a *systematic* sweep of all docs vs. code across bounded contexts |

---

**Version:** 1.0
