# Claude Code + Cursor Configuration

Use this when you have both Claude Code and Cursor in your environment.

## Structure

```
dot-claude/                    → rename to .claude
├── CLAUDE.md                  # Lean root file with core principles
├── agent_docs/                # Detailed reference docs (read on demand)
│   ├── coding-patterns.md     # TypeScript patterns with examples
│   ├── anti-patterns.md       # AI-specific mistakes to avoid
│   ├── error-handling.md      # Error handling conventions
│   ├── testing-patterns.md    # How to write testable code
│   ├── bug-investigation.md   # 6-step debugging protocol
│   └── code-review-checklist.md # Prioritized review checklist
├── commands/
│   ├── fix-types.md           # /cust-fix-types - Fix TS errors without any
│   ├── review-diff.md         # /cust-review-diff - Review for AI patterns
│   ├── simplify.md            # /cust-simplify - Reduce complexity
│   ├── analyze-bug.md         # /cust-analyze-bug - Root cause analysis
│   ├── plan-feature.md        # /cust-plan-feature - Break into stages
│   └── take-notes.md          # /cust-take-notes - Capture discoveries
└── skills/
    ├── code-review/SKILL.md   # Auto-applied during code review
    ├── serverless-aws/SKILL.md
    └── typescript-patterns/SKILL.md
```

## Setup

### 1. Copy to your project

```bash
cp -r dot-claude /your/project/.claude

# Rename commands with cust- prefix for easy discovery
cd /your/project/.claude/commands
for f in *.md; do mv "$f" "cust-$f"; done
```

### 2. Enable Cursor imports (one-time)

In Cursor Settings → Rules:
- Enable "Include CLAUDE.md in context"
- Enable "Import Claude Commands"

This lets Cursor read CLAUDE.md (which references agent_docs/) and use the same `/fix-types`, `/review-diff`, `/simplify` commands.

## What Each Tool Reads

| File | Claude Code | Cursor |
|------|-------------|--------|
| `.claude/CLAUDE.md` | ✅ | ✅ (with import setting) |
| `.claude/agent_docs/*.md` | ✅ (on demand) | ✅ (via CLAUDE.md reference) |
| `.claude/commands/*.md` | ✅ | ✅ (with import setting) |
| `.claude/skills/*/SKILL.md` | ✅ | ❌ |

## Commands

All commands work in both Claude Code and Cursor (after renaming with `cust-` prefix):

- `/cust-fix-types` - Fix TypeScript errors using type guards, not `any`
- `/cust-review-diff` - Review branch diff, remove AI anti-patterns
- `/cust-simplify` - Simplify code while keeping behavior identical
- `/cust-analyze-bug` - Systematic root cause analysis for stubborn bugs
- `/cust-plan-feature` - Break complex features into implementable stages
- `/cust-take-notes` - Capture technical discoveries to `docs/`

## Skills (Claude Code only)

Skills auto-activate based on context:

- **code-review** - Removes excessive comments, defensive checks, `as any` casts
- **serverless-aws** - Lambda handler patterns, secrets caching, SQS processing
- **typescript-patterns** - Type inference, runtime assertions, interface conventions

## Customization

Create `.claude/CLAUDE.local.md` for project-specific overrides.
