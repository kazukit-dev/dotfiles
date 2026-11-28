#!/usr/bin/env bash
set -u

readonly RESET=$'\033[0m'
readonly DIM=$'\033[2m'
readonly GREEN=$'\033[32m'
readonly YELLOW=$'\033[33m'
readonly RED=$'\033[31m'

color_for_percent() {
  local pct=$1
  if ((pct < 50)); then
    printf '%s' "$GREEN"
  elif ((pct < 75)); then
    printf '%s' "$YELLOW"
  else
    printf '%s' "$RED"
  fi
}

format_tokens() {
  local n=$1
  if ((n >= 1000000)); then
    printf '%d.%dM' $((n / 1000000)) $((n % 1000000 / 100000))
  elif ((n >= 1000)); then
    printf '%dk' $((n / 1000))
  else
    printf '%d' "$n"
  fi
}

format_duration_seconds() {
  local s=$1
  if ((s >= 86400)); then
    printf '%dd%dh' $((s / 86400)) $((s % 86400 / 3600))
  elif ((s >= 3600)); then
    printf '%dh%dm' $((s / 3600)) $((s % 3600 / 60))
  else
    printf '%dm' $((s / 60))
  fi
}

format_bar() {
  local pct=$1 width=10 filled bar="" i
  filled=$((pct * width / 100))
  ((filled > width)) && filled=$width
  ((filled < 0)) && filled=0
  for ((i = 0; i < width; i++)); do
    if ((i < filled)); then bar+="▓"; else bar+="░"; fi
  done
  printf '%s' "$bar"
}

format_rate_limit() {
  local label=$1 pct=$2 resets_at=$3 now=$4 remaining
  if ((resets_at > now)); then
    remaining=$(format_duration_seconds $((resets_at - now)))
  else
    remaining="now"
  fi
  printf '%s %s%d%%%s (%s)' "$label" "$(color_for_percent "$pct")" "$pct" "$RESET" "$remaining"
}

git_segment() {
  local dir=$1 branch dirty="" ahead_behind ahead behind
  branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null ||
    git -C "$dir" rev-parse --short HEAD 2>/dev/null) || return 0
  [[ -n $(git -C "$dir" status --porcelain 2>/dev/null) ]] && dirty="*"
  local result="${branch}${dirty}"
  if ahead_behind=$(git -C "$dir" rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null); then
    read -r ahead behind <<<"$ahead_behind"
    ((ahead > 0)) && result+="↑${ahead}"
    ((behind > 0)) && result+="↓${behind}"
  fi
  printf ' (%s)' "$result"
}

input=$(cat)

# IFS is not a tab: whitespace IFS merges consecutive separators, so an empty field would shift every later value.
IFS=$'\x1f' read -r project_dir current_dir model used_pct tokens \
  five_pct five_reset seven_pct seven_reset <<<"$(
    jq -r '
			def int: if . == null then "" else floor end;
			[
				(.workspace.project_dir // .workspace.current_dir // .cwd // ""),
				(.workspace.current_dir // .cwd // ""),
				(.model.display_name // .model.id // ""),
				(.context_window.used_percentage | int),
				(.context_window.current_usage
					| if . == null then ""
					  else (.input_tokens // 0) + (.output_tokens // 0)
					     + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)
					  end),
				(.rate_limits.five_hour.used_percentage | int),
				(.rate_limits.five_hour.resets_at | int),
				(.rate_limits.seven_day.used_percentage | int),
				(.rate_limits.seven_day.resets_at | int)
			] | map(tostring) | join("\u001f")
		' <<<"$input" 2>/dev/null
  )"

line1="${project_dir##*/}"
if [[ -n $current_dir ]]; then
  # Skip optional index.lock writes so the frequent statusline refresh never races a git command the user runs.
  export GIT_OPTIONAL_LOCKS=0
  line1+=$(git_segment "$current_dir")
fi

segments=()
[[ -n $model ]] && segments+=("$model")

if [[ -n $used_pct ]]; then
  ctx="ctx $(color_for_percent "$used_pct")$(format_bar "$used_pct") ${used_pct}%${RESET}"
  [[ -n $tokens && $tokens != 0 ]] && ctx+=" ($(format_tokens "$tokens"))"
  segments+=("$ctx")
fi

if [[ -n $five_pct || -n $seven_pct ]]; then
  now=$(date +%s)
  limits=()
  [[ -n $five_pct ]] && limits+=("$(format_rate_limit 5h "$five_pct" "${five_reset:-0}" "$now")")
  [[ -n $seven_pct ]] && limits+=("$(format_rate_limit 7d "$seven_pct" "${seven_reset:-0}" "$now")")
  rate="${limits[0]}"
  ((${#limits[@]} > 1)) && rate+=" / ${limits[1]}"
  segments+=("$rate")
fi

line2=""
for segment in "${segments[@]+"${segments[@]}"}"; do
  [[ -n $line2 ]] && line2+="${DIM} | ${RESET}"
  line2+=$segment
done

printf '%s\n%s%s\n' "$line1" "$line2" "$RESET"
