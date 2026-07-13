#!/bin/bash
# SessionStart hook: nudge Claude to build a graphify knowledge graph for the
# current repo if one doesn't exist yet.

cwd="${CLAUDE_PROJECT_DIR:-$PWD}"

if ! root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null); then
  exit 0
fi

if [ -f "$root/graphify-out/graph.json" ]; then
  exit 0
fi

context="No graphify knowledge graph exists yet for this repository. Run the graphify skill (invoke Skill with skill: \"graphify\") on the repo root to build one before deep codebase exploration."

jq -n --arg ctx "$context" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
