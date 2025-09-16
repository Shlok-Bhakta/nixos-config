{ lib, config, pkgs, inputs, unstable, ... }: {
  imports = [ 
    ./programs/hypr.nix
    ../../../modules/home-manager/home.nix
  ];
  home.packages = [
  ];
  xdg.configFile = {
    "waybar".source = ../dotfiles/waybar;
  };
}

