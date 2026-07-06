#!/usr/bin/env bash
# Focus the agent that needs attention: blocked (waiting for input) first,
# otherwise done (finished but not yet viewed). herdr keeps an agent "done"
# until its pane is viewed, so focusing it marks the notification read.
# Shows a toast for both outcomes: switched, or nothing to switch to.
set -euo pipefail

target=$(herdr agent list | jq -r '
  [.result.agents[]
   | select((.focused | not) and (.agent_status == "blocked" or .agent_status == "done"))]
  | sort_by(if .agent_status == "blocked" then 0 else 1 end)
  | .[0] // empty
  | [.pane_id, .agent_status, (.agent // "agent")]
  | @tsv
')

if [ -z "$target" ]; then
  herdr notification show "no unread agents" >/dev/null 2>&1 || true
  exit 0
fi

IFS=$'\t' read -r pane status agent <<<"$target"
herdr agent focus "$pane" >/dev/null

case "$status" in
blocked) label="needs input" ;;
*) label="done" ;;
esac
herdr notification show "→ ${agent}: ${label}" --body "$pane" >/dev/null 2>&1 || true
