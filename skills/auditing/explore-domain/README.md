# Explore Domain Skill — Summary

## Purpose

Answer any question about the existing domain — flows, entities, business rules, events, and
source code — accurately, grounded in the real implementation, **without modifying any file**.

Designed for two audiences: Product Owners who want business-level explanations, and developers
(new or experienced) who want code-level navigation.

---

## When to Use

Any time you want to *understand* the system, not change it:

- "What does [entity/feature] creation do?"
- "What events does this service emit?"
- "What happens when a resource is cancelled?"
- "Is there a rule that prevents duplicate [entities]?"
- "Walk me through the [entity] lifecycle for a new dev"

---

## 4 Modes

| Mode | Trigger phrase | Output |
|------|---------------|--------|
| `explain` | "what does X do?", "explain X", "how does X work?" | Narrative + Mermaid diagram + code pointers |
| `list-events` | "what events does this service emit/consume?", "event catalog" | Full event catalog table (consumed + produced) |
| `trace-flow` | "what happens when X?", "trace X", "walk me through event X" | Step-by-step call chain from entry point to side effects |
| `find-rule` | "find rule for X", "what enforces X?", "is there a rule that…?" | Matching BRs/INVs + code file + confirmed/stale status |

Mode is detected automatically from the question. If ambiguous, the skill asks.

---

## Guarantees

- **Read-only:** no file is ever created, modified, or deleted
- **Code-grounded:** always verifies docs against source; flags any doc–code discrepancy
- **Audience-aware:** adjusts detail level for PO vs. new dev vs. experienced dev
- **Specific:** every answer cites real file paths — no placeholder references

---

## What It Does Not Do

- It does not change behaviour → use `/modify-flow`
- It does not create new docs → use `/create-flow-documentation` or `/create-entity-lifecycle`
- It does not run a systematic audit across all docs → use `/audit-docs`

---

## Files

```
skills/explore-domain/
├── SKILL.md    # Full skill instructions
└── README.md   # This summary
```

---

**Version:** 1.0
