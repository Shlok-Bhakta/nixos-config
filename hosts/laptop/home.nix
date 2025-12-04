{ inputs, ... }:

{
  imports = [
    ../shared/home.nix
  ];

  custom = {
    hyprland = {
      isLaptop = true;
      enableSplitWorkspaces = false;
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

    wallpapers = {
      animated = ../../modules/home/wallpapers/wallpaper.gif;
      powerAware = true;
    };
  };
}
