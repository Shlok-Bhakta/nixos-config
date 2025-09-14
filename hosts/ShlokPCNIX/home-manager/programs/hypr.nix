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
    # package = pkgs.hyprland;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      # Add more plugins here as needed
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    extraConfig = ''
      plugin {
        split-monitor-workspaces {
            count = 10
            keep_focused = 0
            enable_notifications = 1
            enable_persistent_workspaces = 0
        }
      }

      cursor {
        no_hardware_cursors = true
      }
    '';
    
    settings = {
      exec-once = [
        "xrandr --output DP-1 --primary"
      ]; 
      monitor = [
        "DP-1, 1920x1080@144, 0x0, 1"
        "HDMI-A-1, 1920x1080@144, -1080x-650, 1, transform, 1"
      ]; 
      bind = [

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, split-workspace, 1"
      "$mainMod, 2, split-workspace, 2"
      "$mainMod, 3, split-workspace, 3"
      "$mainMod, 4, split-workspace, 4"
      "$mainMod, 5, split-workspace, 5"
      "$mainMod, 6, split-workspace, 6"
      "$mainMod, 7, split-workspace, 7"
      "$mainMod, 8, split-workspace, 8"
      "$mainMod, 9, split-workspace, 9"
      "$mainMod, 0, split-workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, split-movetoworkspace, 1"
      "$mainMod SHIFT, 2, split-movetoworkspace, 2"
      "$mainMod SHIFT, 3, split-movetoworkspace, 3"
      "$mainMod SHIFT, 4, split-movetoworkspace, 4"
      "$mainMod SHIFT, 5, split-movetoworkspace, 5"
      "$mainMod SHIFT, 6, split-movetoworkspace, 6"
      "$mainMod SHIFT, 7, split-movetoworkspace, 7"
      "$mainMod SHIFT, 8, split-movetoworkspace, 8"
      "$mainMod SHIFT, 9, split-movetoworkspace, 9"
      "$mainMod SHIFT, 0, split-movetoworkspace, 10"

      "$mainMod SHIFT, D, split-movetoworkspace, special:magic"


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