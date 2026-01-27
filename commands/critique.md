# Critique Branch

Review code changes on the current branch compared to a base branch.

**Usage**: `/critique [base-branch]`
- `base-branch` (optional): Target branch to compare against (defaults to origin/develop if it exists, otherwise origin/main)

**Examples**:
- `/critique` — Review current branch against origin/develop (or origin/main)
- `/critique main` — Review current branch against origin/main

## Pre-computation

```bash
# Parse arguments
ARGS=($ARGS)
CUSTOM_BASE="${ARGS[0]:-}"

# Fetch latest to ensure accurate comparison
git fetch origin develop main 2>/dev/null || git fetch origin main 2>/dev/null || git fetch origin develop 2>/dev/null

# Determine base branch
if [[ -n "$CUSTOM_BASE" ]]; then
  # Try origin/base first, fall back to local
  if git rev-parse "origin/$CUSTOM_BASE" 2>/dev/null >/dev/null; then
    BASE_BRANCH="origin/$CUSTOM_BASE"
  else
    BASE_BRANCH="$CUSTOM_BASE"
  fi
else
  # Default: origin/develop if it exists, otherwise origin/main
  if git rev-parse origin/develop 2>/dev/null >/dev/null; then
    BASE_BRANCH="origin/develop"
  else
    BASE_BRANCH="origin/main"
  fi
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT_COUNT=$(git rev-list --count HEAD ^${BASE_BRANCH} 2>/dev/null || echo "?")
COMMIT_LOG=$(git log ${BASE_BRANCH}..HEAD --oneline 2>/dev/null)
GIT_DIFF=$(git diff ${BASE_BRANCH}...HEAD 2>/dev/null)
FILES_CHANGED=$(git diff ${BASE_BRANCH}...HEAD --name-only 2>/dev/null)
```

**Critiquing branch**: {{CURRENT_BRANCH}}
**Base branch**: {{BASE_BRANCH}} ({{COMMIT_COUNT}} commits ahead)

**Commits to review**:
```
{{COMMIT_LOG}}
```

**Files changed**:
```
{{FILES_CHANGED}}
```

## Available Tools

### Active Hooks (Auto-Enforced)
These patterns are already blocked/warned by hooks—don't waste time flagging them manually:

| Hook | Action | What it catches |
|------|--------|-----------------|
| `block-as-any` | 🚫 block | `as any` casts |
| `block-hardcoded-secrets` | 🚫 block | Secrets in string literals |
| `warn-any-type` | ⚠️ warn | `: any`, `<any>`, `any[]` |
| `warn-as-syntax` | ⚠️ warn | `as Type` (prefer `<Type>`) |
| `warn-debug-code` | ⚠️ warn | `console.log`, `debugger` |
| `warn-default-import` | ⚠️ warn | Default imports (prefer namespace) |
| `warn-foreach` | ⚠️ warn | `.forEach()` (prefer `for...of`) |
| `warn-interface-prefix` | ⚠️ warn | `interface IFoo` (drop I prefix) |

### Skills to Apply
Reference these skills for detailed pattern matching:

- **`code-review`** (`~/.claude/skills/code-review/SKILL.md`)
  - Excessive/obvious comments
  - Gratuitous defensive checks
  - Type escape hatches
  - Over-engineering
  - Verbose logging

- **`typescript-patterns`** (`~/.claude/skills/typescript-patterns/SKILL.md`)
  - Type inference vs explicit returns
  - Runtime type assertions
  - Interface vs type usage
  - Casting syntax
  - Import style

### Specialized Agents (from plugins)
Use Task tool with these agents for deep analysis:
- **`code-reviewer`** (`feature-dev` plugin): Detailed bug/logic analysis
- **`silent-failure-hunter`** (`pr-review-toolkit`): Error handling review
- **`type-design-analyzer`** (`pr-review-toolkit`): New type/interface review
- **`comment-analyzer`** (`pr-review-toolkit`): Documentation accuracy

### Follow-Up Commands
After review, consider:
- `/fix-types` - Fix TypeScript type issues
- `/simplify` - Reduce over-engineering
- `/review-diff` - Smaller focused review
- `/commit` - Commit fixes

---

## Your Task

**Run in plan mode.** Perform a comprehensive code review of the changes below and output PR-style comments.

### Review Checklist

#### 1. Overview
- What do these changes accomplish?
- Are the commits well-organized with clear messages?
- Is this a single cohesive change or should it be split?

#### 2. Code Quality & Style
- Consistent naming conventions (camelCase, PascalCase where appropriate)
- Proper TypeScript usage (avoid `any`, use strict types)
- Appropriate abstraction level (not over-engineered, not under-abstracted)
- Clean imports (no unused, properly organized)
- JSDoc comments accurate and complete where present

#### 3. Anti-Patterns to Flag
- **Dead code**: Unreachable branches, unused variables, commented-out code
- **God objects/functions**: Classes or functions doing too much
- **Primitive obsession**: Using primitives instead of domain types
- **Magic strings/numbers**: Hardcoded values that should be constants
- **Leaky abstractions**: Implementation details exposed in interfaces
- **Copy-paste code**: Duplicated logic that should be abstracted
- **Implicit dependencies**: Hidden coupling between modules
- **Mutable shared state**: Global or shared mutable objects
- **Callback hell**: Deeply nested async code instead of async/await
- **Empty catch blocks**: Swallowed errors without logging/handling

#### 4. Correctness
- Logic errors and edge cases
- Null/undefined handling
- Error handling completeness
- Race conditions in async code
- Type safety (narrowing, exhaustive checks)

#### 5. Testing
- Are new features adequately tested?
- Are edge cases covered?
- Are tests meaningful (not just for coverage)?

#### 6. Risks
- Security vulnerabilities (injection, XSS, secrets exposure)
- Performance concerns (N+1 queries, unbounded loops, memory leaks)
- Breaking changes to public APIs
- Missing backwards compatibility

---

## Output Format

Output each finding as a PR comment with file path and line number. Include ALL findings, even nits.

**Comment types by severity**:
- 🔴 **blocker**: Must fix before merge (bugs, security issues)
- 🟡 **suggestion**: Should fix (anti-patterns, maintainability)
- 🔵 **nit**: Style, naming, minor improvements (optional to address)

**Format each comment as**:
```
📍 **file/path.ts:42** [blocker|suggestion|nit]

> ```ts
> // quoted code snippet from the diff
> ```

**Issue**: Description of the problem.

**Suggestion**: How to fix it (with code example if helpful).
```

Skip praise. Focus only on actionable feedback.

---

## After Review

Once you've listed all comments, ask the user if they'd like you to fix the issues. If yes, enter plan mode to design the solutions and implement the fixes.

## Diff

```diff
{{GIT_DIFF}}
```