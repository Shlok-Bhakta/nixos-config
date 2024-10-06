{ lib, config, pkgs, inputs, ... }: let
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.gif;
  unstable = import ../unstable.nix { inherit inputs pkgs; };
in {
  imports = [
    ./gen-hypr.nix
  ];
  home.packages = [
    unstable.hypridle
  ];
  # Enable Hyprland
  wayland.windowManager.hyprland = {
    package = unstable.hyprland;
    settings = {
      exec-once = [
        "swww img ${wallpaper-path}"
        "swww-daemon --format xrgb"
        "waybar"
        "swaync"
        "wl-paste --type [text|image] --watch cliphist store"
        "xrandr --output DP-1 --primary"
        "kando"
        "vesktop"
        "syncthing"
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
    package = unstable.hyprlock;
    # settings = builtins.imprty
    extraConfig = builtins.readFile ../dotfiles/hypr/hyprlock.conf;
  };
}