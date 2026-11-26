{
  description = "My Main Flake";

  # Only applies to `nix` commands run against this flake. The same caches are
  # also set system-wide in system/features/nix so rebuilds always use them.
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  inputs = {
    # Base system. Moves once per release.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # Fast-moving apps (`unstable.<pkg>`). Prebuilt by Hydra, so no local
    # compiles. Bump with `nix flake update UNSTABLE`.
    UNSTABLE.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # AI tools only (`ai-unstable.<pkg>`). Separate so they can be bumped daily
    # with `nix flake update ai-unstable` without touching anything else.
    ai-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hyprland keeps its own nixpkgs so hyprland.cachix.org hits.
    hyprland.url = "github:hyprwm/Hyprland";
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "UNSTABLE";
    };
    lazyvim.url = "github:pfassina/lazyvim-nix";
    printer-cli.url = "github:Shlok-Bhakta/ESC-POS-Task-Api?dir=cli";
    # Source only; built by pkgs/dekit. Update with `nix flake update dekit`.
    dekit = {
      url = "github:pvolok/dekit";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      unstable = import inputs.UNSTABLE {
        inherit system;
        config.allowUnfree = true;
      };
      ai-unstable = import inputs.ai-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit
          inputs
          self
          unstable
          ai-unstable
          ;
      };

      # Every host is the same recipe: its configuration.nix + home.nix.
      mkHost =
        dir:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/${dir}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.shlok = import ./hosts/${dir}/home.nix;
              home-manager.backupFileExtension = "old";
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.sharedModules = [ stylix.homeModules.stylix ];
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        ShlokPCNIX = mkHost "pc";
        ShlokLAPNIX = mkHost "msi";
        shlokthinkpad = mkHost "thinkpad";
      };
    };
}
