---
name: ship
description: Run linter and tests, fix failures, then commit and open a PR (or push directly when told). Use when the user says "fix linter and tests and create a pr", "ship this", or invokes /ship. Argument "direct <branch>" pushes straight to that branch instead of a PR.
---

# Ship

Validate the working tree (lint + tests), fix what fails, and deliver the changes — PR by default, direct push when the user says so.

## Steps

1. **Detect the project's check commands** (in order):
   - Repo skill or CLAUDE.md/AGENTS.md that documents lint/test commands (e.g. elevate-pim: `bin/shell just lint`, tests inside the build container).
   - `justfile` / `Makefile` recipes (`lint`, `test`, `stan`, `cs`).
   - Language defaults: PHP → `phpstan`, `php-cs-fixer`, `phpunit`; Go → `golangci-lint run`, `go test ./...`; JS/TS → package.json scripts.

2. **Run linter, then tests.** Fix every failure at the root cause — no baseline additions, no `@phpstan-ignore`, no skipped tests unless the user asks. Re-run until both pass.

3. **Deliver**
   - Default: create a branch (`feat/...` or `fix/...` matching the change), commit with a conventional message, push, `gh pr create` with a concise body.
   - `direct <branch>` argument or user said "push directly to X": commit on that branch and push, no PR.
   - Commits: Conventional Commits, no attribution lines, no AI mentions.

4. **Verify CI.** After push, watch the triggered run (`gh pr checks --watch` / `gh run watch`). If it fails on something the local run couldn't catch, fix and push again (one iteration; then report).

## Rules

- Only commit what belongs to the change — review `git status`/`git diff` first, leave unrelated files out.
- If lint/test failures pre-exist on the base branch (verify when unsure), report them instead of silently absorbing them into this change.
