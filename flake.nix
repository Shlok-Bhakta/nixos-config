{
  description = "My Main Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    UNSTABLE.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    ags.url = "github:Aylur/ags";
    kando-nixpkgs = {
      url = "https://github.com/TomaSajt/nixpkgs/archive/kando.tar.gz";
      flake = false;
    };
    zen-browser.url = "github:ch4og/zen-browser-flake";
    yapper = {
      url = "github:Shlok-Bhakta/yapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

};

  outputs = { self, nixpkgs, home-manager, stylix, kando-nixpkgs, ... } @ inputs: let 
      system = "x86_64-linux";
      overlay-kando = final: prev: {
        kando = (import kando-nixpkgs {
          system = final.system;
        }).kando;
      };
  in {
    nixosConfigurations.ShlokPCNIX = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        {
          nixpkgs.config = {
            allowUnfree = true;
            cudaSupport = true;
          };
          nixpkgs.overlays = [ overlay-kando ];
        }
        ./desktop/desk-configuration.nix
        ./desktop/desk-hardware-configuration.nix
        ./desktop/desk-system-settings.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.shlok = import ./desktop/desk-home.nix;
          home-manager.backupFileExtension = "old";
          home-manager.extraSpecialArgs = {
            inherit inputs self;
          };
        }
      ];
    };
    nixosConfigurations.ShlokLAPNIX = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ overlay-kando ];
        }
        ./laptop/laptop-configuration.nix
        ./laptop/laptop-hardware-configuration.nix
        ./laptop/laptop-system-settings.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.shlok = import ./laptop/laptop-home.nix;
          home-manager.backupFileExtension = "old";
          home-manager.extraSpecialArgs = {
            inherit inputs self;
          };
        }
      ];
    };

  };
}
