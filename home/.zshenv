# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Zsh settings
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export SHELL_SESSIONS_DISABLE=1
# Claude Code settings
export CLAUDE_CONFIG_DIR=$XDG_CONFIG_HOME/claude
# Codex settings
export CODEX_HOME=$XDG_CONFIG_HOME/codex
# Python settings
export PYTHON_HISTORY=$XDG_STATE_HOME/python/history
# Node.js settings
export NODE_REPL_HISTORY=$XDG_STATE_HOME/node/repl_history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
# Bun settings
export BUN_INSTALL_CACHE_DIR=$XDG_CACHE_HOME/bun/install/cache
# Deno settings
export DENO_DIR=$XDG_CACHE_HOME/deno
# Docker settings
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
# Less settings
export LESSHISTFILE=$XDG_STATE_HOME/less/history
# Editor
export EDITOR=nvim
