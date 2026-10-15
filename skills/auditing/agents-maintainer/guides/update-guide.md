# AGENTS.md Update Guide

How to update and improve AGENTS.md files.

## 🎯 Update Triggers

Update AGENTS.md when:

### Project Changes
- [ ] New technology introduced
- [ ] Architecture pattern changed
- [ ] Team workflow updated
- [ ] New domain added

### Lessons Learned
- [ ] Agent made repeated mistakes
- [ ] Common misunderstandings identified
- [ ] Best practices evolved
- [ ] Team feedback indicates issues

### Industry Updates
- [ ] New best practices published
- [ ] Security vulnerabilities discovered
- [ ] Tooling changes
- [ ] Framework updates

## 📝 Update Process

### Step 1: Identify What to Update

**From Audit:**
- Review audit findings
- Prioritize by impact
- Select sections to update

**From Feedback:**
- Collect agent mistakes
- Identify patterns
- Determine root causes

**From Changes:**
- List new requirements
- Identify affected sections
- Plan updates accordingly

### Step 2: Plan the Changes

**For each update:**
1. **Current State**: What exists now
2. **Problem**: Why it needs updating
3. **Solution**: What will change
4. **Rationale**: Why this solution
5. **Impact**: What this affects

### Step 3: Make the Changes

#### Adding New Sections

```markdown
## 🆕 [Section Name]

[Content with examples and guidelines]
```

#### Updating Existing Sections

**Before:**
```markdown
## Code Style

Write good code with proper formatting.
```

**After:**
```markdown
## 💻 Code Style

### TypeScript Guidelines
```typescript
// ✅ Good - Explicit types, arrow functions
interface User {
  id: UserId;
  name: UserName;
}

export const createUser = (input: CreateUserInput): Result<User> => {
  const validated = userCreateSchema.parse(input);
  return Result.ok(new User(validated));
};

// ❌ Bad - Implicit any, inconsistent style
const createUser = (input) => {
  return new User(input);
};
```
```

#### Removing Outdated Content

**Before:**
```markdown
## Deployment

Use Heroku for deployment.
```

**After:**
```markdown
## Deployment

Use Docker Compose for deployment (see ADR-003).
```

### Step 4: Validate Changes

**Check for:**
- [ ] Consistency with existing content
- [ ] No contradictions introduced
- [ ] Examples are accurate
- [ ] Language is clear
- [ ] Links and references work

### Step 5: Document Changes

**Update metadata:**
```markdown
---

*Last updated: [DATE]*
```

**Add to changelog:**
```markdown
## Changelog

### [1.1.0] - 2026-06-25
- Added Karpathy Principles section
- Updated testing guidelines
- Fixed security constraints
```

## 🎨 Section Update Templates

### Updating Boundaries

**Template:**
```markdown
## 🚦 Boundaries

**✅ Always do:**
- [Specific action 1]
- [Specific action 2]
- [Specific action 3]

**⚠️ Ask first:**
- [Decision requiring input 1]
- [Decision requiring input 2]

**🚫 Never do:**
- [Prohibited action 1]
- [Prohibited action 2]
```

**Example:**
```markdown
## 🚦 Boundaries

**✅ Always do:**
- Run tests before commits
- Fix linting errors with `npm run lint:fix`
- Add type hints to all new functions
- Use Zod for input validation
- Follow DDD layer boundaries

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

### Updating Code Style

**Template:**
```markdown
## 💻 Code Style

### Language Guidelines
```[language]
// ✅ Good
[example]

// ❌ Bad
[anti-pattern]
```

### Naming Conventions
| Type | Convention | Example |
|------|------------|---------|
| [Type 1] | [Convention] | [Example] |
| [Type 2] | [Convention] | [Example] |
```

### Updating Testing Guidelines

**Template:**
```markdown
## 🧪 Testing Guidelines

### Test Organization
- **Unit tests**: `tests/unit/[domain]/[feature].test.ts`
- **Integration tests**: `tests/integration/[feature].test.ts`
- **E2E tests**: `tests/e2e/[feature].spec.ts`

### Definition of Done
1. ✅ All unit tests pass
2. ✅ E2E tests pass
3. ✅ Code coverage ≥ [X]%
4. ✅ No linting errors
5. ✅ Type checking passes
```

### Updating Karpathy Principles

**Template:**
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

### [Principle Name] Workflow

**Before [action], agents must:**

1. **Step 1** - [Description]
2. **Step 2** - [Description]
3. **Step 3** - [Description]
```

## 🔄 Common Update Scenarios

### Scenario 1: Agent Makes Repeated Mistakes

**Problem**: Agent keeps using `any` type  
**Solution**: 
1. Add to Boundaries: "Never use `any` type without justification"
2. Add to Code Style: Example showing proper typing
3. Add to Definition of Done: "No `any` types in code"

### Scenario 2: New Technology Added

**Problem**: Project adds GraphQL  
**Solution**:
1. Add Commands: GraphQL CLI commands
2. Add Code Style: GraphQL schema and resolver patterns
3. Add Architecture Principles: GraphQL integration with DDD

### Scenario 3: Security Issue Discovered

**Problem**: Agent exposed API keys in logs  
**Solution**:
1. Add to Boundaries: "Never commit secrets or API keys"
2. Add Security section: Secrets management guidelines
3. Add examples: Proper environment variable usage

### Scenario 4: Team Workflow Changed

**Problem**: Team moved from GitFlow to Trunk-Based  
**Solution**:
1. Update Git Workflow: New branching strategy
2. Update Commands: New CI/CD commands
3. Update Definition of Done: New PR requirements

## ✍️ Writing Guidelines

### Use Clear Language
- ✅ "Run tests before committing"
- ❌ "Ensure testing happens"

### Be Specific
- ✅ "Maximum 300 lines per file"
- ❌ "Keep files small"

### Provide Examples
- ✅ Show correct and incorrect patterns
- ❌ Just state the rule

### Include Rationale
- ✅ "Use Zod for validation (consistent error handling)"
- ❌ Just "Use Zod"

### Avoid Contradictions
- Check existing sections before adding
- Cross-reference related guidelines
- Use consistent terminology

## 📊 Update Impact Assessment

| Change Type | Impact | Review Required |
|-------------|--------|-----------------|
| Adding examples | Low | Self |
| Updating examples | Low | Self |
| New section | Medium | Team |
| Changing boundaries | High | Team + Lead |
| Architecture changes | High | Full team review |

## 📝 Change Log Template

```markdown
## Changelog

### [Version] - [DATE]

#### Added
- [New feature or section]

#### Changed
- [Modified section or rule]

#### Fixed
- [Corrected issue]

#### Removed
- [Deprecated content]
```

---

**Last Updated**: 2026-06-25  
**Guide Version**: 1.0.0