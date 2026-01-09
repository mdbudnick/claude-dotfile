# Review Branch Changes

Review code changes on the current branch compared to origin/develop or origin/main (whichever is closer).

## Pre-computation

```bash
# Fetch latest to ensure accurate comparison
git fetch origin develop main 2>/dev/null || git fetch origin main 2>/dev/null || git fetch origin develop 2>/dev/null

# Count commits to each base branch (fewer = closer)
DEVELOP_DISTANCE=$(git rev-list --count HEAD ^origin/develop 2>/dev/null || echo 999999)
MAIN_DISTANCE=$(git rev-list --count HEAD ^origin/main 2>/dev/null || echo 999999)

if [[ "$DEVELOP_DISTANCE" -le "$MAIN_DISTANCE" ]]; then
  BASE_BRANCH="origin/develop"
else
  BASE_BRANCH="origin/main"
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT_COUNT=$(git rev-list --count HEAD ^${BASE_BRANCH})
COMMIT_LOG=$(git log ${BASE_BRANCH}..HEAD --oneline)
GIT_DIFF=$(git diff ${BASE_BRANCH}...HEAD)
FILES_CHANGED=$(git diff ${BASE_BRANCH}...HEAD --name-only)
```

**Current branch**: {{CURRENT_BRANCH}}
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

Perform a comprehensive code review of the changes below.

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

### Output Format

Organize findings by severity:
- 🔴 **Critical**: Must fix before merge (bugs, security issues)
- 🟡 **Important**: Should fix (anti-patterns, maintainability)
- 🔵 **Suggestion**: Nice to have (style, minor improvements)

For each finding, provide:
1. File and line reference
2. Description of the issue
3. Specific fix or code example when applicable

Skip praise. Focus only on actionable feedback.

## Diff

```diff
{{GIT_DIFF}}
```