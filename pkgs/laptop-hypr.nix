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
      bind = [

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      "$mainMod SHIFT, D, movetoworkspace, special:magic"
      ];
      gestures = {
        workspace_swipe = true;
      };
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