{ config, pkgs, inputs, ... }:

{
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
    git
    pyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
    waybar
    wofi
  ];

  system.stateVersion = "24.05"; 

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
