## Quick Reference

See @README.md for project overview, architecture, and available commands.

## Convention

- Pin action versions to commit SHAs using `pinact`:
  ```sh
  nix run nixpkgs#pinact
  ```

- Install AI agent packages through the `llm-agents` flake input, which keeps them up to date with the latest releases. Consume its `packages` output directly (not an overlay) so binaries come from cache.numtide.com.
  ```nix
  packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    <package>
  ];
  ```