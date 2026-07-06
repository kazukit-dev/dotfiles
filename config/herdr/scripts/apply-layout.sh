#!/usr/bin/env bash
# Apply a named layout template to the running herdr session via layout.apply.
# Layout templates live in ~/.config/herdr/layouts/<name>.json and hold the
# layout.apply params (tab_label, root). Pane nodes without an explicit cwd
# get the invoking pane's cwd injected at apply time.
set -euo pipefail

name="${1:?usage: apply-layout.sh <layout-name>}"
layout_file="${XDG_CONFIG_HOME:-$HOME/.config}/herdr/layouts/${name}.json"
socket="${HERDR_SOCKET_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/herdr/herdr.sock}"
cwd="${HERDR_ACTIVE_PANE_CWD:-$PWD}"

[ -f "$layout_file" ] || {
  echo "layout not found: $layout_file" >&2
  exit 1
}
[ -S "$socket" ] || {
  echo "herdr socket not found: $socket" >&2
  exit 1
}

jq -c --arg cwd "$cwd" --arg id "apply-layout-$name" '
  {id: $id, method: "layout.apply", params: (. + {focus: true})}
  | .params.root |= walk(
      if type == "object" and .type == "pane" and (.cwd // "") == ""
      then .cwd = $cwd
      else .
      end
    )
' "$layout_file" | nc -U -w 2 "$socket"
