{ mynvf, unstable, ... }:

{
  imports = [
    ../features/hypridle
    ../features/laptop-waybar
    ../features/power-monitor
  ];

  xdg.configFile."hypr/profile.lua".source = ../features/hyprland/profile-laptop.lua;

  home.packages = [
    mynvf.neovim
    unstable.docker-compose
  ];
}
