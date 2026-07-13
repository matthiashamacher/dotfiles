---
name: fix-my-prs
description: Fix all open PRs authored by the user — failing pipelines and coderabbitai review comments — each in an isolated git worktree. Use when the user says "fix my PRs", "check my pull requests", or invokes /fix-my-prs.
---

# Fix My PRs

Fix every open PR authored by the user in the current repository: failing CI checks and unresolved coderabbitai comments. Work in git worktrees so the local checkout is never polluted.

## Steps

1. **List PRs**
   ```bash
   gh pr list --author "@me" --state open --json number,title,headRefName,url
   ```
   If empty: report and stop.

2. **Per PR — gather state**
   ```bash
   gh pr checks <number>
   gh pr view <number> --comments
   gh api repos/{owner}/{repo}/pulls/<number>/comments --jq '.[] | select(.user.login=="coderabbitai[bot]") | {path, line, body}'
   ```
   Skip PRs that are green and have no unaddressed coderabbitai comments.

3. **Per PR — worktree**
   ```bash
   git fetch origin
   git worktree add ../<repo>-pr<number> <headRefName>
   ```
   All work happens inside that worktree.

4. **Fix**
   - Failing checks: fetch logs with `gh run view <run-id> --log-failed`, fix root cause, run the failing check locally if possible (linter, tests) before pushing.
   - coderabbitai comments: address each valid suggestion; skip invalid ones (note why in the summary).
   - If the PR has merge conflicts with its base: merge the base branch in and resolve.

5. **Push & verify**
   Commit with a conventional message (no attribution lines), push, then poll `gh pr checks <number> --watch` until green or a new failure appears. One re-fix iteration per PR if the first push doesn't go green; after that, report the remaining failure instead of looping.

6. **Cleanup & report**
   Remove each worktree (`git worktree remove ../<repo>-pr<number>`). Final summary per PR: what was fixed, which comments were addressed vs skipped and why, final check status.

## Rules

- Never commit to the user's current checkout — worktrees only.
- Don't resolve/reply to coderabbitai comment threads on GitHub unless asked; fixing the code is enough.
- Don't merge PRs.
