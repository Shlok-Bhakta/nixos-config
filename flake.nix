{
  description = "My Main Flake";

  # Substitutors for faster downloads
  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };



  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    UNSTABLE.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.05";
    ags.url = "github:Aylur/ags";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    yapper = {
      url = "github:Shlok-Bhakta/yapper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww.url = "github:LGFae/swww";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
    nvf.url = "github:notashelf/nvf";
    opencode = {
      url = "github:aodhanhayter/opencode-flake";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    printer-cli = {
      url="github:Shlok-Bhakta/ESC-POS-Task-Api?dir=cli";
    };
};

  outputs = { self, nixpkgs, home-manager, stylix, nvf, ... } @ inputs: let 
      system = "x86_64-linux";
      mynvf = nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./pkgs/nvf/nvf.nix];
      };
  in {

    # setup the nvf stuff
    packages.${system}.mynvf = mynvf.neovim;

    nixosConfigurations.ShlokPCNIX = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.shlok = import ./hosts/desktop/home.nix;
          home-manager.backupFileExtension = "old";
          home-manager.extraSpecialArgs = {
            inherit inputs self mynvf;
          };
          home-manager.sharedModules = [ stylix.homeManagerModules.stylix ];
        }
      ];
    };
    nixosConfigurations.ShlokLAPNIX = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hosts/laptop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.shlok = import ./hosts/laptop/home.nix;
          home-manager.backupFileExtension = "old";
          home-manager.extraSpecialArgs = {
            inherit inputs self mynvf;
          };
          home-manager.sharedModules = [ stylix.homeManagerModules.stylix ];
        }
      ];
    };

  };
}
