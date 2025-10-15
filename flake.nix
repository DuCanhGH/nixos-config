{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of is kept consistent with the
    # `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs.
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets = {
      url = "git+ssh://git@github.com/DuCanhGH/nix-secrets.git";
      flake = false;
    };
  };
  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, lanzaboote, agenix, ... }:
  let
    specialArgs = { inherit inputs; };
  in {
    darwinConfigurations.duckintosh = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      inherit specialArgs;
      modules = [
        home-manager.darwinModules.home-manager
        ./systems/duckintosh/configuration.nix
        { home-manager.extraSpecialArgs = specialArgs; }
      ];
    };
    nixosConfigurations.pneuma = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      inherit specialArgs;
      modules = [
        home-manager.nixosModules.home-manager
        lanzaboote.nixosModules.lanzaboote
        ./systems/pneuma/configuration.nix
        { home-manager.extraSpecialArgs = specialArgs; }
      ];
    };
    nixosConfigurations.ousia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      inherit specialArgs;
      modules = [
        home-manager.nixosModules.home-manager
        ./systems/ousia/configuration.nix
        { home-manager.extraSpecialArgs = specialArgs; }
      ];
    };
  };
}