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
```

**Current branch**: {{CURRENT_BRANCH}}
**Base branch**: {{BASE_BRANCH}} ({{COMMIT_COUNT}} commits ahead)

**Commits to review**:
```
{{COMMIT_LOG}}
```

## Your Task

Review the code changes below. Provide a thorough but concise review covering:

1. **Overview** - What do these changes accomplish?
2. **Code Quality** - Style, readability, maintainability issues
3. **Correctness** - Logic errors, edge cases, potential bugs
4. **Suggestions** - Specific improvements with code examples if needed
5. **Risks** - Security, performance, or compatibility concerns

Focus on actionable feedback. Skip praise for things done correctly.

## Diff

```diff
{{GIT_DIFF}}
```