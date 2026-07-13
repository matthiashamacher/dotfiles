#!/bin/bash
# Claude Code statusline: model | dir | git branch +adds -dels | context % | effort | caveman badge

input=$(cat)

eval "$(printf '%s' "$input" | jq -r '
  @sh "model=\(.model.display_name // "")",
  @sh "cwd=\(.workspace.current_dir // .cwd // "")",
  @sh "ctx=\(.context_window.used_percentage // "")",
  @sh "effort=\(.effort.level // "")"
')"
[ -z "$cwd" ] && cwd=$PWD

dir="${cwd/#$HOME/~}"

branch=""
adds=0
dels=0
if git -C "$cwd" rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  # staged + unstaged additions/deletions vs HEAD
  while read -r a d _; do
    [ "$a" != "-" ] && adds=$((adds + a))
    [ "$d" != "-" ] && dels=$((dels + d))
  done < <(git -C "$cwd" diff HEAD --numstat 2>/dev/null)
fi

sep=$'\033[38;5;240m|\033[0m'

# Group 1: dir (branch) +adds -dels
out=$(printf '\033[38;5;245m%s\033[0m' "$dir")
if [ -n "$branch" ]; then
  out+=" $(printf '\033[38;5;114m(%s)\033[0m' "$branch")"
  if [ "$adds" -gt 0 ] || [ "$dels" -gt 0 ]; then
    out+=" $(printf '\033[38;5;114m+%s\033[0m \033[38;5;167m-%s\033[0m' "$adds" "$dels")"
  fi
fi

# Group 2: model + effort
grp=""
[ -n "$model" ] && grp=$(printf '\033[38;5;111m%s\033[0m' "$model")
[ -n "$effort" ] && grp+="${grp:+ }$(printf '\033[38;5;140m%s\033[0m' "$effort")"
[ -n "$grp" ] && out+=" $sep $grp"

# Group 3: context % + caveman badge
grp=""
if [ -n "$ctx" ]; then
  pct=${ctx%.*}
  # green < 50, yellow < 80, red >= 80
  if [ "$pct" -ge 80 ]; then c=167; elif [ "$pct" -ge 50 ]; then c=179; else c=114; fi
  grp=$(printf '\033[38;5;%sm%s%%\033[0m' "$c" "$pct")
fi
badge=$(bash "$HOME/.claude/plugins/cache/caveman/caveman/0d95a81d35a9/src/hooks/caveman-statusline.sh" 2>/dev/null)
[ -n "$badge" ] && grp+="${grp:+ }$badge"
[ -n "$grp" ] && out+=" $sep $grp"

printf '%s' "$out"
