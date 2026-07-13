---
name: fix-ci
description: Debug and fix a failing GitHub Actions run from its URL, then push and poll until green. Use when the user pastes a GitHub Actions run/job URL, says "CI is failing", "pipeline is red", or invokes /fix-ci <url>.
---

# Fix CI

Take a GitHub Actions run (URL argument, or the latest failing run on the current branch) and drive it to green.

## Steps

1. **Identify the run**
   - URL given: extract owner/repo and run id (`.../actions/runs/<run-id>[/job/<job-id>]`).
   - No URL: `gh run list --branch <current-branch> --limit 5` and pick the latest failure.

2. **Get failure logs**
   ```bash
   gh run view <run-id> --repo <owner>/<repo> --log-failed
   ```
   Quote the shortest decisive error line to the user. If logs are truncated or unclear, inspect the workflow file and the specific job with `gh run view <run-id> --job <job-id> --log`.

3. **Fix root cause**
   - Reproduce locally when cheap (linter, tests, build) before pushing.
   - Fix the actual cause, not the symptom — no `continue-on-error`, no disabling checks, no skipping tests, unless the user asks.
   - If the failure is infra/flaky (network timeout, runner outage): rerun instead of patching — `gh run rerun <run-id> --failed`.

4. **Push to the branch the run belongs to.** If the local checkout is on a different branch, use a worktree.

5. **Poll until resolved**
   ```bash
   gh run watch <new-run-id> --repo <owner>/<repo> --exit-status
   ```
   Green: report done with what was fixed. Red again: go back to step 2 with the new logs. Max 3 fix iterations — after that, summarize findings and remaining failure, and stop.

## Rules

- Never mark done while the run is still in progress — wait for the conclusion.
- Multiple failing jobs: fix all of them in one pass before pushing, not one push per job.
- Report every iteration briefly: what failed, what changed.
