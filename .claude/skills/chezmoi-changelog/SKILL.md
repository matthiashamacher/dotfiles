---
name: chezmoi-changelog
description: Review upstream chezmoi releases since last check, propose and implement relevant dotfile changes, then update the version tracker. Use when user wants to stay current with chezmoi features.
trigger: /chezmoi-changelog
---

# /chezmoi-changelog

Review upstream chezmoi releases since the last tracked version, propose changes to the dotfiles repo, implement approved ones, and update the version tracker.

## Workflow

### Step 1 — Read last-reviewed version

Read `chezmoi-changelog.md` in the chezmoi source dir (default: `~/.local/share/chezmoi/`) to find the last reviewed version and date.

If the file doesn't exist, assume no version has been reviewed and fetch all releases from the last 6 months.

### Step 2 — Fetch releases since last version

Use the GitHub CLI to get all releases after the tracked version:

```bash
gh api "repos/twpayne/chezmoi/releases?per_page=50" \
  --jq '.[] | select(.tag_name > "LAST_VERSION") | {tag: .tag_name, date: .published_at[:10], body: .body}'
```

Replace `LAST_VERSION` with the version from the tracking file (e.g., `v2.70.5`).

### Step 3 — Filter for relevant changes

Scan each release's changelog. Flag items relevant to dotfiles templating:

**High relevance** (always flag):
- New template functions or variables (`.chezmoi.*`, new funcs like `stdinIsATTY`, `globCaseInsensitive`)
- Changes to existing template behavior
- New config file options
- Fixes that affect common patterns (scripts, encryption, externals)

**Medium relevance** (flag if used in this repo):
- Changes to `run_once` / `run_onchange` behavior
- External file handling changes
- Age/rage encryption changes
- 1Password integration changes

**Low relevance** (skip unless noteworthy):
- Docs-only releases
- OS-specific fixes for platforms not in use
- Internal refactors

### Step 4 — Explore the repo for impact

Before proposing, read the current dotfiles to assess impact:
- `.chezmoi.toml.tmpl` — config template
- `.chezmoidata/*.yaml` — data files
- `run_*.sh.tmpl` — script templates
- `private_dot_ssh/private_config.tmpl` — SSH config
- `dot_gitconfig.tmpl` — git config

Match each flagged changelog item against actual usage.

### Step 5 — Propose changes in plan mode

Enter plan mode. For each applicable change, propose:
- What to change and where (file + line)
- Why (which changelog item, what problem it solves)
- What to skip and why

Present a concise list. Don't propose changes with no concrete benefit.

### Step 6 — Implement approved changes

After user approves the plan, implement each change. Keep changes minimal and targeted.

### Step 7 — Update version tracker

Update `chezmoi-changelog.md` with the new latest version and today's date:

```
Last reviewed: vX.Y.Z (YYYY-MM-DD)
```

## Example Output (Step 3)

```
Releases since v2.70.5: v2.71.0, v2.71.1

v2.71.0 (2026-07-15):
  ✦ feat: Add .chezmoi.executable template variable        ← RELEVANT (template var)
  ✦ feat: Add keepassxc integration                        ← skip (using 1Password)
  - fix: Handle symlinks in source dir                     ← low impact

v2.71.1 (2026-07-22):
  - fix: Crash on empty .chezmoiexternal                   ← skip (no externals)
```

## Notes

- Chezmoi source dir is `~/.local/share/chezmoi/` on this machine
- Version tracker file: `chezmoi-changelog.md` in repo root
- Use `gh api` (not WebFetch) for GitHub releases — it's authenticated and faster
- Skip docs-only releases entirely
- Don't propose speculative changes — only concrete improvements with clear benefit
