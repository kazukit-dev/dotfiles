## Quick Reference

See @README.md for project overview, architecture, and available commands.

## Important

- **Never edit `~/.config/` directly.** All config files are symlinked from this dotfiles repo. Always edit files under `dotfiles/config/` instead.

## Nix Code Conventions

- Format with `nixfmt` (enforced by pre-commit and CI)
- Follow XDG Base Directory standard for all config paths

## GitHub Actions Convention

- Pin action versions to commit SHAs using `pinact`:
```sh
nix run nixpkgs#pinact
```

## AI Agent Packages Convention

- Install AI agent packages through the `llm-agents` flake input, which keeps them up to date with the latest releases. 
```nix
packages = [
  pkgs.llm-agents.<package>
];
```

## home-manager Conventions

- `xdg.configFile` with `recursive = true` does not apply `executable = true` to individual files
- Place executable scripts in `scripts/` and create separate `xdg.configFile` entries with `executable = true` (see `claude-code.nix` for example)

## Git Conventions

- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
- Common scopes: `config`, `ci`, `deps`, `darwin`, `home`, `claude` etc
