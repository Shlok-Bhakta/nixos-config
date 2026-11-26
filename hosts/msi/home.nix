{ ... }:

{
  imports = [
    ../../home/profiles/shared.nix
    ../../home/profiles/laptop.nix
    ../../home/features/blender
    ../../home/features/power-monitor
  ];

  xdg.configFile."hypr/profile.lua".source = ../../home/features/hyprland/profile-msi.lua;
}
