# History
# Not exported: a child bash would otherwise write its own format into the
# same HISTFILE and corrupt the extended_history timestamps.
HISTFILE=$XDG_STATE_HOME/zsh/history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_history

[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# Alias
source $ZDOTDIR/aliases.zsh

# Functions
source $ZDOTDIR/functions.zsh

# Keybindings
source $ZDOTDIR/keybindings.zsh

# Init
eval "$(direnv hook zsh)"
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
