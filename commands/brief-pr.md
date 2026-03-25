# Brief PR

Create a pull request with a brief summary and bullet points of changes.

**Usage**: `/brief-pr [base-branch] [--publish]`
- `base-branch` (optional): Target branch for the PR (defaults to develop or main)
- `--publish` (optional): Create a regular PR instead of a draft

## Pre-computation

```bash
# Parse arguments
ARGS=($ARGS)
CUSTOM_BASE=""
DRAFT_FLAG="--draft"

for arg in "${ARGS[@]}"; do
  if [[ "$arg" == "--publish" ]]; then
    DRAFT_FLAG=""
  elif [[ -z "$CUSTOM_BASE" && "$arg" != --* ]]; then
    CUSTOM_BASE="$arg"
  fi
done

# Determine base branch
if [[ -n "$CUSTOM_BASE" ]]; then
  BASE_BRANCH="$CUSTOM_BASE"
else
  BASE_BRANCH=$(git rev-parse --verify origin/develop 2>/dev/null && echo "develop" || echo "main")
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_STATUS=$(git status --short)
GIT_DIFF=$(git diff ${BASE_BRANCH}...HEAD --stat)
COMMIT_LOG=$(git log ${BASE_BRANCH}..HEAD --oneline)
IS_PUSHED=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null && echo "yes" || echo "no")
SHORTCUT_ID=$(echo ${CURRENT_BRANCH} | grep -oE 'sc-[0-9]{5,6}' | head -1 | sed 's/sc-//')
DRAFT_STATUS=$(if [[ -n "$DRAFT_FLAG" ]]; then echo "Draft PR"; else echo "Published PR"; fi)
```

**Base branch**: {{BASE_BRANCH}}
**Current branch**: {{CURRENT_BRANCH}}
**Pushed to remote**: {{IS_PUSHED}}
**PR type**: {{DRAFT_STATUS}}
**Shortcut story ID**: {{SHORTCUT_ID}}

**File changes**:
```
{{GIT_DIFF}}
```

**Commits since {{BASE_BRANCH}}**:
```
{{COMMIT_LOG}}
```

**Working tree status**:
```
{{GIT_STATUS}}
```

## Process

1. Review all changes since {{BASE_BRANCH}} (not just the latest commit)
2. If {{SHORTCUT_ID}} is present, fetch the Shortcut story to understand the motivation behind the changes
3. Write a brief PR description:
   - **Summary**: 1-3 sentences explaining the reason for the changes (use context from the Shortcut story if available)
   - **Changes**: Bullet points of what changed (less than 10 bullets, focus on "what")
4. Push to remote with `-u` flag if not already pushed
5. Create PR using (include {{DRAFT_FLAG}} in the command):
   ```bash
   gh pr create {{DRAFT_FLAG}} --base $(git rev-parse --verify origin/develop 2>/dev/null && echo "develop" || echo "main") --title "Brief title" --body "$(cat <<'EOF'
   <!-- If SHORTCUT_ID exists: https://app.shortcut.com/proxima-ai/story/{SHORTCUT_ID}/ -->

   1-3 sentences explaining the reason for the changes.

   ## Changes
   - Bullet 1
   - Bullet 2
   EOF
   )"
   ```
