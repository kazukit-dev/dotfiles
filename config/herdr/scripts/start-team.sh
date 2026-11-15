#!/usr/bin/env bash
# team レイアウトを今のタブに適用して leader を起動し、役割の初期プロンプトを送る。
# worker / reviewer / consultant は、leader が必要なときに起動して閉じる。
# layout.apply のペインには agent の名前を付けられないので、空のシェルペインを
# 作ってから herdr agent start で起動している。
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
tab_id="${HERDR_ACTIVE_TAB_ID:?HERDR_ACTIVE_TAB_ID is not set}"
prompt_file="$config_dir/prompts/team-leader.md"

# agent の名前は起動中の agent の中で一意でなければならないので、タブ ID を付けて
# 複数のタブで起動しても衝突しないようにする
suffix="$(printf '%s' "$tab_id" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-')"
name() { printf '%s-%s' "$1" "$suffix"; }

# layout.apply はタブを新しい ID で作り直すので、適用前のタブ ID ではペインを探せない。
# 応答に含まれるペインからラベルで leader を探す
pane="$(bash "$config_dir/scripts/apply-layout.sh" team | jq -r \
  'first(.. | objects | select(.label? == "leader" and has("pane_id")) | .pane_id) // empty')"
[ -n "$pane" ] || {
  echo "leader pane not found" >&2
  exit 1
}

# 作った直後のペインはシェルのプロンプトが出ておらず agent start が失敗するので、少し待って再試行する。
# フォルダの信頼確認などで承認待ちになると agent start は失敗を返すが、agent は起動して
# 名前も付いているので、名前が引けたら起動できたとみなす
started=false
for _ in $(seq 1 20); do
  herdr agent start "$(name leader)" --kind claude --pane "$pane" >/dev/null 2>&1 || true
  if herdr agent get "$(name leader)" >/dev/null 2>&1; then
    started=true
    break
  fi
  sleep 0.5
done
$started || {
  echo "failed to start leader" >&2
  exit 1
}

# 承認待ちならユーザーが答えるまで待ってからプロンプトを送る
herdr agent wait "$(name leader)" --until idle --timeout 300000 >/dev/null

prompt="$(sed \
  -e "s/{{worker}}/$(name worker)/g" \
  -e "s/{{reviewer}}/$(name reviewer)/g" \
  -e "s/{{consultant}}/$(name consultant)/g" \
  "$prompt_file")"
herdr agent prompt "$(name leader)" "$prompt" >/dev/null
herdr agent focus "$(name leader)" >/dev/null
