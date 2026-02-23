## Quick Reference

See @README.md for project overview, architecture, and available commands.

## Convention

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