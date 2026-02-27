{ inputs, ... }:
let
  system = "aarch64-darwin";
  username = "kazuki";
  homedir = "/Users/${username}";
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  modules = [
    inputs.determinate.darwinModules.default
    (import ../../nix/darwin { inherit username homedir; })
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        inputs.llm-agents.overlays.default
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ../../nix/home;
        extraSpecialArgs = {
          inherit username homedir inputs;
        };
      };
    }
  ];
}
