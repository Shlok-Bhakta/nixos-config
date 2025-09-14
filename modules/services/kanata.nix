{ lib, config, pkgs, inputs, ... }:
{
  services.kanata = {
    enable = true;
    package = pkgs.kanata;
    keyboards.keychron = {
      devices = [
        "/dev/input/by-id/usb-Keychron_Keychron_K8_Pro-event-kbd"
      ];
      configFile = ../home-manager/dotfiles/kanata/kanata.kbd;
    };
  };
}