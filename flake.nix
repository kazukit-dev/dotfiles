{
  description = "kazukit's Nix configuration";

  nixConfig = {
    extra-substituters = [ "https://ryoppippi.cachix.org" ];
    extra-trusted-public-keys = [
      "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
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
    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      flake-parts,
      treefmt-nix,
      git-hooks-nix,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "kazuki";
      homedir = "/Users/${username}";
      hostname = "gabi";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;

      imports = [
        treefmt-nix.flakeModule
        git-hooks-nix.flakeModule
      ];

      systems = [ "aarch64-darwin" ];

      perSystem =
        { config, pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              oxfmt.enable = true;
              shfmt.enable = true;
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
                  sudo nix run nix-darwin -- switch --flake .#${hostname}
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
                  echo "Updating fake.lock..."
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
        darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (import ./nix/darwin { inherit username homedir; })
            home-manager.darwinModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                inputs.claude-code-overlay.overlays.default
              ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./nix/home;
                extraSpecialArgs = {
                  inherit username homedir;
                };
              };
            }
          ];
        };
      };
    };
}
