{ lib, config, pkgs, inputs, ... }: let
  wallpaper-path = ../dotfiles/wallpaper/wallpaper.gif;
  unstable = import ../unstable.nix { inherit inputs pkgs; };
in {
  imports = [
    ./gen-hypr.nix
  ];
  home.packages = [
    # pkgs.hypridle
  ];
  services.hypridle.enable = false;

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    package = pkgs.hyprland;
    settings = {
      exec-once = [
        "xrandr --output DP-1 --primary"
      ]; 
      monitor = [
        "DP-1, 1920x1080@144, 0x0, 1"
        "HDMI-A-1, 1920x1080@144, -1080x-650, 1, transform, 1"
      ]; 
    };
  };
    # Enable Hyprlock
  programs.hyprlock = {
    enable = true;
    package = pkgs.hyprlock;
    # settings = builtins.imprty
    extraConfig = builtins.readFile ../dotfiles/hypr/hyprlock.conf;
  };
}