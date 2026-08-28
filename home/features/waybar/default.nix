{ pkgs, unstable, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.callPackage ../../../pkgs/waybar { waybar = unstable.waybar; };
  };

  xdg.configFile."waybar".source = ./.;
}
