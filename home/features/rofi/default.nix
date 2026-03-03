{ pkgs, unstable, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override {
      plugins = [
        unstable.rofi-calc
        unstable.rofi-emoji
        unstable.rofi-rbw
      ];
    };
  };

  xdg.configFile."rofi" = {
    source = ./rofi;
    recursive = true;
  };
}
