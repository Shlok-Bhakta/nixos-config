{ lib, mynvf, ... }:

{
  imports = [
    ../features/hypridle
    ../features/laptop-waybar
    ../features/thinkpad-power
  ];

  home.stateVersion = "26.05";

  xdg.configFile."hypr/profile.lua".source = ../features/hyprland/profile-thinkpad.lua;

  programs.hyprlock.extraConfig = lib.mkAfter ''
    auth {
      fingerprint {
        enabled = true
        ready_message = Password or fingerprint
        present_message = Scanning fingerprint
      }
    }
  '';

  services.syncthing.enable = lib.mkForce false;

  home.packages = [
    mynvf.neovim
  ];
}
