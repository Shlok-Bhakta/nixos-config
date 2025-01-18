{ lib, config, pkgs, inputs, ... }: let
  wallpaper-path = ../dotfiles/wallpaper/wallpaper.gif;
in{
  imports = [
    ./gen-hypr.nix
  ];
  home.packages = [
    # pkgs.hypridle
  ];
  services.hypridle.enable = true;
  # Enable Hyprland
  wayland.windowManager.hyprland = {
    package = pkgs.hyprland;
    settings = {
      # exec-once = [
      # ]; 
      monitor = [
        "eDP-1, preferred, auto, 1"
        ", preferred, auto, 1, mirror, eDP-1"
      ];
    };
  };
  # Enable Hyprlock
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    # settings = builtins.imprty
    extraConfig = builtins.readFile ../dotfiles/hypr/laptop-hyprlock.conf;
  };
}