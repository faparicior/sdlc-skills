---
name: sdlc-guide
description: >-
  Wayfinder and router skill for the SDLC workflow.
  LOAD THIS SKILL when user mentions: what skill should I use, sdlc guide,
  how do I start, help with sdlc, what is the next step, or ask-sdlc.
disable-model-invocation: false
---

# SDLC Skills Guide & Wayfinder

I help you choose the right skill for your current task within the Spec-Driven, DDD & TDD Software Development Life Cycle.

## 🧭 Flow Router

```text
What is your immediate goal?
│
├── 🟢 A. I'm starting a brand new product / initiative from scratch
│   ├── Want an 8-step product vision & MVP canvas?   ──> /inception-workshop
│   ├── Want to break down stories & release waves?   ──> /user-story-mapping
│   └── Want a formal Product Requirements Document?  ──> /prd-workshop
│
├── 🔵 B. I have user stories/journeys and need technical specifications
│   ├── End-to-end user journeys & Mermaid flows      ──> /create-flow-documentation
│   ├── Slicing journeys into vertical feature specs  ──> /create-features
│   └── Domain model (Entities, VOs, Rules, Invariants) ─> /create-entity-lifecycle
│
├── 🟣 C. My specs and domain models are ready, time to code
│   ├── Scaffold a new Bounded Context package        ──> /create-module
│   └── Implement feature step-by-step with TDD/DDD   ──> /implement-flow
│
├── 🟠 D. I need to modify an existing, already-documented flow
│   ├── Triage tier (Light / Standard / Full)         ──> /modify-flow
│   └── Brownfield/Legacy code needs specs extracted   ──> /reverse-engineer-domain
│
├── 🏛️ E. I need to make or evolve an architectural decision
│   ├── Record a new Architectural Decision Record    ──> /adr-create
│   ├── Amend an existing ADR non-destructively       ──> /adr-amend
│   ├── Benchmark technology stack & 2026 standards   ──> /adr-review-alternatives
│   └── Score ADR quality and compliance              ──> /adr-validate
│
└── 🔍 F. I need to explore the system or audit documentation health
    ├── Query flows, business rules, or events        ──> /explore-domain
    ├── Check if code has drifted from living docs     ──> /audit-docs
    └── Audit and maintain agent instructions/rules   ──> /agents-maintainer
```

## How to interact

Tell me what you are working on or what stage of development you are in, and I will recommend the exact skill command and parameters to invoke.
