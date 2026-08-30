{
  lib,
  inputs,
  mynvf,
  unstable,
  ...
}:

{
  imports = [
    ../features/waybar
  ];

  home.sessionVariables.HYPRLAND_PRIMARY_MONITOR = "DP-1";

  xdg.configFile = {
    "hypr/profile.lua".source = ../features/hyprland/profile-desktop.lua;
    "hypr/plugins/split-monitor-workspaces" = {
      source = inputs.split-monitor-workspaces;
      recursive = true;
    };
  };

  home.packages = [
    # Win PATH over home-manager's programs.neovim `nvim` from lazyvim-nix.
    (lib.hiPrio mynvf.neovim)
    unstable.docker-compose
  ];
}
