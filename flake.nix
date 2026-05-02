{
  description = "kazukit's Nix configuration";

  nixConfig = {
    extra-substituters = [
      "https://kazukit.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "kazukit.cachix.org-1:pL0zV9aaRVYz0wdxKhfwFXISwTDb10wK7hxbuaxL93Q="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Pinned to 2026-01-26 to avoid masApps installation failure (https://github.com/zhaofengli/nix-homebrew/issues/131)
    nix-homebrew.url = "github:zhaofengli/nix-homebrew/a5409abd0d5013d79775d3419bcac10eacb9d8c5";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agent-skills.url = "github:Kyure-A/agent-skills-nix";

    # Skills
    ast-grep-skill = {
      url = "github:ast-grep/agent-skill";
      flake = false;
    };
  };

  outputs =
    inputs@{
      flake-parts,
      treefmt-nix,
      git-hooks-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;

      imports = [
        treefmt-nix.flakeModule
        git-hooks-nix.flakeModule
      ];

      # aarch64-linux is needed for CI (GitHub Actions ARM runner).
      # perSystem outputs like treefmt formatter are system-dependent,
      # so the runner's architecture must be listed here.
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
      ];

      perSystem =
        { config, pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              # Nix
              nixfmt.enable = true;
              # Lua
              stylua.enable = true;
              # Shell
              shfmt.enable = true;
              # Toml
              taplo.enable = true;
              # Yaml
              yamlfmt.enable = true;
              # JavaScript
              oxfmt = {
                enable = true;
                includes = [
                  "*.js"
                  "*.ts"
                  "*.json"
                  "*.jsonc"
                ];
              };
            };
          };

          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              packageOverrides.treefmt = config.treefmt.build.wrapper;
            };
            deadnix.enable = true;
            statix.enable = true;
            gitleaks = {
              enable = true;
              name = "gitleaks";
              description = "Detect hardcoded secrets";
              entry = "${pkgs.gitleaks}/bin/gitleaks git --verbose --redact --pre-commit --staged";
              pass_filenames = false;
            };
          };

          devShells.default = pkgs.mkShell {
            inherit (config.pre-commit) shellHook;
            packages = config.pre-commit.settings.enabledPackages;
          };

          apps = {
            switch = {
              type = "app";
              meta.description = "Apply nix-darwin configuration changes";
              program = toString (
                pkgs.writeShellScript "switch" ''
                  set -e
                  echo "Applying nix-darwin and home-manager configuration changes..."
                  sudo nix run nix-darwin -- switch --flake ".#gabi"
                  echo "Done!"
                ''
              );
            };
            update = {
              type = "app";
              meta.description = "Update flake.lock dependencies";
              program = toString (
                pkgs.writeShellScript "update" ''
                  set -e
                  echo "Updating flake.lock..."
                  nix flake update
                  echo "Done!"
                ''
              );
            };
            secrets = {
              type = "app";
              meta.description = "Run gitleaks on entire repository";
              program = toString (
                pkgs.writeShellScript "secrets" ''
                  set -e
                  echo "Running gitleaks on entire repository..."
                  ${pkgs.gitleaks}/bin/gitleaks git --verbose --redact
                  echo "Done!"
                ''
              );
            };
          };

        };

      flake = {
        darwinConfigurations.gabi = import ./hosts/gabi { inherit inputs; };
      };
    };
}
