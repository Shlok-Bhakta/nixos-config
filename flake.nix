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
    kando-nixpkgs = {
      url = "https://github.com/TomaSajt/nixpkgs/archive/kando.tar.gz";
      flake = false;
    };
    zen-browser.url = "github:MarceColl/zen-browser-flake";
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
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ overlay-kando ];
        }
        ./configuration.nix
        ./hardware-configuration.nix
        ./system-settings.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.shlok = import ./home.nix;
          home-manager.backupFileExtension = "old";
          home-manager.extraSpecialArgs = {
            inherit inputs self;
          };
        }
      ];
    };

  };
}
