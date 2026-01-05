# Create PR with Concise Description

Create a pull request with a concise markdown description of changes since the base branch.

## Pre-computation

```bash
BASE_BRANCH=$(git rev-parse --verify develop 2>/dev/null && echo "develop" || echo "main")
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
GIT_STATUS=$(git status --short)
GIT_DIFF=$(git diff ${BASE_BRANCH}...HEAD --stat)
COMMIT_LOG=$(git log ${BASE_BRANCH}..HEAD --oneline)
IS_PUSHED=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null && echo "yes" || echo "no")
SHORTCUT_ID=$(echo ${CURRENT_BRANCH} | grep -oE 'sc-[0-9]{5,6}' | head -1 | sed 's/sc-//')
```

**Base branch**: {{BASE_BRANCH}}
**Current branch**: {{CURRENT_BRANCH}}
**Pushed to remote**: {{IS_PUSHED}}
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
2. Create a concise PR description with:
    - **TLDR** (If {{SHORTCUT_ID}} is present, include Shortcut link first, then 1-5 sentences describing changes and purpose)
	- **Summary** (Less than 10 bullet points, focus on "what" and "why")
    - **Technical Changes** (Describe any new technical changes that need explaining, can be omitted for conventional changes)
    - **Test Plan** (describe any tests added, omit if no tests added)
3. Push to remote with `-u` flag if not already pushed
4. Create PR using:
   ```bash
   gh pr create --draft --base {{BASE_BRANCH}} --title "Brief title" --body "$(cat <<'EOF'
   # TLDR
   <!-- If SHORTCUT_ID exists, include: https://app.shortcut.com/proxima-ai/story/{SHORTCUT_ID}/ -->

   1 - 5 Sentences describing the changes at a high-level.

   ## Summary
   - Bullet 1
   - Bullet 2

   ## Technical Changes
   - Added this feature
   - Modified that feature in order to...

   ## Test Plan
   - Description of added tests (if any)
   EOF
   )"
   ```
