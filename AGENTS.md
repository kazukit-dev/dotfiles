## Quick Reference

See @README.md for project overview, architecture, and available commands.

## Convention

- **Never edit `~/.config/` directly.** All config files are symlinked from this dotfiles repo. Always edit files under `dotfiles/config/` instead.

- Pin action versions to commit SHAs using `pinact`:
  ```sh
  nix run nixpkgs#pinact
  ```

- Install AI agent packages through the `llm-agents` flake input, which keeps them up to date with the latest releases. 
  ```nix
  packages = [
    pkgs.llm-agents.<package>
  ];
  ```

- Place executable scripts in `scripts/` and create separate `xdg.configFile` entries with `executable = true` (see `claude-code.nix` for example)
