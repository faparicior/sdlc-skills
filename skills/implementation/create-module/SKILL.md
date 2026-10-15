---
name: create-module
description: >-
  Scaffold a new DDD module as a Turborepo workspace package.
  USE THIS SKILL when user mentions: create module, add module,
  scaffold module, new module, register module, @sessioflow/xxx package,
  module boilerplate, or any request to create a new package under
  packages/modules/ as a buildable, wired Turborepo workspace.
  Creates package.json, tsconfig.json, .gitignore, and container.ts.
  Domain content (entities, value objects, CQRS handlers) is handled by
  create-entity-lifecycle and implement-flow skills.
disable-model-invocation: true
---

# Create Module Skill

Scaffold a new DDD module as a buildable Turborepo workspace package.

This skill creates exactly four files in `packages/modules/{context}/`.
No domain content — just the packaging and wiring infrastructure so the
module can be built, tested, and imported by other packages immediately.

**Important**: Follow AGENTS.md for all code conventions and quality standards.
Domain content scaffolding (entities, value objects, CQRS, controllers) is
handled by `create-entity-lifecycle` and `implement-flow` skills.

---

## 📋 Prerequisites

Before running, confirm:

- [ ] Module name is decided (kebab-case for folder, e.g. `sessions`)
- [ ] The context doesn't already exist under `packages/modules/`
- [ ] Shared packages exist (`@sessioflow/shared-*`)

If unsure, ask the user.

---

## 🧠 Think Before Coding

Follow AGENTS.md Karpathy principles:

1. **Understand** — what is the module's purpose?
2. **Plan** — which files, what content
3. **Check** — verify no existing module covers this context
4. **Execute** — create the four files, run validation

---

## 📦 Output

| File | Path | Purpose |
|------|------|---------|
| package.json | `packages/modules/{context}/package.json` | Workspace package manifest |
| tsconfig.json | `packages/modules/{context}/tsconfig.json` | TypeScript project config |
| .gitignore | `packages/modules/{context}/.gitignore` | Ignore build artifacts |
| container.ts | `packages/modules/{context}/src/container.ts` | Composition root (wiring scaffold) |

---

## 🛠️ Step-by-Step

### Step 1: Create directory

```bash
mkdir -p packages/modules/{context}/src
```

### Step 2: Create package.json

Generate from template. Replace `{context}` with the kebab-case context name.

### Step 3: Create tsconfig.json

Generate from template. The `references` list must include all four shared
packages: `bus`, `database`, `domain`, `logging`.

### Step 4: Create .gitignore

Generate from template (standard npm/node/gitignore).

### Step 5: Create container.ts

Generate from template. This is the wiring scaffold:
- Imports shared bus/middleware types
- Defines factory methods for handlers with default repository injection
- Creates a mediator with command bus + query bus + logging middleware
- Creates HTTP controller wrappers with auth injection
- Supports dependency injection (pass a mock for testing)

No domain types are imported — that's filled in later by the domain skills.

### Step 6: Validate

```bash
# Register workspace
npm install

# Type-check (should pass — no domain code yet)
npx turbo typecheck --filter=@sessioflow/{context}

# Build (should pass — container compiles fine)
npx turbo build --filter=@sessioflow/{context}
```

---

## 📄 Templates

All templates use `{context}` placeholder (kebab-case module name).

### package.json

```json
{
  "name": "@sessioflow/{context}",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "exports": {
    "./container": "./dist/container.js",
    "./domain/*": "./dist/domain/*.js",
    "./application/*": "./dist/application/*.js",
    "./infrastructure/*": "./dist/infrastructure/*.js",
    "./interfaces/*": "./dist/interfaces/*.js"
  },
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@sessioflow/bus": "*",
    "@sessioflow/shared-database": "*",
    "@sessioflow/shared-domain": "*",
    "@sessioflow/shared-logging": "*",
    "drizzle-orm": "^0.45.2",
    "zod": "^4.4.3"
  },
  "devDependencies": {
    "@sessioflow/tsconfig": "*",
    "typescript": "^5"
  }
}
```

**Key fields:**
- `"private": true` — not published to npm registry
- `"type": "module"` — ESM output; all imports use `.js` extension
- `"exports"` — granular subpath exports per DDD layer
- Dependencies use `"*"` — workspace resolution aligns versions automatically

### tsconfig.json

```json
{
  "extends": "../../config/tsconfig/base.json",
  "compilerOptions": {
    "rootDir": "src",
    "outDir": "dist",
    "composite": true
  },
  "include": ["src/**/*"],
  "references": [
    { "path": "../../shared/bus" },
    { "path": "../../shared/database" },
    { "path": "../../shared/domain" },
    { "path": "../../shared/logging" }
  ]
}
```

**Key fields:**
- `"extends"` — shares compiler options with all other packages
- `"composite": true` — enables project references for incremental builds
- `"references"` — declares cross-package type dependencies; TypeScript compile order

### .gitignore

```gitignore
# Build artifacts
dist/
```

### container.ts

```typescript
import {
  InMemoryCommandBus,
  InMemoryQueryBus,
  LoggingMiddleware,
  Mediator,
} from '@sessioflow/bus';
import type { OutboxRepository } from '@sessioflow/shared-database/outbox-repository';
import { DrizzleOutboxRepository } from '@sessioflow/shared-database/outbox-repository';

// ──────────────────────────────────────────────────────────────
// TODO: Import domain types, handlers, repositories, and HTTP controllers.
//
// Example:
//   import { type {Entity}Repository } from './domain/{entity}-repository.interface.js';
//   import { Create{Entity}Handler } from './application/commands/create-{context}/create-{entity}.handler.js';
//   import { create{Entity}Controller } from './interfaces/http/{entity}.controller.js';
// ──────────────────────────────────────────────────────────────

/**
 * {Context} Module Container (Composition Root).
 *
 * Wires Application Use-Cases & HTTP Controllers with
 * default Infrastructure Repositories.
 */
export const {context}Container = {
  /**
   * Create the CQRS mediator with command & query buses.
   */
  createMediator(): Mediator {
    const commandBus = new InMemoryCommandBus();
    const queryBus = new InMemoryQueryBus();
    const loggingMiddleware = new LoggingMiddleware();

    commandBus.use(loggingMiddleware);
    queryBus.use(loggingMiddleware);

    // TODO: Register commands and queries.
    // Example:
    //   commandBus.register(Create{Entity}Command, this.create{Entity}Handler());

    return new Mediator(commandBus, queryBus);
  },

  /**
   * Create the HTTP POST controller.
   */
  createController(
    getAuthUser: () => Promise<{ id: string } | undefined> = async () => ({ id: 'mock-user-id' }),
  ) {
    // TODO: Wire mediator + handler + auth to controller.
    // Example:
    //   const mediator = this.createMediator();
    //   const busHandler = {
    //     execute: (command) => mediator.send<Create{Entity}Command, Create{Entity}Response>(command),
    //   };
    //   return create{Entity}HttpController(request, busHandler, getAuthUser);

    throw new Error('Not implemented — wire in the handler step');
  },
};
```

**What this gives you:**
- A factory function (`createMediator`) that wires buses, middleware, and (later) handlers
- A controller factory (`createController`) for HTTP endpoints
- Dependency injection support: pass mock repositories for testing
- TODO markers to guide domain integration

---

## 📐 What You Get

After this skill runs, the module is:

| Capability | Status |
|-----------|--------|
| Workspace package | ✅ Discovered by npm workspaces |
| TypeScript compilable | ✅ Compiles to `dist/` |
| Turbo buildable | ✅ `npx turbo build --filter=@sessioflow/{context}` |
| Importable by other packages | ✅ Via granular `exports` |
| Domain content | ❌ (not yet — add via `create-entity-lifecycle` / `implement-flow`) |
| Tests | ❌ (not yet — add when domain code exists) |

---

## 🚫 Anti-Patterns

| Anti-Pattern | Correct Approach |
|-------------|-----------------|
| Skip `"private": true` | Packages under `packages/modules/` are internal only |
| Use `"main": "./dist/index.js"` | Use granular `exports` subpaths, not a barrel export |
| Hardcode shared package versions | Use `"*"` — workspace resolution keeps versions aligned |
| Omit `"composite": true` | Required for project references and incremental builds |
| Add domain code in this skill | Domain scaffolding is handled by `create-entity-lifecycle` and `implement-flow` |
| Forget `.js` extension in imports | All internal imports MUST use `.js` (ESM rule) |

---

## 📚 Related Skills

| Skill | When to use |
|-------|-------------|
| `create-entity-lifecycle` | After this module is wired — create domain entities, value objects, state machines |
| `implement-flow` | After domain exists — implement CQRS commands, queries, handlers, controllers |
| `modify-flow` | To change existing module structure or behavior |

---

**Last Updated:** 2026-07-14  
**Version:** 1.0
