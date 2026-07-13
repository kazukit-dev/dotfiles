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
# uv settings
export UV_CACHE_DIR=$XDG_CACHE_HOME/uv
export UV_PYTHON_INSTALL_DIR=$XDG_DATA_HOME/uv/python
export UV_TOOL_DIR=$XDG_DATA_HOME/uv/tools
export UV_TOOL_BIN_DIR=$XDG_DATA_HOME/uv/bin
# Bun settings
export BUN_INSTALL_CACHE_DIR=$XDG_CACHE_HOME/bun/install/cache
# Deno settings
export DENO_DIR=$XDG_CACHE_HOME/deno
# Docker settings
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
# Rust settings
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CARGO_HOME=$XDG_DATA_HOME/cargo
# Less settings
export LESSHISTFILE=$XDG_STATE_HOME/less/history
# Editor
export EDITOR=nvim

# Deduplicate PATH entries
typeset -U path PATH
