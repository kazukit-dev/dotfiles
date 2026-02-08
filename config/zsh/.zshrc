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

eval "$(starship init zsh)"
eval "$(sheldon source)"
eval "$(zoxide init zsh)"