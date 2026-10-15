# AGENTS.md Section Templates

Reusable templates for building comprehensive AGENTS.md files.

## 📋 Complete AGENTS.md Template

```markdown
# [Project Name] Agent Guidelines

Runtime instructions for AI coding agents. See `docs/` for detailed documentation.

## 🛠️ Commands

```bash
# Development
npm run dev              # Start dev server

# Testing
npm test                 # Run all tests
npx vitest run           # Run Vitest tests

# Quality
npm run typecheck        # Type checking
npm run lint             # ESLint
npm run lint:fix         # Auto-fix linting

# Build
npm run build            # Build app
npm run start            # Start production server
```

## 🚦 Boundaries

**✅ Always do:**
- [Actionable rule 1]
- [Actionable rule 2]
- [Actionable rule 3]

**⚠️ Ask first:**
- [Decision requiring human input 1]
- [Decision requiring human input 2]

**🚫 Never do:**
- [Prohibited action 1]
- [Prohibited action 2]
- [Prohibited action 3]

## 📁 Project Structure

```
src/
├── app/                    # Framework routing only
├── domains/                # Business logic (vendor-agnostic)
│   └── [domain]/
│       ├── entities/      # Core entities
│       ├── value-objects/ # Value objects
│       ├── services/      # Domain services
│       └── repositories/  # Repository interfaces
├── application/            # Use cases
├── infrastructure/         # External implementations
│   ├── external/          # Third-party services
│   └── database/          # Database repositories
└── interfaces/            # Web and API entry points

docs/                       # Documentation
tests/                      # Tests
```

## 💻 Code Style

### Language Guidelines
```[language]
// ✅ Good - Explicit types, clear naming
[example code]

// ❌ Bad - Implicit, unclear
[anti-pattern code]
```

### Naming Conventions
| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserForm.tsx` |
| Functions | camelCase | `validateInput()` |
| Constants | UPPER_SNAKE_CASE | `MAX_LENGTH` |
| Types/Interfaces | PascalCase | `UserInput` |
| Files (components) | PascalCase | `UserForm.tsx` |
| Files (features) | kebab-case | `user-service.ts` |

### Error Handling
```[language]
// ✅ Good - Structured error handling
try {
  const result = validate(input);
  return { success: true, data: result };
} catch (error) {
  if (error instanceof ValidationError) {
    return { success: false, errors: error.flatten() };
  }
  console.error('Unexpected error:', error);
  return { success: false, message: 'An error occurred' };
}
```

## 🧪 Testing Guidelines

### Test Organization
- **Unit tests**: `tests/unit/[domain]/[feature].test.ts`
- **Integration tests**: `tests/integration/[feature].test.ts`
- **E2E tests**: `tests/e2e/[feature].spec.ts`

### Test Example
```typescript
import { describe, it, expect } from 'vitest';
import { [Feature] } from '@/domains/[domain]';

describe('[Feature]', () => {
  it('handles valid input correctly', () => {
    const result = [Feature].create(validInput);
    expect(result.isSuccess).toBe(true);
  });

  it('rejects invalid input', () => {
    const result = [Feature].create(invalidInput);
    expect(result.isFailure).toBe(true);
  });
});
```

## ✅ Definition of Done

A task is complete when ALL of the following pass:

1. ✅ All unit tests pass
2. ✅ E2E tests pass
3. ✅ No linting errors
4. ✅ Type checking passes
5. ✅ Code coverage ≥ 80% for new code
6. ✅ Changes committed with conventional commit format

## 📚 Documentation

| Topic | Location |
|-------|----------|
| Architecture | `docs/ARCHITECTURE.md` |
| Architecture Decisions | `docs/adr/README.md` |
| Testing Strategy | `docs/TESTING.md` |
| API Design | `docs/API-DESIGN.md` |

## 🏛️ Architecture Principles

- **[Principle 1]**: [Description]
- **[Principle 2]**: [Description]
- **[Principle 3]**: [Description]

## 🧠 Karpathy Principles for AI Agents

| # | Principle | Core Rule | Prevents |
|---|-----------|-----------|----------|
| 1 | **Think Before Coding** | Surface assumptions, present alternatives | Wrong solutions |
| 2 | **Simplicity First** | Minimum code, no speculative features | Over-engineering |
| 3 | **Surgical Changes** | Touch only what you must | Scope creep |
| 4 | **Goal-Driven Execution** | Define verifiable success criteria | Ambiguous outcomes |
| 5 | **DRY & Reusability** | Search before creating | Duplicate code |
| 6 | **Code Organization** | Keep files <300 LOC | Monolithic files |

### Think Before Coding Workflow

**Before writing any code, agents must:**

1. **Understand the Task**
   - Restate the requirement
   - Identify ambiguities
   - Ask clarifying questions if needed

2. **Plan the Solution**
   - Outline approach step by step
   - Identify files to be modified
   - Consider edge cases

3. **Check Existing Code**
   - Search for similar implementations
   - Review related documentation
   - Look for reusable components

4. **Present Your Plan**
   - Share approach before coding
   - Get confirmation for complex tasks
   - Adjust based on feedback

### Search-First Requirement

**Before creating new code:**
- Use search tools to find existing functionality
- Check domain layer for existing patterns
- Review existing tests for guidance
- **Only create new code if nothing suitable exists**

### File Size Guidelines

- **Maximum 300 lines per file** (excluding tests)
- If a file exceeds this:
  - Extract related functionality into separate modules
  - Create value objects for complex data structures
  - Split into multiple focused files
- **Exception**: Test files can be larger for complex features

## 📝 Git Workflow

**Branch naming:**
- `feat/[short-description]` - New functionality
- `fix/[short-description]` - Bug fixes
- `chore/[short-description]` - Config changes

**Commit format:**
```
[type]: [description in imperative mood]

Examples:
feat: add event creation endpoint
fix: validate CFP dates in event form
chore: update dependencies
```

**PR requirements:**
- One logical change per PR
- Tests pass and coverage maintained
- Linting and type checking pass
- Conventional commit message

---

*Last updated: [DATE]*
```

## 🎨 Section Templates

### Karpathy Principles Section
```markdown
## 🧠 Karpathy Principles for AI Agents

| # | Principle | Core Rule | Prevents |
|---|-----------|-----------|----------|
| 1 | **Think Before Coding** | Surface assumptions, present alternatives | Wrong solutions |
| 2 | **Simplicity First** | Minimum code, no speculative features | Over-engineering |
| 3 | **Surgical Changes** | Touch only what you must | Scope creep |
| 4 | **Goal-Driven Execution** | Define verifiable success criteria | Ambiguous outcomes |
| 5 | **DRY & Reusability** | Search before creating | Duplicate code |
| 6 | **Code Organization** | Keep files <300 LOC | Monolithic files |
```

### Boundaries Section
```markdown
## 🚦 Boundaries

**✅ Always do:**
- Run tests before commits
- Fix linting errors
- Add type hints to all new functions
- Use [validation library] for input validation
- Follow [architecture pattern] layer boundaries

**⚠️ Ask first:**
- Database schema changes
- Adding new dependencies
- Changing authentication strategy
- Modifying API contracts

**🚫 Never do:**
- Commit secrets or API keys
- Push directly to main branch
- Skip tests or linting
- Use `any` type without justification
- Touch `node_modules/` directory
```

### Testing Guidelines Section
```markdown
## 🧪 Testing Guidelines

### Test Organization
- **Unit tests**: `tests/unit/[domain]/[feature].test.ts`
- **Integration tests**: `tests/integration/[feature].test.ts`
- **E2E tests**: `tests/e2e/[feature].spec.ts`

### Definition of Done
1. ✅ All unit tests pass
2. ✅ E2E tests pass
3. ✅ Code coverage ≥ 80%
4. ✅ No linting errors
5. ✅ Type checking passes
```

### Architecture Principles Section
```markdown
## 🏛️ Architecture Principles

- **[Pattern]**: [Description with benefits]
- **[Pattern]**: [Description with benefits]
- **[Pattern]**: [Description with benefits]
```

---

**Last Updated**: 2026-06-25
**Template Version**: 1.0.0