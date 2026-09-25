## Workflow Orchestration
### 1. Plan Mode Default
  - Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
  - Skip plan mode if the user explicitly says to proceed without planning (e.g. "just do it", "no plan needed")
  - If something goes sideways, STOP and re-plan immediately
  - Use plan mode for verification steps, not just building
  - Write detailed specs upfront to reduce ambiguity
### 2. Subagent Strategy
  - Use subagents liberally to keep main context window clean
  - Offload research, exploration, and parallel analysis to subagents
  - For complex problems, throw more compute at it via subagents
  - One task per subagent for focused execution
  - Skip subagents for single-file edits or simple lookups — direct tools are faster
### 3. Verification Before Done
  - Never mark a task complete without proving it works
  - "Proving it works" means: run tests, check logs, or demonstrate correct output in the terminal
  - Diff behavior between main and your changes when relevant
  - Ask yourself: "Would a staff engineer approve this?"
### 4. Demand Elegance (Balanced)
  - For non-trivial changes: pause and ask "is there a more elegant way?"
  - If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
  - Skip this for simple, obvious fixes -- don't over-engineer
  - Challenge your own work before presenting it
### 5. Autonomous Bug Fixing
  - When given a bug report: just fix it. Don't ask for hand-holding
  - Point at logs, errors, failing tests -- then resolve them
  - Zero context switching required from the user
  - Go fix failing CI tests without being told how

## Agent Skills Workflow
Five slash commands for structured, high-quality feature development. Use this pipeline for any non-trivial feature:

```
/grill-me → /write-a-prd → /prd-to-issues → /tdd → /improve-codebase-architecture
```

| Skill | When to use |
|-------|-------------|
| `/grill-me` | Before planning — stress-test an idea |
| `/write-a-prd` | Convert a discussion into a GitHub issue PRD |
| `/prd-to-issues` | Break a PRD into vertical-slice GitHub issues |
| `/tdd` | Implement features with red-green-refactor |
| `/improve-codebase-architecture` | Weekly architecture audit, after dev surges |

## Core Principles
- Simplicity First: Make every change as simple as possible. Impact minimal code.
- No Laziness: Find root causes. No temporary fixes. Senior developer standards.
- Minimal Impact: Only touch what's necessary. No side effects with new bugs.
- Never write this:
-- The phrase "Claude Code" or any mention that you are an AI
-- Any hint of what model or version you are
-- Co-Authored-By lines or any other attribution

## Tips
- Press `#` during a session to have Claude auto-incorporate learnings into CLAUDE.md
- Use `.claude.local.md` in any project for personal overrides (add to `.gitignore`)

## Approach
- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct. No over-engineering.
- If unsure: say so. Never guess or invent file paths.
- User instructions always override this file.

## Efficiency
- Read before writing. Understand the problem before coding.
- No redundant file reads. Read each file once.
- One focused coding pass. Avoid write-delete-rewrite cycles.
- Test once, fix if needed, verify once. No unnecessary iterations.

## Git & CI Conventions
- GitHub Actions URL pasted → run `gh run view --log-failed` immediately, no asking.
- When explicitly told to "push directly to main/develop", push to that branch instead of creating a feature branch and PR.
- After pushing a CI fix, poll the new run with `gh run watch` (or `gh run list`) until it's green or fails again — don't wait to be asked "still failing?".

## Language
- Answer in the language of the prompt (German or English). Keep technical terms, code, and error strings verbatim.
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.

@RTK.md
