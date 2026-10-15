# Agents.md Maintainer

A skill for maintaining and optimizing AGENTS.md files to ensure they stay aligned with industry best practices.

## 📂 Structure

```
agents-maintainer/
├── SKILL.md                    # Main skill definition
├── README.md                   # This file
├── references/
│   └── best-practices.md       # Industry best practices reference
├── templates/
│   ├── agents-sections.md      # AGENTS.md section templates
│   └── validation-checklist.md # Validation checklist template
└── guides/
    ├── audit-guide.md          # How to audit AGENTS.md
    └── update-guide.md         # How to update AGENTS.md
```

## 🎯 Use Cases

### Audit AGENTS.md
```
Read: references/best-practices.md
Read: templates/validation-checklist.md
Follow: guides/audit-guide.md
```

### Update AGENTS.md
```
Read: templates/agents-sections.md
Follow: guides/update-guide.md
```

### Validate Changes
```
Read: templates/validation-checklist.md
Score: Apply rubric
```

### Generate New Content
```
Read: templates/agents-sections.md
Use: Section templates
Follow: guides/update-guide.md
```

## 📚 Key References

| Resource | Purpose |
|----------|---------|
| `references/best-practices.md` | Industry standards from Marmelab, AI-Agent-Standards, OWASP |
| `templates/agents-sections.md` | Ready-to-use templates for all sections |
| `templates/validation-checklist.md` | Scoring rubric and validation criteria |
| `guides/audit-guide.md` | Step-by-step audit process |
| `guides/update-guide.md` | How to make improvements |

## 🔄 Workflow

1. **Audit** - Use audit guide to assess current state
2. **Plan** - Identify what needs updating
3. **Update** - Use templates to make changes
4. **Validate** - Use validation checklist to verify quality
5. **Document** - Record changes in changelog

## 📊 Quality Standards

A good AGENTS.md should score **80+** on the validation checklist:

| Score | Rating |
|-------|--------|
| 90-100 | Excellent |
| 75-89 | Good |
| 60-74 | Fair |
| Below 60 | Poor |

## 🛠️ Integration

This skill integrates with:
- `adr-create` / `adr-amend` / `adr-validate` - Reference ADRs in architecture sections
- Project documentation - Keep guidelines aligned
- CI/CD - Enforce rules through automated checks

---

**Last Updated**: 2026-06-25  
**Version**: 1.0.0