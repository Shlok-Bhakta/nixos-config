{ lib, mynvf, ... }:

{
  imports = [
    ../features/hypridle
    ../features/laptop-waybar
    ../features/thinkpad-power
  ];

  home.stateVersion = "26.05";

  xdg.configFile."hypr/profile.lua".source = ../features/hyprland/profile-thinkpad.lua;

  services.syncthing.enable = lib.mkForce false;

  home.packages = [
    mynvf.neovim
  ];
}
