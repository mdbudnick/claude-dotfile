# Claude Configuration

Personal Claude Code configuration managed via symlinks to `~/.claude/`.

## Quick Start

```bash
git clone <repo-url> ~/code/claude-dotfile
cd ~/code/claude-dotfile
./install.sh
```

The script creates symlinks from this repo to `~/.claude/`, backing up any existing files.

## Structure

```
claude-dotfile/
├── install.sh             # Symlink installer
├── settings.json          # Claude Code settings
├── CLAUDE.md              # Project guidelines template
├── .agent_docs/           # Reference documentation
├── commands/              # Slash commands
├── hooks/                 # Hookify rules
└── skills/                # Domain skills
```

## What Gets Linked

| Source | Destination |
|--------|-------------|
| `commands/` | `~/.claude/commands/` |
| `hooks/` | `~/.claude/hooks/` |
| `skills/` | `~/.claude/skills/` |
| `.agent_docs/` | `~/.claude/.agent_docs/` |
| `settings.json` | `~/.claude/settings.json` |

## Installed Plugins

| Plugin | Commands | Purpose |
|--------|----------|---------|
| **hookify** | — | Runtime enforcement of TypeScript patterns |
| **pr-review-toolkit** | — | 6 specialized review agents |
| **commit-commands** | `/commit`, `/commit-push-pr`, `/clean_gone` | Git workflow |
| **feature-dev** | `/feature-dev` | 7-phase feature development |

## Commands

| Command | Purpose |
|---------|---------|
| `/analyze-bug` | Systematic root cause analysis using 5 Whys |
| `/create-pr` | Create PR with TLDR, summary, and test plan |
| `/critique` | Comprehensive branch review with PR-style comments |
| `/fix-types` | Fix TypeScript errors without `any` or `as any` |
| `/plan-feature` | Break features into 3-5 testable stages |
| `/review-diff` | Quick diff review to remove anti-patterns |
| `/scratchpad` | Track work in `.claude/scratchpad.md` for session continuity |
| `/simplify` | Simplify code while preserving behavior |
| `/take-notes` | Document complex discoveries in `docs/` |

## Hooks

| Hook | Action | Trigger |
|------|--------|---------|
| `block-as-any` | **block** | `as any` casts |
| `block-hardcoded-secrets` | **block** | Hardcoded API keys/passwords |
| `warn-any-type` | warn | `: any`, `<any>`, `any[]` |
| `warn-as-syntax` | warn | `as Type` (use `<Type>` instead) |
| `warn-debug-code` | warn | `console.log`, `debugger` |
| `warn-default-import` | warn | Default imports (use namespace imports) |
| `warn-foreach` | warn | `.forEach()` (use `for...of`) |
| `warn-interface-prefix` | warn | `interface IFoo` (drop I prefix) |

## Skills

| Skill | Purpose |
|-------|---------|
| `code-review` | Remove AI-generated patterns: excessive comments, gratuitous defensive checks, type escape hatches, over-engineering |
| `gemini-image-generator` | Generate images using Google Gemini (text-to-image, image-to-image, 1K/2K/4K) |
| `serverless-aws` | Patterns for Lambda handlers, DynamoDB, SQS, cold start optimization |
| `typescript-patterns` | Type inference, runtime assertions, interfaces vs types, casting syntax, import style |
| `writing-style` | Pedagogical voice for essays/articles: hook with numbers, build mental models, worked examples |

## Agent Docs

Reference documentation in `.agent_docs/`:

| File | When to Read |
|------|--------------|
| `anti-patterns.md` | Before code review or PR |
| `bug-investigation.md` | Debugging resistant issues |
| `code-review-checklist.md` | Reviewing code or preparing a PR |
| `coding-patterns.md` | Writing new TypeScript code |
| `error-handling.md` | Implementing error handling |
| `testing-patterns.md` | Writing or refactoring tests |
| `writing/writing-style-examples.md` | Examples for the writing-style skill |
