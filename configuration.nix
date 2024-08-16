{ lib, config, pkgs, inputs, ... }:
let
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.png;

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
    hyprlock
    hypridle
    hyprpaper
    waybar
    discordo
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })
    vesktop
  ];

  system.stateVersion = "24.05"; 

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

  stylix =  {
    enable = true;
    image = wallpaper-path;
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "CaskaydiaCove Nerd Font";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "CaskaydiaCove Nerd Font";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "CaskaydiaCove Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
