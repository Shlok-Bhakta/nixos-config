{
  description = "My Main Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=24.05";
    UNSTABLE.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    ags.url = "github:Aylur/ags";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    yapper = {
      url = "github:Shlok-Bhakta/yapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

};

  outputs = { self, nixpkgs, home-manager, stylix, ... } @ inputs: let 
      system = "x86_64-linux";
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
          # nixpkgs.overlays = [ ];
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
          # nixpkgs.overlays = [ overlay-kando ];
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
