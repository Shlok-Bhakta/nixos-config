{ lib, config, pkgs, inputs, ... }: let
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.gif;
in{
  imports = [
    ./gen-hypr.nix
  ];
  home.packages = [
    pkgs.hypridle
  ];
  # Enable Hyprland
  wayland.windowManager.hyprland = {
    package = pkgs.hyprland;
    settings = {
      exec-once = [
        "swww img ${wallpaper-path}"
        "swww-daemon --format xrgb"
        "waybar"
        "swaync"
        "wl-paste --type [text|image] --watch cliphist store"
        "kando"
        "vesktop"
      ]; 
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