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
    # hyprland.url = "github:hyprwm/Hyprland";
    ags.url = "github:Aylur/ags";
    # hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    # impurity.url = "github:outfoxxed/impurity.nix";
    # fufexan-dotfiles = {
    #   url = "github:fufexan/dotfiles";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
};

  outputs = { self, nixpkgs, home-manager, stylix, ... } @ inputs: let 
      system = "x86_64-linux";
      # hypkgs = import nixpkgs {
      #   inherit system;
      #   overlays = [
      #       inputs.hyprpanel.overlay.${system}
      #   ];
      # };
  in {
    nixosConfigurations.ShlokPCNIX = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [
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