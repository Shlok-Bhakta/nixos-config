{ inputs, ... }:

{
  imports = [
    ../shared/home.nix
  ];

  custom = {
    hyprland = {
      isLaptop = true;
      enableSplitWorkspaces = false;
      package = inputs.hyprland.packages.x86_64-linux.hyprland;
      monitors = [
        {
          name = "eDP-1";
          resolution = "preferred";
          position = "auto";
          scale = 1;
          isPrimary = true;
        }
        {
          name = "";
          resolution = "preferred";
          position = "auto";
          scale = 1;
          extraConfig = "mirror, eDP-1";
        }
      ];
    };

    waybar = {
      isLaptop = true;
    };

    power-monitor = {
      enable = true;
    };

    wallpapers = {
      animated = ../../modules/home/wallpapers/wallpaper.gif;
    };
  };
}
