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
    # Temporarily unpinned to pick up brew 5.1.x, which fixes the cask API
    # "undefined method 'first' for nil" crash in generate_cask_struct_hash.
    # The previous pin (a5409abd, 2026-01-26) existed to avoid masApps install
    # failure (https://github.com/zhaofengli/nix-homebrew/issues/131); that
    # issue is still open, so we work around it with
    # `homebrew.onActivation.autoUpdate = false` in nix/darwin/homebrew.nix.
    # Re-pin or drop the workaround once #131 is fixed upstream.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    flake-parts.url = "github:hercules-ci/flake-parts";
    agent-skills.url = "github:Kyure-A/agent-skills-nix";

    ast-grep-skills = {
      url = "github:ast-grep/agent-skill";
      flake = false;
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    context7-skills = {
      url = "github:upstash/context7";
      flake = false;
    };
    agent-browser-skills = {
      url = "github:vercel-labs/agent-browser";
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
              verbose = true;
              packageOverrides.treefmt = config.treefmt.build.wrapper;
            };
            deadnix = {
              enable = true;
              verbose = true;
            };
            statix = {
              enable = true;
              verbose = true;
            };
            gitleaks = {
              enable = true;
              verbose = true;
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
        darwinConfigurations.gabi =
          let
            system = "aarch64-darwin";
            username = "kazuki";
            homedir = "/Users/${username}";
            dotfilesPath = "${homedir}/ghq/github.com/kazukit-dev/dotfiles";
          in
          inputs.nix-darwin.lib.darwinSystem {
            inherit system;
            modules = [
              inputs.determinate.darwinModules.default
              inputs.nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  user = username;
                  autoMigrate = true;
                };
              }
              (import ./nix/darwin { inherit username homedir; })
              inputs.home-manager.darwinModules.home-manager
              {
                nixpkgs = {
                  config.allowUnfree = true;
                  # vue-language-server pulls pnpm 10.34.0 as a build-time
                  # dependency; only used to fetch deps during build, not at runtime.
                  config.permittedInsecurePackages = [
                    "pnpm-10.34.0"
                  ];
                  overlays = [
                    inputs.llm-agents.overlays.default
                  ];
                };
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ./nix/home;
                  extraSpecialArgs = {
                    inherit
                      username
                      homedir
                      dotfilesPath
                      inputs
                      ;
                  };
                };
              }
            ];
          };
      };
    };
}
