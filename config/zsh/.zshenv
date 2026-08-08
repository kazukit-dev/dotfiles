# Environment variables for all zsh invocations (login, interactive, scripts).
# Sourced from ~/.zshenv on first launch, read natively by child shells.
# XDG variables are defined in ~/.zshenv, which always runs (or is inherited) first.

# Disable macOS Terminal session restore
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
export BUN_INSTALL_GLOBAL_DIR=$XDG_DATA_HOME/bun/install/global
export BUN_INSTALL_BIN=$XDG_DATA_HOME/bun/bin
# Deno settings
export DENO_DIR=$XDG_CACHE_HOME/deno
# Rust settings
export CARGO_HOME=$XDG_DATA_HOME/cargo
# Docker settings
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
# Less settings
export LESSHISTFILE=$XDG_STATE_HOME/less/history
# Editor (overrides EDITOR=nano from nix-darwin's set-environment)
export EDITOR=nvim

# PATH
path=(
  $CARGO_HOME/bin # cargo install binaries
  $BUN_INSTALL_BIN # bun install -g binaries
  $path
)
# Deduplicate PATH entries
typeset -U path PATH
