{ lib, config, pkgs, inputs, ... }: {
  imports = [ 
    ../pkgs/laptop-hypr.nix
    ../gen-home.nix
  ];
  home.packages = [
  ];
  xdg.configFile = {
    "waybar".source = ../dotfiles/laptop-waybar;
  };
}

