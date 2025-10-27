{ lib, ... }:
{
  options.custom.wallpapers = {
    animated = lib.mkOption {
      type = lib.types.path;
      default = ./wallpaper.gif;
      description = "Animated wallpaper for desktop use";
    };
    static = lib.mkOption {
      type = lib.types.path;
      default = ./wallpaper.png;
      description = "Static wallpaper";
    };
    lockscreen = lib.mkOption {
      type = lib.types.path;
      default = ./background.png;
      description = "Lockscreen background";
    };
    face = lib.mkOption {
      type = lib.types.path;
      default = ./face.png;
      description = "User face icon for lockscreen";
    };
  };
}
