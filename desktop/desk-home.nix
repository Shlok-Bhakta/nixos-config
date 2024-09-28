{ lib, config, pkgs, inputs, ... }: {
  imports = [ 
    ../pkgs/desk-hypr.nix
    ../gen-home.nix
  ];
  home.packages = [
    pkgs.nvidia-vaapi-driver
    pkgs.kando
  ];
  xdg.configFile = {
    "waybar".source = ../dotfiles/waybar;
  };
}

