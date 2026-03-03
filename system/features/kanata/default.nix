{ pkgs, ... }:

let
  kanata-with-cmd = pkgs.kanata.override {
    withCmd = true;
  };
in
{
  services.kanata = {
    enable = true;
    package = kanata-with-cmd;
    keyboards.keychron = {
      devices = [
        "/dev/input/by-id/usb-Keychron_Keychron_K8_Pro-event-kbd"
      ];
      configFile = ./kanata.kbd;
    };
  };
}
