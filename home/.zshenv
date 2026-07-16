# XDG Base Directories
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Zsh settings
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# zsh reads $ZDOTDIR/.zshenv natively only when ZDOTDIR is already set at
# startup; the first shell sets it just above, so source it explicitly here.
[[ -f $ZDOTDIR/.zshenv ]] && source $ZDOTDIR/.zshenv
