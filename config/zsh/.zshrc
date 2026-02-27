# History
export HISTFILE=$XDG_STATE_HOME/zsh/history
export HISTSIZE=10000
export SAVEHIST=10000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups

[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# Alias
source $ZDOTDIR/aliases.zsh
# Functions
source $ZDOTDIR/functions.zsh

# Init
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
## sheldon cache technique
sheldon_cache="$XDG_CACHE_HOME/sheldon.zsh"
sheldon_toml="$XDG_CONFIG_HOME/sheldon/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  mkdir -p $XDG_CACHE_HOME
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml