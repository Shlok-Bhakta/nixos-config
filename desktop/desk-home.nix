{ lib, config, pkgs, inputs, ... }: {
  imports = [ 
    ../pkgs/desk-hypr.nix
    ../gen-home.nix
  ];
  home.packages = [
  ];
  xdg.configFile = {
    "waybar".source = ../dotfiles/waybar;
  };
}

