## Quick Reference

See @README.md for project overview, architecture, and available commands.

## Important

- **Never edit `~/.config/` directly.** All config files are symlinked from this dotfiles repo. Always edit files under `dotfiles/config/` instead.

## Nix Code Conventions

- Format with `nixfmt` (enforced by pre-commit and CI)
- Follow XDG Base Directory standard for all config paths

## GitHub Actions

When editing GitHub Actions workflows:

- Pin action versions to commit SHAs using `pinact`:
  `nix run nixpkgs#pinact`
  (e.g. `actions/checkout@v4` -> `actions/checkout@<sha> # v4`)
- CI runs on `macos-latest` (build) and `ubuntu-24.04-arm` (format check)
- Cachix is used for binary caching (cache name: `kazukit`)

## home-manager Conventions

- `xdg.configFile` with `recursive = true` does not apply `executable = true` to individual files
- Place executable scripts in `scripts/` and create separate `xdg.configFile` entries with `executable = true` (see `claude-code.nix` for example)

## Git Conventions

- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
- Common scopes: `config`, `ci`, `deps`, `darwin`, `home`, `claude` etc
