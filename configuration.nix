{ lib, config, pkgs, inputs, ... }:
let
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.png;
  unstable = inputs.UNSTABLE.legacyPackages.${pkgs.system};
in{
  # imports = [
  #   inputs.home-manager.nixosModules.home-manager
  # ];
  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = inputs.UNSTABLE.packages."${pkgs.system}".hyprland;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    home-manager
    pyprland
    hyprpicker
    hyprcursor
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })
    vesktop
    
  ];

  system.stateVersion = "24.05"; 
  security.pam.services.swaylock = {};
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  services.tailscale = {
    enable = true;
    package = unstable.tailscale;
  };

  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
